:- module(MenuCompraBomboniere, [startMenuCompraBomboniere/0]).

:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Servicos/Bomboniere/BomboniereController.pl').
:- use_module('./Modelos/Compra/CompraBomboniereModel.pl').
:- use_module('./Servicos/Compras/ComprasBomboniereController.pl').
:- use_module('./Utils/UpdateUtils.pl').
:- use_module(library(time)).


startMenuCompraBomboniere :-
    updateProdutosMenu,
    printMatrix('./Interfaces/Compras/Bomboniere/MenuCompraBomboniere.txt'),
    write("Digite uma opção: "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    char_code(_, 1),
    optionsMenu(UserChoice).

optionsMenu(UserChoice) :-
    (UserChoice == "C" ; UserChoice ==  "c") -> startCompra ;   
    (UserChoice == "V" ; UserChoice ==  "v") -> startMenu ;
    writeln("\nOpção Inválida!"),
    sleep(0.7),
    startMenuCompraBomboniere.

startCompra :-
    write("Por favor, insira o número do Produto: "),       
    flush_output,
    read_line_to_string(user_input, Ident),
    char_code(_, 1),
    atom_number(Ident, IdentNumber),
    isProdutoValido(Ident, Bool),
    (Bool ->
        write("Por favor, insira a quantidade de produtos: "),
        flush_output,
        read_line_to_string(user_input, QuantidadeProdutosString),
        atom_number(QuantidadeProdutosString, QuantidadeProdutos),
        getProdutoPreco(IdentNumber, Preco),
        PrecoTotal is Preco * QuantidadeProdutos,
        number_to_atom(PrecoTotal, PrecoTotalString),   
        createCompra(0, QuantidadeProdutosString, PrecoTotalString, Ident, Compra),
        loadfinalizaCompraMenu(Compra)
        ;
        write("Produto inválido!"),
        flush_output,
        sleep(1.0),
        startMenuCompraBomboniere
    ).

/*Funções do menu de finalização de compra*/

loadfinalizaCompraMenu(Compra):-
    updateFinalizacaoMenu(Compra),
    printMatrix('./Interfaces/Compras/MenuFinalizacaoCompraProduto.txt'),
    write("Por favor, escolha uma opção: "),
    flush_output,
    read_line_to_string(user_input, UserChoice),
    char_code(_, 1),
    optionsFinalizacaoMenu(UserChoice, Compra).

updateFinalizacaoMenu(Compra) :-
    Compra = compra(_,QuantidadeProdutos, ValorCompra, ProdutoIdent),
    FilePath = "./Interfaces/Compras/MenuFinalizacaoCompraProduto.txt",
    resetMenu(FilePath, "./Interfaces/Compras/MenuFinalizacaoCompraProdutoBase.txt"),
    concat_atom(["* Quantidade de produtos Comprados: ", QuantidadeProdutos], ' ', NumeroFull),
    concat_atom(["* Valor da Compra: ", ValorCompra], ' ', ValorFull),
    writeMatrixValue(FilePath, NumeroFull, 15, 24),
    writeMatrixValue(FilePath, ValorFull, 18, 24).

optionsFinalizacaoMenu(UserChoice, Compra) :-
    (UserChoice == "F" ; UserChoice ==  "f") -> finalizaCompra(Compra) ;  
    (UserChoice == "C" ; UserChoice ==  "c") -> startMenuCompraBomboniere ; 
    writeln("\nOpção Inválida!"),
    sleep(0.7),
    startMenu.

finalizaCompra(Compra):-
    saveCompra(Compra),
    startMenuCompraBomboniere.

number_to_atom(Number, Atom) :-
    number_codes(Number, Codes),
    atom_codes(Atom, Codes).