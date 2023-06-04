:- module(atividadeController, [exibirAtividade/1, exibirAtividades/0, salvarAtividade/4, buscarAtividadePorId/2,
                                buscarAtividadePorStatus/2, atualizarStatusAtividade/2, atualizarResponsavelIdAtividade/2,
                                removerAtividade/1])
                                
:- use_module(library(http/json)).

ultimo_elemento([], null).
ultimo_elemento([X], X).
ultimo_elemento([_|T], X) :-
    ultimo_elemento(T, X).

% Leitura dos arquivos de JSON
lerJSON(FilePath, File) :-
	open(FilePath, read, F),
	json_read_dict(F, File).

% Formata linha que será adicionada no arquivo JSON
atividadeToJSON(Id, Titulo, Descricao, Status, ResponsavelId, AtividadeJSON) :- 
    swritef(AtividadeJSON, '{"id": %w, "titulo": "%w", "descricao": "%w", "status": "%w", "responsavelId": %w}',
            [Id, Titulo, Descricao, Status, ResponsavelId]).

% Gera uma lista de atividades a partir do JSON
atividadesToJSON([], []).
atividadesToJSON([H|T], [X|Out]) :-
    atividadeToJSON(H.id, H.titulo, H.descricao, H.status, H.responsavelId, X),
    atividadesToJSON(T, Out).

% Exibir uma atividade
exibirAtividade([]).
exibirAtividade([H|_]) :-
    write("ID: "), writeln(H.id),
    write("Título: "), writeln(H.titulo),
    write("Descrição: "), writeln(H.descricao),
    write("Status: "), writeln(H.status).

% Exibe todas as atividades salvas
exibirAtividades() :-
    lerJSON("./banco/atividades.json", Atividades),
    exibirAtividade(Atividades).

% Salvar atividade
salvarAtividade(Titulo, Descricao, Status, ResponsavelId) :-
    lerJSON("./banco/atividades.json", File),
    atividadesToJSON(File, ListaAtividadesJSON),
    ultimo_elemento(File, Ultimo),
    (Ultimo = null -> Id = 1 ; Id is Ultimo.id + 1),
    atividadeToJSON(ID, Titulo, Descricao, Status, ResponsavelId, AtividadeJSON),
    append(ListaAtividadesJSON, [AtividadeJSON], Saida),
    open("./banco/atividades.json", write, Stream),
    write(Stream, Saida),
    close(Stream).

% Buscar atividade por ID no JSON
buscarAtividadePorIdJSON([], _, []).
buscarAtividadePorIdJSON([Atividade|_], Atividade.id, [Atividade]).
buscarAtividadePorIdJSON([_|T], Id, Out) :- buscarAtividadePorIdJSON(T, Id, Out).

% Buscar atividade por ID
buscarAtividadePorId(Id, Atividade) :-
    lerJSON("./banco/atividades.json", File),
    buscarAtividadePorIdJSON(File, Id, Atividade).

% Buscar atividades por status no JSON
buscarAtividadePorStatusJSON([], _, []).
buscarAtividadePorStatusJSON([Atividade|T], Status, [Atividade|Out]) :-
    Atividade.status = Status,
    buscarAtividadePorStatusJSON(T, Status, Out).
buscarAtividadePorStatusJSON([_|T], Status, Out) :-
    buscarAtividadePorStatusJSON(T, Status, Out).

% Buscar atividades por status
buscarAtividadePorStatus(Status, Atividade) :-
    lerJSON("./banco/atividades.json", File),
    buscarAtividadePorStatusJSON(File, Status, Atividade).

% Atualizar status de atividade no JSON
atualizarStatusAtividadeJSON([], _, _, []).
atualizarStatusAtividadeJSON([H|T], H.id, Status, [_{id: H.id, titulo: H.titulo, descricao: H.descricao, status: Status, responsavelId: H.responsavelId}|T]).
atualizarStatusAtividadeJSON([H|T], Id, Status, [H|Out]) :-
    atualizarStatusAtividadeJSON(T, Id, Status, Out).

% Atualizar status de atividade (Nao iniciada, Em andamento, Concluida)
atualizarStatusAtividade(Id, NovoStatus) :-
    lerJSON("./banco/atividades.json", File),
    atualizarStatusAtividadeJSON(File, Id, NovoStatus, SaidaParcial),
    atividadesToJSON(SaidaParcial, Saida),
    open("./banco/atividades.json", write, Stream), write(Stream, Saida), close(Stream).

% Atualizar responsavel pela atividade no JSON
atualizarResponsavelIdAtividadeJSON([], _, _, []).
atualizarResponsavelIdAtividadeJSON([H|T], H.id, ResponsavelId, [_{id: H.id, titulo: H.titulo, descricao: H.descricao, status: H.status, responsavelId: ResponsavelId}|T]).
atualizarResponsavelIdAtividadeJSON([H|T], Id, ResponsavelId, [H|Out]) :-
    atualizarResponsavelIdAtividadeJSON(T, Id, ResponsavelId, Out).

% Atualizar responsavel pela atividade
atualizarResponsavelIdAtividade(Id, NovoResponsavelId) :-
    lerJSON("./banco/atividades.json", File),
    atualizarResponsavelIdAtividadeJSON(File, Id, NovoResponsavelId, SaidaParcial),
    atividadesToJSON(SaidaParcial, Saida),
    open("./banco/atividades.json", write, Stream), write(Stream, Saida), close(Stream).

% Remover atividade no JSON
removerAtividadeJSON([], _, []).
removerAtividadeJSON([H|T], H.id, T).
removerAtividadeJSON([H|T], Id, [H|Out]) :- removerAtividadeJSON(T, Id, Out).

% Remover atividade
removerAtividade(Id) :-
    lerJSON("./banco/atividades.json", File),
    removerAtividadeJSON(File, Id, SaidaParcial),
    atividadesToJSON(SaidaParcial, Saida),
    open("./banco/atividades.json", write, Stream), write(Stream, Saida), close(Stream).
