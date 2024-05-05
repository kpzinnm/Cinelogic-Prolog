:- module(SessaoModel, [createSessao/6]).


createSessao(Ident, IdFilme, Horario, Capacidade, IdSala, Sessao) :-
    Sessao = sessao(Ident, IdFilme, Horario, Capacidade, IdSala).
