:- module(ProdutoModel, [createProduto/4]).


createProduto(Ident, Name, Preco, Produto) :-
    Produto = produto(Ident, Name, Preco).
