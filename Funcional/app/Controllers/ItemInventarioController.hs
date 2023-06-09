{-# LANGUAGE OverloadedStrings #-}
module Controllers.ItemInventarioController where
import Database.PostgreSQL.Simple
import Models.ItemInventario
import qualified Control.Monad
import Data.String (String)

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

buscarItemInventarioPorId :: Connection -> Int -> IO (Maybe ItemInventario)
buscarItemInventarioPorId conn id = do
    itemEncontrado <- query conn "SELECT i.item_id, \
                        \i.item_nome, \
                        \i.item_marca, \
                        \i.item_data_aquisicao \
                        \FROM inventario i WHERE i.item_id = ?" (Only id)
    case itemEncontrado of
        [row] -> return $ Just row
        _ -> return Nothing

buscarItemInventarioPorMarca :: Connection -> String -> IO (Maybe [ItemInventario])
buscarItemInventarioPorMarca conn marca = do
    itensEncontrados <- query conn "SELECT i.item_id, \
                        \i.item_nome, \
                        \i.item_marca, \
                        \i.item_data_aquisicao \
                        \FROM inventario i WHERE i.item_marca = ?" (Only marca)
    case itensEncontrados of
        [] -> return Nothing
        _ -> return $ Just itensEncontrados

buscarItemInventarioPorNome :: Connection -> String -> IO (Maybe [ItemInventario])
buscarItemInventarioPorNome conn nome = do
    itensEncontrados <- query conn "SELECT i.item_id, \
                        \i.item_nome, \
                        \i.item_marca, \
                        \i.item_data_aquisicao \
                        \FROM inventario i WHERE i.item_nome = ?" (Only nome)
    case itensEncontrados of
        [] -> return Nothing
        _ -> return $ Just itensEncontrados

excluirItemInventario :: Connection -> Int -> IO ()
excluirItemInventario conn item_id = Control.Monad.void $ execute conn "DELETE FROM inventario WHERE item_id = ?" (Only item_id)

atualizarItemInventario :: Connection -> Int -> String -> String -> IO ()
atualizarItemInventario conn item_id item_nome item_marca = do
    execute conn "UPDATE inventario SET item_nome = ? WHERE item_id = ?" (item_nome, item_id)
    execute conn "UPDATE inventario SET item_marca = ? WHERE item_id = ?" (item_marca, item_id)
    return ()