:- use_module(library(clpfd)).
:- use_module(library(lists)).

square :-
    %4 x 4
    % Row restrictions
    RowR = [2, 2, 2, 2, 3, 2, 2, 5, 3, 4],
    % Column Restrictions

    ColumnR = [4, 5, 4, 4, 0, 0, 0, 4, 3, 3],
    /*
    |                      [4º
    |                   [3º
    |               1 [2º
    |               1 -> RowR [1º

     1   1   1   1 -> ColumnR
    */

    Number is 10,

    buildList(Number, Number, [], Result),
    /*domain(Result, 0, 1),

    element(1, ResultRow, Elem),
    Elem #= 1,
    /*
    element(1, Result, Row),
    element(1, Row, Elem),
    */
    %element(1, Result, ResultRow),

    apply_row_restrictions(Number, Result, RowR),
    %trace,
    apply_column_restrictions(Number, Number, Result, ColumnR),
    %notrace,
    /*
    nth1(1, Result, ResultRow),
    element(1, ResultRow, Elem),
    Elem #= 1,
    */

    labeling_all(Number, Result),

    nl, write('Result:'), nl,
    write(Result).


labeling_all(1, Matrix) :-
    nth1(1, Matrix, Row),
    labeling([], Row).
labeling_all(Number, Matrix) :-
    NewNumber is Number -1,
    labeling_all(NewNumber, Matrix),
    nth1(Number, Matrix, Row),
    labeling([], Row).


apply_row_restrictions(1, Result, RowR) :-
    element(1, RowR, Elem),
    nth1(1, Result, ResultRow),
    sum(ResultRow, #=, Elem).

apply_row_restrictions(Number, Result, RowR) :-
    NewNumber is Number - 1,
    apply_row_restrictions(NewNumber, Result, RowR),
    element(Number, RowR, Elem),
    nth1(Number, Result, ResultRow),
    sum(ResultRow, #=, Elem).


get_column(1, NumberColumn, Matrix, List) :- 
    nth1(1, Matrix, Row),
    element(NumberColumn, Row, Elem),
    append([], [Elem], List).
get_column(NumberRow, NumberColumn, Matrix, List) :-
    NewNumberRow is NumberRow - 1,
    get_column(NewNumberRow, NumberColumn, Matrix, NewList),
    nth1(NumberRow, Matrix, Row),
    element(NumberColumn, Row, Elem),
    append(NewList, [Elem], List).


apply_column_restrictions(NumberRow, 1, Matrix, ColumnR) :-
    element(1, ColumnR, Elem),
    get_column(NumberRow, 1, Matrix, ResultColumn),
    sum(ResultColumn, #=, Elem).
    
apply_column_restrictions(NumberRow, NumberColumn, Matrix, ColumnR) :-
    NewNumberColumn is NumberColumn - 1,
    apply_column_restrictions(NumberRow, NewNumberColumn, Matrix, ColumnR),
    element(NumberColumn, ColumnR, Elem),
    get_column(NumberRow, NumberColumn, Matrix, ResultColumn),
    sum(ResultColumn, #=, Elem).

    

    

buildRow(1, List, Result) :- 
    append(List, [Variable], Result).
buildRow(Number, List, Result) :-
    NewNumber is Number - 1,
    buildRow(NewNumber, List, NewList),
    append(NewList, [Variable], Result), write(Result).


buildList(NumberColumn, 1, List, Result) :-
    buildRow(NumberColumn, [], RowResult),
    domain(RowResult, 0, 1),
    append(List, [RowResult], Result).

buildList(NumberColumn, NumberRow, List, Result) :-
    buildRow(NumberColumn, [], RowResult),
    domain(RowResult, 0, 1),
    NewNumber is NumberRow - 1,
    buildList(NumberColumn, NewNumber, List, NewList),
    append(NewList, [RowResult], Result).







oldBuildRow(1, List, Result) :- append(List, [0], Result).
oldBuildRow(Number, List, Result) :-
    NewNumber is Number - 1,
    buildRow(NewNumber, List, NewList),
    append(NewList, [0], Result), write(Result).




