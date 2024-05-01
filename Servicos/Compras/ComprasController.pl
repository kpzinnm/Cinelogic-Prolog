:- module(ComprasController, [saveCompra/1]).

:- use_module(library(http/json)).
:- use_module('./Utils/JsonUtils.pl').
:- use_module('./Utils/UpdateUtils.pl').


saveCompra(Compra) :- 
    getComprasJSON(ListaCompras),
    length(ListaCompras, Tamanho),
    Compra = compra(Ident, EmailCliente, NumeroIngressos, ValorCompra),
    lerJSON("./BancoDeDados/Compras/Compra.json", File),
    comprasToJSON(File, ListaComprasJSON),
    NextTamanho is Tamanho + 1,
    compraToJSON(NextTamanho, EmailCliente, NumeroIngressos, ValorCompra, CompraJSON),
    append(ListaComprasJSON, [CompraJSON], Saida),
    open("./BancoDeDados/Compras/Compra.json", write, Stream), write(Stream, Saida), close(Stream).


compraToJSON(Ident, EmailCliente, NumeroIngressos, ValorCompra, Out) :-
	swritef(Out, '{"ident": %w, "emailCliente": "%w", "numeroIngressos": "%w", "valorCompra": "%w"}', [Ident, EmailCliente, NumeroIngressos, ValorCompra]).

comprasToJSON([], []).
comprasToJSON([H|T], [X|Out]) :- 
	compraToJSON(H.ident, H.emailCliente, H.numeroIngressos, H.valorCompra, X), 
	comprasToJSON(T, Out).
    
/*Get Compra*/
getComprasJSON(Out) :-
	lerJSON("./BancoDeDados/Compras/Compra.json", Compras),
	exibirComprasAux(Compras , Result),
    Out = Result.

exibirComprasAux([], []).
exibirComprasAux([H|T], [compra(H.ident, H.emailCliente, H.numeroIngressos, H.valorCompra)|Rest]) :- 
    exibirComprasAux(T, Rest).