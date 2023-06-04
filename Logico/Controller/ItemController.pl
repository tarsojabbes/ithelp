:- module(itemController, [exibirItens/0, exibirItem/1, salvarItem/3, removerItem/1, 
                    buscarItemPorId/2, buscarItemPorMarca/2]).

:- use_module(library(http/json)).

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
    lerJSON("./banco/itens.json", Itens),
    exibirItem(Itens).

% Gera uma lista de items
itensToJSON([], []).
itensToJSON([H|T], [X|Out]) :-
    itemToJSON(H.id, H.nome, H.marca, H.data_aquisicao, X),
    itemToJSON(T, Out).

% Salva um item
salvarItem(Nome, Marca, DataAquisicao) :-
    id(ID), incrementa_id,
    lerJSON("./banco/itens.json", File),
    itemToJSON(File, ListaItensJSON),
    itemToJSON(ID, Nome, Marca, DataAquisicao, ItemJSON),
    append(ListaItensJSON, [ItemJSON], Saida),
    open("./banco/itens.json", write, Stream),
    write(Stream, Saida),
    close(Stream).

% Remove um item no JSON
removerItemJSON([], _, []).
removerItemJSON([H|T], H.id, T).
removerItemJSON([H|T], Id, [H|Out]) :- removerItemJSON(T, Id, Out).

% Remove um item
removerItem(Id) :-
    lerJSON("./banco/itens.json", File),
    removerItemJSON(File, Id, SaidaParcial),
    itensToJSON(SaidaParcial, Saida),
    open("./banco/itens.json", write, Stream), write(Stream, Saida), close(Stream).

% Busca um item pelo ID no JSON
buscarItemPorIdJSON([], _, null).
buscarItemPorIdJSON([Item|_], Item.id, Item).
buscarItemPorIdJSON([_|T], Id, [_|Out]) :- buscarItemPorIdJSON(T, Id, Out).

% Busca um item pelo ID 
buscarItemPorId(Id, Item) :-
    lerJSON("./banco/itens.json", File),
    buscarItemPorIdJSON(File, Id, Item).

% Busca um item pela Marca no JSON
buscarItemPorMarcaJSON([], _, null).
buscarItemPorMarcaJSON([Item|_], Item.marca, Item).
buscarItemPorMarcaJSON([_|T], Marca, [_|Out]) :- buscarItemPorMarcaJSON(T, Marca, Out).

% Busca um item pela Marca
buscarItemPorMarca(Marca, Item) :-
    lerJSON("./banco/itens.json", File),
    buscarItemPorMarcaJSON(File, Marca, Item).

% Busca um item pela Marca
buscarItemPorMarca(Marca, Item) :-
    lerJSON("./banco/itens.json", File),
    buscarItemPorMarcaJSON(File, Marca, Item).
