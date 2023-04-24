{-# LANGUAGE OverloadedStrings #-}
module Controllers.UsuarioController where
import Database.PostgreSQL.Simple
import Models.Usuario
import qualified Control.Monad

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

buscarUsuarioPorId :: Connection -> Int -> IO (Maybe Usuario)
buscarUsuarioPorId conn id = do
    usuarioEncontrado <- query conn "SELECT u.usuario_id, \
                        \u.usuario_nome, \
                        \u.usuario_email, \
                        \u.usuario_senha \
                        \FROM usuario u WHERE u.usuario_id = ?" (Only id)
    case usuarioEncontrado of
        [row] -> return $ Just row
        _ -> return Nothing

buscarUsuarioPorEmail :: Connection -> String -> IO (Maybe Usuario)
buscarUsuarioPorEmail conn email = do
    usuarioEncontrado <- query conn "SELECT u.usuario_id, \
                        \u.usuario_nome, \
                        \u.usuario_email, \
                        \u.usuario_senha \
                        \FROM usuario u WHERE u.usuario_email = ?" (Only email)
    case usuarioEncontrado of
        [row] -> return $ Just row
        _ -> return Nothing

excluirUsuario :: Connection -> Int -> IO ()
excluirUsuario conn usuario_id = Control.Monad.void $ execute conn "DELETE FROM usuario WHERE usuario_id = ?" (Only usuario_id)