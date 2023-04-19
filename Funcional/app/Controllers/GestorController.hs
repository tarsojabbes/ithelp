{-# LANGUAGE OverloadedStrings #-}
module Controllers.GestorController where
import Database.PostgreSQL.Simple

cadastrarGestor :: Connection -> String -> String -> String -> IO()
cadastrarGestor conn nome email senha = do
    let query = "insert into gestor (gestor_nome, \
                                    \gestor_email, \
                                    \gestor_senha) values (?, ?, ?)"
    execute conn query (nome, email, senha)
    return ()