:- use_module(library(http/json)).

% Fato dinâmico para criar os IDs dos Chamados
id(1).
incrementa_id :- retract(id(X)), Y is X + 1, assert(id(Y)).
:- dynamic id/1.

% Leitura dos arquivos de JSON
lerJSON(FilePath, File) :-
	open(FilePath, read, F),
	json_read_dict(F, File).

% Formata a linha que será adicionada no arquivo JSON
chamadoToJSON(Id, Titulo, Descricao, Status, Criador, Responsavel, ChamadoJSON) :-
    swritef(ChamadoJSON, '{"id": %w, "titulo": "%w", "descricao": "%w", "status": "%w", "criador": "%w", "responsavel": "%w"}',
            [Id, Titulo, Descricao, Status, Criador, Responsavel]).

% Exibir um chamado
exibirChamado([]).
exibirChamado([H|_]) :-
    write("ID: "), writeln(H.id),
    write("Titulo: "), writeln(H.titulo),
    write("Descricao: "), writeln(H.descricao),
    write("Status: "), writeln(H.status),
    write("Criador: "), writeln(H.criador),
    write("Responsavel: "), writeln(H.responsavel).

exibirChamados() :-
    lerJSON("./banco/chamados.json", Chamados),
    exibirChamado(Chamados).

% Gera uma lista de chamados
chamadosToJSON([], []).
chamadosToJSON([H|T], [X|Out]) :-
    chamadoToJSON(H.id, H.titulo, H.descricao, H.status, H.criador, H.responsavel, X),
    chamadosToJSON(T, Out).

% Salva um chamado
salvarChamado(Titulo, Descricao, Status, Criador, Responsavel) :-
    id(ID), incrementa_id,
    lerJSON("./banco/chamados.json", File),
    chamadosToJSON(File, ListaChamadosJSON),
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
buscarChamadoPorIdJSON([], _, null).
buscarChamadoPorIdJSON([Chamado|_], Chamado.id, Chamado).
buscarChamadoPorIdJSON([_|T], Id, [_|Out]) :- buscarChamadoPorIdJSON(T, Id, Out).

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
buscarChamadoPorAnalistaJSON([], _, null).
buscarChamadoPorAnalistaJSON([Chamado|_], Chamado.responsavel, Chamado).
buscarChamadoPorAnalistaJSON([_|T], analistaId, [_|Out]) :- buscarChamadoPorAnalistaJSON(T, analistaId, Out).

% Busca os chamados pelo analista responsável
buscarChamadoPorAnalista(analistaId, Chamado) :-
    lerJSON("./banco/chamados.json", File),
    buscarChamadoPorAnalistaJSON(File, analistaId, Chamado).

% Busca os chamados não iniciados
exibirChamadosNaoIniciados() :-
    lerJSON("./banco/chamados.json", Chamados),
    exibirChamadoNaoIniciado(Chamados).

% Exibir um chamado não iniciado
exibirChamadoNaoIniciado([]).
exibirChamadoNaoIniciado([H|T]) :-
    H.status = 'Nao iniciado',
    write("ID: "), writeln(H.id),
    write("Titulo: "), writeln(H.titulo),
    write("Descricao: "), writeln(H.descricao),
    write("Status: "), writeln(H.status),
    write("Criador: "), writeln(H.criador),
    write("Responsavel: "), writeln(H.responsavel),
    exibirChamadoNaoIniciado(T). 
    % não sei se eu precisava tratar a cauda da lista, mas imaginei que, se não tivesse o status "não iniciado", 
    % a relação não ia casar com nada aqui e daria false (fiz isso em todos os métodos que buscam chamados por algum status)

% Busca os chamados em andamento
exibirChamadosEmAndamento() :-
    lerJSON("./banco/chamados.json", Chamados),
    exibirChamadoEmAndamento(Chamados).

% Exibir um chamado em andamento
exibirChamadoEmAndamento([]).
exibirChamadoEmAndamento([H|T]) :-
    H.status = 'Em andamento',
    write("ID: "), writeln(H.id),
    write("Titulo: "), writeln(H.titulo),
    write("Descricao: "), writeln(H.descricao),
    write("Status: "), writeln(H.status),
    write("Criador: "), writeln(H.criador),
    write("Responsavel: "), writeln(H.responsavel),
    exibirChamadoEmAndamento(T).

% Busca os chamados concluídos
exibirChamadosConcluidos() :-
    lerJSON("./banco/chamados.json", Chamados),
    exibirChamadoConcluido(Chamados).

% Exibir um chamado concluido
exibirChamadoConcluido([]).
exibirChamadoConcluido([H|T]) :-
    H.status = 'Concluido',
    write("ID: "), writeln(H.id),
    write("Titulo: "), writeln(H.titulo),
    write("Descricao: "), writeln(H.descricao),
    write("Status: "), writeln(H.status),
    write("Criador: "), writeln(H.criador),
    write("Responsavel: "), writeln(H.responsavel),
    exibirChamadoConcluido(T). 

/*

FALTANDO
- Atualizar o status do chamado
- Atualizar o analista do chamado
- Calcular as estatísticas dos chamados

*/