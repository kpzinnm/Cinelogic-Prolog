:- module(AdministradorController, [saveAdministrador/1, updateAdministradorMenu/0, getLoginAdministrador/3]).

:- use_module('./Utils/JsonUtils.pl').
:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Utils/UpdateUtils.pl').
:- use_module(library(http/json)).

/*Funções de save administradores*/
saveAdministrador(Administrador) :- 
    getAdministradorJSON(ListaAdministrador),
    %length(ListaAdministrador, Tamanho),
    Administrador = administrador(Ident, Login, Senha),
    writeln(ListaAdministrador),
    lerJSON("./BancoDeDados/Administrador/Administrador.json", File),
    administradoresToJSON(File, ListaAdministradorJSON),
    length(ListaAdministrador, Tamanho),
    NextTamanho is Tamanho + 1,
    administradorToJSON(NextTamanho, Login, Senha, AdministradorJSON),
    
    append(ListaAdministradorJSON, [AdministradorJSON], Saida),
    open("./BancoDeDados/Administrador/Administrador.json", write, Stream), write(Stream, Saida), close(Stream).

    /*(Tamanho < 5 ->  % Verifica se o tamanho atual é menor que 5
        Administrador = administrador(Ident, Login, Senha),
        lerJSON("./BancoDeDados/Administrador/Administrador.json", File),
        administradoresToJSON(File, ListaAdministradorJSON),
        %NextTamanho is Tamanho + 1,
        %administradorToJSON(NextTamanho, Name, Duracao, Genero, AdministradorJSON),
        append(ListaAdministradorJSON, [AdministradorJSON], Saida),
        open("./BancoDeDados/Administrador/Administrador.json", write, Stream), write(Stream, Saida), close(Stream)
    ;
        write('Limite máximo de administradores atingido (5 administradores). \n'),
        sleep(1.3)
    ).*/


administradorToJSON(Ident, Login, Senha, Out) :-
	swritef(Out, '{"ident": %w, "login": "%w", "senha": "%w"}', [Ident, Login, Senha]).

administradoresToJSON([], []).
administradoresToJSON([H|T], [X|Out]) :- 
	administradorToJSON(H.ident, H.login, H.senha, X), 
	administradoresToJSON(T, Out).

/*Funções de get administradores*/
getAdministradorJSON(Out) :-
	lerJSON("./BancoDeDados/Administrador/Administrador.json", Administrador),
	exibirAdministradorAux(Administrador , Result),
    Out = Result.

exibirAdministradorAux([], []).
exibirAdministradorAux([H|T], [administrador(H.ident, H.login, H.senha)|Rest]) :- 
    exibirAdministradorAux(T, Rest).

getAdministrador(Login, Senha, Bool) :- 
    getAdministradorJSON(Out), 
    buscarAdministradorPorLogin(Login, Senha, Out, Bool).

buscarAdministradorPorLogin(_, _, [], false).
buscarAdministradorPorLogin(Login, Senha, [administrador(Ident, Login, Senha)|_], true).
buscarAdministradorPorLogin(Login, Senha, [_|Resto], Bool) :-
    buscarAdministradorPorLogin(Login, Senha, Resto, Bool).

/*getAdministradorIdent(Administrador, Ident) :- 
    Administrador = administrador(Ident, _, _, _).

getAdministradorName(ID, Name) :- 
    getAdministrador(ID, Administrador),getAdministradorJSON,
    Administrador = administrador(_, Name, _, _).

getAdministradorDuracao(ID, Duracao) :- 
    getAdministrador(ID, Administrador),
    Administrador = administrador(_, _, Duracao, _).

getAdministradorGenero(ID, Genero) :- 
    getAdministrador(ID, Administrador),
    Administrador = administrador(_, _, _, Genero).
*/

getLoginAdministrador(Login, Senha, Bool) :- 
    getAdministrador(Login, Senha, Bool).

/*Exibição de administradores

updateAdministradorMenu :-
    FilePath = "./Interfaces/Compras/Administrador/MenuCompraAdministrador.txt",
    resetMenu(FilePath, "./Interfaces/Compras/Administrador/MenuCompraAdministradorBase.txt"),
    getAdministradorJSON(Administrador),
    updateAllAdministrador(FilePath, Administrador).

updateAllAdministrador(_, []) :- !.
updateAllAdministrador(FilePath, [H|T]) :-
    getAdministradorIdent(H, Ident),
    write(Ident),
    updateAdministradorName(FilePath, Ident),
    updateAdministradorDuracao(FilePath, Ident),
    updateAdministradorGenero(FilePath, Ident),
    updateAllAdministrador(FilePath, T).

updateAdministradorName(FilePath, Ident) :-
    getAdministradorName(Ident, Name),
    concat_atom(["(", Ident, ") ", Name], '', FullName),
    getColRow(Ident, Row, Col),
    writeMatrixValue(FilePath, FullName, Row, Col).

updateAdministradorDuracao(FilePath, Ident) :-
    getAdministradorDuracao(Ident, Duracao),
    concat_atom(['Duracao:', Duracao], ' ', FullDuracao),
    getColRow(Ident, Row, Col),
    NextRow is Row + 1,
    writeMatrixValue(FilePath, FullDuracao, NextRow, Col).

updateAdministradorGenero(FilePath, Ident) :-
    getAdministradorGenero(Ident, Genero),
    concat_atom(['Genero:', Genero], ' ', FullGenero),
    getColRow(Ident, Row, Col),
    NextRow is Row + 2,
    writeMatrixValue(FilePath, FullGenero, NextRow, Col).

getColRow(1, 12, 3).
getColRow(2, 17, 3).
getColRow(3, 22, 3).
getColRow(4, 27, 3).
getColRow(5, 32, 3).
*/