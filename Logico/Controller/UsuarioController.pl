:- use_module(library(http/json)).

% Fato dinâmico para criar os IDs dos Usuarios
id(1).
incrementa_id :- retract(id(X)), Y is X + 1, assert(id(Y)).
:- dynamic id/1.

% Leitura dos arquivos de JSON
lerJSON(FilePath, File) :-
	open(FilePath, read, F),
	json_read_dict(F, File).

% Formata a linha que será adicionada no arquivo JSON
usuarioToJSON(Id, Nome, Email, Senha, UsuarioJSON) :-
    swritef(UsuarioJSON, '{"id": %w, "nome": "%w", "email": "%w", "senha": "%w"}',
            [Id, Nome, Email, Senha]).

% Exibir um usuario
exibirUsuario([]).
exibirusuario([H|_]) :-
    write("ID: "), writeln(H.id),
    write("Nome: "), writeln(H.nome),
    write("Email: "), writeln(H.email).

exibirUsuarios() :-
    lerJSON("./banco/usuarios.json", Usuarios),
    exibirUsuario(Usuarios).

% Gera uma lista de usuários
usuariosToJSON([], []).
usuariosToJSON([H|T], [X|Out]) :-
    usuarioToJSON(H.id, H.nome, H.email, H.senha, X),
    usuariosToJSON(T, Out).

% Salva um usuário
salvarUsuario(Nome, Email, Senha) :-
    id(ID), incrementa_id,
    lerJSON("./banco/usuarios.json", File),
    usuariosToJSON(File, ListaUsuariosJSON),
    usuarioToJSON(ID, Nome, Email, Senha, UsuarioJSON),
    append(ListaUsuariosJSON, [UsuarioJSON], Saida),
    open("./banco/usuarios.json", write, Stream),
    write(Stream, Saida),
    close(Stream).

% Remove um usuário do JSON
removerUsuarioJSON([], _, []).
removerUsuarioJSON([H|T], H.id, T).
removerUsuarioJSON([H|T], Id, [H|Out]) :- removerUsuarioJSON(T, Id, Out).

% Remove um usuário
removerUsuario(Id) :-
    lerJSON("./banco/usuarios.json", File),
    removerUsuarioJSON(File, Id, SaidaParcial),
    usuariosToJSON(SaidaParcial, Saida),
    open("./banco/usuarios.json", write, Stream), write(Stream, Saida), close(Stream).

% Busca um usuario por ID no JSON
buscarUsuarioPorIdJSON([], _, null).
buscarUsuarioPorIdJSON([Usuario|_], Usuario.id, Usuario).
buscarUsuarioPorIdJSON([_|T], Id, [_|Out]) :- buscarUsuarioPorIdJSON(T, Id, Out).

% Busca um usuário por ID
buscarUsuarioPorId(Id, Usuario) :-
    lerJSON("./banco/usuarios.json", File),
    buscarUsuarioPorIdJSON(File, Id, Usuario).

% Busca um usuario pelo email no JSON
buscarUsuarioPorEmailJSON([], _, []).
buscarUsuarioPorEmailJSON([H|_], H.email, H).
buscarUsuarioPorEmailJSON([_|T], Email, Out) :- buscarUsuarioPorEmailJSON(T, Email, Out).

% Busca um usuario pelo email
buscarUsuarioPorEmail(Email, Usuario) :-
    lerJSON("./banco/usuarios.json", File),
    buscarUsuarioPorEmailJSON(File, Email, Usuario).
