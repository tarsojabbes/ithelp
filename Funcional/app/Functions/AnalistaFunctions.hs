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
