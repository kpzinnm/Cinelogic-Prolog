:- module(MenuLoginAdministradorController, [startLoginAdministrador/0]).

:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Modelos/Administrador/AdministradorModel.pl').
:- use_module('./Servicos/Administrador/AdministradorController.pl').
:- use_module('./Menus/Configuracoes/MenuConfiguracoesController.pl').

startLoginAdministrador :-
    printMatrix("./Interfaces/Configuracoes/menuConfiguracoesLogin.txt"),
    write("Digite o login: "),
    flush_output,
    read_line_to_string(user_input, UserLogin),
    write("Digite a senha: "),
    flush_output,
    read_line_to_string(user_input, UserPassword),
    %createAdministrador(0, UserLogin, UserPassword, Administrador),
    loginAdministrador(UserLogin, UserPassword).

loginAdministradorErrado :-
    printMatrix("./Interfaces/Configuracoes/menuConfiguracoesLoginInvalido.txt"),
    write("Digite o login: "),
    flush_output,
    read_line_to_string(user_input, UserLogin),
    write("Digite a senha: "),
    flush_output,
    read_line_to_string(user_input, UserPassword),
    %createAdministrador(0, UserLogin, UserPassword, Administrador),
    loginAdministrador(UserLogin, UserPassword).

loginAdministrador(Login, Senha) :-
    getLoginAdministrador(Login, Senha, Bool),
    (Bool -> starMenuConfiguracoes; loginAdministradorErrado).

