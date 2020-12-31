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
    %apply_square_restrictions(Result),

    disjoint2(SquareList, [wrap(1, Number, 1, Number)]),

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
    get_column_one(NumberRow, 1, Matrix, ResultColumn),
    sum(ResultColumn, #=, Elem).
    
apply_column_restrictions(NumberRow, NumberColumn, Matrix, ColumnR) :-
    NewNumberColumn is NumberColumn - 1,
    apply_column_restrictions(NumberRow, NewNumberColumn, Matrix, ColumnR),
    element(NumberColumn, ColumnR, Elem),
    get_column_one(NumberRow, NumberColumn, Matrix, ResultColumn),
    sum(ResultColumn, #=, Elem).


/*
build_index_lists([H | _] , Result) :-
build_index_lists(List, Result) :-
*/


get_extremes(List, ElemStart-ElemEnd) :- %List - Lista de listas com os indices adjacentes
    length(List, LengthList),
    nth1(1, List, ElemStart),
    nth1(LengthList, List, ElemEnd).



get_row_aux(MatrixRow, RowNumber, StartColumn, EndColumn, Row) :- %um dos casos base, se a ultima coluna passar do limite da matrix entao não dá append
    write(RowNumber), nl,
    length(MatrixRow, Length),
    EndColumn > Length.
get_row_aux(MatrixRow, RowNumber, StartColumn, EndColumn, Row) :- %um dos casos base
    write(RowNumber), nl,
    StartColumn == EndColumn,
    element(StartColumn, MatrixRow, Element),
    append([], [Element], Row).
get_row_aux(MatrixRow, RowNumber, StartColumn, EndColumn, Row) :-
    write(RowNumber), nl,
    StartColumn > 0,
    NewStartColumn is StartColumn + 1,
    get_row_aux(MatrixRow, RowNumber, NewStartColumn, EndColumn, NewRow),
    element(StartColumn, MatrixRow, Element),
    append(NewRow, [Element], Row).
get_row_aux(MatrixRow, RowNumber, StartColumn, EndColumn, Row) :- %Se a start column estiver colada a uma parede
    write(RowNumber), nl,
    CurrentStartColumn is StartColumn + 1,
    NewStartColumn is CurrentStartColumn + 1,
    get_row_aux(MatrixRow, RowNumber, NewStartColumn, EndColumn, NewRow),
    element(StartColumn, MatrixRow, Element),
    append(NewRow, [Element], Row).


get_row(Matrix, [0, StartColumn]-[0, EndColumn], []).
get_row(Matrix, [StartRow, StartColumn]-[StartRow, EndColumn], []) :-
    length(Matrix, LengthNumber),
    StartRow > LengthNumber.
get_row(Matrix, [StartRow, StartColumn]-[StartRow, EndColumn], Row) :-
    StartRow > 0,
    nth1(StartRow, Matrix, RowList),
    get_row_aux(RowList, StartRow, StartColumn, EndColumn, Row).


get_column_aux(MatrixColumn, ColumnNumber, StartRow, EndRow, Column) :- %um dos casos base, se a ultima coluna passar do limite da matrix entao não dá append
    write(ColumnNumber), write('-'), write(StartRow), nl,
    write(Column), nl,
    length(MatrixColumn, Length),
    EndRow > Length.
get_column_aux(MatrixColumn, ColumnNumber, StartRow, EndRow, Column) :- %um dos casos base
    write(ColumnNumber), write('-'), write(StartRow), nl,
    write(Column), nl,
    StartRow == EndRow,
    element(StartRow, MatrixColumn, Element),
    append([], [Element], Column),
    write('Column: '), write(Column).
get_column_aux(MatrixColumn, ColumnNumber, StartRow, EndRow, Column) :-
    write(ColumnNumber), write('-'), write(StartRow), nl,
    write(Column), nl,
    StartRow > 0,
    NewStartRow is StartRow + 1,
    get_column_aux(MatrixColumn, ColumnNumber, NewStartRow, EndRow, NewColumn),
    element(StartRow, MatrixColumn, Element),
    append(NewColumn, [Element], Column),
    write('Column: '), write(Column).
get_column_aux(MatrixColumn, ColumnNumber, StartRow, EndRow, Column) :- %Se a start Row estiver colada a uma parede
    write(ColumnNumber), write('-'), write(StartRow), nl,
    write(Column), nl,
    CurrentStartRow is StartRow + 1,
    NewStartRow is CurrentStartRow + 1,
    get_column_aux(MatrixColumn, ColumnNumber, NewStartRow, EndRow, NewColumn),
    element(StartRow, MatrixColumn, Element),
    append(NewColumn, [Element], Column),
    write('Column: '), write(Column).

get_column(Matrix, [StartRow, 0]-[StartRow, 0], []).
get_column(Matrix, [StartRow, StartColumn]-[EndRow, StartColumn], []) :-
    length(Matrix, LengthNumber),
    StartColumn > LengthNumber.
get_column(Matrix, [StartRow, StartColumn]-[EndRow, StartColumn], Column) :-
    StartColumn > 0,
    get_column_generic(EndRow, StartRow, StartColumn, Matrix, ColumnList),
    %nth1(StartRow, Matrix, RowList).
    get_column_aux(ColumnList, StartColumn, StartRow, EndRow, Column).




get_around(Matrix, [StartRow, StartColumn]-[EndRow, EndColumn], Result) :-
    UpperRow is StartRow - 1,
    LowerRow is EndRow + 1,
    LeftColumn is StartColumn - 1,
    RightColumn is EndColumn + 1,
    get_row(Matrix, [UpperRow, LeftColumn]-[UpperRow, RightColumn], UpperRowList), %get upper row
    get_row(Matrix, [EndRow, LeftColumn]-[EndRow, RightColumn], LowerRowList), %get lower row
    get_column(Matrix, [StartRow, LeftColumn]-[EndRow, LeftColumn], LeftColumnList), %Left column
    get_column(Matrix, [StartRow, RightColumn]-[EndRow, RightColumn], RightColumnList), %Left column
    %get_around_aux(Matrix, [StartRow, StartColumn]-[EndRow, EndColumn], Result)
    append([], UpperRowList, TempList1),
    append(TempList1, LowerRowList, TempList2),
    append(TempList2, LeftColumnList, TempList3),
    append(TempList3, RightColumnList, Result).


set_around_zero([]).
set_around_zero([H | T]) :-
    H #= 0,
    set_around_zero(T).



get_square_around(Matrix, List, Result) :- %List - Lista de listas com os indices adjacentes
    get_extremes(List, Extremes),
    get_around(Matrix, Extremes, Result),
    set_around_zero(Result).

    
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

% NumberRowFinish has to be smaller
get_column_generic(NumberRowFinish, NumberRowFinish, NumberColumn, Matrix, List) :- 
    nth1(1, Matrix, Row),
    element(NumberColumn, Row, Elem),
    append([], [Elem], List).
get_column_generic(NumberRowStart, NumberRowFinish, NumberColumn, Matrix, List) :-
    NewNumberRow is NumberRowStart - 1,
    get_column_generic(NewNumberRow, NumberRowFinish, NumberColumn, Matrix, NewList),
    nth1(NumberRow, Matrix, Row),
    element(NumberColumn, Row, Elem),
    append(NewList, [Elem], List). 


get_column_one(1, NumberColumn, Matrix, List) :- 
    nth1(1, Matrix, Row),
    element(NumberColumn, Row, Elem),
    append([], [Elem], List).
get_column_one(NumberRow, NumberColumn, Matrix, List) :-
    NewNumberRow is NumberRow - 1,
    get_column_one(NewNumberRow, NumberColumn, Matrix, NewList),
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




