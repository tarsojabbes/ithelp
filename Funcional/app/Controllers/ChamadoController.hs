{-# LANGUAGE OverloadedStrings #-}
module Controllers.ChamadoController where
import Database.PostgreSQL.Simple
import Models.Chamado (Chamado)
import qualified Control.Monad

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

buscarChamadosNaoIniciados :: Connection -> IO [Chamado]
buscarChamadosNaoIniciados conn = do
    query_ conn "SELECT c.chamado_id, \
                        \c.chamado_titulo, \
                        \c.chamado_descricao, \
                        \c.chamado_status, \
                        \c.chamado_criador_id, \
                        \c.chamado_analista_id \
                        \FROM chamado c WHERE c.chamado_status = 'Nao iniciado'" :: IO [Chamado]

buscarChamadosEmAndamento :: Connection -> IO [Chamado]
buscarChamadosEmAndamento conn = do
    query_ conn "SELECT c.chamado_id, \
                        \c.chamado_titulo, \
                        \c.chamado_descricao, \
                        \c.chamado_status, \
                        \c.chamado_criador_id, \
                        \c.chamado_analista_id \
                        \FROM chamado c WHERE c.chamado_status = 'Em andamento'" :: IO [Chamado]

buscarChamadosConcluidos :: Connection -> IO [Chamado]
buscarChamadosConcluidos conn = do
    query_ conn "SELECT c.chamado_id, \
                        \c.chamado_titulo, \
                        \c.chamado_descricao, \
                        \c.chamado_status, \
                        \c.chamado_criador_id, \
                        \c.chamado_analista_id \
                        \FROM chamado c WHERE c.chamado_status = 'Concluido'" :: IO [Chamado]

buscarChamadosPorTitulo :: Connection -> String -> IO (Maybe [Chamado])
buscarChamadosPorTitulo conn titulo = do
    result <- query conn "SELECT c.chamado_id, \
                          \c.chamado_titulo, \
                          \c.chamado_descricao, \
                          \c.chamado_status, \
                          \c.chamado_criador_id, \
                          \c.chamado_analista_id \
                          \FROM chamado c WHERE c.chamado_titulo = ?" (Only titulo)
    case result of
        [] -> return Nothing
        chamados -> return (Just chamados)

buscarChamadoPorId :: Connection -> Int -> IO (Maybe Chamado)
buscarChamadoPorId conn id = do
    chamadoEncontrado <- query conn "SELECT c.chamado_id, \
                        \c.chamado_titulo, \
                        \c.chamado_descricao, \
                        \c.chamado_status, \
                        \c.chamado_criador_id, \
                        \c.chamado_analista_id \
                        \FROM chamado c WHERE c.chamado_id = ?" (Only id)
    case chamadoEncontrado of
        [row] -> return $ Just row
        _ -> return Nothing

buscarChamadoPorCriadorId :: Connection -> Int -> IO (Maybe Chamado)
buscarChamadoPorCriadorId conn criador_id = do
    chamadoEncontrado <- query conn "SELECT c.chamado_id, \
                        \c.chamado_titulo, \
                        \c.chamado_descricao, \
                        \c.chamado_status, \
                        \c.chamado_criador_id, \
                        \c.chamado_analista_id \
                        \FROM chamado c WHERE c.chamado_criador_id = ?" (Only criador_id)
    case chamadoEncontrado of
        [row] -> return $ Just row
        _ -> return Nothing

buscarChamadoPorAnalistaId :: Connection -> Int -> IO (Maybe [Chamado])
buscarChamadoPorAnalistaId conn analista_id = do
    chamadosEncontrados <- query conn "SELECT c.chamado_id, \
                        \c.chamado_titulo, \
                        \c.chamado_descricao, \
                        \c.chamado_status, \
                        \c.chamado_criador_id, \
                        \c.chamado_analista_id \
                        \FROM chamado c WHERE c.chamado_analista_id = ?" (Only analista_id)
    case chamadosEncontrados of
        [] -> return Nothing
        _ -> return $ Just chamadosEncontrados

atualizarStatusChamado :: Connection -> Int -> String -> IO ()
atualizarStatusChamado conn id status = do
    execute conn "UPDATE chamado SET chamado_status = ? WHERE chamado_id = ?" (status, id)
    return ()

atualizarAnalistaIdChamado :: Connection -> Int -> Int -> IO ()
atualizarAnalistaIdChamado conn chamado_id analista_id = do
    execute conn "UPDATE chamado SET chamado_analista_id = ? WHERE chamado_id = ?" (analista_id, chamado_id)
    return ()

excluirChamado :: Connection -> Int -> IO ()
excluirChamado conn chamado_id = Control.Monad.void $ execute conn "DELETE FROM chamado WHERE chamado_id = ?" (Only chamado_id)