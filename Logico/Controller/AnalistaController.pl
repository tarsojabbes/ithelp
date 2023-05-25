:- use_module(library(http/json)).

% Fato dinâmico para criar os IDs dos Analistas
id(1).
incrementa_id :- retract(id(X)), Y is X + 1, assert(id(Y)).
:- dynamic id/1.

% Leitura dos arquivos de JSON
lerJSON(FilePath, File) :-
	open(FilePath, read, F),
	json_read_dict(F, File).

% Formata a linha que será adicionada no arquivo JSON
analistaToJSON(Id, Nome, Email, Senha, Avaliacao, AnalistaJSON) :-
    swritef(AnalistaJSON, '{"id": "%w", "nome": "%w", "email": "%w", "senha": "%w", "avaliacao": "%w"}',
            [Id, Nome, Email, Senha, Avaliacao]).

% Exibir um analista
exibirAnalista([]).
exibirAnalista([H|T]) :-
    write("ID: "), writeln(H.id),
    write("Nome: "), writeln(H.nome),
    write("Email: "), writeln(H.email),
    write('Avaliacao: '), writeln(H.avaliacao)

exibirAnalistas() :-
    lerJSON("./banco/analistas.json", Analistas),
    exibirAnalista(Analistas).

% Gera uma lista de analistas
analistasToJSON([], []).
analistasToJSON([H|T], [X|Out]) :-
    analistaToJSON(H.id, H.nome, H.email, H.senha, H.avaliacao, X),
    analistasToJSON(T, Out).

% Salva um analista
salvarAnalista(Nome, Email, Senha, Avaliacao) :-
    id(ID), incrementa_id,
    lerJSON("./banco/analistas.json", File),
    analistasToJSON(File, ListaAnalistasJSON),
    analistaToJSON(ID, Nome, Email, Senha, Avaliacao, AnalistaJSON),
    append(ListaAnalistasJSON, [AnalistaJSON], Saida),
    open("./banco/analistas.json", write, Stream),
    write(Stream, Saida),
    close(Stream).

% Remove um analista no JSON
removerAnalistaJSON([], _, []).
removerAnalistaJSON([H|T], H.id, T).
removerAnalistaJSONO([H|T], Id, [H|Out]) :- removerAgenteJSON(T, Id, Out).

% Remove um analista
removerAnalista(Id) :-
    lerJSON("./banco/analistas.json", File),
    removerAgenteJSON(File, Id, SaidaParcial),
    analistasToJSON(SaidaParcial, Saida),
    open("./banco/analistas.json", write, Stream), write(Stream, Saida), close(Stream).

% Busca um analista pelo ID no JSON
buscarAnalistaPorIdJSON([], _, null).
buscarAnalistaPorIdJSON([Agente|_], Agente.id, Agente).
buscarAnalistaPorIdJSON([_|T], Id, [_|Out]) :- buscarAnalistaPorIdJSON(T, Id, Out).

% Busca um analista pelo ID 
buscarAnalistaPorId(Id, Analista) :-
    lerJSON("./banco/analistas.json", File),
    buscarAnalistaPorIdJSON(File, Id, Analista).

% Busca um analista pelo Email

% Atualiza a avaliacao de um analista

