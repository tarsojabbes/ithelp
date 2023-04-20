module Models.Gestor where

data Gestor = Gestor {
    gestor_id :: Int,
    gestor_nome :: String,
    gestor_email :: String,
    gestor_senha :: String
} deriving (Show, Read, Eq)