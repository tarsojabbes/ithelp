{-# LANGUAGE OverloadedStrings #-}
module Controllers.AnalistaController where
import Database.PostgreSQL.Simple

cadastrarAnalista :: Connection -> String -> String -> String -> String -> Float -> IO()
cadastrarAnalista conn nome email senha cargo avaliacao = do
    let query = "insert into analista (analista_nome, \
                                    \analista_email,\
                                    \analista_senha,\
                                    \cargo,\
                                    \analista_avaliacao) values (?, ?, ?, ?, ?)"
    execute conn query (nome, email, senha, cargo, avaliacao)
    return ()


