{-# LANGUAGE OverloadedStrings #-}
module Controllers.UsuarioController where
import Database.PostgreSQL.Simple

cadastrarUsuario :: Connection -> String -> String -> String -> IO()
cadastrarUsuario conn nome email senha = do
    let query = "insert into usuario (usuario_nome, \
                                    \usuario_email, \
                                    \usuario_senha) values (?, ?, ?)"
    execute conn query (nome, email, senha)
    return ()
