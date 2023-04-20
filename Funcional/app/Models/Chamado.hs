module Models.Chamado where
import Database.PostgreSQL.Simple (FromRow)
import Database.PostgreSQL.Simple.FromRow (field, FromRow (fromRow))

data Chamado = Chamado {
    chamado_id :: Int,
    chamado_titulo :: String,
    chamado_descricao :: String,
    chamado_status :: String,
    chamado_criador_id :: Int,
    chamado_analista_id :: Int
} deriving (Show, Read, Eq)

instance FromRow Chamado where
    fromRow = Chamado <$> field
                        <*> field
                        <*> field
                        <*> field
                        <*> field
                        <*> field