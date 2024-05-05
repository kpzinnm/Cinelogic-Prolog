:- module(BomboniereController, [saveProduto/1, isProdutoValido/2 , updateProdutosMenu/0, deleteProduto/1, getProdutoPreco/2]).

:- use_module('./Utils/JsonUtils.pl').
:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Utils/UpdateUtils.pl').
:- use_module(library(http/json)).

/*Funções de save produtos*/
saveProduto(Produto) :- 
    getProdutosJSON(ListaProdutos),
    length(ListaProdutos, Tamanho),
    Produto = produto(Ident, Name, Preco),
    lerJSON("./BancoDeDados/Bomboniere/Bomboniere.json", File),
    produtosToJSON(File, ListaProdutosJSON),
    NextTamanho is Tamanho + 1,
    produtoToJSON(NextTamanho, Name, Preco, ProdutoJSON),
    append(ListaProdutosJSON, [ProdutoJSON], Saida),
    open("./BancoDeDados/Bomboniere/Bomboniere.json", write, Stream), write(Stream, Saida), close(Stream).

produtoToJSON(Ident, Name, Preco, Out) :-
	swritef(Out, '{"ident": %w, "name": "%w", "preco": %w}', [Ident, Name, Preco]).

produtosToJSON([], []).
produtosToJSON([H|T], [X|Out]) :- 
	produtoToJSON(H.ident, H.name, H.preco, X), 
	produtosToJSON(T, Out).

/*Funções de get produtos*/
getProdutosJSON(Out) :-
	lerJSON("./BancoDeDados/Bomboniere/Bomboniere.json", Produtos),
	exibirProdutosAux(Produtos , Result),
    Out = Result.

exibirProdutosAux([], []).
exibirProdutosAux([H|T], [produto(H.ident, H.name, H.preco)|Rest]) :- 
    exibirProdutosAux(T, Rest).

getProduto(Int, Produto) :- 
    getProdutosJSON(Out), 
    buscarProdutoPorId(Int, Out, Produto).

buscarProdutoPorId(_, [], _) :- fail.
buscarProdutoPorId(Ident, [produto(Ident, Name, Preco)|_], produto(Ident, Name, Preco)).
buscarProdutoPorId(Ident, [_|Resto], ProdutoEncontrado) :-
    buscarProdutoPorId(Ident, Resto, ProdutoEncontrado).

getProdutoIdent(Produto, Ident) :- 
    Produto = produto(Ident, _, _).

getProdutoName(ID, Name) :- 
    getProduto(ID, Produto),
    Produto = produto(_, Name, _).

getProdutoPreco(ID, Preco) :- 
    getProduto(ID, Produto),
    Produto = produto(_, _, Preco).

/*Exibição de produtos*/

updateProdutosMenu :-
    FilePath = "./Interfaces/Compras/Bomboniere/MenuCompraBomboniere.txt",
    resetMenu(FilePath, "./Interfaces/Compras/Bomboniere/MenuCompraBomboniereBase.txt"),
    getProdutosJSON(Produtos),
    updateAllProdutos(FilePath, Produtos).

updateAllProdutos(_, []) :- !.
updateAllProdutos(FilePath, [H|T]) :-
    getProdutoIdent(H, Ident),
    write(Ident),
    updateProdutosName(FilePath, Ident),
    updateProdutosPreco(FilePath, Ident),
    updateAllProdutos(FilePath,T).

updateProdutosName(FilePath, Ident) :-
    getProdutoName(Ident, Name),
    concat_atom(["(", Ident, ") ", Name], '', FullName),
    getColRow(Ident, Row, Col),
    writeMatrixValue(FilePath, FullName, Row, Col).

updateProdutosPreco(FilePath, Ident) :-
    getProdutoPreco(Ident, Preco),
    concat_atom(['Preco:', Preco], ' ', FullPreco),
    getColRow(Ident, Row, Col),
    NextRow is Row + 1,
    writeMatrixValue(FilePath, FullPreco, NextRow, Col).

deleteProduto(Ident) :-
    lerJSON("./BancoDeDados/Bomboniere/Bomboniere.json", File),
    getProdutosJSON(ListaProdutos),
    deleteProdutoAux(Ident, ListaProdutos, NovosProdutos),
    produtosToJSON(NovosProdutos, ListaProdutosJSON),
    open("./BancoDeDados/Bomboniere/Bomboniere.json", write, Stream),
    write(Stream, ListaProdutosJSON),
    close(Stream).

deleteProdutoAux(_, [], []).
deleteProdutoAux(Ident, [produto(Ident, _, _) | Resto], NovosProdutos) :-
    deleteProdutoAux(Ident, Resto, NovosProdutos).
deleteProdutoAux(Ident, [Produto | Resto], [Produto | NovosProdutos]) :-
    deleteProdutoAux(Ident, Resto, NovosProdutos).


getColRow(1, 12, 3).
getColRow(2, 17, 3).
getColRow(3, 22, 3).
getColRow(4, 27, 3).
getColRow(5, 32, 3).

isProdutoValido(Ident, Bool) :-
    getProdutosJSON(ProdutosJson),
    atom_number(Ident, IdentInt),
    isProdutoValidoAuxiliar(IdentInt, ProdutosJson, Bool).

isProdutoValidoAuxiliar(_, [], false).
isProdutoValidoAuxiliar(Ident, [produto(Ident, Name, Preco)|_], true).
isProdutoValidoAuxiliar(Ident, [_|Resto], Bool) :-
    isProdutoValidoAuxiliar(Ident, Resto, Bool).