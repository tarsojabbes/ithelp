{-# LANGUAGE OverloadedStrings #-}
module Controllers.GestorController where
import Database.PostgreSQL.Simple
import Models.Gestor (Gestor)
import Controllers.ChamadoController (listarChamados, buscarChamadoPorId, buscarChamadosPorTitulo, buscarChamadosEmAndamento, buscarChamadosNaoIniciados, buscarChamadosConcluidos)
import Controllers.ItemInventarioController (listarItensInventario)
import Controllers.AtividadeController (listarAtividades, atualizarResponsavelIdAtividade)
import Controllers.AnalistaController (cadastrarAnalista)
import Controllers.UsuarioController (cadastrarUsuario)
import Text.Printf (printf)

cadastrarGestor :: Connection -> String -> String -> String -> IO()
cadastrarGestor conn nome email senha = do
    let query = "insert into gestor (gestor_nome, \
                                    \gestor_email, \
                                    \gestor_senha) values (?, ?, ?)"
    execute conn query (nome, email, senha)
    return ()

listarGestores :: Connection -> IO [Gestor]
listarGestores conn = do
    query_ conn "SELECT g.gestor_id, \
                        \g.gestor_nome, \
                        \g.gestor_email, \
                        \g.gestor_senha \
                        \FROM gestor g" :: IO [Gestor]

buscarGestorPorId :: Connection -> Int -> IO (Maybe Gestor)
buscarGestorPorId conn id = do
    gestorEncontrado <- query conn "SELECT g.gestor_id, \
                                    \g.gestor_nome, \
                                    \g.gestor_email, \
                                    \g.gestor_senha \
                                    \FROM gestor g WHERE g.gestor_id = ?" (Only id)
    case gestorEncontrado of
        [row] -> return $ Just row
        _ -> return Nothing

buscarGestorPorEmail :: Connection -> String -> IO (Maybe Gestor)
buscarGestorPorEmail conn email = do
    gestorEncontrado <- query conn "SELECT g.gestor_id, \
                                    \g.gestor_nome, \
                                    \g.gestor_email, \
                                    \g.gestor_senha \
                                    \FROM gestor g WHERE g.gestor_email = ?" (Only email)
    case gestorEncontrado of
        [row] -> return $ Just row
        _ -> return Nothing

excluirGestor :: Connection -> Int -> IO ()
excluirGestor conn gestor_id = Control.Monad.void $ execute conn "DELETE FROM gestor WHERE gestor_id = ?" (Only gestor_id)

--- Coisas novas ---

acessaAtividades :: Connection -> IO [Atividade]
acessaAtividades conn = listarAtividades conn

acessaInventario :: Connection -> IO [ItemInventario]
acessaInventario conn = listarItensInventario conn

acessaChamados :: Connection -> IO [Chamado]
acessaChamados conn = listarChamados conn

acessaChamadoPorId :: Connection -> Int -> IO (Maybe Chamado)
acessaChamadoPorId conn = acessaChamadoPorID conn

acessaChamadoPorTitulo :: Connection -> String -> IO [Chamado]
acessaChamadoPorTitulo conn titulo = buscarChamadosPorTitulo conn titulo 

chamadosAbertos :: Connection -> IO [Chamado]
chamadosAbertos conn = buscarChamadosEmAndamento conn

criarAnalista :: Connection -> String -> String -> String -> Int -> IO()
criarAnalista conn nome email senha avaliacao = cadastrarAnalista conn nome email senha avaliacao 

criarUsuario :: Connection -> String -> String -> String -> IO()
criarUsuario conn nome email senha = cadastrarUsuario conn nome email senha

calculaEstatisticasChamados :: Connection -> IO [String]
calculaEstatisticasChamados conn = do 
    printf "%.2f chamados não iniciados" ((length buscarChamadosNaoIniciados conn) / (length acessaChamados conn))
    printf "%.2f chamados em andamento" ((length buscarChamadosEmAndamento conn) / (length acessaChamados conn))
    printf "%.2f chamados concluídos" ((length buscarChamadosConcluidos conn) / (length acessaChamados conn))

criarAtividadeParaAnalista :: Connection -> String -> String -> String -> Int -> IO()
criarAtividadeParaAnalista conn titulo descricao status responsavel_id  = cadastrarAtividade conn titulo descricao status responsavel_id 

delegarAtividadeParaAnalista :: Connection -> Int -> Int -> IO ()
delegarAtividadeParaAnalista conn atividade_id responsavel_id = atualizarResponsavelIdAtividade conn atividade_id responsavel_id

historicoDeChamados :: Connection -> IO [Chamado]
historicoDeChamados conn = listarChamados conn