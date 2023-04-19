{-# LANGUAGE OverloadedStrings #-}
module Controllers.ItemInventarioController where
import Database.PostgreSQL.Simple

cadastrarItemInventario :: Connection -> String -> String -> IO()
cadastrarItemInventario conn nome marca = do
    let query = "insert into inventario (item_nome, \
                                        \item_marca, \
                                        \item_data_aquisicao) values (?, ?, CURRENT_TIMESTAMP)"
    execute conn query (nome, marca)
    return ()