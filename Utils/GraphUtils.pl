:- module(graphUtils, [updateWLGraphCandle/3]).

:- use_module('./Utils/MatrixUtils.pl').

updateWLGraphCandle(Filepath, Row, Col) :-
    writeMatrixValue(Filepath, "❚", Row, Col).