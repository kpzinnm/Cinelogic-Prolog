:- module(SessoesController, [saveSessao/1]).

:- use_module('./Utils/JsonUtils.pl').
:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Utils/UpdateUtils.pl').
:- use_module(library(http/json)).
:- use_module('./Servicos/Sessoes/AtualizaSessoes.pl').

cadastrarSessao(Sessao) :-
   % Sessao = sessao(Ident, IdFilme, Capacidade, Horario, IdSala),
    write(Sessao.Horario).

/*Funções de save filmes*/
saveSessao(Sessao) :- 
    Sessao = sessao(Ident, Horario, Capacidade, SalaIdent, FilmeIdent),
    %Bool = validaHorario(Horario),
    atom_number(FilmeIdent, IdFilme),
    loadSessoesDoFilme(IdFilme).
    /*getSessoesJSON(ListaSessoes),
    length(ListaSessoes, Tamanho),
    (Tamanho < 4 ->  % Verifica se o tamanho atual é menor que 4
        Sessao = sessao(Ident, IdFilme, Capacidade, Horario, IdSala),
        lerJSON("./BancoDeDados/Sessoes/Sessao.json", File),
        sessoesToJSON(File, ListaSessoesJSON),
        NextTamanho is Tamanho + 1,
        sessaoToJSON(NextTamanho, IdFilme, Capacidade, Horario, IdSala, SessaoJSON),
        append(ListaSessoesJSON, [SessaoJSON], Saida),
        open("./BancoDeDados/Sessoes/Sessao.json", write, Stream), write(Stream, Saida), close(Stream)
    ;
        write('Limite máximo de sessões atingido (4 sessões). \n'),
        sleep(1.3)
    ).*/

validaHorario(Horario) :-
    Horario = (Hora, Minutos),
    Hora >= 0, Hora < 24, Minutos >= 0, Minutos < 60.


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

getSessaoIdSala(ID, IdSala) :-
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

/*Funções de save filmes
saveFilme(Filme) :- 
    getFilmesJSON(ListaFilmes),
    length(ListaFilmes, Tamanho),
    (Tamanho < 5 ->  % Verifica se o tamanho atual é menor que 5
        Filme = filme(Ident, Name, Duracao, Genero),
        lerJSON("./BancoDeDados/Filmes/Filme.json", File),
        filmesToJSON(File, ListaFilmesJSON),
        NextTamanho is Tamanho + 1,
        filmeToJSON(NextTamanho, Name, Duracao, Genero, FilmeJSON),
        append(ListaFilmesJSON, [FilmeJSON], Saida),
        open("./BancoDeDados/Filmes/Filme.json", write, Stream), write(Stream, Saida), close(Stream)
    ;
        write('Limite máximo de filmes atingido (5 filmes). \n'),
        sleep(1.3)
    ).


filmeToJSON(Ident, Name, Duracao, Genero, Out) :-
	swritef(Out, '{"ident": %w, "name": "%w", "duracao": "%w", "genero": "%w"}', [Ident, Name, Duracao, Genero]).

filmesToJSON([], []).
filmesToJSON([H|T], [X|Out]) :- 
	filmeToJSON(H.ident, H.name, H.duracao, H.genero, X), 
	filmesToJSON(T, Out).

/*Funções de get filmes
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

getFilmeIdent(Filme, Ident) :- 
    Filme = filme(Ident, _, _, _).

getFilmeName(ID, Name) :- 
    getFilme(ID, Filme),
    Filme = filme(_, Name, _, _).

getFilmeDuracao(ID, Duracao) :- 
    getFilme(ID, Filme),
    Filme = filme(_, _, Duracao, _).

getFilmeGenero(ID, Genero) :- 
    getFilme(ID, Filme),
    Filme = filme(_, _, _, Genero).

/*Exibição de filmes

updateFilmesMenu :-
    FilePath = "./Interfaces/Compras/Filmes/MenuCompraFilmes.txt",
    resetMenu(FilePath, "./Interfaces/Compras/Filmes/MenuCompraFilmesBase.txt"),
    getFilmesJSON(Filmes),
    updateAllFilmes(FilePath, Filmes).

updateAllFilmes(_, []) :- !.
updateAllFilmes(FilePath, [H|T]) :-
    getFilmeIdent(H, Ident),
    updateFilmesName(FilePath, Ident),
    updateFilmesDuracao(FilePath, Ident),
    updateFilmesGenero(FilePath, Ident),
    updateAllFilmes(FilePath, T).

updateFilmesName(FilePath, Ident) :-
    getFilmeName(Ident, Name),
    concat_atom(["(", Ident, ") ", Name], '', FullName),
    getColRow(Ident, Row, Col),
    writeMatrixValue(FilePath, FullName, Row, Col).

updateFilmesDuracao(FilePath, Ident) :-
    getFilmeDuracao(Ident, Duracao),
    concat_atom(['Duracao:', Duracao], ' ', FullDuracao),
    getColRow(Ident, Row, Col),
    NextRow is Row + 1,
    writeMatrixValue(FilePath, FullDuracao, NextRow, Col).

updateFilmesGenero(FilePath, Ident) :-
    getFilmeGenero(Ident, Genero),
    concat_atom(['Genero:', Genero], ' ', FullGenero),
    getColRow(Ident, Row, Col),
    NextRow is Row + 2,
    writeMatrixValue(FilePath, FullGenero, NextRow, Col).

getColRow(1, 12, 3).
getColRow(2, 17, 3).
getColRow(3, 22, 3).
getColRow(4, 27, 3).
getColRow(5, 32, 3).

isFilmeValido(Ident, Bool) :-
    getFilmesJSON(FilmesJson),
    atom_number(Ident, IdentInt),
    isFilmeValidoAuxiliar(IdentInt, FilmesJson, Bool).

isFilmeValidoAuxiliar(_, [], false).
isFilmeValidoAuxiliar(Ident, [filme(Ident, Name, Duracao, Genero)|_], true).
isFilmeValidoAuxiliar(Ident, [_|Resto], Bool) :-
    isFilmeValidoAuxiliar(Ident, Resto, Bool).*/