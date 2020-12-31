:- use_module(library(lists)).
:- use_module(library(clpfd)).

% ----------------- UTILS -----------------
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
% -----------------------------------------------

fill_row(Matrix, NumberRow, NumberColumn, SquareSize, ColumnN) :-
    ColumnN > SquareSize.
fill_row(Matrix, NumberRow, NumberColumn, SquareSize, ColumnN) :-
    nth1(NumberRow, Matrix, RowElem),
    element(NumberColumn, RowElem, Elem),
    Elem #= 1,
    NewColumnN is ColumnN + 1,
    NewNumberColumn is NumberColumn + 1,
    fill_row(Matrix, NumberRow, NewNumberColumn, SquareSize, NewColumnN).

fill_square(Matrix, NumberRow, NumberColumn, SquareSize, RowN) :-
    RowN > SquareSize.
fill_square(Matrix, NumberRow, NumberColumn, SquareSize, RowN) :-
    fill_row(Matrix, NumberRow, NumberColumn, SquareSize, 1),
    NewNumberRow = NumberRow + 1,
    NewRowN is RowN + 1,
    fill_square(Matrix, NewNumberRow, NumberColumn, SquareSize, NewRowN).


generate_square(Matrix, NumberRow, NumberColumn) :-
    length(Matrix, MatrixSize),
    SquareSize #=< MatrixSize - NumberColumn,
    length(List, SquareSize),
    fill_square(Matrix, NumberRow, NumberColumn, SquareSize, 1).
    

checks_position(Matrix, 1, 1) :- %Canto superior esquerdo
    nth1(1, Matrix, ElemRow),
    element(1, ElemRow, Elem),
    Elem #= 1 #<=> generate_square(Matrix, 1, 1).

checks_position(Matrix, 1, NumberColumn) :- %Linha superior
    LeftNumberColumn is NumberColumn - 1,
    nth1(1, Matrix, RowElem),
    element(LeftNumberColumn, RowElem, ElemLeft),
    ElemLeft #= 0,
    element(NumberColumn, ElemRow, Elem),
    Elem #= 1 #<=> generate_square(Matrix, 1, NumberColumn).

checks_position(Matrix, NumberRow, 1) :- %Coluna à esquerda
    UpperNumberRow is NumberRow - 1,
    nth1(UpperNumberRow, Matrix, RowElemUp),
    element(1, RowElemUp, ElemUp),
    ElemUp #= 0,
    nth1(NumberRow, Matrix, RowElem),
    element(1, RowElem, Elem),
    Elem #= 1 #<=> generate_square(Matrix, NumberRow, 1).

checks_position(Matrix, NumberRow, NumberColumn) :- %Restantes posições
    UpperNumberRow is NumberRow - 1,    % Checks upper row
    nth1(UpperNumberRow, Matrix, RowElemUp),
    OtherNumberColumn is NumberColumn - 1,
    element(OtherNumberColumn, RowElemUp, ElemUpLeft),
    element(NumberColumn, RowElemUp, ElemUp),
    ElemUpLeft #= 0,
    ElemUp #= 0,
    LeftNumberColumn is NumberColumn - 1,   % Checks left cell
    nth1(NumberRow, Matrix, RowElem),
    element(LeftNumberColumn, RowElem, ElemLeft),
    ElemLeft #= 0,
    element(NumberColumn, RowElem, Elem),
    Elem #= 1 #<=> generate_square(Matrix, NumberRow, 1).


generate_corner(Matrix, NumberRow, NumberColumn) :-
    checks_position(Matrix, NumberRow, NumberColumn).
% generate_corner(Matrix, NumberRow, NumberColumn).


square_columns(Matrix, NumberRow, NumberColumn) :-
    length(Matrix, MatrixSize),
    NumberColumn > MatrixSize.
square_columns(Matrix, NumberRow, NumberColumn) :-
    generate_corner(Matrix, NumberRow, NumberColumn),
    NewNumberColumn is NumberColumn + 1,
    square_columns(Matrix, NumberRow, NewNumberColumn).


square_rows(Matrix, NumberRow, NumberColumn) :-
    length(Matrix, MatrixSize),
    NumberRow > MatrixSize.
square_rows(Matrix, NumberRow, NumberColumn) :-
    square_columns(Matrix, NumberRow, NumberColumn),
    NewNumberRow is NumberRow + 1,
    square_rows(Matrix, NewNumberRow, NumberColumn).


squares(Matrix) :- %NumberRow a começar por cima (1 -> N)
    %Só mais uma dúvida, a ideia seria então "percorrer" toda a matriz a tentar gerar cantos e, por sua vez, quadrados, 
    %tentando que isso encaixasse com as restrições das linhas/colunas colocadas anteriormente. 
    %Então seria possível usar as restrições materializáveis para chamar as funções de verificação de um canto 
    %consoante já termos ou não "passado" por aquela célula na restrições anteriores

    %Percorrer a matriz
    %Tentar gerar um canto
    % If true
        %Gerar quadrado
    %Continuar a percorrer a matriz

    square_rows(Matrix, 1, 1).
    

labeling_all(1, Matrix) :-
    nth1(1, Matrix, Row),
    labeling([], Row).
labeling_all(Number, Matrix) :-
    NewNumber is Number - 1,
    labeling_all(NewNumber, Matrix),
    nth1(Number, Matrix, Row),
    labeling([], Row).



start_test :-

    %build_list(List),
    %notrace,
    ListSize = 3,
    buildList(ListSize, ListSize, [], List),
    %test(List, Result),
    %trace,
    %get_row(List, [1,1]-[1,3], RowResult),
    %trace,
    %get_column(List, [1,1]-[3,1], ColumnResult),
    squares(List),
    nl, nl,
    %write(RowResult),
    write(List),

    %labeling([], RowResult),

    labeling_all(ListSize, List),

    nl, nl,
    write(List).