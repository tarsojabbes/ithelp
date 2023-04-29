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
import Functions.AnalistaFunctions

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
                        

main :: IO ()
main = do
    conn <- iniciandoDatabase
    exibeMenuLogin
    perfil <- getLine
    if perfil == "a" || perfil == "A" then do
        loginEfetuado <- loginAnalista conn
        if loginEfetuado then funcoesAnalista conn else do putStrLn ""
    else do
        print "Nada"
    
