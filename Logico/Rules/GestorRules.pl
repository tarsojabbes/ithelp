:- module(gestorRules, [mainMenuGestor/0,exibirMenuGestor/0, lidarComComando/1, lidarComOpcaoChamado/1, exibeFuncoesChamados/0]).

:- use_module("./Controller/AnalistaController.pl").
:- use_module("./Controller/GestorController.pl").
:- use_module("./Controller/UsuarioController.pl").
:- use_module("./Controller/ChamadoController.pl").
:- use_module("./Controller/AtividadeController.pl").
:- use_module("./Controller/ItemController.pl").

mainMenuGestor():-
    exibirMenuGestor(),
    read(Comando),
    lidarComComando(Comando).

exibirMenuGestor():-
    writeln("Enquanto gestor, você pode executar as seguintes funções:"),
    writeln("------FUNÇÕES PARA GESTOR----"),
    writeln("1 - Gerenciar chamados"),
    writeln("2 - Visualizar inventário"),
    writeln("3 - Visualizar quadro de atividades"),
    writeln("4 - Criar nova atividade"),
    writeln("5 - Delegar atividade"),
    writeln("6 - Criar novo usuário"),
    writeln("7 - Criar novo analista"),
    writeln("8 - Logout"),
    writeln("------------------------------------------"),
    writeln("Qual função você deseja executar?").

lidarComComando(1):-
    exibeFuncoesChamados(),
    read(Opcao),
    lidarComOpcaoChamado(Opcao).
lidarComComando(2):-
    itemController:exibirItens(),
    mainMenuGestor().
lidarComComando(3):-
    atividadeController:exibirAtividades(),
    mainMenuGestor().
lidarComComando(4):-
    writeln("Qual o título da atividade a ser criada?"),
    read(Titulo),
    writeln("Qual a descrição da atividade?"),
    read(Descricao),
    writeln("Quem é o responsável pela atividade?"),
    read(ResponsavelId),
    atividadeController:salvarAtividade(Titulo, Descricao, 'Nao iniciada', ResponsavelId),
    writeln("---Atividade criada com sucesso---"),
    mainMenuGestor().
lidarComComando(5):-
    writeln("Qual o ID da atividade a ser delegada?"),
    read(AtividadeId),
    writeln("Qual o ID do novo responsável pela atividade?"),
    read(NovoResponsavelId), 
    atividadeController:atualizarResponsavelIdAtividade(AtividadeId, NovoResponsavelId),
    writeln("---Atividade repassada com sucesso--"),
    mainMenuGestor().
lidarComComando(6):-
    writeln("Insira o nome do novo usuário:"),
    read(Nome),
    writeln("Cadastre o email do novo usuário:"),
    read(Email),
    writeln("Cadastre uma senha para o novo usuário:"),
    read(Senha),
    usuarioController:salvarUsuario(Nome,Email,Senha),
    writeln("---Usuário cadastrado com sucesso---"),
    mainMenuGestor().
lidarComComando(7):-
    writeln("Insira o nome do novo analista:"),
    read(Nome),
    writeln("Cadastre o email do novo analista:"),
    read(Email),
    writeln("Cadastre uma senha para o novo analista:"),
    read(Senha),
    analistaController:salvarAnalista(Nome,Email,Senha,5),
    writeln("---Analista cadastrado com sucesso---"),
    mainMenuGestor().
lidarComComando(8):-!.
lidarComComando(_):-
    writeln("A função escolhida não existe. Por favor, selecione alguma das opções abaixo"),
    mainMenuGestor().

exibeFuncoesChamados():-
    writeln("---FUNÇÕES PARA CHAMADOS---"),
    writeln("1 - Visualizar chamados"),
    writeln("2 - Visualizar chamados abertos"),
    writeln("3 - Visualizar estatísticas de número de chamados"),
    writeln("4 - Buscar chamado por ID"),
    writeln("5 - Buscar chamado por título"),
    writeln("------------------------------------------"),
    writeln("Qual função você deseja executar?").

lidarComOpcaoChamado(1):-
    chamadoController:exibirChamados(),
    mainMenuGestor().
lidarComOpcaoChamado(2):-
    chamadoController:buscarChamadoPorStatus("Nao iniciado", Chamado),
    chamadoController:exibirChamado(Chamado),
    mainMenuGestor().
lidarComOpcaoChamado(3) :-
    % Busca pelos chamados em diferentes estados
    chamadoController:buscarChamadoPorStatus("Nao iniciado", ChamadosNaoIniciados),
    chamadoController:buscarChamadoPorStatus("Em andamento", ChamadosEmAndamento),
    chamadoController:buscarChamadoPorStatus("Concluido", ChamadosConcluidos),

    % Determina a quantidade de cada tipo de chamados pelo status
    chamadoController:quantidadeTotalChamados(Qtd),
    length(ChamadosNaoIniciados, QtdChamadosNaoIniciados),
    length(ChamadosEmAndamento, QtdChamadosEmAndamento),
    length(ChamadosConcluidos, QtdChamadosConcluidos),

    write(Qtd), writeln(" chamados totais"),
    write(QtdChamadosNaoIniciados), writeln(" chamados não iniciados"),
    write(QtdChamadosEmAndamento), writeln(" chamados em andamento"),
    write(QtdChamadosConcluidos), writeln(" chamados concluídos"),
    mainMenuGestor().

lidarComOpcaoChamado(4):-
    writeln("Qual o ID do chamado a ser acessado?"),
    read(Id),
    chamadoController:buscarChamadoPorId(Id, Chamado),
    chamadoController:exibirChamado(Chamado),
    mainMenuGestor().
lidarComOpcaoChamado(4):- writeln("Chamado com ID informado não foi encontrado").
lidarComOpcaoChamado(5):-
    writeln("Qual o título do chamado a ser acessado?"),
    read(Titulo),
    chamadoController:buscarChamadoPorTitulo(Titulo, Chamado),
    chamadoController:exibirChamado([Chamado]),
    mainMenuGestor().
lidarComOpcaoChamado(_):-
    writeln("A função escolhida não existe. Por favor, selecione alguma das opções abaixo"),
    mainMenuGestor().
