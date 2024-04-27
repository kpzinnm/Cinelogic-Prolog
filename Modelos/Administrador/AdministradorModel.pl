:- module(AdministradorModel, [createAdministrador/4]).

createAdministrador(ident, login, senha) :-
    Administrador = administrador(ident, login, senha).