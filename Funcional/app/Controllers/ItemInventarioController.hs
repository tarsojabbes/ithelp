{-# LANGUAGE OverloadedStrings #-}
module Controllers.ItemInventarioController where
import Database.PostgreSQL.Simple
import Models.ItemInventario

cadastrarItemInventario :: Connection -> String -> String -> IO()
cadastrarItemInventario conn nome marca = do
    let query = "insert into inventario (item_nome, \
                                        \item_marca, \
                                        \item_data_aquisicao) values (?, ?, CURRENT_TIMESTAMP)"
    execute conn query (nome, marca)
    return ()

listarItensInventario :: Connection -> IO [ItemInventario]
listarItensInventario conn = do
    query_ conn "SELECT i.item_id, \
                        \i.item_nome, \
                        \i.item_marca, \
                        \i.item_data_aquisicao \
                        \FROM inventario i" :: IO [ItemInventario] 