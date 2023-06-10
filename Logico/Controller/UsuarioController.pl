:- module(usuarioController, [exibirUsuario/1, exibirUsuarios/0, salvarUsuario/3, removerUsuario/1,
                                buscarUsuarioPorEmail/2, buscarUsuarioPorId/2]).

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
    lerJSON("./banco/usuarios.json", File),
    usuariosToJSON(File, ListaUsuariosJSON),
    ultimo_elemento(File, Ultimo),
    (Ultimo = null -> Id = 1 ; Id is Ultimo.id + 1),
    usuarioToJSON(Id, Nome, Email, Senha, UsuarioJSON),
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
buscarUsuarioPorIdJSON([], _, []).
buscarUsuarioPorIdJSON([Usuario|_], Usuario.id, [Usuario]).
buscarUsuarioPorIdJSON([_|T], Id, Out) :- buscarUsuarioPorIdJSON(T, Id, Out).

% Busca um usuário por ID
buscarUsuarioPorId(Id, Usuario) :-
    lerJSON("./banco/usuarios.json", File),
    buscarUsuarioPorIdJSON(File, Id, Usuario).

% Busca um usuario pelo email no JSON
buscarUsuarioPorEmailJSON([], _, null).
buscarUsuarioPorEmailJSON([H|_], H.email, H).
buscarUsuarioPorEmailJSON([_|T], Email, Out) :- buscarUsuarioPorEmailJSON(T, Email, Out).

% Busca um usuario pelo email
buscarUsuarioPorEmail(Email, Usuario) :-
    lerJSON("./banco/usuarios.json", File),
    buscarUsuarioPorEmailJSON(File, Email, Usuario).
