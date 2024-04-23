:- module(MenuCompraFilmes, [startMenuCompraFilmes/0]).

:- use_module('./Utils/MatrixUtils.pl').

startMenuCompraFilmes :-
    printMatrix('./Interfaces/Compras/Filmes/MenuCompraFilmes.txt').