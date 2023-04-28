{-# LANGUAGE OverloadedStrings #-}
module Functions.GestrorFunctions where
import Database.PostgreSQL.Simple
import Controllers.ChamadoController
import Controllers.GestorController (acessaAtividades,acessaInventario,acessaChamados,acessaChamadoPorId,acessaChamadoPorTitulo,chamadosAbertos,criarAnalista,
criarUsuario,calculaEstatisticasChamados,criarAtividadeParaAnalista,delegarAtividadeParaAnalista,historicoDeChamados)

funcoesGestor :: Connection -> IO ()
funcoesGestor conn = do
    exibeMenuFuncoesGestor
    funcao <- getLine
    lidaComFuncaoEscolhida conn funcao

exibeMenuFuncoesGestor :: IO ()
exibeMenuFuncoesGestor = do
    putStrLn "Enquanto gestor, você pode executar as seguintes funções:"
    putStrLn "------FUNÇÕES PARA GESTOR----"
    putStrLn "1 - Gerenciar chamados"
    putStrLn "2 - Visualizar inventário"
    putStrLn "3 - Visualizar quadro de atividades"
    putStrLn "4 - Criar nova atividade"
    putStrLn "5 - Delegar atividade"
    putStrLn "6 - Criar novo usuário"
    putStrLn "7 - Criar novo analista"
    putStrLn "------------------------------------------"
    putStrLn "Qual função você deseja executar?"

lidaComFuncaoEscolhida :: Connection -> String -> IO ()
lidaComFuncaoEscolhida conn funcao = do
    if funcao == "1" then do
        exibeMenuOpcoesGestorChamado
        funcao_chamado <- getLine
        lidaComOpcaoChamado conn funcao_chamado
    else do
        print ""

exibeMenuOpcoesGestorChamado :: IO ()
exibeMenuOpcoesGestorChamado = do
    putStrLn "---FUNÇÕES PARA CHAMADOS---"
    putStrLn "1 - Visualizar chamados"
    putStrLn "2 - Visualizar chamados abertos"
    putStrLn "3 - Visualizar estatísticas de número de chamados"
    putStrLn "4 - Buscar chamado por ID"
    putStrLn "5 - Buscar chamado por título"
    putStrLn "------------------------------------------"
    putStrLn "Qual função você deseja executar?"

lidaComOpcaoChamado :: Connection -> String -> IO ()
lidaComOpcaoChamado conn funcao_chamado = do
    if funcao_chamado == "1" then acessaChamados
    else if  funcao_chamado == "2" then chamadosAbertos
    else if  funcao_chamado == "3" then calculaEstatisticasChamados
    else if  funcao_chamado == "4" then do
        putStrLn "Qual o ID do chamado a ser acessado?"
        chamado_id <- getLine
        acessaChamadoPorId conn chamado_id
    else if funcao_atividade == "5" then do
        putStrLn "Qual o título do chamado a ser acessado?"
        chamado_titulo <- getLine
        acessaChamadoPorTitulo conn chamado_titulo
    else do
            print ""
