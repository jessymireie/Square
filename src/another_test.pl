:- use_module(library(clpfd)).
:- use_module(library(lists)).

create_squares([H|T], SquaresBoard):-
        length(H, Size),
        Square is round(sqrt(Size)),
        create_squares_aux_vertical([H|T] , SquaresBoard, [], Square, 0, Size).

    create_squares_aux_vertical(_, SquaresBoard, SquaresBoard, _, Max, Max).
    create_squares_aux_vertical(Board, SquaresBoard, SquaresBoardAux, N, I, Max):-
        create_squares_aux_horizontal(Board, SquaresBoardLine, [], N, I, 0, Max),
        append(SquaresBoardAux, SquaresBoardLine, SquaresBoardAux2),
        I2 is I + N,
        create_squares_aux_vertical(Board, SquaresBoard, SquaresBoardAux2, N, I2, Max).
        
    create_squares_aux_horizontal(_, SquaresBoard, SquaresBoard, _, _, Max, Max).
    create_squares_aux_horizontal(Board, SquaresBoard, SquaresBoardAux, N, Line, I, Max):-
        create_squares_aux2_vertical(Board, H2, [], I, Line, N, 0),
        append(SquaresBoardAux, [H2], SquaresBoardAux2),
        I2 is I + N,
        create_squares_aux_horizontal(Board, SquaresBoard, SquaresBoardAux2, N, Line, I2, Max).
    

    create_squares_aux2_vertical(_, Square, Square, _, _, N, N).
    create_squares_aux2_vertical(Board, Square, SquareAux, Column, R1, N, Dif):-
       create_squares_aux2_horizontal(Board, Line, [], R1, Column, N, 0),
       append(SquareAux, Line, SquareAux2),
       R2 is R1 +1,
       Dif2 is Dif + 1,
       create_squares_aux2_vertical(Board, Square, SquareAux2, Column, R2,N, Dif2).

    create_squares_aux2_horizontal(_, Square, Square, _, _, N, N).
    create_squares_aux2_horizontal(Board, Square,SquareAux, Row, C1, N, Dif):-
        get_value(Board, Row, C1, Value2),
        append(SquareAux,[Value2], SquareAux2),
        C2 is C1+1,
        Dif2 is Dif +1,
        create_squares_aux2_horizontal(Board, Square, SquareAux2, Row, C2, N, Dif2).