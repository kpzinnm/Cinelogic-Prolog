:- module(CompraModel, [createCompra/5]).

createCompra(Ident, EmailCliente, NumeroIngressos, ValorCompra, Compra) :-
    Compra = compra(Ident, EmailCliente, NumeroIngressos, ValorCompra).