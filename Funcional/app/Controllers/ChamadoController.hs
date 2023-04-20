{-# LANGUAGE OverloadedStrings #-}
module Controllers.ChamadoController where
import Database.PostgreSQL.Simple
import Models.Chamado (Chamado)

cadastrarChamado :: Connection -> String -> String -> String -> Int -> Int -> IO ()
cadastrarChamado conn titulo descricao status criador_id analista_id = do
    let query = "insert into chamado (chamado_titulo, \
                                    \chamado_descricao, \
                                    \chamado_status, \
                                    \chamado_criador_id, \
                                    \chamado_analista_id) values (?, ?, ?, ?, ?)"
    execute conn query (titulo, descricao, status, criador_id, analista_id)
    return ()

listarChamados :: Connection -> IO [Chamado]
listarChamados conn = do
    query_ conn "SELECT c.chamado_id, \
                        \c.chamado_titulo, \
                        \c.chamado_descricao, \
                        \c.chamado_status, \
                        \c.chamado_criador_id, \
                        \c.chamado_analista_id \
                        \FROM chamado c" :: IO [Chamado]