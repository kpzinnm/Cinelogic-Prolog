:- module(MenuPrincipalController, [startMenu/0]).

:- use_module('./Main.pl').

startMenu :-
    write("Digite uma opção: "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    char_code(_, 1),
    write(UserChoice).