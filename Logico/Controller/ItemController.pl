:- module(itemController, [exibirItens/0, exibirItem/1, salvarItem/3, removerItem/1, 
                    buscarItemPorId/2, buscarItemPorMarca/2, buscarItemPorNome/2]).

:- use_module(library(http/json)).

ultimo_elemento([], null).
ultimo_elemento([X], X).
ultimo_elemento([_|T], X) :-
    ultimo_elemento(T, X).

% Fato dinâmico para criar os IDs dos Itens
id(1).
incrementa_id :- retract(id(X)), Y is X + 1, assert(id(Y)).
:- dynamic id/1.

% Leitura dos arquivos de JSON
lerJSON(FilePath, File) :-
	open(FilePath, read, F),
	json_read_dict(F, File).

% Formata a linha que será adicionada no arquivo JSON
itemToJSON(Id, Nome, Marca, DataAquisicao, ItemJSON) :-
    swritef(ItemJSON, '{"id": %w, "nome": "%w", "marca": "%w", "data_aquisicao": "%w"}',
            [Id, Nome, Marca, DataAquisicao]).

% Exibir um item
exibirItem([]).
exibirItem([H|_]) :-
    write("ID: "), writeln(H.id),
    write("Nome: "), writeln(H.nome),
    write("Data de aquisição: "), writeln(H.data_aquisicao).

exibirItens() :-
    lerJSON("../banco/itens.json", Itens),
    exibirItem(Itens).

% Gera uma lista de items
itensToJSON([], []).
itensToJSON([H|T], [X|Out]) :-
    itemToJSON(H.id, H.nome, H.marca, H.data_aquisicao, X),
    itensToJSON(T, Out).

% Salva um item
salvarItem(Nome, Marca, DataAquisicao) :-
    lerJSON("../banco/itens.json", File),
    itensToJSON(File, ListaItemJSON),
    ultimo_elemento(File, Ultimo),
    (Ultimo = null -> Id = 1 ; Id is Ultimo.id + 1),
    itemToJSON(Id, Nome, Marca, DataAquisicao, ItemJSON),
    append(ListaItemJSON, [ItemJSON], Saida),
    open("../banco/itens.json", write, Stream),
    write(Stream, Saida),
    close(Stream).

% Remove um item no JSON
removerItemJSON([], _, []).
removerItemJSON([H|T], H.id, T).
removerItemJSON([H|T], Id, [H|Out]) :- removerItemJSON(T, Id, Out).

% Remove um item
removerItem(Id) :-
    lerJSON("../banco/itens.json", File),
    removerItemJSON(File, Id, SaidaParcial),
    itensToJSON(SaidaParcial, Saida),
    open("../banco/itens.json", write, Stream), write(Stream, Saida), close(Stream).

% Busca um item pelo ID no JSON
buscarItemPorIdJSON([], _, null).
buscarItemPorIdJSON([Item|_], Item.id, Item).
buscarItemPorIdJSON([_|T], Id, [_|Out]) :- buscarItemPorIdJSON(T, Id, Out).

% Busca um item pelo ID 
buscarItemPorId(Id, Item) :-
    lerJSON("../banco/itens.json", File),
    buscarItemPorIdJSON(File, Id, Item).

% Busca um item pela Marca no JSON
buscarItemPorMarcaJSON([], _, null).
buscarItemPorMarcaJSON([Item|_], Item.marca, Item).
buscarItemPorMarcaJSON([_|T], Marca, [_|Out]) :- buscarItemPorMarcaJSON(T, Marca, Out).

% Busca um item pela Marca
buscarItemPorMarca(Marca, Item) :-
    lerJSON("../banco/itens.json", File),
    buscarItemPorMarcaJSON(File, Marca, Item).

% Busca um item pela Nome no JSON
buscarItemPorNomeJSON([], _, null).
buscarItemPorNomeJSON([Item|_], Item.nome, Item).
buscarItemPorNomeJSON([_|T], Nome, [_|Out]) :- buscarItemPorNomeJSON(T, Nome, Out).

% Busca um item pelo Nome
buscarItemPorNome(Nome, Item) :-
    lerJSON("../banco/itens.json", File),
    buscarItemPorNomeJSON(File, Nome, Item).
