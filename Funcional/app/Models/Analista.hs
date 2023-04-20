module Models.Analista where

data Analista = Analista {
    analista_id :: Int,
    analista_nome :: String,
    analista_email :: String,
    analista_senha :: String,
    analista_avaliacao :: Float
} deriving (Show, Read, Eq)