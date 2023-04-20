module Models.Usuario where

data Usuario = Usuario {
    usuario_id :: Int,
    usuario_nome :: String,
    usuario_email :: String,
    usuario_senha :: String
} deriving (Show, Read, Eq)