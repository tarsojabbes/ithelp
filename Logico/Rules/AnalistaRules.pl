:- module(analistaRules, [mainMenuAnalista/1]).

:- use_module("../Controller/ChamadoController.pl").
:- use_module("../Controller/ItemController.pl").
:- use_module("../Controller/AtividadeController.pl").

mainMenuAnalista(Id) :-
    exibirMenuAnalista,
    read(Comando),
    lidaComComando(Comando, Id).

exibirMenuAnalista :-
    writeln("Enquanto analista, você pode executar as seguintes funções:"),
    writeln("------FUNÇÕES PARA ANALISTA----"),
    writeln("1 - Gerenciar chamados"),
    writeln("2 - Gerenciar atividades"),
    writeln("3 - Gerenciar itens do inventário"),
    writeln("4 - Ver minhas estatísticas"),
    writeln("------------------------------------------"),
    writeln("Qual função você deseja executar?").

lidaComComando(1, Id) :-
    exibeOpcoesChamado,
    read(Opcao),
    lidaComOpcaoChamado(Opcao, Id).

lidaComComando(2, Id) :-
    exibeOpcoesAtividade,
    read(Opcao),
    lidaComOpcaoAtividade(Opcao, Id).

lidaComComando(3, Id) :-
    exibeOpcoesInventario,
    read(Opcao),
    lidaComOpcaoInventario(Opcao, Id).

lidaComComando(_, Id) :-
    writeln("A função escolhida não existe. Por favor, selecione alguma das opções abaixo"),
    mainMenuAnalista(Id).

exibeOpcoesChamado :-
    writeln("---FUNÇÕES PARA QUADRO DE CHAMADOS---"),
    writeln("1 - Criar novo chamado"),
    writeln("2 - Listar chamados não iniciados"),
    writeln("3 - Listar chamados em andamento"),
    writeln("4 - Listar chamados concluídos"),
    writeln("5 - Buscar chamado por ID"),
    writeln("6 - Colocar chamado em andamento"),
    writeln("7 - Finalizar chamado"),
    writeln("8 - Excluir um chamado"),
    writeln("9 - Repassar chamado para analista diferente"),
    writeln("------------------------------------------"),
    writeln("Qual função você deseja executar?").

lidaComOpcaoChamado(1, Id) :-
    writeln("Qual o título do chamado a ser criado?"),
    read(Titulo),
    writeln("Qual a descrição do chamado?"),
    read(Descricao),
    chamadoController:salvarChamado(Titulo, Descricao, "Nao iniciado", Id, Id),
    writeln("------Chamado criado com sucesso-------"),
    mainMenuAnalista(Id).

lidaComOpcaoChamado(2, Id) :- 
    chamadoController:buscarChamadoPorStatus("Nao iniciado", Chamados),
    chamadoController:exibirChamado(Chamados),
    mainMenuAnalista(Id).

lidaComOpcaoChamado(3, Id) :-
    chamadoController:buscarChamadoPorStatus("Em andamento", Chamados),
    chamadoController:exibirChamado(Chamados),
    mainMenuAnalista(Id).

lidaComOpcaoChamado(4, Id) :-
    chamadoController:buscarChamadoPorStatus("Concluido", Chamados),
    chamadoController:exibirChamado(Chamados),
    mainMenuAnalista(Id).

lidaComOpcaoChamado(5, Id) :-
    writeln("Qual o ID do chamado que você deseja buscar?"),
    read(IdChamado),
    chamadoController:buscarChamadoPorId(IdChamado, ChamadoEncontrado),
    chamadoController:exibirChamado(ChamadoEncontrado),
    mainMenuAnalista(Id).

lidaComOpcaoChamado(6, Id) :-
    writeln("Qual o ID do chamado que você deseja colocar em andamento?"),
    read(IdChamado),
    chamadoController:atualizarStatusChamado(IdChamado, "Em andamento"),
    chamadoController:atualizarResponsavelIdChamado(IdChamado, Id),
    writeln("---Chamado colocado em andamento com sucesso---"),
    mainMenuAnalista(Id).

lidaComOpcaoChamado(7, Id) :-
    writeln("Qual o ID do chamado que você deseja marcar como concluído?"),
    read(IdChamado),
    chamadoController:atualizarStatusChamado(IdChamado, "Concluido"),
    writeln("---Chamado concluído com sucesso---"),
    mainMenuAnalista(Id).

lidaComOpcaoChamado(8, Id) :-
    writeln("Qual o ID do chamado que você deseja excluir?"),
    read(IdChamado),
    chamadoController:removerChamado(IdChamado),
    writeln("---Chamado excluído com sucesso---"),
    mainMenuAnalista(Id).

lidaComOpcaoChamado(9, Id) :-
    writeln("Qual o ID do chamado que você deseja repassar?"),
    read(IdChamado),
    writeln("Qual o ID do analista que você deseja que o chamado seja repassado?"),
    read(NovoResponsavelId),
    chamadoController:atualizarResponsavelIdChamado(IdChamado, NovoResponsavelId),
    writeln("---Chamado repassado com sucesso---"),
    mainMenuAnalista(Id).

lidaComOpcaoChamado(_, Id) :- 
    writeln("Você não selecionou uma opção válida. Selecione algum das opções abaixo\n"),
    lidaComComando(1, Id).

exibeOpcoesInventario :- 
    writeln("---FUNÇÕES PARA QUADRO DE ITENS DO INVENTÁRIO---"),
    writeln("1 - Criar novo item do inventário"),
    writeln("2 - Listar os itens do inventário"),
    writeln("3 - Buscar item do inventário por ID"),
    writeln("4 - Buscar item do inventário por Nome"),
    writeln("5 - Buscar item do inventário por Marca"),
    writeln("6 - Atualizar um item do inventário"),
    writeln("7 - Excluir um item do inventário").

lidaComOpcaoInventario(1, Id) :-
    writeln("Qual o nome do item a ser adicionado?"),
    read(ItemNome),
    writeln("Qual a marca do item a ser adicionado?"),
    read(ItemMarca),
    writeln("Qual a data de aquisição do item a ser adicionado?"),
    read(ItemData),
    itemController:salvarItem(ItemNome, ItemMarca, ItemData),
    writeln("---Item cadastrado com sucesso---"),
    mainMenuAnalista(Id).

lidaComOpcaoInventario(2, Id) :-
    itemController:exibirItens,
    mainMenuAnalista(Id).

lidaComOpcaoInventario(3, Id) :-
    writeln("Qual o ID do item que você deseja buscar?"),
    read(IdItem),
    itemController:buscarItemPorId(IdItem, ItemEncontrado),
    itemController:exibirItem(ItemEncontrado),
    mainMenuAnalista(Id).

lidaComOpcaoInventario(4, Id) :-
    writeln("Qual o Nome do item que você deseja buscar?"),
    read(Nome),
    itemController:buscarItemPorNome(Nome, ItensEncontrados),
    itemController:exibirItem(ItensEncontrados),
    mainMenuAnalista(Id).

lidaComOpcaoInventario(5, Id) :-
    writeln("Qual o Marca do item que você deseja buscar?"),
    read(Marca),
    itemController:buscarItemPorMarca(Marca, ItensEncontrados),
    itemController:exibirItem(ItensEncontrados),
    mainMenuAnalista(Id).

lidaComOpcaoInventario(6, Id) :-
    writeln("Qual o Id do item que você deseja atualizar?"),
    read(ItemId),
    writeln("Qual o novo nome do item?"),
    read(NovoNome),
    writeln("Qual a nova marca do item?"),
    read(NovaMarca), 
    itemController:atualizarItem(ItemId, NovoNome, NovaMarca),
    writeln("---Item atualizado com sucesso---"),
    mainMenuAnalista(Id).

lidaComOpcaoInventario(7, Id) :-
    writeln("Qual o ID do item de Inventário que você deseja excluir?"),
    read(ItemId),
    itemController:removerItem(ItemId),
    writeln("---Item excluído com sucesso---"),
    mainMenuAnalista(Id).

lidaComOpcaoInventario(_, Id) :- 
    writeln("Você não selecionou uma opção válida. Selecione algum das opções abaixo\n"),
    lidaComComando(3, Id).

exibeOpcoesAtividade :-
    writeln("---FUNÇÕES PARA QUADRO DE ATIVIDADES---"),
    writeln("1 - Criar nova atividade"),
    writeln("2 - Listar atividades não iniciadas"),
    writeln("3 - Listar atividades em andamento"),
    writeln("4 - Listar atividades concluídas"),
    writeln("5 - Buscar atividade por ID"),
    writeln("6 - Colocar atividade em andamento"),
    writeln("7 - Finalizar atividade"),
    writeln("8 - Excluir uma atividade"),
    writeln("------------------------------------------"),
    writeln("Qual função você deseja executar?").

lidaComOpcaoAtividade(1, Id) :-
    writeln("Qual o título da atividade a ser criada?"),
    read(Titulo),
    writeln("Qual a descrição da atividade?"),
    read(Descricao),
    atividadeController:salvarAtividade(Titulo, Descricao, "Nao iniciada", Id),
    writeln("---Atividade cadastrada com sucesso--"),
    mainMenuAnalista(Id).

lidaComOpcaoAtividade(2, Id) :-
    atividadeController:buscarAtividadePorStatus("Nao iniciada", Atividades),
    atividadeController:exibirAtividade(Atividades),
    mainMenuAnalista(Id).

lidaComOpcaoAtividade(3, Id) :- 
    atividadeController:buscarAtividadePorStatus("Em andamento", Atividades),
    atividadeController:exibirAtividade(Atividades),
    mainMenuAnalista(Id).

lidaComOpcaoAtividade(4, Id) :-
    atividadeController:buscarAtividadePorStatus("Concluida", Atividades),
    atividadeController:exibirAtividade(Atividades),
    mainMenuAnalista(Id).

lidaComOpcaoAtividade(5, Id) :-
    writeln("Qual o ID da atividade que você deseja buscar?"),
    read(IdAtividade),
    atividadeController:buscarAtividadePorId(IdAtividade, Atividade),
    atividadeController:exibirAtividade(Atividade),
    mainMenuAnalista(Id).

lidaComOpcaoAtividade(6, Id) :-
    writeln("Qual o ID da atividade que você deseja colocar em andamento?"),
    read(IdAtividade),
    atividadeController:atualizarStatusAtividade(IdAtividade, "Em andamento"),
    atividadeController:atualizarResponsavelIdAtividade(IdAtividade, Id),
    writeln("---Atividade colocada em andamento---"),
    mainMenuAnalista(Id).

lidaComOpcaoAtividade(7, Id) :-
    writeln("Qual o ID atividade que você deseja marcar como concluída?"),
    read(IdAtividade),
    atividadeController:atualizarStatusAtividade(IdAtividade, "Concluida"),
    writeln("---Atividade marcada como concluida---"),
    mainMenuAnalista(Id).

lidaComOpcaoAtividade(8, Id) :-
    writeln("Qual o ID atividade que você deseja excluir?"),
    read(IdAtividade),
    atividadeController:removerAtividade(IdAtividade),
    writeln("---Atividade excluída com sucesso---"),
    mainMenuAnalista(Id).

lidaComOpcaoAtividade(_, Id) :-
    writeln("Você não selecionou uma opção válida. Selecione algum das opções abaixo\n"),
    lidaComComando(2, Id).