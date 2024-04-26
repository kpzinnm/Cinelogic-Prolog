:- module(MenuConfiguracoesController, [starMenuConfiguracoes/0]).

:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Modelos/Filmes/FilmeModel.pl').
:- use_module('./Servicos/Filmes/FilmesController.pl').


starMenuConfiguracoes :-
    printMatrix('./Interfaces/Configuracoes/menuConfiguracoesAdmin.txt'),
    write("Digite uma opção: "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    char_code(_, 1),
    optionsStartMenu(UserChoice).


optionsStartMenu(UserChoice) :-
    (UserChoice == "V" ; UserChoice ==  "v") -> startMenu ;  
    (UserChoice == "F" ; UserChoice ==  "f") -> adicionarFilme ; 
    writeln("\nOpção Inválida!"),
    sleep(0.7),
    startMenu.

adicionarFilme :- 
    printMatrix("./Interfaces/Configuracoes/MenuCadastroDeFilmes.txt"),
    write("Digite o título do filmes: "),
    read_line_to_string(user_input, Titulo),
    write("Digite duração do filme: "),
    read_line_to_string(user_input, Duracao),
    write("Digite o genero do filme:"),
    read_line_to_string(user_input, Genero),
    createFilme("0", Titulo, Duracao, Genero, Filme),
    saveFilme(Filme),
    starMenuConfiguracoes.


