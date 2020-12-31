:- use_module(library(lists)).
:- use_module(library(clpfd)).

build_index_lists([H | _] , Result).

build_index_lists(List, Result).


get_square_around(Matrix, List) :- %List - Lista de listas com os indices adjacentes
    findall(List, [H | _], Result),
    build_index_lists(List, Result).


test(List, ElemStart-ElemEnd) :- %List - Lista de listas com os indices adjacentes
    length(List, LengthList),
    nth1(1, List, ElemStart),
    nth1(LengthList, List, ElemEnd).



% ---------------- AUX JÁ NO GAME.PL -------------------------
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
    
get_column_one(1, NumberColumn, Matrix, List) :- 
    nth1(1, Matrix, Row),
    element(NumberColumn, Row, Elem),
    append([], [Elem], List).
get_column_one(NumberRow, NumberColumn, Matrix, List) :-
    NewNumberRow is NumberRow - 1,
    get_column(NewNumberRow, NumberColumn, Matrix, NewList),
    nth1(NumberRow, Matrix, Row),
    element(NumberColumn, Row, Elem),
    append(NewList, [Elem], List). 

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
% ---------------------------------------------------------------



build_index_list(List) :-
    List = [
        [1, 1], [1, 2], [1, 3],
        [2, 1], [2, 2], [2, 3],
        [3, 1], [3, 2], [3, 3]
    ].

build_list(List) :-
    List = [
        [1, 0, 1],
        [0, 1, 0],
        [1, 0, 1]
    ].




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






start_test :-

    %build_list(List),
    %notrace,
    buildList(3, 3, [], List),
    %test(List, Result),
    %trace,
    %get_row(List, [1,1]-[1,3], RowResult),
    %trace,
    get_column(List, [1,1]-[3,1], ColumnResult),
    nl, nl,
    %write(RowResult),
    write(ColumnResult),

    %labeling([], RowResult),
    labeling([], ColumnResult),

    nl, nl,
    write(ColumnResult).