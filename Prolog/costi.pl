
cost(nord, Res) :- Res is 1.
cost(sud, Res) :- Res is 1.
cost(est, Res) :- Res is 1.
cost(ovest, Res) :- Res is 1.

f(Nodo, GScore, HScore, FScore):-
    h(Nodo, HScore),
    FScore is GScore + HScore.

h(pos(X1, Y1), HScore) :- 
    finale(pos(X2, Y2)),
    euclideanDistance(X1, Y1, X2, Y2, HScore).
    %manhattanDistance(X1, Y1, X2, Y2, HScore).

manhattanDistance(X1, Y1, X2, Y2, HScore) :-
    HScore is abs(X2 - X1) + abs(Y2 - Y1). 

euclideanDistance(X1, Y1, X2, Y2, HScore) :-    
    HScore is sqrt((X2-X1)^2 + (Y2-Y1)^2). 