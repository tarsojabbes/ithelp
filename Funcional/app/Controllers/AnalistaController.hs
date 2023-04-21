{-# LANGUAGE OverloadedStrings #-}
module Controllers.AnalistaController where
import Database.PostgreSQL.Simple
import Models.Analista

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

buscarAnalistaPorId :: Connection -> Int -> IO (Maybe Analista)
buscarAnalistaPorId conn id = do
    analistaEncontrado <- query conn "SELECT a.analista_id, \
                                        \a.analista_nome, \
                                        \a.analista_email, \
                                        \a.analista_senha, \
                                        \a.analista_avaliacao \
                                        \FROM analista a WHERE a.analista_id = ?" (Only id)
    case analistaEncontrado of
        [row] -> return $ Just row
        _ -> return Nothing

buscarAnalistaPorEmail :: Connection -> String -> IO (Maybe Analista)
buscarAnalistaPorEmail conn email = do
    analistaEncontrado <- query conn "SELECT a.analista_id, \
                                        \a.analista_nome, \
                                        \a.analista_email, \
                                        \a.analista_senha, \
                                        \a.analista_avaliacao \
                                        \FROM analista a WHERE a.analista_email = ?" (Only email)
    case analistaEncontrado of
        [row] -> return $ Just row
        _ -> return Nothing

atualizarAvaliacaoAnalista :: Connection -> Int -> Int -> IO ()
atualizarAvaliacaoAnalista conn analista_id avaliacao = do
    [Only avaliacao_atual] <- query conn "SELECT analista_avaliacao FROM analista WHERE analista_id = ?" (Only analista_id)

    let nova_avaliacao = (avaliacao_atual + avaliacao) `div` 2

    execute conn "UPDATE analista SET analista_avaliacao = ? WHERE analista_id = ?" (nova_avaliacao, analista_id)
    return ()