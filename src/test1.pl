:- use_module(library(lists)).
:- use_module(library(clpfd)).

% ----------------- UTILS -----------------
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
% -----------------------------------------------


% Working already ------------------------------------------
apply_row_restrictions(1, Matrix, RowR) :-
    element(1, RowR, Elem),
    nth1(1, Matrix, ResultRow),
    sum(ResultRow, #=, Elem).

apply_row_restrictions(Number, Matrix, RowR) :-
    NewNumber is Number - 1,
    apply_row_restrictions(NewNumber, Matrix, RowR),
    element(Number, RowR, Elem),
    nth1(Number, Matrix, MatrixRow),
    sum(MatrixRow, #=, Elem).

apply_column_restrictions(Number, Matrix, ColumnR) :-
    transpose(Matrix, NewMatrix),
    apply_row_restrictions(Number, NewMatrix, ColumnR).

/*
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
*/
% --------------------------------------------------------




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

generate_square(Matrix, NumberRow, NumberColumn, 0).
generate_square(Matrix, NumberRow, NumberColumn, 1) :-
    length(Matrix, MatrixSize),
    SquareSize #=< MatrixSize - NumberColumn,
    length(List, SquareSize),
    fill_square(Matrix, NumberRow, NumberColumn, SquareSize, 1).
    

%generate_square(Matrix, NumberRow, NumberColumn, 0).
%generate_square(Matrix, NumberRow, NumberColumn, 1) :-

    

checks_position(Matrix, 1, 1) :- %Canto superior esquerdo
    nth1(1, Matrix, ElemRow),
    element(1, ElemRow, Elem),
    Elem #= 1 #<=> B,
    generate_square(Matrix, 1, 1, B).
    % notrace.

checks_position(Matrix, 1, NumberColumn) :- %Linha superior
    LeftNumberColumn is NumberColumn - 1,
    nth1(1, Matrix, RowElem),
    element(LeftNumberColumn, RowElem, ElemLeft),
    element(NumberColumn, RowElem, Elem),
    ElemLeft #= 0 #/\ Elem #= 1 #<=> B,
    generate_square(Matrix, 1, NumberColumn, B).

checks_position(Matrix, NumberRow, 1) :- %Coluna à esquerda
    UpperNumberRow is NumberRow - 1,
    nth1(UpperNumberRow, Matrix, RowElemUp),
    element(1, RowElemUp, ElemUp),
    nth1(NumberRow, Matrix, RowElem),
    element(1, RowElem, Elem),
    ElemUp #= 0 #/\ Elem #= 1 #<=> B,
    generate_square(Matrix, NumberRow, 1, B).

checks_position(Matrix, NumberRow, NumberColumn) :- %Restantes posições
    UpperNumberRow is NumberRow - 1,    % Checks upper row
    nth1(UpperNumberRow, Matrix, RowElemUp),
    OtherNumberColumn is NumberColumn - 1,
    element(OtherNumberColumn, RowElemUp, ElemUpLeft),
    element(NumberColumn, RowElemUp, ElemUp),
    LeftNumberColumn is NumberColumn - 1,   % Checks left cell
    nth1(NumberRow, Matrix, RowElem),
    element(LeftNumberColumn, RowElem, ElemLeft),
    element(NumberColumn, RowElem, Elem),
    ElemUpLeft #= 0 #/\ ElemUp #= 0 #/\ ElemLeft #= 0 #/\ Elem #= 1 #<=> B,
    generate_square(Matrix, NumberRow, 1, B).


generate_corner(Matrix, NumberRow, NumberColumn) :-
    % trace,
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


flatten([], []).
flatten([A|B], L) :- 
    is_list(A),
    flatten(B, B1), 
    !,
    append(A, B1, L).
flatten([A|B], [A|B1]) :- 
    flatten(B, B1).




start_test :-

    %build_list(List),
    %notrace,

    RowR = [2, 2, 2, 2, 3, 2, 2, 5, 3, 4],
    ColumnR = [4, 5, 4, 4, 0, 0, 0, 4, 3, 3],

    % RowR = [1, 1, 0],
    % ColumnR = [1, 1, 0],

    % RowR = [2, 2, 0],
    % ColumnR = [2, 2, 0],

    % RowR = [2, 2, 0],
    % ColumnR = [2, 2, 0],

    ListSize = 10,
    buildList(ListSize, ListSize, [], List),


    apply_row_restrictions(ListSize, List, RowR),
    % apply_column_restrictions(ListSize, ListSize, List, ColumnR),
    apply_column_restrictions(ListSize, List, ColumnR),



    %test(List, Result),
    %trace,
    %get_row(List, [1,1]-[1,3], RowResult),
    %trace,
    %get_column(List, [1,1]-[3,1], ColumnResult),
    % squares(List),
    % nl, nl,
    %write(RowResult),
    % write(List),

    %labeling([], RowResult),

    flatten(List, FinalList),

    %labeling_all(ListSize, List),
    
    labeling([], FinalList),

    % nl, nl,
    write(List).