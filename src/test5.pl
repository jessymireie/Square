:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- include('display.pl').

square(StartX, StartY, Lengths) :-
    %Rows = [2, 2, 2, 2, 3, 2, 2, 5, 3, 4],
    %Columns = [4, 5, 4, 4, 0, 0, 0, 4, 3, 3],

    % Rows = [2, 2, 2, 2, 3, 2, 2, 5, 3, 4],
    % Columns = [3, 3, 4, 0, 0, 0, 4, 4, 5, 4],

    %Rows = [3, 3, 3, 0],
    %Columns = [3, 3, 3, 0],

    %Rows = [1, 0, 2, 2],
    %Columns = [1, 0, 2, 2],

    % Rows = [2, 0, 0, 2],
    % Columns = [2, 0, 0, 2],  >> Este dá erro :(

    % StartX = [Ax, Bx, Cx, Dx],
    % StartY = [Ay,By,Cy,Dy],
    % Lengths = [L1, L2, L3, L4],

    %Rows = [3, 3, 3, 0, 1],
    %Columns = [3, 3, 3, 0, 1],

    Rows = [1, 1, 1, 1, 1, 1, 1, 1],
    Columns = [1, 1, 1, 1, 1, 1, 1, 1],

    length(Rows, RowSize),
    get_size(RowSize, Size),

    write('Building lists: '), write(Size), nl,

    % trace,
    build_lists(Rectangles, StartX, StartY, Lengths, NewRectangles, NewStartX, NewStartY, NewLengths, Size, RowSize),


    domain(NewStartX, 1, RowSize),
    domain(NewStartY, 1, RowSize),
    domain(NewLengths, 0, RowSize),


    disjoint2(NewRectangles, [margin(a,a,1,1)]),
    write('Disjoint'), nl,
    line_constraints(NewStartX, NewLengths, 1, Rows),
    write('Rows'), nl,
    line_constraints(NewStartY, NewLengths, 1, Columns),
    write('Columns'), nl,

    orderedSolution(NewStartX, NewStartY),

    append(NewStartX, NewStartY, V),
    write('Append'), nl,
    append(V, NewLengths, Vars),
    write('Append'), nl,

    labeling([], Vars), 
    write(NewStartX), nl,
    write(NewStartY), nl,
    write(NewLengths), nl,

    print_solution(NewStartX, NewStartY, NewLengths, RowSize, _).


orderedSolution([_], [_]).
orderedSolution([X1,X2|X], [Y1,Y2|Y]):-
    (X1 #= X2 #/\ Y1 #< Y2) #\/ X1 #< X2,
    orderedSolution([X2|X],[Y2|Y]),!.



filter_lists_Aux(StartX, StartY, Lengths, 1, StartXFiltered, StartYFiltered, LengthsFiltered) :-
    nth1(1, Lengths, Elem),
    Elem > 0,
    append([], [Elem], LengthsFiltered),
    nth1(1, StartX, ElemX),
    nth1(1, StartY, ElemY),
    append([], [ElemX], StartXFiltered),
    append([], [ElemY], StartYFiltered).
filter_lists_Aux(StartX, StartY, Lengths, 1, StartXFiltered, StartYFiltered, LengthsFiltered) :-
    nth1(NewLengthsSize, Lengths, Elem),
    Elem == 0,
    StartXFiltered = [],
    StartYFiltered = [],
    LengthsFiltered = [].
filter_lists_Aux(StartX, StartY, Lengths, LengthsSize, NewStartXFiltered, NewStartYFiltered, NewLengthsFiltered) :-
    NewLengthsSize is LengthsSize - 1,
    nth1(LengthsSize, Lengths, Elem),
    Elem > 0,
    filter_lists_Aux(StartX, StartY, Lengths, NewLengthsSize, StartXFiltered, StartYFiltered, LengthsFiltered),
    append(LengthsFiltered, [Elem], NewLengthsFiltered),
    nth1(LengthsSize, StartX, ElemX),
    nth1(LengthsSize, StartY, ElemY),
    append(StartXFiltered, [ElemX], NewStartXFiltered),
    append(StartYFiltered, [ElemY], NewStartYFiltered).
filter_lists_Aux(StartX, StartY, Lengths, LengthsSize, NewStartXFiltered, NewStartYFiltered, NewLengthsFiltered) :-
    NewLengthsSize is LengthsSize - 1,
    nth1(LengthsSize, Lengths, Elem),
    Elem == 0,
    filter_lists_Aux(StartX, StartY, Lengths, NewLengthsSize, NewStartXFiltered, NewStartYFiltered, NewLengthsFiltered).

filter_lists(StartX, StartY, Lengths, StartXFiltered, StartYFiltered, LengthsFiltered) :-
    length(Lengths, LengthsSize),
    filter_lists_Aux(StartX, StartY, Lengths, LengthsSize, StartXFiltered, StartYFiltered, LengthsFiltered).


build_matrix(RowSize, RowSize, [H | []]) :-
    length(List, RowSize),
    append([], List, H).
build_matrix(RowSize, ColumnSize, [H | T]) :-
    NewColumnSize is ColumnSize + 1,
    build_matrix(RowSize, NewColumnSize, T),
    length(List, RowSize),
    append([], List, H).


fill_row(StartY, 1, Max, Row) :-
    nth1(StartY, Row, Elem),
    Elem = 1.
fill_row(StartY, Size, SizeConst, Row) :-
    NewStartY is StartY + 1,
    NewSize is Size - 1,
    fill_row(NewStartY, NewSize, SizeConst, Row),
    nth1(StartY, Row, Elem),
    Elem = 1.


fill_aux(StartX, StartY, 1, SizeConst, Matrix) :-
    nth1(StartX, Matrix, Row),
    Max is StartY + 1,
    fill_row(StartY, SizeConst, Max, Row).
fill_aux(StartX, StartY, Size, SizeConst, Matrix) :-
    NewStartX is StartX + 1,
    NewSize is Size -1,
    fill_aux(NewStartX, StartY, NewSize, SizeConst, Matrix),
    nth1(StartX, Matrix, Row),
    fill_row(StartY, SizeConst, SizeConst, Row).


fill_matrix(StartXFiltered, StartYFiltered, LengthsFiltered, 1, Matrix, FilledMatrix) :-
    nth1(1, StartXFiltered, StartXNumber),
    nth1(1, StartYFiltered, StartYNumber),
    nth1(StartXNumber, Matrix, Row),
    nth1(StartYNumber, Row, Elem),
    Elem = 1,
    nth1(1, LengthsFiltered, Size),
    fill_aux(StartXNumber, StartYNumber, Size, Size, Matrix).
fill_matrix(StartXFiltered, StartYFiltered, LengthsFiltered, AuxSize, Matrix, FilledMatrix) :-
    NewAuxSize is AuxSize - 1,
    fill_matrix(StartXFiltered, StartYFiltered, LengthsFiltered, NewAuxSize, Matrix, FilledMatrix),
    nth1(AuxSize, StartXFiltered, StartXNumber),
    nth1(AuxSize, StartYFiltered, StartYNumber),
    nth1(StartXNumber, Matrix, Row),
    nth1(StartYNumber, Row, Elem),
    Elem = 1,
    nth1(AuxSize, LengthsFiltered, Size),
    fill_aux(StartXNumber, StartYNumber, Size, Size, Matrix).


complete_aux(Row, 1) :-
    nth1(1, Row, Elem),
    Elem \== 1,
    Elem = 0.
complete_aux(Row, 1).
complete_aux(Row, RowSize) :-
    nth1(RowSize, Row, Elem),
    Elem \== 1,
    Elem = 0,
    NewRowSize is RowSize - 1,
    complete_aux(Row, NewRowSize).
complete_aux(Row, RowSize) :-
    nth1(RowSize, Row, Elem),
    Elem == 1,
    NewRowSize is RowSize - 1,
    complete_aux(Row, NewRowSize).

complete_matrix(Matrix, 1, RowSize) :-
    nth1(1, Matrix, Row), 
    complete_aux(Row, RowSize).
complete_matrix(Matrix, RowSize, ConstRowSize) :-
    NewRowSize is RowSize - 1, 
    complete_matrix(Matrix, NewRowSize, ConstRowSize),
    nth1(RowSize, Matrix, Row), 
    complete_aux(Row, ConstRowSize).

print_solution(StartX, StartY, Lengths, RowSize, Solution) :-
    filter_lists(StartX, StartY, Lengths, StartXFiltered, StartYFiltered, LengthsFiltered),
    write(StartXFiltered), nl,
    write(StartYFiltered), nl,
    write(LengthsFiltered), nl,
    build_matrix(RowSize, 1, Matrix),
    length(StartXFiltered, AuxSize),
    fill_matrix(StartXFiltered, StartYFiltered, LengthsFiltered, AuxSize, Matrix, FilledMatrix),
    complete_matrix(Matrix, RowSize, RowSize),
    displayMatrix(Matrix, RowSize, 1).




build_lists(Rectangles, StartX, StartY, Lengths, NewRectangles, NewStartX, NewStartY, NewLengths, 1, FixedSize) :-
    NewRectangles = [rect(Ax, L1, Ay, L1, a)], 
    NewStartX = [Ax], 
    NewStartY = [Ay], 
    NewLengths = [L1], 
    % append([Rectangles], [rect(Ax, L1, Ay, L1, a)], NewRectangles),
    % append([StartX], [Ax], NewStartX),
    % append([StartY], [Ay], NewStartY),
    % append([Lengths], [L1], NewLengths),
    Ax + L1 #=< (FixedSize+1),
    Ay + L1 #=< (FixedSize+1).
build_lists(Rectangles, StartX, StartY, Lengths, ResultRectangles, ResultStartX, ResultStartY, ResultLengths, Size, FixedSize) :-
    write(Size), nl,
    NewSize is Size - 1,
    % trace,
    build_lists(Rectangles, StartX, StartY, Lengths, NewRectangles, NewStartX, NewStartY, NewLengths, NewSize, FixedSize),
    append(NewRectangles, [rect(Ax, L1, Ay, L1, a)], ResultRectangles),
    append(NewStartX, [Ax], ResultStartX),
    append(NewStartY, [Ay], ResultStartY),
    append(NewLengths, [L1], ResultLengths),
    write('Appended'), nl,
    Ax + L1 #=< (FixedSize+1),
    Ay + L1 #=< (FixedSize+1).



get_size(RowSize, Size) :-
    Flag is RowSize mod 2,
    Flag == 0,
    Size is (RowSize // 2) * (RowSize // 2).
get_size(RowSize, Size) :-
    Flag is RowSize mod 2,
    Flag == 1,
    Size is ((RowSize + 1)//2) * ((RowSize + 1)//2).


%line_constraints(Coordenates, Lengths, N)
line_constraints(_, _, _, []).
line_constraints(Coordenates, Lengths, LineNo, [LineTotal|RestTotals]):-
    check_line(Coordenates, Lengths, LineNo, Counter),
    LineNo2 is LineNo + 1,
    Counter #= LineTotal,
    line_constraints(Coordenates, Lengths, LineNo2, RestTotals).

check_line([], [], _, 0).
check_line([X|RestX], [L|RestL], LineNo, Counter):-
    LineNo #>= X #/\  LineNo #< (X + L) #<=> B,
    Counter #= Counter2 + (B*L),
    check_line(RestX,RestL, LineNo, Counter2).


% X = [1,1,3,3]
% Y = [1,3,1,3]
% L = [1,1,1,1]