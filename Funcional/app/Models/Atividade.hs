module Models.Atividade where
import Database.PostgreSQL.Simple (FromRow)
import Database.PostgreSQL.Simple.FromRow (field, FromRow (fromRow))

data Atividade = Atividade {
    atividade_id :: Int,
    atividade_titulo :: String,
    atividade_descricao :: String,
    atividade_status :: String,
    atividade_responsavel_id :: Int
} deriving (Show, Read, Eq)

instance FromRow Atividade where
    fromRow = Atividade <$> field
                        <*> field
                        <*> field
                        <*> field
                        <*> field