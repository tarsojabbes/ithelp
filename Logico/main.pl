:- initialization(main).

:- use_module("./Controller/AnalistaController.pl").

main :-
    writeln("Teste de boas vindas."),
    writeln("Criação de um Analista"),
    write("Nome: "), read(Nome), % Sem passar os valores entre aspas, exceto se forem números
    write("Email: "), read(Email),
    write("Senha: "), read(Senha),
    analistaController:salvarAnalista(Nome, Email, Senha, 5).