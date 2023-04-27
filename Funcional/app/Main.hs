{-# LANGUAGE OverloadedStrings #-}

module Main where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Controllers.AnalistaController (listarAnalistas, buscarAnalistaPorEmail)
import Controllers.AtividadeController (listarAtividades, cadastrarAtividade, buscarAtividadePorId)
import Controllers.ChamadoController (listarChamados)
import Controllers.ItemInventarioController (listarItensInventario)
import Controllers.UsuarioController
import Models.Gestor (Gestor(gestor_senha))
import Controllers.GestorController (buscarGestorPorEmail)
import Models.Analista
import Models.Usuario
import Models.Atividade (Atividade(atividade_responsavel_id, atividade_titulo, atividade_descricao))
import Text.Printf

exibeMenuLogin :: IO ()
exibeMenuLogin = do
    putStrLn "Com qual perfil de acesso você deseja utilizar o sistema?"
    putStrLn "[G]estor"
    putStrLn "[A]nalista"
    putStrLn "[U]suário"

loginAnalista :: Connection -> IO Bool
loginAnalista conn = do
    putStrLn "Informe o seu email:"
    email <- getLine
    putStrLn "Informe a sua senha:"
    senha <- getLine
    maybeAnalistaEncontrado <- buscarAnalistaPorEmail conn email
    case maybeAnalistaEncontrado of
        Just analistaEncontrado ->
            if analista_senha analistaEncontrado == senha
            then do
                printf "Seja bem vindo, %s, caso requisitado informe seu ID: %d" (analista_nome analistaEncontrado) (analista_id analistaEncontrado)
                return True
            else do
                print "Senha incorreta"
                return False
        Nothing -> do
            print "Analista não encontrado"
            return False
                        

funcoesAnalista :: Connection -> IO ()
funcoesAnalista conn = do
    putStrLn "Enquanto analista, você pode executar as seguintes funções:"
    putStrLn "------FUNÇÕES PARA ANALISTA----"
    putStrLn "1 - Gerenciar atividades"
    putStrLn "2 - Gerenciar itens do inventário"
    putStrLn "3 - Gerenciar chamados"
    putStrLn "4 - Ver minhas estatísticas"
    putStrLn "------------------------------------------"
    putStrLn "Qual função você deseja executar?"
    funcao <- getLine

    if funcao == "1" then do
        putStrLn "---FUNÇÕES PARA QUADRO DE ATIVIDADES---"
        putStrLn "1 - Criar nova atividade"
        putStrLn "2 - Listar atividades não iniciadas"
        putStrLn "3 - Listar atividades em andamento"
        putStrLn "4 - Listar atividades concluídas"
        putStrLn "5 - Buscar atividade por ID"
        putStrLn "------------------------------------------"
        putStrLn "Qual função você deseja executar?"
        funcao_atividade <- getLine

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
    else do
        print ""

main :: IO ()
main = do
    putStrLn "Criando base de dados..."
    conn <- iniciandoDatabase
    putStrLn "Base de dados criada"
    exibeMenuLogin
    perfil <- getLine
    if perfil == "a" then do
        loginEfetuado <- loginAnalista conn
        if loginEfetuado then funcoesAnalista conn else do putStrLn ""
    else do
        print "Nada"
    
