:- module(gestorController, [exibirGestor/1, exibirGestores/0, salvarGestor/3, removerGestor/1,
                            buscarGestorPorId/2, buscarGestorPorEmail/2])

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
gestorToJSON(Id, Nome, Email, Senha, GestorJSON) :-
    swritef(GestorJSON, '{"id": %w, "nome": "%w", "email": "%w", "senha": "%w"}',
            [Id, Nome, Email, Senha]).

% Exibir um gestor
exibirGestor([]).
exibirGestor([H|T]) :-
    write("ID: "), writeln(H.id),
    write("Nome: "), writeln(H.nome),
    write("Email: "), writeln(H.email),
    exibirGestor(T).

exibirGestores() :-
    lerJSON("./banco/gestores.json", Gestores),
    exibirGestor(Gestores).

% Gera uma lista de gestores
gestoresToJSON([], []).
gestoresToJSON([H|T], [X|Out]) :-
    gestorToJSON(H.id, H.nome, H.email, H.senha, X),
    gestoresToJSON(T, Out).

% Salva um gestor
salvarGestor(Nome, Email, Senha) :-
    lerJSON("./banco/gestores.json", File),
    gestoresToJSON(File, ListaGestoresJSON),
    ultimo_elemento(File, Ultimo),
    (Ultimo = null -> Id = 1 ; Id is Ultimo.id + 1),
    gestorToJSON(ID, Nome, Email, Senha, GestorJSON),
    append(ListaGestoresJSON, [GestorJSON], Saida),
    open("./banco/gestores.json", write, Stream),
    write(Stream, Saida),
    close(Stream).

% Remove um gestor no JSON
removerGestorJSON([], _, []).
removerGestorJSON([H|T], H.id, T).
removerGestorJSON([H|T], Id, [H|Out]) :- removerGestorJSON(T, Id, Out).

% Remove um gestor
removerGestor(Id) :-
    lerJSON("./banco/gestores.json", File),
    removerGestorJSON(File, Id, SaidaParcial),
    gestoresToJSON(SaidaParcial, Saida),
    open("./banco/gestores.json", write, Stream), write(Stream, Saida), close(Stream).

% Busca um gestor pelo ID no JSON
buscarGestorPorIdJSON([], _, []).
buscarGestorPorIdJSON([Gestor|_], Gestor.id, [Gestor]).
buscarGestorPorIdJSON([_|T], Id, Out) :- buscarGestorPorIdJSON(T, Id, Out).

% Busca um gestor pelo ID 
buscarGestorPorId(Id, Gestor) :-
    lerJSON("./banco/gestores.json", File),
    buscarGestorPorIdJSON(File, Id, Gestor).

% Busca um gestor pelo Email no JSON
buscarGestorPorEmailJSON([], _, null).
buscarGestorPorEmailJSON([Gestor|_], Gestor.email, Gestor).
buscarGestorPorEmailJSON([_|T], Email, [_|Out]) :- buscarGestorPorEmailJSON(T, Email, Out).

% Busca um gestor pelo Email
buscarGestorPorEmail(Email, Gestor) :-
    lerJSON("./banco/gestores.json", File),
    buscarGestorPorEmailJSON(File, Email, Gestor).
