:- module(MenuCompraFilmes, [startMenuCompraFilmes/0]).

:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Servicos/Filmes/FilmesController.pl').
:- use_module('./Modelos/Compra/CompraModel.pl').
:- use_module('./Servicos/Compras/ComprasController.pl').
:- use_module('./Utils/UpdateUtils.pl').
:- use_module(library(time)).
:- use_module('./Servicos/Compras/ValorIngressoController.pl').



startMenuCompraFilmes :-
    updateFilmesMenu,
    printMatrix('./Interfaces/Compras/Filmes/MenuCompraFilmes.txt'),
    write("Digite uma opção: "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    char_code(_, 1),
    optionsMenu(UserChoice).

optionsMenu(UserChoice) :-
    (UserChoice == "C" ; UserChoice ==  "c") -> getEmailComprador ;   
    (UserChoice == "V" ; UserChoice ==  "v") -> startMenu ;
    writeln("\nOpção Inválida!"),
    sleep(0.7),
    startMenuCompraFilmes.

getEmailComprador :-
    write("Antes de fazer a compra, por favor informe o seu email: "),
    flush_output,
    read_line_to_string(user_input, EmailComprador), 
    char_code(_, 1),
    startCompra(EmailComprador).

startCompra(EmailComprador) :-
    write("Por favor, insira o número do Filme: "),       
    flush_output,
    read_line_to_string(user_input, Ident),
    char_code(_, 1),
    isFilmeValido(Ident, Bool),
    (Bool ->
        write('Por favor, insira o número de ingressos: '),
        flush_output,
        read_line_to_string(user_input, NumeroIngressosString),
        atom_number(NumeroIngressosString, NumeroIngressos),
        getValorIngressoJSON(ValorUnitario),
        ValorCompra is ValorUnitario * NumeroIngressos,
        createCompra(0, EmailComprador, NumeroIngressos, ValorCompra, Ident, Compra),
        loadfinalizaCompraMenu(Compra)
        ;
        write("Filme inválido!"),
        flush_output,
        sleep(1.0),
        startMenuCompraFilmes
    ).

/*Funções do menu de finalização de compra*/

loadfinalizaCompraMenu(Compra):-
    updateFinalizacaoMenu(Compra),
    printMatrix('./Interfaces/Compras/MenuFinalizacaoCompra.txt'),
    write("Por favor, escolha uma opção: "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    char_code(_, 1),
    optionsFinalizacaoMenu(UserChoice, Compra).

updateFinalizacaoMenu(Compra) :-
    Compra = compra(_,EmailCliente,NumeroIngressos,ValorCompra, FilmeIdent),
    FilePath = "./Interfaces/Compras/MenuFinalizacaoCompra.txt",
    resetMenu(FilePath, "./Interfaces/Compras/MenuFinalizacaoCompraBase.txt"),
    concat_atom(["* Email Comprador:", EmailCliente], ' ', EmailFull),
    concat_atom(["* Número Ingressos Comprados: ", NumeroIngressos], ' ', NumeroFull),
    concat_atom(["* Valor da Compra: ", ValorCompra], ' ', ValorFull),
    writeMatrixValue(FilePath, EmailFull, 12, 24),
    writeMatrixValue(FilePath, NumeroFull, 15, 24),
    writeMatrixValue(FilePath, ValorFull, 18, 24).

optionsFinalizacaoMenu(UserChoice, Compra) :-
    (UserChoice == "F" ; UserChoice ==  "f") -> finalizaCompra(Compra) ;  
    (UserChoice == "C" ; UserChoice ==  "c") -> startMenuCompraFilmes ; 
    writeln("\nOpção Inválida!"),
    sleep(0.7),
    startMenu.

finalizaCompra(Compra):-
    saveCompra(Compra),
    startMenuCompraFilmes.