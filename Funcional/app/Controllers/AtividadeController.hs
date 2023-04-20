{-# LANGUAGE OverloadedStrings #-}
module Controllers.AtividadeController where
import Database.PostgreSQL.Simple
import Models.Atividade

cadastrarAtividade :: Connection -> String -> String -> String -> Int -> IO()
cadastrarAtividade conn titulo descricao status responsavel_id = do
    let query = "insert into quadro_atividade (atividade_titulo, \
                                                \atividade_descricao, \
                                                \atividade_status, \
                                                \atividade_responsavel_id) values (?, ?, ?, ?)"
    execute conn query (titulo, descricao, status, responsavel_id)
    return ()

listarAtividades :: Connection -> IO [Atividade]
listarAtividades conn = do
    query_ conn "SELECT a.atividade_id, \
                        \a.atividade_titulo, \
                        \a.atividade_descricao, \
                        \a.atividade_status, \
                        \a.atividade_responsavel_id \
                        \FROM quadro_atividade a" :: IO [Atividade]