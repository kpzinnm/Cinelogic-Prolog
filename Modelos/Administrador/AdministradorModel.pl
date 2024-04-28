:- module(AdministradorModel, [createAdministrador/4]).

createAdministrador(Ident, Login, Senha, Administrador) :-
    Administrador = administrador(Ident, Login, Senha).