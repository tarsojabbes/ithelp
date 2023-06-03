:- module(usuarioRules, [mainMenuUsuario/0,exibirMenuUsuario/0, lidarComComando/1, lidarComOpcaoChamado/1, exibeFuncoesChamados/0])

:- use_module("./Controller/AnalistaController.pl").
:- use_module("./Controller/ChamadoController.pl").

mainMenuUsuario():-
    exibirMenuUsuario(),
    read(Comando),
    lidarComComando(Comando).

exibirMenuUsuario():-
    writeln("Enquanto usuário, você pode executar as seguintes funções:"),
    writeln("------FUNÇÕES PARA USUÁRIO----"),
    writeln("1 - Criar chamado"),
    writeln("2 - Acompanhar chamados que você criou"),
    writeln("3 - Avaliar analista responsável pelos seus chamados"),
    writeln("------------------------------------------"),
    writeln("Qual função você deseja executar?").

lidarComComando("1"):-
    writeln("Qual o título do chamado?"),
    read(TituloChamado),
    writeln("Qual a descrição do chamado?"),
    read(DescricaoChamado),
    writeln("------CONFIRMA CRIAÇÃO DO CHAMADO?----"),
    writeln("1 - Confirma"),
    writeln("2 - Cancela"),
    read(ConfirmaCriacaoChamado),
    (ConfirmaCriacaoChamado == 1 -> chamadoController.salvarChamado(TituloChamado, DescricaoChamado, "Nao iniciado", Criador, Responsavel)), /* TODO pegar Criador antes, saber quem sera o responsavel */
    mainMenuUsuario().

lidarComComando("2"):-
    writeln("Qual o seu ID de Usuário?"), /* TODO ver se tem uma forma automatica de pegar esse id */
    read(usuarioId),
    buscarChamadoPorCriador(usuarioId, Chamado),
    writeln(Chamado), /* TODO usar um if pro caso de não vir nenhum chamado parar com !, e usar uma funcao pra formatar a lista de chamados */
    mainMenuUsuario().
lidarComOpcaoChamado("2"):- writeln("Chamados para o usuário informado não foram encontrados").

lidarComComando("3"):-
    atividadeController:exibirAtividades().
    writeln("Qual o ID do analista?"),
    read(analistaId),
    writeln("Qual a avaliação para esse analista (1 a 5 estrelas)?"),
    read(avaliacaoAnalista),
    writeln("------CONFIRMA AVALIAÇÃO DO ANALISTA?----"),
    writeln("1 - Confirma"),
    writeln("2 - Cancela"),
    read(ConfirmaAvaliacaoAnalista),
    lidaComConfirmacaoAvaliacao(ConfirmaAvaliacaoAnalista), /* TODO salvar no banco ou nao, usar um if, nao precisa criar nova regra */
    mainMenuUsuario().

lidarComComando(_):-
    writeln("A função escolhida não existe. Por favor, selecione alguma das opções abaixo"),
    exibirMenuUsuario().
