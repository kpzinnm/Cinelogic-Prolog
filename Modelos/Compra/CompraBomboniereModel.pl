:- module(CompraModel, [createCompra/6]).

createCompra(Ident, Nome, QuantidadeProdutos, ValorCompra, ProdutoIdent, Compra) :-
    Compra = compra(Ident, Nome, QuantidadeProdutos, ValorCompra,  ProdutoIdent).