:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- include('display.pl').

square :-
    displayName,
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
    
    /*
        write("Dimension: "),
        read(Number),
    */

    Number is 10,

    buildList(Number, Number, [], Result),

    %Restrictions
    apply_row_restrictions(Number, Result, RowR),
    apply_column_restrictions(Number, Number, Result, ColumnR),
    apply_square_restrictions(Result),

    labeling_all(Number, Result),

    nl, write('Result:'), nl,
    %write(Result)
    displayMatrix(Result,Number,1).


labeling_all(1, Matrix) :-
    nth1(1, Matrix, Row),
    labeling([], Row).
labeling_all(Number, Matrix) :-
    NewNumber is Number -1,
    labeling_all(NewNumber, Matrix),
    nth1(Number, Matrix, Row),
    labeling([], Row).

%---------Restrictions---------------------
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



build_index_lists([H | _] , Result) :-


build_index_lists(List, Result) :-


get_extremes(List, ElemStart-ElemEnd) :- %List - Lista de listas com os indices adjacentes
    length(List, LengthList),
    nth1(1, List, ElemStart),
    nth1(LengthList, List, ElemEnd).



get_row_aux(Matrix, StartColumn, EndColumn, Row) :- %um dos casos base
    StartColumn == EndColumn,
    append([], [StartColumn], Row).
get_row_aux(Matrix, StartColumn, EndColumn, Row) :-
    StartColumn > 0,
    NewStartColumn is StartColumn + 1,
    get_row_aux(Matrix, NewStartColumn, EndColumn, NewRow),
    append(NewRow, [StartColumn], Row).
get_row_aux(Matrix, StartColumn, EndColumn, Row) :- %Se a start column estiver colada a uma parede
    CurrentStartColumn is StartRow + 1,
    NewStartColumn is CurrentStartColumn + 1,
    get_row_aux(Matrix, NewStartColumn, EndColumn, NewRow),
    append(NewRow, [CurrentStartColumn], Row).



get_row(Matrix, [StartRow, StartColumn]-[StartRow, EndColumn], Row) :-
    nth1(StartRow, Matrix, RowList),
    NewStartColumn is StartColumn - 1,
    NewEndColumn is EndColumn + 1,
    get_row_aux(Matrix, NewStartColumn, NewEndColumn, Row),




get_around(Matrix, [StartRow, StartColumn]-[EndRow, EndColumn], Result) :-
    UpperRow is StartRow - 1,
    get_row(Matrix, [UpperRow, StartColumn]-[UpperRow, EndColumn], UpperRow), %get upper row
    get_row(Matrix, [EndRow, StartColumn]-[EndRow, EndColumn], UpperRow), %get lower row
    get_around_aux(Matrix, [StartRow, StartColumn]-[EndRow, EndColumn], Result)
    nth1()


get_square_around(Matrix, List, Result) :- %List - Lista de listas com os indices adjacentes
    get_extremes(List, Extremes),
    get_around(Matrix, Extremes, Result).

    
make_empty()


square_restrictions(Matrix, List) :-
    %get_square_around(Result)
    %checks_filled(Result) result é o que está À volta
    square_restrictions(Matrix, ListaComSquareEoqUEEstaAVolta).
square_restrictions(Matrix, List) :-
square_restrictions(Matrix, List) :-
square_restrictions(Matrix, List) :-
square_restrictions(Matrix, List) :-




apply_square_restrictions(Matrix):-
    % for each row
        %for each cell
        %square_restrictions(Matrix, [cell])


%--------------------------------------------------------    

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




