:- module(MenuCompraBomboniere, startMenuCompraBomboniere/0]).

:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Servicos/Bomboniere/BomboniereController.pl').

startMenuCompraFilmes :-
    updateBomboniereMenu,
    printMatrix('./Interfaces/Compras/Bomboniere/MenuCompraBomboniere.txt'),
    write("Digite uma opção: "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    char_code(_, 1),
    optionsMenu(UserChoice).

optionsMenu(UserChoice) :-
    (UserChoice == "C" ; UserChoice ==  "c") -> write("Comprar Produto") ;
    (UserChoice == "V" ; UserChoice ==  "v") -> startMenu ;
    writeln("\nOpção Inválida!"),
    sleep(0.7),
    startMenuCompraBomboniere.
