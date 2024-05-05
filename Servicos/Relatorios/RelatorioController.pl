:- module(RelatorioController, [updateRelatorioMenu/0, updateGraficoMenu/0]).

:- use_module('./Utils/UpdateUtils.pl').
:- use_module('./Servicos/Compras/ComprasController.pl').
:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Utils/GraphUtils.pl').
:- use_module('./Servicos/Filmes/FilmesController.pl').


/* Relatorios*/

updateRelatorioMenu :-
    FilePath = "./Interfaces/Configuracoes/Relatorio/menuRelatorios.txt",
    resetMenu(FilePath, "./Interfaces/Configuracoes/Relatorio/menuRelatoriosBase.txt"),
    totalBruto(FilePath),
    totalIngrassosVendidos(FilePath).

totalBruto(FilePath) :-
    getComprasJSON(ListaCompras),
    somaValorCompras(ListaCompras, 0, Total),
    writeMatrixValue(FilePath, Total, 18, 27).

somaValorCompras([], Total, Total).
somaValorCompras([compra(_, _, _, ValorCompra, _)|T], Acc, Total) :- 
    atom_number(ValorCompra, ValorCompraInt),
    NewAcc is Acc + ValorCompraInt,
    somaValorCompras(T, NewAcc, Total).

totalIngrassosVendidos(FilePath) :-
    getComprasJSON(ListaCompras),
    somaIngressos(ListaCompras, 0, Total),
    writeMatrixValue(FilePath, Total, 24, 34).

somaIngressos([], Total, Total).
somaIngressos([compra(_, _, NumeroIngressos, _, _)|T], Acc, Total) :- 
    atom_number(NumeroIngressos, NumeroIngressosInt),
    NewAcc is Acc + NumeroIngressosInt,
    somaIngressos(T, NewAcc, Total).



/* Grafico */

updateGraficoMenu :-
    FilePath = "./Interfaces/Configuracoes/Relatorio/menuGrafico.txt",
    resetMenu(FilePath, "./Interfaces/Configuracoes/Relatorio/menuGraficoBase.txt"),
    getFilmesJSON(Filmes),
    updateGraficoAllFilmes(FilePath, Filmes).

updateGraficoAllFilmes(_, []) :- !.
updateGraficoAllFilmes(FilePath, [H|T]) :-
    getFilmeIdent(H, IdentFilme),
    updateFilmesName(FilePath, IdentFilme),
    totalIngrassosVendidosIdent(FilePath, IdentFilme),
    updateGraficoAllFilmes(FilePath, T).

updateFilmesName(FilePath, Ident) :-
    getFilmeName(Ident, Name),
    getColRowName(Ident, Row, Col),
    writeMatrixValue(FilePath, Name, Row, Col).

getColRowName(1, 35, 7).
getColRowName(2, 36, 7).
getColRowName(3, 37, 7).
getColRowName(4, 38, 7).
getColRowName(5, 39, 7).

totalIngrassosVendidosIdent(FilePath, IdentFilme) :-
    getComprasJSON(ListaCompras),
    somaIngressosIdent(ListaCompras, IdentFilme, 0, Total),
    updateGrafico(FilePath, IdentFilme, Total).

somaIngressosIdent([], IdentFilme, Total, Total).
somaIngressosIdent([compra(_, _, NumeroIngressos, _, Ident)|T], IdentFilme, Acc, Total) :- 
    atom_number(NumeroIngressos, NumeroIngressosInt),
    atom_number(Ident, IdentInt),
    (IdentInt = IdentFilme ->
        NewAcc is Acc + NumeroIngressosInt;
        NewAcc is Acc
    ),
    somaIngressosIdent(T, IdentFilme, NewAcc, Total).

updateGrafico(FilePath, IdentFilme, 0).
updateGrafico(FilePath,IdentFilme, Total) :-
    getColRowGrafico(IdentFilme, Col, Row),
    NewCol is Col - Total,
    updateWLGraphCandle(FilePath, NewCol, Row),
    NewAcc is Total - 1,
    updateGrafico(FilePath, IdentFilme, NewAcc).

getColRowGrafico(1, 32, 23).
getColRowGrafico(2, 32, 36).
getColRowGrafico(3, 32, 48).
getColRowGrafico(4, 32, 62).
getColRowGrafico(5, 32, 76).
