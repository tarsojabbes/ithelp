{-# LANGUAGE OverloadedStrings #-}
module Controllers.UsuarioController where
import Database.PostgreSQL.Simple
import Models.Usuario

cadastrarUsuario :: Connection -> String -> String -> String -> IO()
cadastrarUsuario conn nome email senha = do
    let query = "insert into usuario (usuario_nome, \
                                    \usuario_email, \
                                    \usuario_senha) values (?, ?, ?)"
    execute conn query (nome, email, senha)
    return ()

listarUsuarios :: Connection -> IO [Usuario]
listarUsuarios conn = do
    query_ conn "SELECT u.usuario_id, \
                        \u.usuario_nome, \
                        \u.usuario_email, \
                        \u.usuario_senha \
                        \FROM usuario u" :: IO [Usuario]
