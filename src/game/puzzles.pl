:- include('square.pl').

puzzle1:-
    Rows = [1, 1, 1, 1, 1, 1, 1, 1],
    Columns = [1, 1, 1, 1, 1, 1, 1, 1],
    square(Rows,Columns).
    
puzzle2:-
    Rows = [2, 2, 2, 2, 3, 2, 2, 5, 3, 4],
    Columns = [4, 5, 4, 4, 0, 0, 0, 4, 3, 3],
    square(Rows,Columns).

puzzle3:-
    Rows = [2, 2, 2, 2, 3, 2, 2, 5, 3, 4],
    Columns = [3, 3, 4, 0, 0, 0, 4, 4, 5, 4],
    square(Rows,Columns).
    
puzzle4:-
    Rows = [3, 3, 3, 0],
    Columns = [3, 3, 3, 0],
    square(Rows,Columns).

puzzle5:-
    Rows = [1, 0, 2, 2],
    Columns = [1, 0, 2, 2],
    square(Rows,Columns).
    
puzzle6:-
    Rows = [2, 0, 0, 2],
    Columns = [2, 0, 0, 2],
    square(Rows,Columns).

puzzle7:-
    Rows = [3, 3, 3, 0, 1],
    Columns = [3, 3, 3, 0, 1],
    square(Rows,Columns).

puzzle8:-
    Rows = [3, 3, 3, 0, 1],
    Columns = [3, 3, 3, 0, 1],
    square(Rows,Columns).

puzzle8:-
    Rows = [1, 1, 1, 1, 1, 1],
    Columns = [1, 1, 1, 1, 1, 1],
    square(Rows,Columns).