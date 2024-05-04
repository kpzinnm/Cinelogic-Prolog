:- module(RelatorioController, [updateRelatorioMenu/0]).

:- use_module('./Utils/UpdateUtils.pl').
:- use_module('./Servicos/Compras/ComprasController.pl').
:- use_module('./Utils/MatrixUtils.pl').


updateRelatorioMenu :-
    FilePath = "./Interfaces/Configuracoes/Relatorio/menuRelatorios.txt",
    resetMenu(FilePath, "./Interfaces/Configuracoes/Relatorio/menuRelatoriosBase.txt"),
    totalBruto(FilePath),
    totalIngrassosVendidos(FilePath).


totalBruto(FilePath) :-
    getComprasJSON(ListaCompras),
    somaValorCompras(ListaCompras, 0, Total),
    writeMatrixValue(FilePath, Total, 18, 27).
    sleep(0.7).

somaValorCompras([], Total, Total).
somaValorCompras([compra(_, _, _, ValorCompra, _)|T], Acc, Total) :- 
    atom_number(ValorCompra, ValorCompraInt),
    NewAcc is Acc + ValorCompraInt,
    somaValorCompras(T, NewAcc, Total).

totalIngrassosVendidos(FilePath) :-
    getComprasJSON(ListaCompras),
    somaIngressos(ListaCompras, 0, Total),
    writeMatrixValue(FilePath, Total, 24, 34).
    sleep(0.7).

somaIngressos([], Total, Total).
somaIngressos([compra(_, _, NumeroIngressos, _, _)|T], Acc, Total) :- 
    atom_number(NumeroIngressos, NumeroIngressosInt),
    NewAcc is Acc + NumeroIngressosInt,
    somaIngressos(T, NewAcc, Total).
