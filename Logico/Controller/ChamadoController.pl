:- module(chamadoController, [exibirChamado/1, exibirChamados/0, salvarChamado/5, removerChamado/1,
                                atualizarResponsavelIdChamado/2, buscarChamadoPorId/2, buscarChamadoPorCriador/2,
                                buscarChamadoPorAnalista/2, buscarChamadoPorStatus/2, quantidadeTotalChamados/1]).

:- use_module(library(http/json)).

ultimo_elemento([], null).
ultimo_elemento([X], X).
ultimo_elemento([_|T], X) :-
    ultimo_elemento(T, X).

% Leitura dos arquivos de JSON
lerJSON(FilePath, File) :-
	open(FilePath, read, F),
	json_read_dict(F, File).

% Formata a linha que será adicionada no arquivo JSON
chamadoToJSON(Id, Titulo, Descricao, Status, Criador, Responsavel, ChamadoJSON) :-
    swritef(ChamadoJSON, '{"id": %w, "titulo": "%w", "descricao": "%w", "status": "%w", "criador": %w, "responsavel": %w}',
            [Id, Titulo, Descricao, Status, Criador, Responsavel]).

% Exibir um chamado
exibirChamado([]).
exibirChamado([H|T]) :-
    writeln("-----------------------------------"),
    write("ID: "), writeln(H.id),
    write("Titulo: "), writeln(H.titulo),
    write("Descricao: "), writeln(H.descricao),
    write("Status: "), writeln(H.status),
    write("Criador: "), writeln(H.criador),
    write("Responsavel: "), writeln(H.responsavel),
    writeln("-----------------------------------"),
    exibirChamado(T).

exibirChamados() :-
    lerJSON("./banco/chamados.json", Chamados),
    exibirChamado(Chamados).

% Gera uma lista de chamados
chamadosToJSON([], []).
chamadosToJSON([H|T], [X|Out]) :-
    chamadoToJSON(H.id, H.titulo, H.descricao, H.status, H.criador, H.responsavel, X),
    chamadosToJSON(T, Out).

% Busca todos os chamados
quantidadeTotalChamados(QtdChamados) :-
    lerJSON("./banco/chamados.json", File),
    chamadosToJSON(File, Chamados),
    length(Chamados, QtdChamados).

% Salva um chamado
salvarChamado(Titulo, Descricao, Status, Criador, Responsavel) :-
    lerJSON("./banco/chamados.json", File),
    chamadosToJSON(File, ListaChamadosJSON),
    ultimo_elemento(File, Ultimo),
    (Ultimo = null -> Id = 1 ; Id is Ultimo.id + 1),
    chamadoToJSON(Id, Titulo, Descricao, Status, Criador, Responsavel, ChamadoJSON),
    append(ListaChamadosJSON, [ChamadoJSON], Saida),
    open("./banco/chamados.json", write, Stream),
    write(Stream, Saida),
    close(Stream).

% Remove um chamado no JSON
removerChamadoJSON([], _, []).
removerChamadoJSON([H|T], H.id, T).
removerChamadoJSON([H|T], Id, [H|Out]) :- removerChamadoJSON(T, Id, Out).

% Remove um chamado
removerChamado(Id) :-
    lerJSON("./banco/chamados.json", File),
    removerChamadoJSON(File, Id, SaidaParcial),
    chamadosToJSON(SaidaParcial, Saida),
    open("./banco/chamados.json", write, Stream), write(Stream, Saida), close(Stream).

% Busca um chamado pelo ID no JSON
buscarChamadoPorIdJSON([], _, []).
buscarChamadoPorIdJSON([Chamado|_], Chamado.id, [Chamado]).
buscarChamadoPorIdJSON([_|T], Id, Out) :- buscarChamadoPorIdJSON(T, Id, Out).

% Busca um chamado pelo ID 
buscarChamadoPorId(Id, Chamado) :-
    lerJSON("./banco/chamados.json", File),
    buscarChamadoPorIdJSON(File, Id, Chamado).

% Busca um chamado pelo título no JSON
buscarChamadoPorTituloJSON([], _, null).
buscarChamadoPorTituloJSON([Chamado|_], Chamado.titulo, Chamado).
buscarChamadoPorTituloJSON([_|T], Titulo, [_|Out]) :- buscarChamadoPorTituloJSON(T, Titulo, Out).

% Busca um chamado pelo titulo
buscarChamadoPorTitulo(Titulo, Chamado) :-
    lerJSON("./banco/chamados.json", File),
    buscarChamadoPorTituloJSON(File, Titulo, Chamado).

% Busca os chamados pelo criador no JSON
buscarChamadoPorCriadorJSON([], _, null).
buscarChamadoPorCriadorJSON([Chamado|_], Chamado.criador, Chamado).
buscarChamadoPorCriadorJSON([_|T], criadorId, [_|Out]) :- buscarChamadoPorCriadorJSON(T, criadorId, Out).

% Busca os chamados pelo criador
buscarChamadoPorCriador(criadorId, Chamado) :-
    lerJSON("./banco/chamados.json", File),
    buscarChamadoPorCriadorJSON(File, criadorId, Chamado).

% Busca os chamados pelo analista responsável no JSON
buscarChamadoPorAnalistaJSON([], _, []).
buscarChamadoPorAnalistaJSON([Chamado|T], Chamado.responsavel, [Chamado|Out]) :-
    Chamado.responsavel = AnalistaId,
    buscarChamadoPorAnalistaJSON(T, AnalistaId , Out).
buscarChamadoPorAnalistaJSON([_|T], AnalistaId, Out) :-
    buscarChamadoPorAnalistaJSON(T, AnalistaId, Out).

% Busca os chamados pelo analista responsável
buscarChamadoPorAnalista(AnalistaId, Chamado) :-
    lerJSON("./banco/chamados.json", File),
    buscarChamadoPorAnalistaJSON(File, AnalistaId, Chamado).

% Buscar chamados por status no JSON
buscarChamadoPorStatusJSON([], _, []).
buscarChamadoPorStatusJSON([Chamado|T], Status, [Chamado|Out]) :-
    Chamado.status = Status,
    buscarChamadoPorStatusJSON(T, Status, Out).
buscarChamadoPorStatusJSON([_|T], Status, Out) :-
    buscarChamadoPorStatusJSON(T, Status, Out).

% Buscar chamados por status
buscarChamadoPorStatus(Status, Chamado) :-
    lerJSON("./banco/chamados.json", File),
    buscarChamadoPorStatusJSON(File, Status, Chamado).

% Atualizar status de Chamado no JSON
atualizarStatusChamadoJSON([], _, _, []).
atualizarStatusChamadoJSON([H|T], H.id, Status, [_{id: H.id, titulo: H.titulo, descricao: H.descricao, status: Status, criador: H.criador, responsavel: H.responsavel}|T]).
atualizarStatusChamadoJSON([H|T], Id, Status, [H|Out]) :-
    atualizarStatusChamadoJSON(T, Id, Status, Out).

% Atualizar status de chamado (Nao iniciado, Em andamento, Concluido)
atualizarStatusChamado(Id, NovoStatus) :-
    lerJSON("./banco/chamados.json", File),
    atualizarStatusChamadoJSON(File, Id, NovoStatus, SaidaParcial),
    chamadosToJSON(SaidaParcial, Saida),
    open("./banco/chamados.json", write, Stream), write(Stream, Saida), close(Stream).

% Atualizar responsavel pelo chamado no JSON
atualizarResponsavelIdChamadoJSON([], _, _, []).
atualizarResponsavelIdChamadoJSON([H|T], H.id, ResponsavelId, [_{id: H.id, titulo: H.titulo, descricao: H.descricao, status: H.status, criador: H.criador, responsavel: ResponsavelId}|T]).
atualizarResponsavelIdChamadoJSON([H|T], Id, ResponsavelId, [H|Out]) :-
    atualizarResponsavelIdChamadoJSON(T, Id, ResponsavelId, Out).

% Atualizar responsavel pelo chamado
atualizarResponsavelIdChamado(Id, NovoResponsavelId) :-
    lerJSON("./banco/chamados.json", File),
    atualizarResponsavelIdChamadoJSON(File, Id, NovoResponsavelId, SaidaParcial),
    chamadosToJSON(SaidaParcial, Saida),
    open("./banco/chamados.json", write, Stream), write(Stream, Saida), close(Stream).