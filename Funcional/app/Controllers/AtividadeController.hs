{-# LANGUAGE OverloadedStrings #-}
module Controllers.ChamadoController where
import Database.PostgreSQL.Simple ( execute, Connection )

cadastrarAtividade :: Connection -> String -> String -> String -> Int -> IO()
cadastrarAtividade conn titulo descricao status responsavel_id = do
    let query = "insert into quadro_atividade (atividade_titulo, \
                                                \atividade_descricao, \
                                                \atividade_status, \
                                                \atividade_responsavel_id) values (?, ?, ?, ?)"
    execute conn query (titulo, descricao, status, responsavel_id)
    return ()