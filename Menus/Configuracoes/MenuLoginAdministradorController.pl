:- module(MenuLoginAdministradorController, [startLoginAdministrador/0]).

:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Modelos/Administrador/AdministradorModel.pl').

startLoginAdministrador :-
    printMatrix("./Interfaces/Configuracoes/menuConfiguracoesLogin.txt"),
    write("Digite o login: "),
    flush_output,
    read_line_to_string(user_input, UserLogin),
    write("Digite a senha: "),
    flush_output,
    read_line_to_string(user_input, UserPassword),
    loginAdministrador.

loginAdministrador :-
    write("Login adm").
