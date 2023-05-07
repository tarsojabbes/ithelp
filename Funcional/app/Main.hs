{-# LANGUAGE OverloadedStrings #-}

module Main where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Controllers.AnalistaController (listarAnalistas, buscarAnalistaPorEmail)
import Controllers.AtividadeController (listarAtividades, cadastrarAtividade, buscarAtividadePorId)
import Controllers.ChamadoController (listarChamados)
import Controllers.ItemInventarioController (listarItensInventario)
import Controllers.UsuarioController
import Models.Gestor (Gestor(gestor_senha, gestor_id), gestor_nome)
import Controllers.GestorController (buscarGestorPorEmail)
import Models.Analista
import Models.Usuario
import Models.Atividade (Atividade(atividade_responsavel_id, atividade_titulo, atividade_descricao))
import Text.Printf
import Functions.AnalistaFunctions
import Functions.GestorFunctions
import Functions.UsuarioFunctions

exibeMenuLogin :: IO ()
exibeMenuLogin = do
    putStrLn "Com qual perfil de acesso você deseja utilizar o sistema?"
    putStrLn "[G]estor"
    putStrLn "[A]nalista"
    putStrLn "[U]suário"

loginAnalista :: Connection -> IO (Maybe Analista)
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
                return (Just analistaEncontrado)
            else do
                putStrLn "Senha incorreta"
                return Nothing
        Nothing -> do
            putStrLn "Analista não encontrado"
            return Nothing

loginGestor :: Connection -> IO Bool
loginGestor conn = do
    putStrLn "Informe o seu email:"
    email <- getLine
    putStrLn "Informe a sua senha:"
    senha <- getLine
    maybeGestorEncontrado <- buscarGestorPorEmail conn email
    case maybeGestorEncontrado of
        Just gestorEncontrado ->
            if gestor_senha gestorEncontrado == senha
            then do
                printf "Seja bem vindo, %s, caso requisitado informe seu ID: %d" (gestor_nome gestorEncontrado) (gestor_id gestorEncontrado)
                return True
            else do
                putStrLn "Senha incorreta"
                return False
        Nothing -> do
            putStrLn "Gestor não encontrado"
            return False

loginUsuario :: Connection -> IO (Maybe Usuario)
loginUsuario conn = do
    putStrLn "Informe o seu email:"
    email <- getLine
    putStrLn "Informe a sua senha:"
    senha <- getLine
    maybeUsuarioEncontrado <- buscarUsuarioPorEmail conn email
    case maybeUsuarioEncontrado of
        Just usuarioEncontrado ->
            if usuario_senha usuarioEncontrado == senha
            then do
                printf "Seja bem vindo, %s, caso requisitado informe seu ID: %d" (usuario_nome usuarioEncontrado) (usuario_id usuarioEncontrado)
                return (Just usuarioEncontrado)
            else do
                putStrLn "Senha incorreta"
                return Nothing
        Nothing -> do
            putStrLn "Usuário não encontrado"
            return Nothing
                        
main :: IO ()
main = do
    conn <- iniciandoDatabase
    exibeMenuLogin
    perfil <- getLine
    if perfil == "a" || perfil == "A" then do
        loginEfetuado <- loginAnalista conn
        case loginEfetuado of
            Just analistaEncontrado -> funcoesAnalista conn analistaEncontrado
            Nothing -> putStrLn ""
    else if perfil == "g" || perfil == "G" then do
        loginEfetuado <- loginGestor conn
        if loginEfetuado then funcoesGestor conn else do putStrLn ""
    else if perfil == "u" || perfil == "U" then do
        loginEfetuado <- loginUsuario conn
        case loginEfetuado of
            Just usuarioEncontrado -> funcoesUsuario conn usuarioEncontrado
            Nothing -> putStrLn ""
    else do
        putStrLn "Nada"
