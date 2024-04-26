:- module(UpdateUtils, [resetMenu/2]).

resetMenu(Target, OriginalPath) :-
    open(Target, write, StreamTarget),
    open(OriginalPath, read, StreamOriginal),
    copy_stream_data(StreamOriginal, StreamTarget),
    close(StreamTarget),
    close(StreamOriginal).