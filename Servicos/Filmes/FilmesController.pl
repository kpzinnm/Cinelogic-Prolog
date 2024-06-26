:- module(FilmesController, [saveFilme/1, updateFilmesMenu/0, isFilmeValido/2, getFilmeName/2, getFilmesJSON/1, getFilmeIdent/2, getFilmeName/2, atualizaSessoesFilmesInterface/0]).

:- use_module('./Utils/JsonUtils.pl').
:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Utils/UpdateUtils.pl').
:- use_module(library(http/json)).
:- use_module('./Servicos/Sessoes/AtualizaSessaoInterface.pl').

/*Funções de save filmes*/
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

atualizaSessoesFilmesInterface :-
    getFilmesJSON(ListaFilmes),
    %loadSessoesDoFilme(1).
    atualizaInterfaceAuxiliar(ListaFilmes).

atualizaInterfaceAuxiliar([]).
atualizaInterfaceAuxiliar([filme(Ident, Name, Duracao, Genero)|T]) :-
    %atom_number(Ident, IdentInt),
    loadSessoesDoFilme(Ident),
    atualizaInterfaceAuxiliar(T).

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

/*Exibição de filmes*/

updateFilmesMenu :-
    FilePath = "./Interfaces/Compras/Filmes/MenuCompraFilmes.txt",
    resetMenu(FilePath, "./Interfaces/Compras/Filmes/MenuCompraFilmesBase.txt"),
    getFilmesJSON(Filmes),
    atualizaInterfaceAuxiliar(Filmes),
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
    isFilmeValidoAuxiliar(Ident, Resto, Bool).