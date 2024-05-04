:- module(SessoesController, [saveSessao/1, updateSessoesMenu/0, isSessaoValida/2, getSessaoName/2]).

:- use_module('./Utils/JsonUtils.pl').
:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Utils/UpdateUtils.pl').
:- use_module(library(http/json)).

/*Funções de save filmes*/
saveSessao(Sessao) :- 
    getSessoesJSON(ListaSessoes),
    length(ListaSessoes, Tamanho),
    (Tamanho < 4 ->  % Verifica se o tamanho atual é menor que 4
        Sessao = sessao(Ident, IdFilme, Capacidade, Horario, IdSala),
        lerJSON("./BancoDeDados/Sessoes/Sessao.json", File),
        SessoesToJSON(File, ListaSessoesJSON),
        NextTamanho is Tamanho + 1,
        SessaoToJSON(NextTamanho, IdFilme, Capacidade, Horario, IdSala, SessaoJSON),
        append(ListaSessoesJSON, [SessaoJSON], Saida),
        open("./BancoDeDados/Sessoes/Sessao.json", write, Stream), write(Stream, Saida), close(Stream)
    ;
        write('Limite máximo de sessões atingido (4 sessões). \n'),
        sleep(1.3)
    ).


sessaoToJSON(Ident, IdFilme, Capacidade, Horario, IdSala, Out) :-
	swritef(Out, '{"ident": %w, "idFilme": "%w", "capacidade": "%w", "horario": "%w", "idSala": "%w"}', [Ident, IdFilme, Capacidade, Horario, IdSala]).

sessoesToJSON([], []).
sessoesToJSON([H|T], [X|Out]) :- 
	sessaoToJSON(H.ident, H.idFilme, H.capacidade, H.horario, H.idSala, X), 
	sessoesToJSON(T, Out).

/*Funções de get sessões*/
getSessoesJSON(Out) :-
	lerJSON("./BancoDeDados/Sessoes/Sessao.json", Sessoes),
	exibirSessoesAux(Sessoes , Result),
    Out = Result.

exibirSessoesAux([], []).
exibirSessoesAux([H|T], [sessao(H.ident, H.idFilme, H.capacidade, H.horario, H.idSala)|Rest]) :- 
    exibirSessoesAux(T, Rest).

getSessao(Int, Sessao) :- 
    getSessoesJSON(Out), 
    buscarSessaoPorId(Int, Out, Sessao).

buscarSessaoPorId(_, [], _) :- fail.
buscarSessaoPorId(Ident, [sessao(Ident, IdFilme, Capacidade, Horario, IdSala)|_], sessao(Ident, IdFilme, Capacidade, Horario, IdSala)).
buscarSessaoPorId(Ident, [_|Resto], SessaoEncontrada) :-
    buscarSessaoPorId(Ident, Resto, SessaoEncontrada).

getSessaoIdent(Sessao, Ident) :- 
    Sessao = sessao(Ident, _, _, _, _).

getSessaoIdFilme(ID, IdFilme) :- 
    getSessao(ID, Sessao),
    Sessao = sessao(_, IdFilme, _, _, _).

getSessaoCapacidade(ID, Capacidade) :- 
    getSessao(ID, Sessao),
    Sessao = sessao(_, _, Capacidade, _, _).

getSessaoHorario(ID, Horario) :- 
    getSessao(ID, Sessao),
    Sessao = sessao(_, _, _, Horario, _).

getSessaoIdSala(ID, IdSala)
    getSessao(ID, Sessao),
    Sessao = sessao(_, _, _, _, IdSala).

/*Exibição de sessões*/

updateSessoesMenu :-
    FilePath = "./Interfaces/Compras/Sessoes/MenuCompraSessoes.txt",
    resetMenu(FilePath, "./Interfaces/Compras/Sessoes/MenuCompraSessoesBase.txt"),
    getSessoesJSON(Sessoes),
    updateAllSessoes(FilePath, Sessoes).

updateAllSessoes(_, []) :- !.
updateAllSessoes(FilePath, [H|T]) :-
    getSessaoIdent(H, Ident),
    updateSessoesIdFilme(FilePath, Ident),
    updateSessoesCapacidade(FilePath, Ident),
    updateSessoesHorario(FilePath, Ident),
    updateSessoesIdSala(FilePath, Ident),
    updateAllSessoes(FilePath, T).

updateSessoesIdFilme(FilePath, Ident) :-
    getSessaoIdFilme(Ident, IdFilme),
    concat_atom(["(", Ident, ") ", IdFilme], '', FullName),
    getColRow(Ident, Row, Col),
    writeMatrixValue(FilePath, FullName, Row, Col).

updateSessoesCapacidade(FilePath, Ident) :-
    getSessaoCapacidade(Ident, Capacidade),
    concat_atom(['Capacidade:', Capacidade], ' ', FullCapacidade),
    getColRow(Ident, Row, Col),
    NextRow is Row + 1,
    writeMatrixValue(FilePath, FullCapacidade, NextRow, Col).

updateSessoesHorario(FilePath, Ident) :-
    getSessaoHorario(Ident, Horario),
    concat_atom(['Horario:', Horario], ' ', FullHorario),
    getColRow(Ident, Row, Col),
    NextRow is Row + 2,
    writeMatrixValue(FilePath, FullHorario, NextRow, Col).

updateSessoesIdSala(FilePath, Ident) :-
    getSessaoIdSala(Ident, IdSala),
    concat_atom(['IdSala:', IdSala], ' ', FullIdSala),
    getColRow(Ident, Row, Col),
    NextRow is Row + 2,
    writeMatrixValue(FilePath, FullIdSala, NextRow, Col).

getColRow(1, 12, 3).
getColRow(2, 17, 3).
getColRow(3, 22, 3).
getColRow(4, 27, 3).
getColRow(5, 32, 3).

isSessaoValida(Ident, Bool) :-
    getSessoesJSON(SessoesJson),
    atom_number(Ident, IdentInt),
    isSessaoValidoAuxiliar(IdentInt, SessoesJson, Bool).

isSessaoValidaAuxiliar(_, [], false).
isSessaoValidaAuxiliar(Ident, [sessao(Ident, IdFilme, Capacidade, Horario, IdSala)|_], true).
isSessaoValidaAuxiliar(Ident, [_|Resto], Bool) :-
    isSessaoValidaAuxiliar(Ident, Resto, Bool).