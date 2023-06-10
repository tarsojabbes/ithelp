:- initialization(main).

:- use_module("./Rules/AnalistaRules.pl").
:- use_module("./Rules/GestorRules.pl").
:- use_module("./Rules/UsuarioRules.pl").
:- use_module("./Controller/AnalistaController.pl").
:- use_module("./Controller/GestorController.pl").
:- use_module("./Controller/UsuarioController.pl").

exibeMenuLogin :-
    writeln("Com qual perfil de acesso você deseja utilizar o sistema?"),
    writeln("[G]estor"),
    writeln("[A]nalista"),
    writeln("[U]suário").

loginAnalista :-
    writeln("Informe o seu email:"),
    read(Email),
    writeln("Informe a sua senha:"),
    read(Senha),
    analistaController:buscarAnalistaPorEmail(Email, Analista),
    (Analista = null -> 
        writeln("Analista não encontrado"),
        main
    ; (Analista.senha = Senha -> 
         write("Seja bem vindo, "), writeln(Analista.nome), 
         analistaRules:mainMenuAnalista(Analista.id),
         main
        ;   writeln("Senha incorreta"),
            main
    )).

loginGestor :-
    writeln("Informe o seu email:"),
    read(Email),
    writeln("Informe a sua senha:"),
    read(Senha),
    gestorController:buscarGestorPorEmail(Email, Gestor),
    (Gestor = null ->
        writeln("Gestor não encontrado"),
        main
    ; (Gestor.senha = Senha -> 
        write("Seja bem vindo, "), writeln(Gestor.nome),
        gestorRules:mainMenuGestor,
        main
        ;   writeln("Senha incorreta"),
            main
    )).

loginUsuario :-
    writeln("Informe o seu email:"),
    read(Email),
    writeln("Informe a sua senha:"),
    read(Senha),
    usuarioController:buscarUsuarioPorEmail(Email, Usuario),
    (Usuario = null ->
        writeln("Usuário não encontrado"),
        main
    ; (Usuario.senha = Senha ->
        write("Seja bem vindo, "), writeln(Usuario.nome),
        usuarioRules:mainMenuUsuario(Usuario.id),
        main
        ;   writeln("Senha incorreta"),
            main
    )).

main :-
    exibeMenuLogin,
    read(PerfilAtom),
    atom_chars(PerfilAtom, [Perfil]),
    (Perfil = 'A' -> loginAnalista ;
    (Perfil = 'G' -> loginGestor) ;
    (Perfil = 'U' -> loginUsuario) ;
    (writeln("Opção inválida"),
    main)).
