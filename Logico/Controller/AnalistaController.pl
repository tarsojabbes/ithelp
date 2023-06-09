:- module(analistaController, [exibirAnalistas/0, exibirAnalista/1, salvarAnalista/4, removerAnalista/1, 
                    buscarAnalistaPorId/2, buscarAnalistaPorEmail/2, editarAvaliacaoAnalista/2]).

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
analistaToJSON(Id, Nome, Email, Senha, Avaliacao, AnalistaJSON) :-
    swritef(AnalistaJSON, '{"id": %w, "nome": "%w", "email": "%w", "senha": "%w", "avaliacao": %w}',
            [Id, Nome, Email, Senha, Avaliacao]).

% Exibir um analista
exibirAnalista([]).
exibirAnalista([H|_]) :-
    write("ID: "), writeln(H.id),
    write("Nome: "), writeln(H.nome),
    write("Email: "), writeln(H.email),
    write("Avaliacao: "), writeln(H.avaliacao).

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
    lerJSON("./banco/analistas.json", File),
    analistasToJSON(File, ListaAnalistasJSON),
    ultimo_elemento(File, Ultimo),
    (Ultimo = null -> Id = 1 ; Id is Ultimo.id + 1),
    analistaToJSON(Id, Nome, Email, Senha, Avaliacao, AnalistaJSON),
    append(ListaAnalistasJSON, [AnalistaJSON], Saida),
    open("./banco/analistas.json", write, Stream),
    write(Stream, Saida),
    close(Stream).

% Remove um analista no JSON
removerAnalistaJSON([], _, []).
removerAnalistaJSON([H|T], H.id, T).
removerAnalistaJSON([H|T], Id, [H|Out]) :- removerAnalistaJSON(T, Id, Out).

% Remove um analista
removerAnalista(Id) :-
    lerJSON("./banco/analistas.json", File),
    removerAnalistaJSON(File, Id, SaidaParcial),
    analistasToJSON(SaidaParcial, Saida),
    open("./banco/analistas.json", write, Stream), write(Stream, Saida), close(Stream).

% Busca um analista pelo ID no JSON
buscarAnalistaPorIdJSON([], _, []).
buscarAnalistaPorIdJSON([Analista|_], Analista.id, [Analista]).
buscarAnalistaPorIdJSON([_|T], Id, Out) :- buscarAnalistaPorIdJSON(T, Id, Out).

% Busca um analista pelo ID 
buscarAnalistaPorId(Id, Analista) :-
    lerJSON("./banco/analistas.json", File),
    buscarAnalistaPorIdJSON(File, Id, Analista).

% Busca um analista pelo Email no JSON
buscarAnalistaPorEmailJSON([], _, null).
buscarAnalistaPorEmailJSON([Analista|_], Analista.email, Analista).
buscarAnalistaPorEmailJSON([_|T], Email, Out) :- buscarAnalistaPorEmailJSON(T, Email, Out).

% Busca um analista pelo Email
buscarAnalistaPorEmail(Email, Analista) :-
    lerJSON("./banco/analistas.json", File),
    buscarAnalistaPorEmailJSON(File, Email, Analista).

% Atualiza a avaliacao de um analista no JSON
editarAvaliacaoAnalistaJSON([], _, _, []).
editarAvaliacaoAnalistaJSON([H|T], H.id, Avaliacao, [_{id: H.id, avaliacao: Avaliacao, nome: H.nome, email: H.email, senha: H.senha}|T]).
editarAvaliacaoAnalistaJSON([H|T], Id, Avaliacao, [H|Out]) :-
    editarAvaliacaoAnalistaJSON(T, Id, Avaliacao, Out).

% Atualiza a avaliacao de um analista
editarAvaliacaoAnalista(Id, NovaNota) :-
    lerJSON("./banco/analistas.json", File),
    buscarAnalistaPorId(Id, [AnalistaEncontrado|_]),
    calculaNovaAvaliacao(AnalistaEncontrado.avaliacao, NovaNota, AvaliacaoNova),
    editarAvaliacaoAnalistaJSON(File, Id, AvaliacaoNova, SaidaParcial),
    analistasToJSON(SaidaParcial, Saida),
    open("./banco/analistas.json", write, Stream), write(Stream, Saida), close(Stream).

% Calcula nova avaliacao
calculaNovaAvaliacao(AvaliacaoAntiga, NovaNota, AvaliacaoNova) :-
    AvaliacaoNova is (integer(AvaliacaoAntiga)+integer(NovaNota))/2.
