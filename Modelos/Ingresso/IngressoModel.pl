:- module(IngressoModel, [createValor/2]).


createValor(ValorIngresso, Valor) :-
    Valor = valor(ValorIngresso).