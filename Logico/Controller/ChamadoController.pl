:- module(chamadoController, [exibirChamado/1, exibirChamados/0, salvarChamado/5, removerChamado/3,
                                atualizarResponsavelIdChamado/2, buscarChamadoPorId/2, buscarChamadoPorCriador/2,
                                buscarChamadoPorAnalista/2, buscarChamadoPorStatus/2])

:- use_module(library(http/json)).

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
    lerJSON("./banco/chamados.json", File),
    chamadosToJSON(File, ListaChamadosJSON),
    length(ListaChamadosJSON, Tamanho),
    Id is Tamanho + 1,
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
atualizarStatusChamadoJSON([H|T], H.id, Status, [_{id: H.id, titulo: H.titulo, descricao: H.descricao, status: Status, responsavelId: H.responsavelId}|T]).
atualizarStatusChamadoJSON([H|T], Id, Status, [H|Out]) :-
    atualizarStatusChamadoJSON(T, Id, Status, Out).

% Atualizar status de chamado (Nao iniciado, Em andamento, Concluido)
atualizarStatusChamado(Id, NovoStatus) :-
    lerJSON("./banco/Chamados.json", File),
    atualizarStatusChamadoJSON(File, Id, NovoStatus, SaidaParcial),
    chamadosToJSON(SaidaParcial, Saida),
    open("./banco/chamados.json", write, Stream), write(Stream, Saida), close(Stream).

% Atualizar responsavel pelo chamado no JSON
atualizarResponsavelIdChamadoJSON([], _, _, []).
atualizarResponsavelIdChamadoJSON([H|T], H.id, ResponsavelId, [_{id: H.id, titulo: H.titulo, descricao: H.descricao, status: H.status, responsavelId: ResponsavelId}|T]).
atualizarResponsavelIdChamadoJSON([H|T], Id, ResponsavelId, [H|Out]) :-
    atualizarResponsavelIdChamadoJSON(T, Id, ResponsavelId, Out).

% Atualizar responsavel pelo chamado
atualizarResponsavelIdChamado(Id, NovoResponsavelId) :-
    lerJSON("./banco/Chamados.json", File),
    atualizarResponsavelIdchamadoJSON(File, Id, NovoResponsavelId, SaidaParcial),
    chamadosToJSON(SaidaParcial, Saida),
    open("./banco/chamados.json", write, Stream), write(Stream, Saida), close(Stream).

/*

FALTANDO
- Calcular as estatísticas dos chamados

*/