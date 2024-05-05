:- module(AtualizaSessaoInterface, [loadSessoesDoFilme/1]).

:- use_module('./Utils/JsonUtils.pl').
:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Utils/UpdateUtils.pl').
:- use_module(library(http/json)).
:- use_module('./Modelos/Sessoes/Sessao.pl').
:- use_module('./Servicos/Filmes/FilmesController.pl').
:- use_module('./Utils/MatrixUtils.pl').

getSessoesJSON(Out) :-
    lerJSON("./BancoDeDados/Sessoes/Sessao.json", Sessoes),
    exibirSessoesAux(Sessoes , Result),
    Out = Result.
exibirSessoesAux([], []).
exibirSessoesAux([H|T], [sessao(H.ident, H.idFilme, H.horario, H.capacidade, H.idSala)|Rest]) :- 
    exibirSessoesAux(T, Rest).

loadSessoesDoFilme(IDDoFilme) :-
    getSessoesJSON(Sessoes),
    atualizaSessoes(Sessoes, IDDoFilme, 1).

atualizaSessoes([], _, _).
atualizaSessoes([Sessao|T], IDDoFilme, PosicaoDaSessao) :-
    Sessao = sessao(Ident, IdFilme, Horario, Capacidade, IdSala),
    atom_number(IdFilme, IdFilmeInt),
    (comparaIdent(IDDoFilme, IdFilmeInt) -> 
        write("Atualiza Sessoes"),
        atualizaNomeSessao(IDDoFilme, PosicaoDaSessao),
        atualizaHorarioSessao(IDDoFilme, Horario, PosicaoDaSessao),
        atualizaSalaSessao(IDDoFilme, IdSala, PosicaoDaSessao),
        NovoPosicaoDaSessao is PosicaoDaSessao + 1,
        resetaPosicao(NovoPosicaoDaSessao),
        atualizaSessoes(T, IDDoFilme, NovoPosicaoDaSessao) ;
        
        atualizaSessoes(T, IDDoFilme, PosicaoDaSessao)
     ).
    
        
resetaPosicao(Posicao) :-
    (Posicao > 3 -> Posicao = 1 ; true).

comparaIdent(IdFilme, IdFilmeSessao):-
    IdFilme == IdFilmeSessao.

atualizaHorarioSessao(ID, Horario, PosicaoDaSessao) :-
    getSessaoPosition(ID, PosicaoDaSessao, Posicao, Coluna),
    Horario = [Hora, Minuto],
    format(atom(Texto), 'Horário: ~w: ~w', [Hora, Minuto]),
    NewPosition is Posicao + 1,
    writeMatrixValue('./Interfaces/Compras/Filmes/MenuCompraFilmes.txt', Texto, NewPosition, Coluna).

atualizaNomeSessao(ID, PosicaoDaSessao) :-
    getSessaoPosition(ID, PosicaoDaSessao, Posicao, Coluna),
    format(atom(Titulo), 'SESSÃO: ~w', PosicaoDaSessao),
    writeMatrixValue('./Interfaces/Compras/Filmes/MenuCompraFilmes.txt', Titulo, Posicao, Coluna).

atualizaSalaSessao(ID, Sala, PosicaoDaSessao) :-
    getSessaoPosition(ID, PosicaoDaSessao, Posicao, Coluna),
    format(atom(Texto), 'Sala: ~w', Sala),
    NewPosition is Posicao + 2,
    writeMatrixValue('./Interfaces/Compras/Filmes/MenuCompraFilmes.txt', Texto, NewPosition, Coluna).


getSessaoPosition(1, 1, 12, 34).
getSessaoPosition(1, 2, 12, 51).
getSessaoPosition(1, 3, 12, 68).
getSessaoPosition(1, 4, 12, 85).

getSessaoPosition(2, 1, 17, 34).
getSessaoPosition(2, 2, 17, 51).
getSessaoPosition(2, 3, 17, 68).
getSessaoPosition(2, 4, 17, 85).

getSessaoPosition(3, 1, 22, 34).
getSessaoPosition(3, 2, 22, 51).
getSessaoPosition(3, 3, 22, 68).
getSessaoPosition(3, 4, 22, 85).

getSessaoPosition(4, 1, 27, 34).
getSessaoPosition(4, 2, 27, 51).
getSessaoPosition(4, 3, 27, 68).
getSessaoPosition(4, 4, 27, 85).

getSessaoPosition(5, 1, 32, 34).
getSessaoPosition(5, 2, 32, 51).
getSessaoPosition(5, 3, 32, 68).
getSessaoPosition(5, 4, 32, 85).

