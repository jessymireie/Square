:- use_module(library(lists)).

displayName:-
    nl,write(' S Q U A R E '), nl.

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

displayColumns(Dimension,Dimension,Columns):- 
    nth1(Dimension,Columns,Elem),
    write(Elem).

displayColumns(0,Dimension,Columns):-write('  '),displayColumns(1,Dimension,Columns).

displayColumns(N,Dimension,Columns):-
    nth1(N,Columns,Elem),
    write(Elem),
    write('   '),
    NewN is N +1,
    displayColumns(NewN,Dimension,Columns).


writeLine(0):-write('-').
writeLine(Number):-
    write('----'),
    NewNumber is Number - 1,
    writeLine(NewNumber).


displayMatrix(Matrix,Dimension,Dimension,Rows):-
    writeLine(Dimension),nl,
    nth1(Dimension,Matrix,Row),
    writeRow(0,Dimension,Row),
    nth1(Dimension,Rows,RowNumber),
    write(' '),write(RowNumber),nl,
    writeLine(Dimension).
    
displayMatrix(Matrix,Dimension,Number, Rows):-
    writeLine(Dimension),nl,
    nth1(Number,Matrix,Row),
    writeRow(0,Dimension,Row),
    nth1(Number,Rows,RowNumber),
    write(' '),write(RowNumber),nl,
    NewNumber is Number + 1,
    displayMatrix(Matrix,Dimension,NewNumber,Rows).