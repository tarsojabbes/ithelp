{-# LANGUAGE OverloadedStrings #-}

module Functions.AnalistaFunctions where
import Database.PostgreSQL.Simple
import Controllers.AtividadeController
import Models.Atividade
import Controllers.AnalistaController (buscarAnalistaPorId)
import Models.Analista
import Text.Printf
import qualified Data.Maybe
import Control.Exception (catch)
import Controllers.ChamadoController
import Models.Chamado
import Controllers.ItemInventarioController
import Models.ItemInventario


funcoesAnalista :: Connection -> Analista -> IO ()
funcoesAnalista conn analista = do
    exibeMenuFuncoesAnalista
    funcao <- getLine
    lidaComFuncaoEscolhida conn analista funcao

exibeMenuFuncoesAnalista :: IO ()
exibeMenuFuncoesAnalista = do
    putStrLn "Enquanto analista, você pode executar as seguintes funções:"
    putStrLn "------FUNÇÕES PARA ANALISTA----"
    putStrLn "1 - Gerenciar atividades"
    putStrLn "2 - Gerenciar itens do inventário"
    putStrLn "3 - Gerenciar chamados"
    putStrLn "4 - Ver minhas estatísticas"
    putStrLn "------------------------------------------"
    putStrLn "Qual função você deseja executar?"

lidaComFuncaoEscolhida :: Connection -> Analista -> String -> IO ()
lidaComFuncaoEscolhida conn analista funcao
    | funcao == "1" = do
        exibeMenuOpcoesAnalistaAtividade
        funcao_atividade <- getLine
        lidaComOpcaoAtividade conn analista funcao_atividade

    | funcao == "2" = do
        exibeMenuOpcoesAnalistaInventario
        funcao_inventario <- getLine
        lidaComOpcaoInventario conn analista funcao_inventario

    | funcao == "3" = do 
        exibeMenuOpcoesAnalistaChamado
        funcaoChamado <- getLine
        lidaComOpcaoChamado conn analista funcaoChamado

    | funcao == "4" = do
        exibeEstatisticasProprias conn analista
        funcoesAnalista conn analista

    | otherwise = do
        printf "A função escolhida não existe. Por favor, selecione alguma das opções abaixo\n"
        funcoesAnalista conn analista

-- funcões de Atividades
exibeMenuOpcoesAnalistaAtividade :: IO ()
exibeMenuOpcoesAnalistaAtividade = do
    putStrLn "---FUNÇÕES PARA QUADRO DE ATIVIDADES---"
    putStrLn "1 - Criar nova atividade"
    putStrLn "2 - Listar atividades não iniciadas"
    putStrLn "3 - Listar atividades em andamento"
    putStrLn "4 - Listar atividades concluídas"
    putStrLn "5 - Buscar atividade por ID"
    putStrLn "6 - Colocar atividade em andamento"
    putStrLn "7 - Finalizar atividade"
    putStrLn "8 - Excluir uma atividade"
    putStrLn "------------------------------------------"
    putStrLn "Qual função você deseja executar?"

lidaComOpcaoAtividade :: Connection -> Analista -> String -> IO ()
lidaComOpcaoAtividade conn analista funcao_atividade = do
    if funcao_atividade == "1" then do
        putStrLn "Qual o título da atividade a ser criada?"
        atividade_titulo <- getLine
        putStrLn "Qual a descrição da atividade?"
        atividade_descricao <- getLine
        cadastrarAtividade conn atividade_titulo atividade_descricao "Nao iniciada" (analista_id analista)
        putStrLn "---Atividade cadastrada com sucesso--"

    else if funcao_atividade == "2" then do
        atividades_nao_iniciadas <- buscarAtividadesNaoIniciadas conn
        formataListaAtividade conn atividades_nao_iniciadas

    else if funcao_atividade == "3" then do
        atividades_em_andamento <- buscarAtividadesEmAndamento conn
        formataListaAtividade conn atividades_em_andamento

    else if funcao_atividade == "4" then do
        atividades_concluidas <- buscarAtividadesConcluidas conn
        formataListaAtividade conn atividades_concluidas

    else if funcao_atividade == "5" then do
        putStrLn "Qual o ID da atividade que você deseja buscar?"
        atividade_id <- readLn :: IO Int
        atividade_encontrada <- buscarAtividadePorId conn atividade_id
        case atividade_encontrada of
            Just atividade -> formataAtividade conn atividade
            Nothing -> printf "Atividade com o ID informado não foi encontrada\n"

    else if funcao_atividade == "6" then do
        putStrLn "Qual o ID da atividade que você deseja colocar em andamento?"
        atividade_id <- readLn :: IO Int
        atualizarStatusAtividade conn atividade_id "Em andamento"
        atualizarResponsavelIdAtividade conn atividade_id (analista_id analista)
        putStrLn "---Atividade colocada em andamento---"
    
    else if funcao_atividade == "7" then do
        putStrLn "Qual o ID atividade que você deseja marcar como concluída?"
        atividade_id <- readLn :: IO Int
        atualizarStatusAtividade conn atividade_id "Concluida"
        putStrLn "---Atividade marcada como concluida---"

    else if funcao_atividade == "8" then do
        putStrLn "Qual o ID atividade que você deseja excluir?"
        atividade_id <- readLn :: IO Int
        excluirAtividade conn atividade_id
        putStrLn "---Atividade excluída com sucesso---"

    else do
            printf "Você não selecionou uma opção válida. Selecione algum das opções abaixo\n"

    funcoesAnalista conn analista 

formataListaAtividade :: Connection -> [Atividade] -> IO ()
formataListaAtividade _ [] = putStrLn ""
formataListaAtividade conn (x:xs) = do
    formataAtividade conn x
    formataListaAtividade conn xs

formataAtividade :: Connection -> Atividade -> IO ()
formataAtividade conn atividade = do
    putStrLn "\n------------------------"
    printf "%s\n" (atividade_titulo atividade)
    putStrLn "------------------------"
    printf "ID da atividade%s\n" (atividade_id atividade)
    printf "Descrição: %s\n" (atividade_descricao atividade)
    printf "Status: %s\n" (atividade_status atividade)
    responsavel <- buscarAnalistaPorId conn (atividade_responsavel_id atividade)
    case responsavel of
        Just analista -> printf "Responsavel: %s\n" (analista_nome analista)
        Nothing -> printf "Nao há analista responsável por essa atividade\n"

-- funcões do Inventario
exibeMenuOpcoesAnalistaInventario :: IO ()
exibeMenuOpcoesAnalistaInventario = do 
    mapM_ putStrLn ["---FUNÇÕES PARA QUADRO DE ITENS DO INVENTÁRIO---",
                    "1 - Criar novo item do inventário",
                    "2 - Listar os itens do inventário",
                    "3 - Buscar item do inventário por ID",                
                    "4 - Buscar item do inventário por Nome",                
                    "5 - Buscar item do inventário por Marca",                
                    "6 - Atualizar um item do inventário",                
                    "7 - Excluir um item do inventário"]

lidaComOpcaoInventario :: Connection  -> Analista -> String -> IO ()
lidaComOpcaoInventario conn analista funcao_inventario = do
    case funcao_inventario of
        "1" -> do
            putStrLn "Qual o nome do item a ser adicionado?"
            itemNome <- getLine
            putStrLn "Qual a marca do item a ser adicionado?"
            itemMarca <- getLine
            cadastrarItemInventario conn itemNome itemMarca 
            putStrLn "---Item cadastrado com sucesso---"
    
        "2" -> do
            itens <- listarItensInventario conn
            formataListaItensInventario conn itens

        "3" -> do
            putStrLn "Qual o ID do item que você deseja buscar?"
            itemId <- readLn :: IO Int
            itemEncontrado <- buscarItemInventarioPorId conn itemId
            case itemEncontrado of
                Just item -> formataItemInventario conn item
                Nothing -> printf "Item de Inventario com o ID informado não foi encontrado\n"

        "4" -> do
            putStrLn "Qual o nome do item que você deseja buscar?"
            itemNome <- getLine
            itemEncontrado <- buscarItemInventarioPorNome conn itemNome
            case itemEncontrado of
                Just item -> formataListaItensInventario conn item
                Nothing -> printf "Item de Inventario com o nome informado não foi encontrado\n"


        "5" -> do
            putStrLn "Qual a marca do item que você deseja buscar?"
            itemMarca <- getLine
            itemEncontrado <- buscarItemInventarioPorMarca conn itemMarca
            case itemEncontrado of
                Just item -> formataListaItensInventario conn item
                Nothing -> printf "Item de Inventario com a marca informada não foi encontrado\n"

        "6" -> do
            putStrLn "Qual o ID do item que você deseja atualizar?"
            itemId <- readLn :: IO Int
            putStrLn "Qual o novo nome do item?"
            itemNome <- getLine
            putStrLn "Qual a nova marca do item?"
            itemMarca <- getLine
            itemEncontrado <- buscarItemInventarioPorId conn itemId
            case itemEncontrado of
                Just item -> atualizarItemInventario conn itemId itemNome itemMarca
                Nothing -> printf "Item de Inventario com o ID informado não foi encontrado\n"
            putStrLn "---Item atualizado com sucesso--"


        "7" -> do
            putStrLn "Qual o ID do item de Inventário que você deseja excluir?"
            itemId <- readLn :: IO Int
            excluirItemInventario conn itemId
            putStrLn "---Item excluído com sucesso---"

        _ -> do
            printf "Você não selecionou uma opção válida. Selecione alguma das opções abaixo\n"
        
    funcoesAnalista conn analista

formataListaItensInventario :: Connection -> [ItemInventario] -> IO ()
formataListaItensInventario _ [] = putStrLn ""
formataListaItensInventario conn (x:xs) = do
    formataItemInventario conn x
    formataListaItensInventario conn xs

formataItemInventario :: Connection -> ItemInventario -> IO ()
formataItemInventario conn itemInventario = do
    printf "\n------------------------\n"
    printf "ID do Item:%s\nNome: %s\nMarca: %s\nData De Aquisição: %s\n"
            (item_id itemInventario)
            (item_nome itemInventario)
            (item_marca itemInventario)
            (show (item_data_aquisicao itemInventario))

--funções de chamado
exibeMenuOpcoesAnalistaChamado :: IO ()
exibeMenuOpcoesAnalistaChamado = do
    putStrLn "---FUNÇÕES PARA QUADRO DE CHAMADOS---"
    putStrLn "1 - Criar novo chamado"
    putStrLn "2 - Listar chamados não iniciados"
    putStrLn "3 - Listar chamados em andamento"
    putStrLn "4 - Listar chamados concluídos"
    putStrLn "5 - Buscar chamado por ID"
    putStrLn "6 - Colocar chamado em andamento"
    putStrLn "7 - Finalizar chamado"
    putStrLn "8 - Excluir um chamado"
    putStrLn "9 - Repassar chamado para analista diferente"
    putStrLn "------------------------------------------"
    putStrLn "Qual função você deseja executar?"

lidaComOpcaoChamado :: Connection -> Analista -> String -> IO ()
lidaComOpcaoChamado conn analista funcao_chamado = do
    if funcao_chamado == "1" then do
        putStrLn "Qual o título do chamado a ser criado?"
        chamado_titulo <- getLine
        putStrLn "Qual a descrição do chamado?"
        chamado_descricao <- getLine
        cadastrarChamado conn chamado_titulo chamado_descricao "Nao iniciado" (analista_id analista) (analista_id analista)
        putStrLn "---Chamado criado com sucesso---"

    else if funcao_chamado == "2" then do
        chamados_nao_iniciados <- buscarChamadosNaoIniciados conn
        formataListaChamado conn chamados_nao_iniciados
        
    else if funcao_chamado == "3" then do
        chamados_em_andamento <- buscarChamadosEmAndamento conn
        formataListaChamado conn chamados_em_andamento

    else if funcao_chamado == "4" then do
        chamados_concluidos <- buscarChamadosConcluidos conn
        formataListaChamado conn chamados_concluidos

    else if funcao_chamado == "5" then do
        putStrLn "Qual o ID do chamado que você deseja buscar?"
        chamado_id <- readLn :: IO Int
        chamado_encontrado <- buscarChamadoPorId conn chamado_id
        case chamado_encontrado of
            Just chamado -> formataChamado conn chamado
            Nothing -> printf "Chamado com o ID informado não foi encontrado\n"

    else if funcao_chamado == "6" then do
        putStrLn "Qual o ID do chamado que você deseja colocar em andamento?"
        chamado_id <- readLn :: IO Int
        atualizarStatusChamado conn chamado_id "Em andamento"
        let id_analista = analista_id analista
        atualizarAnalistaIdChamado conn chamado_id id_analista
        putStrLn "---Chamado colocado em andamento com sucesso---"
    
    else if funcao_chamado == "7" then do
        putStrLn "Qual o ID do chamado que você deseja marcar como concluído?"
        chamado_id <- readLn :: IO Int
        atualizarStatusChamado conn chamado_id "Concluido"
        putStrLn "---Chamado concluído com sucesso---"

    else if funcao_chamado == "8" then do
        putStrLn "Qual o ID do chamado que você deseja excluir?"
        chamado_id <- readLn :: IO Int
        excluirChamado conn chamado_id
        putStrLn "---Chamado excluído com sucesso---"
    
    else if funcao_chamado == "9" then do
        putStrLn "Qual o ID do chamado que você deseja repassar?"
        chamado_id <- readLn :: IO Int
        putStrLn "Qual o ID do analista que você deseja que o chamado seja repassado?"
        novo_analista_id <- readLn :: IO Int
        atualizarAnalistaIdChamado conn chamado_id novo_analista_id
        putStrLn "---Chamado repassado com sucesso---"

    else do
            printf "Você não selecionou uma opção válida. Selecione algum das opções abaixo\n"
    
    funcoesAnalista conn analista

formataListaChamado :: Connection -> [Chamado] -> IO ()
formataListaChamado _ [] = putStrLn ""
formataListaChamado conn (x:xs) = do
    formataChamado conn x
    formataListaChamado conn xs

formataChamado :: Connection -> Chamado -> IO ()
formataChamado conn chamado = do
    putStrLn "\n------------------------"
    printf "%s\n" (chamado_titulo chamado)
    putStrLn "------------------------"
    printf "ID do chamado: %s\n" (chamado_id chamado)
    printf "Descrição: %s\n" (chamado_descricao chamado)
    printf "Status: %s\n" (chamado_status chamado)
    responsavel <- buscarAnalistaPorId conn (chamado_analista_id chamado)
    case responsavel of
        Just analista -> printf "Responsavel: %s (ID: %d)\n" (analista_nome analista) (analista_id analista)
        Nothing -> printf "Não há analista responsável por essa atividade\n"
    
--funções da exibição de estatísticas próprias
exibeEstatisticasProprias :: Connection -> Analista -> IO ()
exibeEstatisticasProprias conn analista = do

        let id = analista_id analista

        analistaEncontrado <- buscarAnalistaPorId conn id
        case analistaEncontrado of
                Just analista -> formataAvaliacao conn analista
                Nothing -> printf "Analista com o ID informado não foi encontrado\n"
        
        printf "\n------------------------\n"
        printf "Chamados Do Analista"
        printf "\n------------------------\n"

        chamadosEncontrados <- buscarChamadoPorAnalistaId conn id
        case chamadosEncontrados of
                Just chamados -> formataListaChamado conn chamados
                Nothing -> printf "Chamados para o analista informado não foram encontrados\n"


formataAvaliacao :: Connection -> Analista -> IO ()
formataAvaliacao conn analista = do
    printf "\n------------------------\n"
    printf "Avaliação dos usuários: %i" (analista_avaliacao analista)
    printf "\n------------------------\n"


formataChamadoDoAnalista :: Connection -> Chamado -> IO ()
formataChamadoDoAnalista conn chamado = do

    printf "\nChamado: %s\n" (chamado_titulo chamado)
    printf "Descrição: %s\n" (chamado_descricao chamado)
    printf "Status: %s\n" (chamado_status chamado)