:- module(CompraModel, [createCompra/5]).

createCompra(Ident, QuantidadeProdutos, ValorCompra, ProdutoIdent, Compra) :-
    Compra = compra(Ident, QuantidadeProdutos, ValorCompra,  ProdutoIdent).