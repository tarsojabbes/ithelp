{-# LANGUAGE OverloadedStrings #-}
module LocalDB.ConnectionDB where
import Database.PostgreSQL.Simple

-- Informações do banco de dados local
localDB :: ConnectInfo
localDB = defaultConnectInfo {
    connectHost = "localhost",
    connectDatabase = "postgres",
    connectUser = "postgres",
    connectPassword = "123456",
    connectPort = 5432
}

-- Conexão com o banco
connectionMyDB :: IO Connection
connectionMyDB = connect localDB

createAnalista :: Connection -> IO()
createAnalista conn = do
    execute_ conn "CREATE TABLE IF NOT EXISTS analista (\
                    \analista_id SERIAL PRIMARY KEY,\
                    \analista_nome VARCHAR(100) NOT NULL,\
                    \analista_email VARCHAR(100) NOT NULL,\
                    \analista_senha VARCHAR(100) NOT NULL,\
                    \analista_avaliacao FLOAT NOT NULL)"
    return ()

createGestor :: Connection -> IO()
createGestor conn = do
    execute_ conn "CREATE TABLE IF NOT EXISTS gestor (\
                    \gestor_id SERIAL PRIMARY KEY,\
                    \gestor_nome VARCHAR(100) NOT NULL,\
                    \gestor_email VARCHAR(100) NOT NULL,\
                    \gestor_senha VARCHAR(100) NOT NULL)"
    return ()

createUsuario :: Connection -> IO()
createUsuario conn = do
    execute_ conn "CREATE TABLE IF NOT EXISTS usuario (\
                    \usuario_id SERIAL PRIMARY KEY,\
                    \usuario_nome VARCHAR(100) NOT NULL,\
                    \usuario_email VARCHAR(100) NOT NULL,\
                    \usuario_senha VARCHAR(100) NOT NULL)"
    return ()

createInventario :: Connection -> IO()
createInventario conn = do
    execute_ conn "CREATE TABLE IF NOT EXISTS inventario (\
                    \item_id SERIAL PRIMARY KEY,\
                    \item_nome VARCHAR(150) NOT NULL,\
                    \item_marca VARCHAR(50) NOT NULL,\
                    \item_data_aquisicao DATE NOT NULL)"
    return ()

createChamado :: Connection -> IO()
createChamado conn = do
    execute_ conn "CREATE TABLE IF NOT EXISTS chamado (\
                    \chamado_id SERIAL PRIMARY KEY,\
                    \chamado_titulo VARCHAR(200) NOT NULL,\
                    \chamado_descricao TEXT NOT NULL,\
                    \chamado_status VARCHAR(20) NOT NULL,\
                    \chamado_criador_id INTEGER REFERENCES usuario(usuario_id),\
                    \chamado_analista_id INTEGER REFERENCES analista(analista_id))"
    return ()

createQuadroAtividade :: Connection -> IO()
createQuadroAtividade conn = do
    execute_ conn "CREATE TABLE IF NOT EXISTS quadro_atividade (\
                    \atividade_id SERIAL PRIMARY KEY,\
                    \atividade_titulo VARCHAR(200) NOT NULL,\
                    \atividade_descricao TEXT NOT NULL,\
                    \atividade_responsavel_id INTEGER REFERENCES analista(analista_id),\
                    \atividade_status VARCHAR(20) NOT NULL)"
    return ()


iniciandoDatabase :: IO Connection
iniciandoDatabase = do
  c <- connectionMyDB
  createAnalista c
  createGestor c
  createUsuario c
  createInventario c
  createChamado c
  createQuadroAtividade c
  return c