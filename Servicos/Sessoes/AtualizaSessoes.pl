:- module(AtualizaSessoes, [loadSessoesDoFilme/1]).

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
exibirSessoesAux([H|T], [sessao(H.ident, H.filmeIdent, H.capacidade, H.horario, H.idSala)|Rest]) :- 
    exibirSessoesAux(T, Rest).

loadSessoesDoFilme(IDDoFilme) :-
    getSessoesJSON(Sessoes),
    %write(IDDoFilme),
    atualizaSessoes(Sessoes, IDDoFilme, 1).

atualizaSessoes([], _, _).
atualizaSessoes([Sessao|T], IDDoFilme, PosicaoDaSessao) :-
    Sessao = sessao(Ident, FilmeIdent, Capacidade, Horario, SalaIdent),
    (comparaIdent(IDDoFilme, FilmeIdent) -> 
       % write(Capacidade),
        %getFilme(IDDoFilme, Filme),
        %Filme = filme(Ident, Name, Duracao, Genero),
        atualizaNomeSessao(IDDoFilme, PosicaoDaSessao),
        atualizaHorarioSessao(IDDoFilme, Horario, PosicaoDaSessao),
        atualizaSalaSessao(IDDoFilme, SalaIdent, PosicaoDaSessao),
        NovoPosicaoDaSessao is PosicaoDaSessao + 1,
        resetaPosicao(NovoPosicaoDaSessao),
        atualizaSessoes(T, IDDoFilme, NovoPosicaoDaSessao) ;
        
        atualizaSessoes(T, IDDoFilme, PosicaoDaSessao),
        write("Falso")
     ).
    
        %atualizaNomeSessao idDoFilme ("SESSÃO " ++ show posicaoDaSessao) posicaoDaSessao
        %atualizaHorarioSessao idDoFilme (Modelos.Sessao.horario h) posicaoDaSessao
        %atualizaSalaSessao idDoFilme (idSala h) posicaoDaSessao
        %atualizaSessoes t idDoFilme (posicaoDaSessao + 1)

    /*sessao_filme(Sessao, filmeIdent),
    ident(filmeIdent, IDDoFilme),
    atualizaNomeSessao(IDDoFilme, PosicaoDaSessao),
    horario(Sessao, Horario),
    atualizaHorarioSessao(IDDoFilme, Horario, PosicaoDaSessao),
    idSala(Sessao, IdSala),
    atualizaSalaSessao(IDDoFilme, IdSala, PosicaoDaSessao),
    NovoPosicaoDaSessao is PosicaoDaSessao + 1,
    atualizaSessoes(T, IDDoFilme, NovoPosicaoDaSessao).
atualizaSessoes([_|T], IDDoFilme, PosicaoDaSessao) :-
    atualizaSessoes(T, IDDoFilme, PosicaoDaSessao).*/
    
resetaPosicao(Posicao) :-
    (Posicao > 3 -> Posicao = 1 ; true).

comparaIdent(IdFilme, IdFilmeSessao):-
    IdFilme == IdFilmeSessao.

atualizaHorarioSessao(ID, Horario, PosicaoDaSessao) :-
    write(Horario),
    flush_output,
    getSessaoPosition(ID, PosicaoDaSessao, Posicao, Coluna),
    Horario = [Hora, Minuto],
    write(Hora),
    flush_output,
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

/*
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use when" #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Servicos.Sessao.AtualizaSessaoInterfaceServico where
import Modelos.Sessao ( Sessao(filme, ident, horario, idSala) )
import Modelos.Filme ( Filme(ident, duracao) )
import Servicos.Sessao.SessaoController ( getSessoesJSON )
import Control.Concurrent ( threadDelay )
import Servicos.Matriz.MatrizServices
import qualified Modelos.Sessao as Modelos
---------------
-----Funções para atualizar sessão na interface 
loadSessoesDoFilme :: Int -> IO()
loadSessoesDoFilme idDoFilme = do
    sessoes <- getSessoesJSON
    atualizaSessoes sessoes idDoFilme 1

atualizaSessoes :: [Sessao] -> Int -> Int -> IO ()
atualizaSessoes [] _ _= return ()
atualizaSessoes (h:t) idDoFilme posicaoDaSessao= do
    let filmeDaSessao = filme h
    if Modelos.Filme.ident filmeDaSessao == idDoFilme then do
        atualizaNomeSessao idDoFilme ("SESSÃO " ++ show posicaoDaSessao) posicaoDaSessao
        atualizaHorarioSessao idDoFilme (Modelos.Sessao.horario h) posicaoDaSessao
        atualizaSalaSessao idDoFilme (idSala h) posicaoDaSessao
        atualizaSessoes t idDoFilme (posicaoDaSessao + 1)
    else
        atualizaSessoes t idDoFilme posicaoDaSessao

atualizaHorarioSessao :: Int -> (Int, Int) -> Int -> IO()
atualizaHorarioSessao id horario posicaoDaSessao = do
    let posicao = getSessaoPosition id posicaoDaSessao
    writeMatrixValue "./Interfaces/Compras/Filmes/MenuComprasFilmes.txt" ("Horário: " ++ horarioToString horario) (head posicao+1) (last posicao)

horarioToString:: (Int, Int) -> String
horarioToString (h, t) = show h ++ ":" ++ show t

atualizaNomeSessao :: Int -> String -> Int -> IO ()
atualizaNomeSessao  id titulo posicaoDaSessao= do
    let posicao = getSessaoPosition id posicaoDaSessao
    writeMatrixValue "./Interfaces/Compras/Filmes/MenuComprasFilmes.txt" titulo (head posicao) (last posicao)

atualizaSalaSessao :: Int -> Int -> Int -> IO()
atualizaSalaSessao id sala posicaoDaSessao = do 
    let posicao = getSessaoPosition id posicaoDaSessao
    writeMatrixValue "./Interfaces/Compras/Filmes/MenuComprasFilmes.txt" ("Sala: " ++ show sala) (head posicao+2) (last posicao)



getSessaoPosition :: Int -> Int -> [Int]
getSessaoPosition 1 1 = [12, 34]
getSessaoPosition 1 2 = [12, 51]
getSessaoPosition 1 3 = [12, 68]
getSessaoPosition 1 4 = [12, 85]
--------------------------------
getSessaoPosition 2 1 = [17, 34]
getSessaoPosition 2 2 = [17, 51]
getSessaoPosition 2 3 = [17, 68]
getSessaoPosition 2 4 = [17, 85]
--------------------------------
getSessaoPosition 3 1 = [22, 34]
getSessaoPosition 3 2 = [22, 51]
getSessaoPosition 3 3 = [22, 68]
getSessaoPosition 3 4 = [22, 85]
--------------------------------
getSessaoPosition 4 1 = [27, 34]
getSessaoPosition 4 2 = [27, 51]
getSessaoPosition 4 3 = [27, 68]
getSessaoPosition 4 4 = [27, 85]
--------------------------------
getSessaoPosition 5 1 = [32, 34]
getSessaoPosition 5 2 = [32, 51]
getSessaoPosition 5 3 = [32, 68]
getSessaoPosition 5 4 = [32, 85]
*/