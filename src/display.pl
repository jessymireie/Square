/*  L1: lista com o numero de cada linha
    L2: lista com o numero de cada coluna.
intialSquare(L1, L2, Lines, Columns):-
    writeLine, nl,
    writeColumn(L),
    writeLineNumber(Line1),
    ....
    write('  '),writeColumns(Columns).


    Columns: numeros que aparecem em baixo
writeColumns([]).
writeColumns([C|R]):-
    write(C),write('   '),
    writeColumns(R).



    L: lista de 0 e 1 em que o quadrado fica pintado ou não
writeColumn(L)
    
    0:quadrado não pintado
 writeSquare(0):-
    write('| 0 ').

    1: quadrado pintado
 writeSquare(1):-
    write('| 1 ').

    */





/*Tentar descobrir o padrão*/
initialSquare:-
    writeLine, nl , writeColumn, writeLineNumber(2), nl, 
    writeLine, nl , writeColumn, writeLineNumber(2), nl, 
    writeLine, nl , writeColumn, writeLineNumber(2), nl, 
    writeLine, nl , writeColumn, writeLineNumber(2), nl, 
    writeLine, nl , writeColumn, writeLineNumber(3), nl, 
    writeLine, nl , writeColumn, writeLineNumber(2), nl, 
    writeLine, nl , writeColumn, writeLineNumber(2), nl, 
    writeLine, nl , writeColumn, writeLineNumber(5), nl, 
    writeLine, nl , writeColumn, writeLineNumber(3), nl, 
    writeLine, nl , writeColumn, writeLineNumber(4), nl, writeLine,nl,
    write('  '),writeColumnNumber(4), write('   '),
    writeColumnNumber(5), write('   '),
    writeColumnNumber(4), write('   '),
    writeColumnNumber(4), write('   '),
    writeColumnNumber(0), write('   '),
    writeColumnNumber(0), write('   '),
    writeColumnNumber(0), write('   '),
    writeColumnNumber(4), write('   '),
    writeColumnNumber(3), write('   '),
    writeColumnNumber(3).
    

writeLine:-
    write('-----------------------------------------').

writeColumn:-
    write('| 1 |   |   |   |   |   |   |   |   |   | ').

/*numero que aparece em cada linha*/
writeLineNumber(N):-
    write(N).

writeColumnNumber(N):-
    write(N).

initial:-
    initialSquare.