:- module(MenuConfiguracoesController, [startMenuConfiguracoes/0]).

:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Modelos/Filmes/FilmeModel.pl').
:- use_module('./Servicos/Filmes/FilmesController.pl').
:- use_module('./Servicos/Administrador/AdministradorController.pl').
:- use_module('./Modelos/Administrador/AdministradorModel.pl').
:- use_module('./Modelos/Sessao/SessaoModel.pl').
:- use_module('./Servicos/Sessoes/SessoesController.pl').
:- use_module('./Modelos/Produtos/ProdutoModel.pl').
:- use_module('./Servicos/Bomboniere/BomboniereController.pl').


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
    (UserChoice == "A" ; UserChoice == "a") -> adicionarAdministrador;
    (UserChoice == "B" ; UserChoice ==  "b") -> adicionarProdutoBomboniere ;
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
    startMenuConfiguracoes.

adicionarSessao :-
    printMatrix("./Interfaces/Configuracoes/MenuCadastroSessao.txt"),
    write("Digite o Identificador do filme:"),
    read_line_to_string(user_input, IdFilme),
    isFilmeValido(IdFilme, Bool),
    (Bool ->
        write("Digite o horario no formato (<hora>, <minutos>): "),
        read_line_to_string(user_input, Horario),
        write("Informa a capacidade: "),
        read_line_to_string(user_input, Capacidade),
        write("Informe o ID da sala: "),
        read_line_to_string(user_input, IdSala),
        createSessao("0", IdFilme, Horario, Capacidade, IdSala),
        saveSessao(Sessao),
        startMenuConfiguracoes.
        
        ;
        write("Filme não registrado"),
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

adicionarProdutoBomboniere :-
    printMatrix("./Interfaces/Configuracoes/menuCadastroBomboniere.txt"),
    write("Digite o título do produto: "),
    read_line_to_string(user_input, Name),
    write("Digite o preço do produto: "),
    read_line_to_string(user_input, Preco),
    createProduto("0", Name, Preco, Produto),
    saveProduto(Produto),
    startMenuConfiguracoes.
