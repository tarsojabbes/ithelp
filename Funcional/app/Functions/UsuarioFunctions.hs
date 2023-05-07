{-# LANGUAGE OverloadedStrings #-}

module Functions.UsuarioFunctions where
import Database.PostgreSQL.Simple
import Controllers.ChamadoController (cadastrarChamado, buscarChamadoPorCriadorId)
import Controllers.AnalistaController (atualizarAvaliacaoAnalista, buscarAnalistaPorEmail)
import Models.Usuario
import Models.Chamado
import qualified Control.Monad
import Text.Printf
import Functions.AnalistaFunctions (formataListaDeChamados)
import Models.Analista (analista_id)

funcoesUsuario :: Connection -> Usuario -> IO ()
funcoesUsuario conn usuario = do
    exibeMenuFuncoesUsuario
    funcao <- getLine
    lidaComFuncaoEscolhida conn usuario funcao

exibeMenuFuncoesUsuario :: IO ()
exibeMenuFuncoesUsuario = do
    putStrLn "Enquanto usuário, você pode executar as seguintes funções:"
    putStrLn "------FUNÇÕES PARA USUÁRIO----"
    putStrLn "1 - Criar chamado"
    putStrLn "2 - Acompanhar chamados que você criou"
    putStrLn "3 - Avaliar analista responsável pelos seus chamados"
    putStrLn "------------------------------------------"
    putStrLn "Qual função você deseja executar?"

lidaComFuncaoEscolhida :: Connection -> Usuario -> String -> IO ()
lidaComFuncaoEscolhida conn usuario funcao
    | funcao == "1" = do
        putStrLn "Qual o título do chamado?"
        titulo_chamado <- getLine
        putStrLn "Qual a descrição do chamado?"
        descricao_chamado <- getLine
        putStrLn "------CONFIRMA CRIAÇÃO DO CHAMADO?----"
        putStrLn "1 - Confirma"
        putStrLn "2 - Cancela"
        confirmacao <- getLine
        criaChamado conn usuario confirmacao titulo_chamado descricao_chamado
        funcoesUsuario conn usuario

    | funcao == "2" = do
        let id_usuario = usuario_id usuario
        chamadosEncontrados <- buscarChamadoPorCriadorId conn id_usuario
        case chamadosEncontrados of
                Just chamados -> formataListaDeChamados conn chamados
                Nothing -> printf "Chamados para o usuário informado não foram encontrados\n"
        funcoesUsuario conn usuario

    | funcao == "3" = do
        putStrLn "Qual o ID do analista?"
        id_analista <- readLn :: IO Int
        putStrLn "Qual a avaliação para esse analista (1 a 5 estrelas)?"
        avaliacao <- readLn :: IO Int
        putStrLn "------CONFIRMA AVALIAÇÃO DO ANALISTA?----"
        putStrLn "1 - Confirma"
        putStrLn "2 - Cancela"
        confirmacao <- getLine
        avaliaAnalista conn id_analista avaliacao confirmacao
        funcoesUsuario conn usuario

    | otherwise = do
        printf "A função escolhida não existe. Por favor, selecione alguma das opções abaixo\n"
        funcoesUsuario conn usuario

criaChamado :: Connection -> Usuario -> String -> String -> String -> IO ()
criaChamado conn usuario confirmacao titulo_chamado descricao_chamado = do
    if confirmacao == "1" then do
        let status_chamado = "Nao iniciado"
        let id_usuario = usuario_id usuario
        analista_padrao <- buscarAnalistaPorEmail conn "analista@email.com"
        let analista = analista_padrao
        case analista_padrao of 
            Just analista -> do
                let id_analista = analista_id analista
                cadastrarChamado conn titulo_chamado descricao_chamado status_chamado id_usuario id_analista
                putStrLn "---Chamado criado com sucesso---"
            _ -> putStrLn "---Analista padrão não encontrado"
    
    else do
        putStrLn "---Criação do chamado cancelada---"

avaliaAnalista :: Connection -> Int -> Int -> String -> IO ()
avaliaAnalista conn id_analista avaliacao confirmacao = do
    if confirmacao == "1" then do
        atualizarAvaliacaoAnalista conn id_analista avaliacao
        putStrLn "---Avaliação atualizada com sucesso---"
    
    else do
        putStrLn "---Avaliação cancelada---"
