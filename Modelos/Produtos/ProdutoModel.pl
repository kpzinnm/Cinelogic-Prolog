:- module(ProdutoModel, [createProduto/5]).


createProduto(Ident, TituloProduto, Preco, Produto) :-
    Produto = produto(Ident, TituloProduto, Preco).
