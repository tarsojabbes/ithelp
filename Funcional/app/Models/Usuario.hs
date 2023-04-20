module Models.Usuario where
import Database.PostgreSQL.Simple (FromRow)
import Database.PostgreSQL.Simple.FromRow (field, FromRow (fromRow))

data Usuario = Usuario {
    usuario_id :: Int,
    usuario_nome :: String,
    usuario_email :: String,
    usuario_senha :: String
} deriving (Show, Read, Eq)

instance FromRow Usuario where
    fromRow = Usuario <$> field
                        <*> field
                        <*> field
                        <*> field