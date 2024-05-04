:- use_module(library(lists)).

% Constantes
constantePATH("./BancoDeDados/Sessao.json").
constanteTempPATH("./BancoDeDados/SessaoTemp.json").

% Retorna uma lista com todas as sessoes cadastradas
getSessoesJSON(Sessoes) :-
    constantePATH(Path),
    read_file_to_string(Path, FileString, []),
    atom_string(FileAtom, FileString),
    atom_json_term(FileAtom, Sessoes, [as(term)]).

% Adiciona uma sessao ao arquivo JSON
adicionaSessaoJSON(Sessao) :-
    getSessoesJSON(Sessoes),
    length(Sessoes, Length),
    NewIdent is Length + 1,
    mudaId(Sessao, NewIdent, SessaoComNovoId),
    append(Sessoes, [SessaoComNovoId], NovaLista),
    constanteTempPATH(TempPath),
    open(TempPath, write, Stream),
    write_term(Stream, NovaLista, [as(term)]),
    close(Stream),
    rename_file(constanteTempPATH, constantePATH).

% Muda o id de uma sessao de acordo com a quantidade de sessoes
mudaId(Sessao, NewIdent, SessaoComNovoId) :-
    Sessao = sessao(OldIdent, IdFilme, Capacidade, Horario, IdSala),
    SessaoComNovoId = sessao(NewIdent, Filme, Capacidade, Horario, IdSala).

% Verifica se uma sessao foi cadastrada a partir do id
contemSessao(IdSessao, Sessoes) :-
    member(sessao(IdSessao, _, _, _, _), Sessoes).

% Deleta uma sessao do arquivo JSON a partir do identificador
deletaSessao(Ident) :-
    getSessoesJSON(Sessoes),
    deleteSessaoPorId(Ident, Sessoes, NovaLista),
    length(NovaLista, NewLength),
    length(Sessoes, OldLength),
    NewLength < OldLength,
    constanteTempPATH(TempPath),
    open(TempPath, write, Stream),
    write_term(Stream, NovaLista, [as(term)]),
    close(Stream),
    rename_file(constanteTempPATH, constantePATH).

% Remove uma sessao da lista com base no identificador
deleteSessaoPorId(_, [], []).
deleteSessaoPorId(Ident, [sessao(Ident, _, _, _, _)|T], NovasSessoes) :-
    deleteSessaoPorId(Ident, T, NovasSessoes).
deleteSessaoPorId(Ident, [H|T], [H|NovasSessoes]) :-
    H = sessao(Id, _, _, _, _),
    Id \= Ident,
    deleteSessaoPorId(Ident, T, NovasSessoes).

% Verifica se o horario esta no formato correto, hora >=0 e <=23 e minuto >=0 e <=59
validaHorario(Hora, Minuto) :-
    between(0, 23, Hora),
    between(0, 59, Minuto).

% Função para comparar o horário das sessões
comparaHorarioSessao((Hora1, Minuto1), (Hora2, Minuto2)) :-
    Hora1 =:= Hora2,
    Minuto1 =:= Minuto2.

% Verifica se o filme terminou uma hora antes do inicio de outra sessao
verificaFilmeTerminou(SessaoNova, SessaoExistente) :-
    duracaoFilmeSessaoExistente(SessaoExistente, DuracaoExistente),
    duracaoFilmeSessaoNova(SessaoNova, DuracaoNova),
    horario(SessaoExistente, HorasExistente, MinutosExistente),
    horario(SessaoNova, HorasNova, MinutosNova),
    TotalMinutosExistente is HorasExistente * 60 + DuracaoExistente + MinutosExistente,
    TotalMinutosNova is HorasNova * 60 + DuracaoNova + MinutosNova,
    TotalMinutosSessaoNova is HorasNova * 60 + MinutosNova,
    TotalMinutosSessaoExistente is HorasExistente * 60 + MinutosExistente,
    (   HorasNova < HorasExistente ->
        TotalMinutosSessaoExistente - TotalMinutosNova < 60
    ;   TotalMinutosSessaoNova - TotalMinutosExistente < 60
    ).

% Duração do filme da sessão existente
duracaoFilmeSessaoExistente(sessao(_, filme(_, _, _, Duracao), _), DuracaoFilme) :-
    number_codes(DuracaoFilme, Duracao).

% Duração do filme da sessão nova
duracaoFilmeSessaoNova(sessao(_, filme(_, _, _, Duracao), _), DuracaoFilme) :-
    number_codes(DuracaoFilme, Duracao).

% Horário da sessão
horario(sessao(_, _, Horario, _, _), Horas, Minutos) :-
    Horario = (Horas, Minutos).
