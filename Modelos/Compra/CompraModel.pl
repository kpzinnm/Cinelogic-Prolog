:- module(CompraModel, [createCompra/6]).

createCompra(Ident, EmailCliente, NumeroIngressos, ValorCompra, FilmeIdent, Compra) :-
    Compra = compra(Ident, EmailCliente, NumeroIngressos, ValorCompra, FilmeIdent).