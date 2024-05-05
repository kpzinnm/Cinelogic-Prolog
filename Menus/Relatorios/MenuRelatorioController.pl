:- module(MenuRelatorioController, [menuRelatorio/0]).

:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Menus/Configuracoes/MenuConfiguracoesController.pl').
:- use_module('./Servicos/Relatorios/RelatorioController.pl').


menuRelatorio :- 
    updateRelatorioMenu,
    printMatrix("./Interfaces/Configuracoes/Relatorio/menuRelatorios.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    char_code(_, 1),
    optionsRelarotiotMenu(UserChoice).


menuGraficoRelatorio :-
    updateGraficoMenu,
    printMatrix("./Interfaces/Configuracoes/Relatorio/menuGrafico.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    char_code(_, 1),
    optionsGraficoMenu(UserChoice).

optionsGraficoMenu(UserChoice) :-
    (UserChoice == "V" ; UserChoice ==  "v") -> menuRelatorio ;
    writeln("\nOpção Inválida!"),
    sleep(0.7),
    menuGraficoRelatorio.



optionsRelarotiotMenu(UserChoice) :-
    (UserChoice == "V" ; UserChoice ==  "v") -> startMenuConfiguracoes ;
    (UserChoice == "G" ; UserChoice ==  "g") -> menuGraficoRelatorio ;
    writeln("\nOpção Inválida!"),
    sleep(0.7),
    menuRelatorio.