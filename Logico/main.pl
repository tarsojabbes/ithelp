:- initialization(main).

:- use_module("./Rules/AnalistaRules.pl").

main :-
    analistaRules:mainMenuAnalista(3).