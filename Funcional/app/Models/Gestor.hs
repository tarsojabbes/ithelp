module Models.Gestor where
import Database.PostgreSQL.Simple (FromRow)
import Database.PostgreSQL.Simple.FromRow (field, FromRow (fromRow))

data Gestor = Gestor {
    gestor_id :: Int,
    gestor_nome :: String,
    gestor_email :: String,
    gestor_senha :: String
} deriving (Show, Read, Eq)

instance FromRow Gestor where
    fromRow = Gestor <$> field
                        <*> field
                        <*> field
                        <*> field