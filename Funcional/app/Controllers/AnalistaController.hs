{-# LANGUAGE OverloadedStrings #-}
module Controllers.AnalistaController where
import Database.PostgreSQL.Simple
import Models.Analista
import qualified Models.Analista

cadastrarAnalista :: Connection -> String -> String -> String -> Int -> IO()
cadastrarAnalista conn nome email senha avaliacao = do
    let query = "insert into analista (analista_nome, \
                                    \analista_email,\
                                    \analista_senha,\
                                    \analista_avaliacao) values (?, ?, ?, ?)"
    execute conn query (nome, email, senha , avaliacao)
    return ()

listarAnalistas :: Connection -> IO [Analista]
listarAnalistas conn = do
    query_ conn "SELECT a.analista_id,\
                        \a.analista_nome, \
                        \a.analista_email, \
                        \a.analista_senha, \
                        \a.analista_avaliacao \
                        \FROM analista a" :: IO [Analista]
