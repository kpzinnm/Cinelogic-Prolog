:- module(FilmeModel, [createFilme/5]).


createFilme(Ident, Name, Duracao, Genero, Filme) :-
    Filme = filme(Ident, Name, Duracao, Genero).