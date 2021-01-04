:- include('square.pl').

%4x4
puzzle1:-
    Rows = [1, 0, 2, 2],
    Columns = [1, 0, 2, 2],
    square(Rows,Columns).
    
%4x4
puzzle2:-
    Rows = [2, 0, 0, 2],
    Columns = [2, 0, 0, 2],
    square(Rows,Columns).

%5x5
puzzle3:-
    Rows = [3, 3, 3, 0, 1],
    Columns = [3, 3, 3, 0, 1],
    square(Rows,Columns).

%5x5
puzzle4:-
    Rows = [3, 3, 3, 0, 1],
    Columns = [3, 3, 3, 0, 1],
    square(Rows,Columns).

%6x6
puzzle5:-
    Rows = [1, 1, 1, 1, 1, 1],
    Columns = [1, 1, 1, 1, 1, 1],
    square(Rows,Columns).

%7x7
puzzle6:-
    Rows = [1,1, 1, 1, 1, 1, 1],
    Columns = [1,1, 1, 1, 1, 1, 1],
    square(Rows,Columns).

%8x8
puzzle7:-
    Rows = [1, 1, 1, 1, 1, 1, 1, 1],
    Columns = [1, 1, 1, 1, 1, 1, 1, 1],
    square(Rows,Columns).

%--------------------- bloqueia -------------------
%10x10 
puzzle8:-
    Rows = [2, 2, 2, 2, 3, 2, 2, 5, 3, 4],
    Columns = [4, 5, 4, 4, 0, 0, 0, 4, 3, 3],
    square(Rows,Columns).

%10x10
puzzle9:-
    Rows = [2, 2, 2, 2, 3, 2, 2, 5, 3, 4],
    Columns = [3, 3, 4, 0, 0, 0, 4, 4, 5, 4],
    square(Rows,Columns).