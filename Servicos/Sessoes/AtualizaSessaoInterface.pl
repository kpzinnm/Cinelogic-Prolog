:- use_module(library(lists)).

:- dynamic sessao_position/3. % Para manter as posições das sessões dinamicamente

% Função principal para carregar sessões do filme
loadSessoesDoFilme(IdFilme) :-
    getSessoesJSON(Sessoes),
    atualizaSessoes(Sessoes, IdFilme, 1).

% Atualiza as sessões
atualizaSessoes([], _, _).
atualizaSessoes([Sessao|T], IdDoFilme, PosicaoDaSessao) :-
    filmeDaSessao(Sessao, FilmeDaSessao),
    ident(FilmeDaSessao, IdentFilmeDaSessao),
    (   IdentFilmeDaSessao =:= IdDoFilme ->
        atualizaNomeSessao(IdDoFilme, "SESSÃO " || PosicaoDaSessao, PosicaoDaSessao),
        horario(Sessao, Horario),
        atualizaHorarioSessao(IdDoFilme, Horario, PosicaoDaSessao),
        idSala(Sessao, IdSala),
        atualizaSalaSessao(IdDoFilme, IdSala, PosicaoDaSessao)
    ;   true
    ),
    PosicaoSeguinte is PosicaoDaSessao + 1,
    atualizaSessoes(T, IdDoFilme, PosicaoSeguinte).

% Converte horário para string
horarioToString(Hora, Minuto, HorarioString) :-
    atom_concat(Hora, ":", HoraString),
    atom_concat(HoraString, Minuto, HorarioString).

% Atualiza horário da sessão
atualizaHorarioSessao(Id, Horario, PosicaoDaSessao) :-
    getSessaoPosition(Id, PosicaoDaSessao, [X, Y]),
    horarioToString(Horario, HorarioString),
    writeMatrixValue("./Interfaces/Compras/MenuCompras.txt", "Horário: " || HorarioString, X, Y).

% Atualiza nome da sessão
atualizaNomeSessao(Id, Titulo, PosicaoDaSessao) :-
    getSessaoPosition(Id, PosicaoDaSessao, [X, Y]),
    writeMatrixValue("./Interfaces/Compras/MenuCompras.txt", Titulo, X, Y).

% Atualiza sala da sessão
atualizaSalaSessao(Id, Sala, PosicaoDaSessao) :-
    getSessaoPosition(Id, PosicaoDaSessao, [X, Y]),
    atom_concat("Sala: ", Sala, SalaString),
    writeMatrixValue("./Interfaces/Compras/MenuCompras.txt", SalaString, X, Y).

% Obtém a posição da sessão
getSessaoPosition(Id, PosicaoDaSessao, [X, Y]) :-
    sessao_position(Id, PosicaoDaSessao, [X, Y]), !.

% Definição das posições das sessões
:- asserta(sessao_position(1, 1, [12, 34])).
:- asserta(sessao_position(1, 2, [12, 51])).
:- asserta(sessao_position(1, 3, [12, 68])).
:- asserta(sessao_position(1, 4, [12, 85])).
:- asserta(sessao_position(2, 1, [17, 34])).
:- asserta(sessao_position(2, 2, [17, 51])).
:- asserta(sessao_position(2, 3, [17, 68])).
:- asserta(sessao_position(2, 4, [17, 85])).
:- asserta(sessao_position(3, 1, [22, 34])).
:- asserta(sessao_position(3, 2, [22, 51])).
:- asserta(sessao_position(3, 3, [22, 68])).
:- asserta(sessao_position(3, 4, [22, 85])).
:- asserta(sessao_position(4, 1, [27, 34])).
:- asserta(sessao_position(4, 2, [27, 51])).
:- asserta(sessao_position(4, 3, [27, 68])).
:- asserta(sessao_position(4, 4, [27, 85])).
:- asserta(sessao_position(5, 1, [32, 34])).
:- asserta(sessao_position(5, 2, [32, 51])).
:- asserta(sessao_position(5, 3, [32, 68])).
:- asserta(sessao_position(5, 4, [32, 85])).
