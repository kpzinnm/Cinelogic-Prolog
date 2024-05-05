:- module(ValorIngressoController, [saveValorIngresso/1, getValorIngressoJSON/1]).

:- use_module('./Utils/JsonUtils.pl').
:- use_module('./Modelos/Ingresso/IngressoModel.pl').

saveValorIngresso(Valor) :-
    lerJSON("./BancoDeDados/Ingresso/ValorIngresso.json", File),
    valorToJSON(Valor, Saida),
    open("./BancoDeDados/Ingresso/ValorIngresso.json", write, Stream), write(Stream, Saida), close(Stream).


valorToJSON(ValorIngresso, Out) :-
	swritef(Out, '{"valorIngresso": %w}', [ValorIngresso]).

getValorIngressoJSON(Out) :-
	lerJSON("./BancoDeDados/Ingresso/ValorIngresso.json", Valor),
    ValorTotal = [Valor.valorIngresso],
    head(ValorTotal, Retorno),
    Out = Retorno,
    flush_output.
    
head([Head | _], Head).
