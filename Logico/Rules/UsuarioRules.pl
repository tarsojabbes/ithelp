:- module(usuarioRules, [mainMenuUsuario/1]).

:- use_module("./Controller/AnalistaController.pl").
:- use_module("./Controller/ChamadoController.pl").

mainMenuUsuario(Id):-
    exibirMenuUsuario,
    read(Comando),
    lidarComComando(Comando, Id).

exibirMenuUsuario:-
    writeln("Enquanto usuário, você pode executar as seguintes funções:"),
    writeln("------FUNÇÕES PARA USUÁRIO----"),
    writeln("1 - Criar chamado"),
    writeln("2 - Acompanhar chamados que você criou"),
    writeln("3 - Avaliar analista responsável pelos seus chamados"),
    writeln("------------------------------------------"),
    writeln("Qual função você deseja executar?").

lidarComComando(1, Id):-
    writeln("Qual o título do chamado?"),
    read(TituloChamado),
    writeln("Qual a descrição do chamado?"),
    read(DescricaoChamado),
    writeln("------CONFIRMA CRIAÇÃO DO CHAMADO?----"),
    writeln("1 - Confirma"),
    writeln("2 - Cancela"),
    read(ConfirmaCriacaoChamado),
    (ConfirmaCriacaoChamado == 1 -> analistaController:buscarAnalistaPorEmail("analista@email.com", AnalistaPadrao),
     chamadoController:salvarChamado(TituloChamado, DescricaoChamado, "Nao iniciado", Id, AnalistaPadrao.id),
     writeln("---Chamado criado com sucesso---") ;
     writeln("---Criação do chamado cancelada---")),
    mainMenuUsuario(Id).

lidarComComando(2, Id):-
    chamadoController:buscarChamadoPorCriador(Id, Chamado),
    exibirChamadosUsuario(Chamado),
    mainMenuUsuario(Id).

lidarComComando(3, Id):-
    writeln("Qual o ID do analista?"),
    read(AnalistaId),
    writeln("Qual a avaliação para esse analista (1 a 5 estrelas)?"),
    read(AvaliacaoAnalista),
    writeln("------CONFIRMA AVALIAÇÃO DO ANALISTA?----"),
    writeln("1 - Confirma"),
    writeln("2 - Cancela"),
    read(ConfirmaAvaliacaoAnalista),
    (ConfirmaAvaliacaoAnalista == 1 -> analistaController:editarAvaliacaoAnalista(AnalistaId, AvaliacaoAnalista),
         writeln("---Avaliação atualizada com sucesso---") ;
         writeln("---Avaliação cancelada---")),
    mainMenuUsuario(Id).

lidarComComando(_, Id):-
    writeln("A função escolhida não existe. Por favor, selecione alguma das opções abaixo"),
    mainMenuUsuario(Id).

% exibição dos chamados do usuario
exibirChamadosUsuario([]) :- writeln("Chamados para o usuário informado não foram encontrados").
exibirChamadosUsuario(Chamados) :-
    writeln("--------------------------"),
    writeln("Chamados do Usuário"),
    writeln("--------------------------"),
    nl,
    printarChamados(Chamados).

printarChamados([]).
printarChamados([Chamado|Resto]) :-
    printarChamado(Chamado),
    printarChamados(Resto).

printarChamado(Chamado) :-
    write("Chamado: "),
    writeln(Chamado.titulo),
    write("Descrição: " ),
    writeln(Chamado.descricao),
    write("Status: "),
    writeln(Chamado.status),
    nl.
