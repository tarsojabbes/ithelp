module Models.ItemInventario where
import Database.PostgreSQL.Simple (FromRow)
import Database.PostgreSQL.Simple.FromRow (field, FromRow (fromRow))
import Data.Time (Day)
data ItemInventario = ItemInventario {
    item_id :: Int,
    item_nome :: String,
    item_marca :: String,
    item_data_aquisicao :: Day
} deriving (Show, Read, Eq)

instance FromRow ItemInventario where
    fromRow = ItemInventario <$> field
                        <*> field
                        <*> field
                        <*> field