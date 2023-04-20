module Models.Analista where
import Database.PostgreSQL.Simple (FromRow)
import Database.PostgreSQL.Simple.FromRow (field, FromRow (fromRow))

data Analista = Analista {
    analista_id :: Int,
    analista_nome :: String,
    analista_email :: String,
    analista_senha :: String,
    analista_avaliacao :: Int
} deriving (Show, Read, Eq)

instance FromRow Analista where
    fromRow = Analista <$> field
                        <*> field
                        <*> field
                        <*> field
                        <*> field