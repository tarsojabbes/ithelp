{-# LANGUAGE OverloadedStrings #-}

module Functions.AnalistaFunctions where
import Database.PostgreSQL.Simple
import Controllers.AtividadeController
import Models.Atividade
import Controllers.AnalistaController (buscarAnalistaPorId)
import Models.Analista
import Text.Printf
import qualified Data.Maybe
import Control.Exception (catch)
import Controllers.ChamadoController
import Models.Chamado

funcoesAnalista :: Connection -> IO ()
funcoesAnalista conn = do
    exibeMenuFuncoesAnalista
    funcao <- getLine
    lidaComFuncaoEscolhida conn funcao

exibeMenuFuncoesAnalista :: IO ()
exibeMenuFuncoesAnalista = do
    putStrLn "Enquanto analista, você pode executar as seguintes funções:"
    putStrLn "------FUNÇÕES PARA ANALISTA----"
    putStrLn "1 - Gerenciar atividades"
    putStrLn "2 - Gerenciar itens do inventário"
    putStrLn "3 - Gerenciar chamados"
    putStrLn "4 - Ver minhas estatísticas"
    putStrLn "------------------------------------------"
    putStrLn "Qual função você deseja executar?"

lidaComFuncaoEscolhida :: Connection -> String -> IO ()
lidaComFuncaoEscolhida conn funcao = do
    if funcao == "1" then do
        exibeMenuOpcoesAnalistaAtividade
        funcao_atividade <- getLine
        lidaComOpcaoAtividade conn funcao_atividade
    else if funcao == "3" then do
        exibeMenuOpcoesAnalistaChamado
        funcaoChamado <- getLine
        lidaComOpcaoChamado conn funcaoChamado
    else do
        printf "A função escolhida não existe. Por favor, selecione alguma das opções abaixo\n"
        funcoesAnalista conn

exibeMenuOpcoesAnalistaAtividade :: IO ()
exibeMenuOpcoesAnalistaAtividade = do
    putStrLn "---FUNÇÕES PARA QUADRO DE ATIVIDADES---"
    putStrLn "1 - Criar nova atividade"
    putStrLn "2 - Listar atividades não iniciadas"
    putStrLn "3 - Listar atividades em andamento"
    putStrLn "4 - Listar atividades concluídas"
    putStrLn "5 - Buscar atividade por ID"
    putStrLn "6 - Colocar atividade em andamento"
    putStrLn "7 - Finalizar atividade"
    putStrLn "8 - Excluir uma atividade"
    putStrLn "------------------------------------------"
    putStrLn "Qual função você deseja executar?"

lidaComOpcaoAtividade :: Connection -> String -> IO ()
lidaComOpcaoAtividade conn funcao_atividade = do
    if funcao_atividade == "1" then do
        putStrLn "Qual o titulo da atividade a ser criada?"
        atividade_titulo <- getLine
        putStrLn "Qual a descrição da atividade?"
        atividade_descricao <- getLine
        putStrLn "Quem é o responsável pela atividade"
        atividade_responsavel_id <- readLn :: IO Int
        cadastrarAtividade conn atividade_titulo atividade_descricao "Nao iniciada" atividade_responsavel_id

    else if funcao_atividade == "2" then do
        atividades_nao_iniciadas <- buscarAtividadesNaoIniciadas conn
        formataListaAtividade conn atividades_nao_iniciadas

    else if funcao_atividade == "3" then do
        atividades_em_andamento <- buscarAtividadesEmAndamento conn
        formataListaAtividade conn atividades_em_andamento

    else if funcao_atividade == "4" then do
        atividades_concluidas <- buscarAtividadesConcluidas conn
        formataListaAtividade conn atividades_concluidas

    else if funcao_atividade == "5" then do
        putStrLn "Qual o ID da atividade que você deseja buscar?"
        atividade_id <- readLn :: IO Int
        atividade_encontrada <- buscarAtividadePorId conn atividade_id
        case atividade_encontrada of
            Just atividade -> formataAtividade conn atividade
            Nothing -> printf "Atividade com o ID informado não foi encontrada\n"

    else if funcao_atividade == "6" then do
        putStrLn "Qual o ID da atividade que você deseja colocar em andamento?"
        atividade_id <- readLn :: IO Int
        putStrLn "Qual o seu ID?"
        atividade_responsavel_id <- readLn :: IO Int
        atualizarStatusAtividade conn atividade_id "Em andamento"
        atualizarResponsavelIdAtividade conn atividade_id atividade_responsavel_id
    
    else if funcao_atividade == "7" then do
        putStrLn "Qual o ID atividade que você deseja marcar como concluída?"
        atividade_id <- readLn :: IO Int
        atualizarStatusAtividade conn atividade_id "Concluida"

    else if funcao_atividade == "8" then do
        putStrLn "Qual o ID atividade que você deseja excluir?"
        atividade_id <- readLn :: IO Int
        excluirAtividade conn atividade_id

    else do
            printf "Você não selecionou uma opção válida. Selecione algum das opções abaixo\n"
            lidaComFuncaoEscolhida conn "1"

formataListaAtividade :: Connection -> [Atividade] -> IO ()
formataListaAtividade _ [] = putStrLn ""
formataListaAtividade conn (x:xs) = do
    formataAtividade conn x
    formataListaAtividade conn xs

formataAtividade :: Connection -> Atividade -> IO ()
formataAtividade conn atividade = do
    putStrLn "\n------------------------"
    printf "%s\n" (atividade_titulo atividade)
    putStrLn "------------------------"
    printf "Descrição: %s\n" (atividade_descricao atividade)
    printf "Status: %s\n" (atividade_status atividade)
    responsavel <- buscarAnalistaPorId conn (atividade_responsavel_id atividade)
    case responsavel of
        Just analista -> printf "Responsavel: %s\n" (analista_nome analista)
        Nothing -> printf "Nao ha analista responsavel por essa atividade"

exibeMenuOpcoesAnalistaChamado :: IO ()
exibeMenuOpcoesAnalistaChamado = do
    putStrLn "---FUNÇÕES PARA QUADRO DE CHAMADOS---"
    putStrLn "1 - Criar novo chamado"
    putStrLn "2 - Listar chamados não iniciados"
    putStrLn "3 - Listar chamados em andamento"
    putStrLn "4 - Listar chamados concluídos"
    putStrLn "5 - Buscar chamado por ID"
    putStrLn "6 - Colocar chamado em andamento"
    putStrLn "7 - Finalizar chamado"
    putStrLn "8 - Excluir um chamado"
    putStrLn "9 - Repassar chamado para analista diferente"
    putStrLn "------------------------------------------"
    putStrLn "Qual função você deseja executar?"

lidaComOpcaoChamado :: Connection -> String -> IO ()
lidaComOpcaoChamado conn funcao_chamado = do
    if funcao_chamado == "1" then do
        putStrLn "Qual o titulo do chamado a ser criado?"
        chamado_titulo <- getLine
        putStrLn "Qual a descrição do chamado?"
        chamado_descricao <- getLine
        putStrLn "Quem é o responsável pelo chamado"
        chamado_responsavel_id <- readLn :: IO Int
        cadastrarChamado conn chamado_titulo chamado_descricao "Nao iniciado" chamado_responsavel_id chamado_responsavel_id
        putStrLn "---Chamado criado com sucesso---"

    else if funcao_chamado == "2" then do
        chamados_nao_iniciados <- buscarChamadosNaoIniciados conn
        formataListaChamado conn chamados_nao_iniciados
        
    else if funcao_chamado == "3" then do
        chamados_em_andamento <- buscarChamadosEmAndamento conn
        formataListaChamado conn chamados_em_andamento

    else if funcao_chamado == "4" then do
        chamados_concluidos <- buscarChamadosConcluidos conn
        formataListaChamado conn chamados_concluidos

    else if funcao_chamado == "5" then do
        putStrLn "Qual o ID do chamado que você deseja buscar?"
        chamado_id <- readLn :: IO Int
        chamado_encontrado <- buscarChamadoPorId conn chamado_id
        case chamado_encontrado of
            Just chamado -> formataChamado conn chamado
            Nothing -> printf "Chamado com o ID informado não foi encontrado\n"

    else if funcao_chamado == "6" then do
        putStrLn "Qual o ID do chamado que você deseja colocar em andamento?"
        chamado_id <- readLn :: IO Int
        putStrLn "Qual o seu ID?"
        chamado_analista_id <- readLn :: IO Int
        atualizarStatusChamado conn chamado_id "Em andamento"
        atualizarAnalistaIdChamado conn chamado_id chamado_analista_id
        putStrLn "---Chamado colocado em andamento com sucesso---"
    
    else if funcao_chamado == "7" then do
        putStrLn "Qual o ID do chamado que você deseja marcar como concluído?"
        chamado_id <- readLn :: IO Int
        atualizarStatusChamado conn chamado_id "Concluido"
        putStrLn "---Chamado concluído com sucesso---"

    else if funcao_chamado == "8" then do
        putStrLn "Qual o ID do chamado que você deseja excluir?"
        chamado_id <- readLn :: IO Int
        excluirAtividade conn chamado_id
        putStrLn "---Chamado excluido com sucesso---"
    
    else if funcao_chamado == "9" then do
        putStrLn "Qual o ID do chamado que você deseja repassar?"
        chamado_id <- readLn :: IO Int
        putStrLn "Qual o ID do analista que você deseja que o chamado seja repassado?"
        novo_analista_id <- readLn :: IO Int
        atualizarAnalistaIdChamado conn chamado_id novo_analista_id
        putStrLn "---Chamado repassado com sucesso---"

    else do
            printf "Você não selecionou uma opção válida. Selecione algum das opções abaixo\n"
            lidaComFuncaoEscolhida conn "3"

formataListaChamado :: Connection -> [Chamado] -> IO ()
formataListaChamado _ [] = putStrLn ""
formataListaChamado conn (x:xs) = do
    formataChamado conn x
    formataListaChamado conn xs

formataChamado :: Connection -> Chamado -> IO ()
formataChamado conn chamado = do
    putStrLn "\n------------------------"
    printf "%s\n" (chamado_titulo chamado)
    putStrLn "------------------------"
    printf "Descrição: %s\n" (chamado_descricao chamado)
    printf "Status: %s\n" (chamado_status chamado)
    responsavel <- buscarAnalistaPorId conn (chamado_analista_id chamado)
    case responsavel of
        Just analista -> printf "Responsavel: %s\n" (analista_nome analista)
        Nothing -> printf "Não há analista responsável por essa atividade"