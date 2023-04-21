{-# LANGUAGE OverloadedStrings #-}
module Controllers.GestorController where
import Database.PostgreSQL.Simple
import Models.Gestor (Gestor)

cadastrarGestor :: Connection -> String -> String -> String -> IO()
cadastrarGestor conn nome email senha = do
    let query = "insert into gestor (gestor_nome, \
                                    \gestor_email, \
                                    \gestor_senha) values (?, ?, ?)"
    execute conn query (nome, email, senha)
    return ()

listarGestores :: Connection -> IO [Gestor]
listarGestores conn = do
    query_ conn "SELECT g.gestor_id, \
                        \g.gestor_nome, \
                        \g.gestor_email, \
                        \g.gestor_senha \
                        \FROM gestor g" :: IO [Gestor]

buscarGestorPorId :: Connection -> Int -> IO (Maybe Gestor)
buscarGestorPorId conn id = do
    gestorEncontrado <- query conn "SELECT g.gestor_id, \
                                    \g.gestor_nome, \
                                    \g.gestor_email, \
                                    \g.gestor_senha \
                                    \FROM gestor g WHERE g.gestor_id = ?" (Only id)
    case gestorEncontrado of
        [row] -> return $ Just row
        _ -> return Nothing

buscarGestorPorEmail :: Connection -> String -> IO (Maybe Gestor)
buscarGestorPorEmail conn email = do
    gestorEncontrado <- query conn "SELECT g.gestor_id, \
                                    \g.gestor_nome, \
                                    \g.gestor_email, \
                                    \g.gestor_senha \
                                    \FROM gestor g WHERE g.gestor_email = ?" (Only email)
    case gestorEncontrado of
        [row] -> return $ Just row
        _ -> return Nothing