module Models.Chamado where

data Chamado = Chamado {
    chamado_id :: Int,
    chamado_titulo :: String,
    chamado_descricao :: String,
    chamado_status :: String,
    chamado_criador_id :: Int,
    chamado_analista_id :: Int
} deriving (Show, Read, Eq)