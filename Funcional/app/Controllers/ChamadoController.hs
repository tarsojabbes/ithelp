{-# LANGUAGE OverloadedStrings #-}
module Controllers.ChamadoController where
import Database.PostgreSQL.Simple

cadastrarChamado :: Connection -> String -> String -> String -> Int -> Int -> IO ()
cadastrarChamado conn titulo descricao status criador_id analista_id = do
    let query = "insert into chamado (chamado_titulo, \
                                    \chamado_descricao, \
                                    \chamado_status, \
                                    \chamado_criador_id, \
                                    \chamado_analista_id) values (?, ?, ?, ?, ?)"
    execute conn query (titulo, descricao, status, criador_id, analista_id)
    return ()