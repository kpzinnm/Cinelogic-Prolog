:- module(MenuCompraFilmes, [startMenuCompraFilmes/0]).

:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Servicos/Filmes/FilmesController.pl').

startMenuCompraFilmes :-
    updateFilmesMenu,
    printMatrix('./Interfaces/Compras/Filmes/MenuCompraFilmes.txt').