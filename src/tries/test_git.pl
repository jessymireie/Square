:- use_module(library(clpfd)).
:- use_module(library(between)).
:- use_module(library(lists)).

% Get row at Index

get_row(Index, N, Size, Square, Row) :-
    N #>= Index * Size,
    prefix_length(Square, Row, Size). 

get_row(Index, N, Size, [_|T], Row) :-
    N #< Index * Size,
    N1 is N + 1,
    get_row(Index, N1, Size, T, Row). 

% Get column at Index

get_column(_, N, Size, _, []) :-
    Aux is Size * Size,
    N >= Aux.

get_column(Index, N, Size, Square, [H|T]) :-
    I is Index + N,  
    N1 is N + Size,
    nth0(I, Square, H),
    get_column(Index, N1, Size, Square, T).

trim(L, N, S) :-         % Trim N elements from a list
    length(P, N),        % Generate an unbound prefix list of the desired length
    append(P, S, L).     % Get the desired suffix.

% Unflatten list by one level

unflatten([], _, []).

unflatten(Vars, Size, [H|T]) :-
    prefix_length(Vars, H, Size),
    trim(Vars, Size, VarsOut), 
    unflatten(VarsOut, Size, T).
    
% Flattens a list by one-level

flatten([], []).

flatten([A|B],L) :- 
    is_list(A),
    flatten(B,B1), 
    !,
    append(A,B1,L).

flatten([A|B], [A|B1]) :- 
    flatten(B, B1).

generate_squares(Size, StartsX, StartsY, SquareSizes, NumSquares) :-
    %MaxNumSquares is Size * Size,                   % Max number squares painted
    %NumSquares #>= 0,                               % Number squares must be greater than or equal to 0
    %NumSquares #< MaxNumSquares,                    % Number squares must be less than max
    NumSquares #= 13,

    length(StartsX, NumSquares),                    % Generate list of x coords
    length(StartsY, NumSquares),                    % Generate list of y coords
    length(SquareSizes, NumSquares),                % Generate list of square sizes

    S is Size - 1,           
                           
    domain(StartsX, 0, S),                          % Constraint X
    domain(StartsY, 0, S),                          % Constraint Y
    domain(SquareSizes, 1, Size),                   % Constraint Size

    construct_squares(Size, StartsX, StartsY, SquareSizes, Squares),    % Creates list of squares
    disjoint2(Squares, [margin(0, 0, 1, 1)]).                           % Gives non-touching and non-overlapping squares

construct_squares(_, [], [], [], []).   % End of recursion

construct_squares(Size, [StartX|T1], [StartY|T2], [SquareSize|T3], [square(StartX, SquareSize, StartY, SquareSize)|T4]) :-
    StartX + SquareSize #=< Size,               % Constraint Size Square
    StartY + SquareSize #=< Size,               % Constraint Size Square
    construct_squares(Size, T1, T2, T3, T4).    % Recursion


solve(Blocked, Rows, Columns, Vars) :-
    % Domain and variables definition

    length(Rows, Size),   

    MaxNumSquares is Size * Size,                
    NumSquares #>= 0,                               
    NumSquares #< MaxNumSquares,      

    length(StartsX, NumSquares),                    
    length(StartsY, NumSquares),                   
    length(SquareSizes, NumSquares),                

    S is Size - 1,           
                           
    domain(StartsX, 0, S),                         
    domain(StartsY, 0, S),                          
    domain(SquareSizes, 1, Size),                  

    construct_squares(Size, StartsX, StartsY, SquareSizes, Squares), 

    % Constraints

    disjoint2(Squares, [margin(0, 0, 1, 1)]),
    lines_constraints(0, Rows, StartsX, SquareSizes),
    lines_constraints(0, Columns, StartsY, SquareSizes),

    % Solution search

    VarsList = [NumSquares, StartsX, StartsY, SquareSizes],
    flatten(VarsList, Vars),
    labeling([], Vars).


    

construct_squares(_, [], [], [], []). 

construct_squares(Size, [StartX|T1], [StartY|T2], [SquareSize|T3], [square(StartX, SquareSize, StartY, SquareSize)|T4]) :-
    StartX + SquareSize #=< Size,              
    StartY + SquareSize #=< Size,
    construct_squares(Size, T1, T2, T3, T4).  

% Rows and columns NumFilledCells cells constraints

lines_constraints(_, [], _, _).

lines_constraints(Index, [NumFilledCells|T], Starts, SquareSizes) :-
    line_constraints(Index, NumFilledCells, Starts, SquareSizes),
    I is Index + 1,
    lines_constraints(I, T, Starts, SquareSizes).

line_constraints(Index, NumFilledCells, Starts, SquareSizes) :-
    findall(
        SquareSize,
        (
            element(N, Starts, Start),  
            element(N, SquareSizes, SquareSize),  
            intersect(Index, Start, SquareSize)
        ),
        Lines),
    sum(Lines, #=, NumFilledCells).
    
% Check if a square intersects a row or column

intersect(Index, Start, SquareSize) :-
    Start #=< Index,
    Index #=< Start + SquareSize.
