:- module(SessoesModel, [createSessao/6]).

createSessao(Ident, Horario, Capacidade, SalaIdent, FilmeIdent, Sessao) :-
    Sessao = sessao(Ident, Horario, Capacidade, SalaIdent, FilmeIdent).