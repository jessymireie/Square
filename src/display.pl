:- use_module(library(lists)).

displayName:-
    write("------ S Q U A R E ------").

writeRow(Number,Number,Row):- 
    nth1(Number,Row,Elem),
    write(Elem),
    write(' |').

writeRow(0,Number,Row):-write('| '),writeRow(1,Number,Row).

writeRow(N,Number,Row):-
    nth1(N,Row,Elem),
    write(Elem),
    write(' | '),
    NewN is N +1,
    writeRow(NewN,Number,Row).


writeLine(0):-write('-').
writeLine(Number):-
    write('----'),
    NewNumber is Number - 1,
    writeLine(NewNumber).


displayMatrix(Matrix,Dimension,Dimension):-
    writeLine(Dimension),nl,
    nth1(Dimension,Matrix,Row),
    writeRow(0,Dimension,Row),nl,
    writeLine(Dimension).
    
displayMatrix(Matrix,Dimension,Number):-
    writeLine(Dimension),nl,
    nth1(Number,Matrix,Row),
    writeRow(0,Dimension,Row),nl,
    NewNumber is Number + 1,
    displayMatrix(Matrix,Dimension,NewNumber).