:- module(ComprasBomboniereController, [saveCompra/1]).

:- use_module(library(http/json)).
:- use_module('./Utils/JsonUtils.pl').
:- use_module('./Utils/UpdateUtils.pl').


saveCompra(Compra) :- 
    getComprasJSON(ListaCompras),
    length(ListaCompras, Tamanho),
    Compra = compra(Ident, QuantidadeProdutos, ValorCompra, ProdutoIdent),
    lerJSON("./BancoDeDados/Compras/CompraBomboniere.json", File),
    comprasToJSON(File, ListaComprasJSON),
    NextTamanho is Tamanho + 1,
    compraToJSON(NextTamanho, QuantidadeProdutos, ValorCompra, ProdutoIdent, CompraJSON),
    append(ListaComprasJSON, [CompraJSON], Saida),
    open("./BancoDeDados/Compras/CompraBomboniere.json", write, Stream), write(Stream, Saida), close(Stream).


compraToJSON(Ident, QuantidadeProdutos, ValorCompra, ProdutoIdent, Out) :-
	swritef(Out, '{"ident": %w, "quantidadeProdutos": "%w", "valorCompra": "%w", "produtoIdent": "%w"}', [Ident, QuantidadeProdutos, ValorCompra, ProdutoIdent]).

comprasToJSON([], []).
comprasToJSON([H|T], [X|Out]) :- 
	compraToJSON(H.ident, H.quantidadeProdutos, H.valorCompra, H.produtoIdent, X), 
	comprasToJSON(T, Out).
    
/*Get Compra*/
getComprasJSON(Out) :-
	lerJSON("./BancoDeDados/Compras/CompraBomboniere.json", Compras),
	exibirComprasAux(Compras , Result),
    Out = Result.

exibirComprasAux([], []).
exibirComprasAux([H|T], [compra(H.ident, H.quantidadeProdutos, H.valorCompra, H.produtoIdent)|Rest]) :- 
    exibirComprasAux(T, Rest).