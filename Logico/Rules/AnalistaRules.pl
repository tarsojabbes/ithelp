:- module(analistaRules, [mainMenuAnalista/1]).

:- use_module("../Controller/ChamadoController.pl").

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

