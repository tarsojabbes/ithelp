{-# LANGUAGE OverloadedStrings #-}
module Functions.GestorFunctions where
import Database.PostgreSQL.Simple
import Controllers.ChamadoController
import Controllers.GestorController (acessaAtividades,acessaInventario,acessaChamados,acessaChamadoPorId, chamadosAbertos,criarAnalista,criarUsuario,calculaEstatisticasChamados,criarAtividadeParaAnalista,delegarAtividadeParaAnalista,historicoDeChamados)
import Functions.AnalistaFunctions (formataListaDeChamados, formataListaItensInventario, formataListaAtividade, formataListaChamado, formataChamado)
import Controllers.ItemInventarioController (listarItensInventario)
import Controllers.AtividadeController (listarAtividades)
import Models.Chamado (Chamado(chamado_titulo))

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
    else if funcao == "2" then do
        itens <- listarItensInventario conn
        formataListaItensInventario conn itens
    else if funcao == "3" then do
        atividades <- listarAtividades conn
        formataListaAtividade conn atividades

    else if funcao == "4" then do
        putStrLn "Qual o titulo da atividade a ser criada?"
        atividade_titulo <- getLine
        putStrLn "Qual a descrição da atividade?"
        atividade_descricao <- getLine
        putStrLn "Quem é o responsável pela atividade?"
        atividade_responsavel_id <- readLn :: IO Int
        criarAtividadeParaAnalista conn atividade_titulo atividade_descricao "Nao iniciada" atividade_responsavel_id
        putStrLn "---Atividade criada com sucesso---"

    else if funcao == "5" then do
        putStrLn "Qual o ID da atividade a ser delegada?"
        atividade_id <- readLn :: IO Int
        putStrLn "Qual o ID do novo responsável pela atividade?"
        responsavel_id <- readLn :: IO Int
        delegarAtividadeParaAnalista conn atividade_id responsavel_id
        putStrLn "---Atividade repassada com sucesso---"

    else if funcao == "6" then do
        putStrLn "Insira o nome do novo usuário:"
        usuario_nome <- getLine
        putStrLn "Cadastre o email do novo usuário:"
        usuario_email <- getLine
        putStrLn "Cadastre uma senha para o novo usuário:"
        usuario_senha <- getLine
        criarUsuario conn usuario_nome usuario_email usuario_senha
        putStrLn "---Usuário cadastrado com sucesso---"

    else if funcao == "7" then do
        putStrLn "Insira o nome do novo analista:"
        analista_nome <- getLine
        putStrLn "Cadastre o email do novo analista:"
        analista_email <- getLine
        putStrLn "Cadastre uma senha para o novo analista:"
        analista_senha <- getLine
        criarAnalista conn analista_nome analista_email analista_senha 5
        putStrLn "---Analista cadastrado com sucesso---"

    else do
        print "A função escolhida não existe. Por favor, selecione alguma das opções abaixo\n"
        funcoesGestor conn

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
    if funcao_chamado == "1" then do
        chamados <- listarChamados conn
        formataListaChamado conn chamados
    else if  funcao_chamado == "2" then do
        chamados_abertos <- buscarChamadosEmAndamento conn
        formataListaChamado conn chamados_abertos
    else if  funcao_chamado == "3" then do
        calculaEstatisticasChamados conn
    else if  funcao_chamado == "4" then do
        putStrLn "Qual o ID do chamado a ser acessado?"
        chamado_id <- readLn :: IO Int
        chamado_encontrado <- buscarChamadoPorId conn chamado_id
        case chamado_encontrado of
            Just chamado -> formataChamado conn chamado
            _ -> print "Chamado com ID informado não foi encontrado"

    else if funcao_chamado == "5" then do
        putStrLn "Qual o título do chamado a ser acessado?"
        chamado_titulo <- getLine
        chamado_encontrado <- buscarChamadosPorTitulo conn chamado_titulo
        case chamado_encontrado of
            Just chamado -> formataListaChamado conn chamado
            Nothing -> print "Chamado com título informado não foi encontrado"
    else do
            print "Você não selecionou uma opção válida. Selecione alguma das opções abaixo\n"
            lidaComFuncaoEscolhida conn "1"
