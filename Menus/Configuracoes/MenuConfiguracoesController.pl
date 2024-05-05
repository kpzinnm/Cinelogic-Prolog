:- module(MenuConfiguracoesController, [startMenuConfiguracoes/0]).

:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Modelos/Filmes/FilmeModel.pl').
:- use_module('./Servicos/Filmes/FilmesController.pl').
:- use_module('./Servicos/Administrador/AdministradorController.pl').
:- use_module('./Modelos/Administrador/AdministradorModel.pl').
:- use_module('./Modelos/Sessoes/SessoesModel.pl').
:- use_module('./Servicos/Sessoes/SessoesController.pl').

startMenuConfiguracoes :-
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
    (UserChoice == "A" ; UserChoice == "a") -> adicionarAdministrador ;
    writeln("\nOpção Inválida!"),
    sleep(0.7),
    startMenuConfiguracoes.

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
    startMenuConfiguracoes.

adicionarSessao :-
    printMatrix("./Interfaces/Configuracoes/ManuCadastroSessao.txt"),
    write("Digite o Identificador do filme:"),
    flush_output,
    read_line_to_string(user_input, IdFilme),
    isFilmeValido(IdFilme, Bool),
    (Bool ->
        write("Digite o horario no formato (<hora>, <minutos>): "),
        flush_output,
        read_line_to_string(user_input, Horario),
        %Horario = (Hora, Minutos),
        write("Informa a capacidade: "),
        flush_output,
        read_line_to_string(user_input, Capacidade),
        write("Informe o ID da sala: "),
        flush_output,
        read_line_to_string(user_input, IdSala),
        createSessao(0, Horario, Capacidade, IdSala, IdFilme, Sessao),
        saveSessao(Sessao)
        ;
        write("Filme não registrado"),
        flush_output,
        sleep(1.2),
        startMenuConfiguracoes
    ).

    
adicionarAdministrador :-
    printMatrix("./Interfaces/Configuracoes/menuConfiguracoesLogin.txt"),
    write("Digite o login: "),
    flush_output,
    read_line_to_string(user_input, UserLogin),
    write("Digite a senha: "),
    flush_output,
    read_line_to_string(user_input, UserPassword),
    createAdministrador(0, UserLogin, UserPassword, Administrador),
    saveAdministrador(Administrador),
    startMenuConfiguracoes.

