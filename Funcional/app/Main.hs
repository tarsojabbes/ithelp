{-# LANGUAGE OverloadedStrings #-}

module Main where
import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Controllers.AnalistaController (listarAnalistas)
import Controllers.AtividadeController (listarAtividades)
import Controllers.ChamadoController (listarChamados)
import Controllers.ItemInventarioController (listarItensInventario)
import Controllers.UsuarioController

main :: IO ()
main = do
    putStrLn "Criando base de dados..."
    conn <- iniciandoDatabase
    putStrLn "Base de dados criada"
