{-# LANGUAGE OverloadedStrings #-}
module Controllers.GestorController where
import Database.PostgreSQL.Simple
import Models.Gestor (Gestor)
import Controllers.ChamadoController (listarChamados, buscarChamadoPorId, buscarChamadosPorTitulo, buscarChamadosEmAndamento, buscarChamadosNaoIniciados, buscarChamadosConcluidos)
import Controllers.ItemInventarioController (listarItensInventario)
import Controllers.AtividadeController (listarAtividades, atualizarResponsavelIdAtividade, cadastrarAtividade)
import Controllers.AnalistaController (cadastrarAnalista)
import Controllers.UsuarioController (cadastrarUsuario)
import Text.Printf (printf)
import Models.Atividade
import qualified Control.Monad
import Models.ItemInventario
import Models.Chamado

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
acessaAtividades = listarAtividades

acessaInventario :: Connection -> IO [ItemInventario]
acessaInventario = listarItensInventario

acessaChamados :: Connection -> IO [Chamado]
acessaChamados = listarChamados

acessaChamadoPorId :: Connection -> Int -> IO (Maybe Chamado)
acessaChamadoPorId = buscarChamadoPorId

chamadosAbertos :: Connection -> IO [Chamado]
chamadosAbertos = buscarChamadosEmAndamento

criarAnalista :: Connection -> String -> String -> String -> Int -> IO()
criarAnalista = cadastrarAnalista 

criarUsuario :: Connection -> String -> String -> String -> IO()
criarUsuario = cadastrarUsuario

calculaEstatisticasChamados :: Connection -> IO ()
calculaEstatisticasChamados conn = do
    chamados <- acessaChamados conn
    chamadosNaoIniciados <- buscarChamadosNaoIniciados conn
    chamadosEmAndamento <- buscarChamadosEmAndamento conn
    chamadosConcluidos <- buscarChamadosConcluidos conn

    let qtdChamadosTotais = length chamados
    let qtdChamadosNaoIniciados = length chamadosNaoIniciados
    let qtdChamadosEmAndamento = length chamadosEmAndamento
    let qtdChamadosConcluidos = length chamadosConcluidos

    printf "%d chamados totais" qtdChamadosTotais
    printf "%d chamados não iniciados" qtdChamadosNaoIniciados
    printf "%d chamados em andamento" qtdChamadosEmAndamento
    printf "%d chamados concluídos" qtdChamadosConcluidos

criarAtividadeParaAnalista :: Connection -> String -> String -> String -> Int -> IO()
criarAtividadeParaAnalista = cadastrarAtividade

delegarAtividadeParaAnalista :: Connection -> Int -> Int -> IO ()
delegarAtividadeParaAnalista = atualizarResponsavelIdAtividade 

historicoDeChamados :: Connection -> IO [Chamado]
historicoDeChamados = listarChamados 