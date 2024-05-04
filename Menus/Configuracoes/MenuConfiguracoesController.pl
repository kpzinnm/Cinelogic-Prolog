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
    (UserChoice == "S" ; UserChoice ==  "s") -> adicionarSessao ;
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

adicionarSessao :-
    printMatrix("./Interfaces/Configuracoes/MenuCadastroSessoe.txt"),
    write("Digite o Identificador do filme:"),
    flush_output,
    read_line_to_string(user_input, IdFilme),
    isFilmeValido(IdFilme, Bool),
    (Bool ->
        write("Digite o horario no formato (<hora>, <minutos>): "),
        flush_output,
        read(Horario),
        write("Informa a capacidade: "),
        flush_output,
        read_line_to_string(user_input, Capacidade),
        write("Informe o ID da sala: "),
        flush_output
        
        ;
        write("Filme não registrado"),
        sleep(1.2),
        starMenuConfiguracoes
    ).

    
            
            


