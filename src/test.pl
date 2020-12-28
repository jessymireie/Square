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


get_element(Matrix, Row, Column, Element) :-
    nth1(Row, Matrix, ResultRow),
    element(Column, ResultRow, Element).
append_element(Matrix, Row, Column, Element, List, ResultList) :-
    get_element(Matrix, Row, Column, Element),
    append(List, [Element], ResultList).

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

start_test :-

    %build_list(List),
    buildList(3, 3, [], List),
    %test(List, Result),
    trace,
    get_row(List, [1,1]-[1,3], RowResult),
    nl, nl,
    write(RowResult),

    labeling([], RowResult),

    nl, nl,
    write(RowResult).