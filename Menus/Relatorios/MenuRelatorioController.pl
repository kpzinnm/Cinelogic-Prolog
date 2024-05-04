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


optionsRelarotiotMenu(UserChoice) :-
    (UserChoice == "V" ; UserChoice ==  "v") -> starMenuConfiguracoes ;
    writeln("\nOpção Inválida!"),
    sleep(0.7),
    menuRelatorio.