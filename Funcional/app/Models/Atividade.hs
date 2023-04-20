module Models.Atividade where

data Atividade = Atividade {
    atividade_id :: Int,
    atividade_titulo :: String,
    atividade_descricao :: String,
    atividade_responsavel_id :: Int,
    atividade_status :: String
} deriving (Show, Read, Eq)