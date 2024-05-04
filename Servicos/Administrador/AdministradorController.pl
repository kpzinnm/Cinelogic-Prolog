:- module(AdministradorController, [saveAdministrador/1, updateAdministradorMenu/0, getLoginAdministrador/3]).

:- use_module('./Utils/JsonUtils.pl').
:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Utils/UpdateUtils.pl').
:- use_module(library(http/json)).
:- use_module('./Menus/Configuracoes/MenuConfiguracoesController.pl').

% Cadastra um novo administrador, função externa
saveAdministrador(Administrador) :- 
    getAdministradorJSON(ListaAdministrador),
    Administrador = administrador(Ident, Login, Senha),
    getValidaAdministrador(Login, Bool),
    (Bool -> 
        lerJSON("./BancoDeDados/Administrador/Administrador.json", File),
        administradoresToJSON(File, ListaAdministradorJSON),
        length(ListaAdministrador, Tamanho),
        NextTamanho is Tamanho + 1,
        administradorToJSON(NextTamanho, Login, Senha, AdministradorJSON),

        append(ListaAdministradorJSON, [AdministradorJSON], Saida),
        open("./BancoDeDados/Administrador/Administrador.json", write, Stream), write(Stream, Saida), close(Stream),
        write("Cadastro realizado com sucesso! \n"),
        sleep(1);
        
        write('Login já existente. \n'),
        sleep(1.3),
        starMenuConfiguracoes).


administradorToJSON(Ident, Login, Senha, Out) :-
	swritef(Out, '{"ident": %w, "login": "%w", "senha": "%w"}', [Ident, Login, Senha]).

administradoresToJSON([], []).
administradoresToJSON([H|T], [X|Out]) :- 
	administradorToJSON(H.ident, H.login, H.senha, X), 
	administradoresToJSON(T, Out).

getAdministradorJSON(Out) :-
	lerJSON("./BancoDeDados/Administrador/Administrador.json", Administrador),
	exibirAdministradorAux(Administrador , Result),
    Out = Result.

exibirAdministradorAux([], []).
exibirAdministradorAux([H|T], [administrador(H.ident, H.login, H.senha)|Rest]) :- 
    exibirAdministradorAux(T, Rest).

% Busca administrador por login e senha
getAdministrador(Login, Senha, Bool) :- 
    getAdministradorJSON(Out), 
    buscarAdministradorPorLogin(Login, Senha, Out, Bool).

% Euxiliar do getAdministrado
buscarAdministradorPorLogin(_, _, [], false).
buscarAdministradorPorLogin(Login, Senha, [administrador(Ident, Login, Senha)|_], true).
buscarAdministradorPorLogin(Login, Senha, [_|Resto], Bool) :-
    buscarAdministradorPorLogin(Login, Senha, Resto, Bool).

% Caso já aja um login igual, nega a operação
getValidaAdministrador(Login, Bool) :-
    getAdministradorJSON(Out),
    buscarLoginValido(Login, Out, Bool).

% Auxiliar do getValidaAdministrador
buscarLoginValido(_, [], true).
buscarLoginValido(Login, [administrador(Ident, Login, Senha)|_], false).
buscarLoginValido(Login, [_|Resto], Bool) :-
    buscarLoginValido(Login, Resto, Bool).
    
% Função externa para login
getLoginAdministrador(Login, Senha, Bool) :- 
    getAdministrador(Login, Senha, Bool).

