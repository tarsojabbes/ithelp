{-# LANGUAGE OverloadedStrings #-}
module Functions.AnalistaFunctions where
import Database.PostgreSQL.Simple
import Controllers.AtividadeController

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
        print ""

exibeMenuOpcoesAnalistaAtividade :: IO ()
exibeMenuOpcoesAnalistaAtividade = do
    putStrLn "---FUNÇÕES PARA QUADRO DE ATIVIDADES---"
    putStrLn "1 - Criar nova atividade"
    putStrLn "2 - Listar atividades não iniciadas"
    putStrLn "3 - Listar atividades em andamento"
    putStrLn "4 - Listar atividades concluídas"
    putStrLn "5 - Buscar atividade por ID"
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
    else if funcao_atividade == "5" then do
        putStrLn "Qual o ID da atividade que você deseja buscar?"
        atividade_id <- readLn :: IO Int
        atividade_encontrada <- buscarAtividadePorId conn atividade_id
        print atividade_encontrada
    else do
            print ""
