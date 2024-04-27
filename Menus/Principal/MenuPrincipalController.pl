:- module(MenuPrincipalController, [startMenu/0]).

:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Menus/Compras/MenuCompraFilmes.pl').
:- use_module('./Menus/Configuracoes/MenuConfiguracoesController.pl').
:- use_module('./Menus/Configuracoes/MenuLoginAdministradorController.pl').

startMenu :-
    printMatrix('./Interfaces/Principal/MenuPrincipal.txt'),
    write("Digite uma opção: "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    char_code(_, 1),
    optionsStartMenu(UserChoice).

optionsStartMenu(UserChoice) :-
    (UserChoice == "I" ; UserChoice ==  "i") -> startMenuCompraFilmes ;   
    (UserChoice == "R" ; UserChoice ==  "r") -> write(UserChoice) ;
    (UserChoice == "A" ; UserChoice ==  "a") -> startLoginAdministrador ;
    (UserChoice == "S" ; UserChoice ==  "s") -> halt ;
    writeln("\nOpção Inválida!"),
    sleep(0.7),
    startMenu.