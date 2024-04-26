:- module(FilmesController, [saveFilme/1, updateFilmesMenu/0]).

:- use_module('./Utils/JsonUtils.pl').
:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Utils/UpdateUtils.pl').
:- use_module(library(http/json)).

/*Funções de save filmes*/
saveFilme(Filme) :- 
    Filme = filme(Ident, Name, Duracao, Genero),
    lerJSON("./BancoDeDados/Filmes/Filme.json", File),
    getFilmesJSON(ListaFilmes),
    length(ListaFilmes, Tamanho),
    filmesToJSON(File, ListaFilmesJSON),
    filmeToJSON(Tamanho, Name, Duracao, Genero, FilmeJSON),
    append(ListaFilmesJSON, [FilmeJSON], Saida),
    open("./BancoDeDados/Filmes/Filme.json", write, Stream), write(Stream, Saida), close(Stream).

filmeToJSON(Ident, Name, Duracao, Genero, Out) :-
	swritef(Out, '{"ident": %w, "name": "%w", "duracao": "%w", "genero": "%w"}', [Ident, Name, Duracao, Genero]).

filmesToJSON([], []).
filmesToJSON([H|T], [X|Out]) :- 
	filmeToJSON(H.ident, H.name, H.duracao, H.genero, X), 
	filmesToJSON(T, Out).

/*Funções de get filmes*/
getFilmesJSON(Out) :-
	lerJSON("./BancoDeDados/Filmes/Filme.json", Filmes),
	exibirFilmesAux(Filmes , Result),
    Out = Result.

exibirFilmesAux([], []).
exibirFilmesAux([H|T], [filme(H.ident, H.name, H.duracao, H.genero)|Rest]) :- 
    exibirFilmesAux(T, Rest).

getFilme(Int, Filme) :- 
    getFilmesJSON(Out), 
    buscarFilmePorId(Int, Out, Filme).

buscarFilmePorId(_, [], _) :- fail.
buscarFilmePorId(Ident, [filme(Ident, Name, Duracao, Genero)|_], filme(Ident, Name, Duracao, Genero)).
buscarFilmePorId(Ident, [_|Resto], FilmeEncontrado) :-
    buscarFilmePorId(Ident, Resto, FilmeEncontrado).

getFilmeName(ID, Name) :- 
    getFilme(ID, Filme),
    Filme = filme(_, Name, _, _).

getFilmeIdent(Filme, Ident) :- 
    Filme = filme(Ident, _, _, _).


/*Exibição de filmes*/

updateFilmesMenu :-
    FilePath = "./Interfaces/Compras/Filmes/MenuCompraFilmes.txt",
    resetMenu(FilePath, "./Interfaces/Compras/Filmes/MenuCompraFilmesBase.txt"),
    getFilmesJSON(Filmes),
    updateAllFilmesName(FilePath, Filmes).

updateAllFilmesName(_, []) :- !.
updateAllFilmesName(FilePath, [H|T]) :-
    getFilmeIdent(H, Ident),
    write(Ident),
    updateFilmesName(FilePath, Ident),
    updateAllFilmesName(FilePath, T).

updateFilmesName(FilePath, Ident) :-
    getFilmeName(Ident, Name),
    getColRow(Ident, Row, Col),
    writeMatrixValue(FilePath, Name, Row, Col).

getColRow(1, 12, 3).
getColRow(2, 17, 3).
getColRow(3, 22, 3).
getColRow(4, 27, 3).
getColRow(5, 32, 3).
