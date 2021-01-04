:- use_module(library(clpfd)).
:- use_module(library(lists)).

square(StartX, StartY, Lengths):-
    %Rows = [3, 3, 3, 0],
    %Columns = [3, 3, 3, 0],
    Rows = [1, 1, 1],
    Columns = [1, 1, 1],

    StartX = [Ax, Bx, Cx, Dx],
    StartY = [Ay,By,Cy,Dy],
    Lengths = [L1, L2, L3, L4],

    length(Rows, N),
    domain(StartX, 1, N),
    domain(StartY, 1, N),
    domain(Lengths, 0, N),

    Rectangles = [
        rect(Ax, L1, Ay, L1, a),
        rect(Bx, L2, By, L2, a),
        rect(Cx, L3, Cy, L3, a),
        rect(Dx, L4, Dy, L4, a)
        % rect(Ex, L5, Ey, L5, a)
    ],

    Ax + L1 #=< (N+1),
    Ay + L1 #=< (N+1),
    Bx + L2 #=< (N+1),
    By + L2 #=< (N+1),
    Cx + L3 #=< (N+1),
    Cy + L3 #=< (N+1),
    Dx + L4 #=< (N+1),
    Dy + L4 #=< (N+1),
    % Ex + L5 #=< (N+1),
    % Ey + L5 #=< (N+1),

    disjoint2(Rectangles, [margin(a,a,1,1)]),
    line_constraints(StartX, Lengths, 1, Rows),
    line_constraints(StartX, Lengths, 1, Cols),
    append(StartX, StartY, V),
    append(V, Lengths, Vars),
    labeling([], Vars).


buildRow(1, List, Result) :- 
    append(List, [Variable], Result).
buildRow(Number, List, Result) :-
    NewNumber is Number - 1,
    buildRow(NewNumber, List, NewList),
    append(NewList, [Variable], Result).

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