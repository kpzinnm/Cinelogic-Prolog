:- module(FilmesController, [saveFilme/1]).

:- use_module('./Utils/JsonUtils.pl').
:- use_module(library(http/json)).

saveFilme(Filme) :- 
    Filme = filme(Ident, Name, Duracao, Genero),
    lerJSON("./BancoDeDados/Filmes/Filme.json", File),
    filmesToJSON(File, ListaFilmesJSON),
    filmeToJSON(Ident, Name, Duracao, Genero, FilmeJSON),
    append(ListaFilmesJSON, [FilmeJSON], Saida),
    open("./BancoDeDados/Filmes/Filme.json", write, Stream), write(Stream, Saida), close(Stream).

filmeToJSON(Ident, Name, Duracao, Genero, Out) :-
	swritef(Out, '{"ident": %w, "name": "%w", "duracao": "%w", "genero": "%w"}', [Ident, Name, Duracao, Genero]).

filmesToJSON([], []).
filmesToJSON([H|T], [X|Out]) :- 
	filmeToJSON(H.ident, H.name, H.duracao, H.genero, X), 
	filmesToJSON(T, Out).
