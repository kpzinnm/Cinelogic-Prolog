:- module(SessoesController, [saveSessao/1]).

:- use_module(library(lists)).
:- use_module('./Utils/JsonUtils.pl').
:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Utils/UpdateUtils.pl').
:- use_module(library(http/json)).
:- use_module('./Menus/Configuracoes/MenuConfiguracoesController.pl').


% Adiciona uma sessao ao arquivo JSON
saveSessao(Sessao) :-
    getSessoesJSON(Sessoes),
    Sessao = sessao(Ident, IdFilme, Horario, Capacidade, IdSala),
    lerJSON("./BancoDeDados/Sessoes/Sessao.json", File),
    sessoesToJSON(File, SessoesJSON),
    length(Sessoes, Tamanho),
    NextTamanho is Tamanho + 1,
    sessaoToJSON(NextTamanho, IdFilme, Horario, Capacidade, IdSala, SessaoJSON),

    append(SessoesJSON, [SessaoJSON], Saida),
    open("./BancoDeDados/Sessoes/Sessao.json", write, Stream), write(Stream, Saida), close(Stream),
    write("Cadastro realizado com sucesso! \n"),
    sleep(1),
    startMenuConfiguracoes.

sessaoToJSON(Ident, IdFilme, Horario, Capacidade, IdSala, Out) :-
	swritef(Out, '{"ident": %w, "idFilme": "%w", "horario": %w, "capacidade": "%w", "idSala": "%w"}', [Ident, IdFilme, Horario, Capacidade, IdSala]).

sessoesToJSON([], []).
sessoesToJSON([H|T], [X|Out]) :-
	sessaoToJSON(H.ident, H.idFilme, H.horario, H.capacidade, H.idSala, X),
	sessoesToJSON(T, Out).

getSessoesJSON(Out) :-
	lerJSON("./BancoDeDados/Sessoes/Sessao.json", Sessoes),
	exibirSessoesAux(Sessoes , Result),
	Out = Result.

exibirSessoesAux([], []).
exibirSessoesAux([H|T], [sessao(H.ident, H.idFilme, H.horario, H.capacidade, H.idSala)|Rest]) :-
	exibirSessoesAux(T, Rest).
