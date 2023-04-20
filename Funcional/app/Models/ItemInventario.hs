module Models.ItemInventario where

data ItemInventario = ItemInventario {
    item_id :: Int,
    item_nome :: String,
    item_marca :: String,
    item_data_aquisicao :: String
} deriving (Show, Read, Eq)