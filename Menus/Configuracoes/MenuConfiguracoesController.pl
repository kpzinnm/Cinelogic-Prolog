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
:- use_module('./Menus/Relatorios/MenuRelatorioController.pl').
:- use_module('./Servicos/Administrador/AdministradorController.pl').
:- use_module('./Modelos/Administrador/AdministradorModel.pl').
:- use_module('./Servicos/Compras/ValorIngressoController.pl').


startMenuConfiguracoes :-
    printMatrix('./Interfaces/Configuracoes/menuConfiguracoesAdmin.txt'),
    write("Digite uma opção: "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    char_code(_, 1),
    optionsStartMenu(UserChoice).


optionsStartMenu(UserChoice) :-
    (UserChoice == "V" ; UserChoice ==  "v") -> startMenu ;  
    (UserChoice == "R" ; UserChoice ==  "r") -> menuRelatorio ; 
    (UserChoice == "F" ; UserChoice ==  "f") -> adicionarFilme ; 
    (UserChoice == "S" ; UserChoice ==  "s") -> adicionarSessao ;
    (UserChoice == "I" ; UserChoice ==  "i") -> atualizaValorIngresso ;
    (UserChoice == "A" ; UserChoice == "a") -> adicionarAdministrador;

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
    printMatrix("./Interfaces/Configuracoes/MenuCadastroSessao.txt"),
    write("Digite o Identificador do filme:"),
    flush_output,
    read_line_to_string(user_input, IdFilme),
    isFilmeValido(IdFilme, Bool),
    (Bool ->
        write("Digite a hora: "),
        read_line_to_string(user_input, Hora),
        write("Digite os minutos: "),
        read_line_to_string(user_input, Minutos),

        horaToList(Hora, Minutos, Lista),

        (isHorarioValido(Hora, Minutos) ->
            write("Informe a capacidade: "),
            read_line_to_string(user_input, Capacidade),
            write("Informe o ID da sala: "),
            read_line_to_string(user_input, IdSala),

            createSessao("0", IdFilme, Lista, Capacidade, IdSala, Sessao),
            saveSessao(Sessao),
            startMenuConfiguracoes;

            write("Horário inválido!"),
            flush_output,
            sleep(1),
            startMenuConfiguracoes
            )
    ).
   

adicionarAdministrador :-
    printMatrix("./Interfaces/Configuracoes/menuConfiguracoesLogin.txt"),
    write("Digite o login: "),
    flush_output,
    read_line_to_string(user_input, UserLogin),
    write("Digite a senha: "),
    flush_output,
    read_line_to_string(user_input, UserPassword),
    getValorIngressoJSON(Valor),
    createAdministrador(Valor, UserLogin, UserPassword, Administrador),
    saveAdministrador(Administrador),
    starMenuConfiguracoes.

adicionarProdutoBomboniere :-
    printMatrix("./Interfaces/Configuracoes/menuCadastroBomboniere.txt"),
    write("Digite o título do produto: "),
    read_line_to_string(user_input, Name),
    write("Digite o preço do produto: "),
    read_line_to_string(user_input, Preco),
    createProduto("0", Name, Preco, Produto),
    saveProduto(Produto),
    startMenuConfiguracoes.

horaToList(Hora, Minutos, Lista) :-
    atom_number(Hora, HoraNumber),
    atom_number(Minutos, MinutosNumber),
    Lista = [HoraNumber, MinutosNumber].

isHorarioValido(Hora, Minutos) :-
    atom_number(Hora, HoraN),
    atom_number(Minutos, MinutosN),
    HoraN >= 0,
    HoraN =< 23,
    MinutosN >= 0,
    MinutosN =< 60.

atualizaValorIngresso :-
    printMatrix("./Interfaces/Configuracoes/MenuAtualizaValorIngresso.txt"),
    write("Digite o valor do ingresso: "),
    flush_output,
    read_line_to_string(user_input, Valor),
    saveValorIngresso(Valor),
    write("Valor Atualizado"),
    flush_output,
    sleep(1.2),
    starMenuConfiguracoes.
