:- [azioni].
%:- [labirinto_noexit].
:- [labirinto].
%:- [labirinto20].
%:- [labirinto_2exit].
%:- [labirinto_ostacolato].
%:- [labirinto_50_4exit].
%:- [labirinto_50].
:- [costi].

start :-
  statistics(walltime, [TimeSinceStart | [_]]),
  ida_star,
  statistics(walltime, [NewTimeSinceStart | [ExecutionTime]]),
  write('Execution took '), write(ExecutionTime), write(' ms.'), nl.


ida_star() :-
  iniziale(S),
  f(S, 0, HScore, FScore),
  ida_star_aux(FScore-node(S, [], 0, HScore), [S], FScore, Solution),
  write(Solution),
  write('Execution took '), write(ExecutionTime), write(' ms.'), nl.


ida_star_aux(S, Visited, Bound, Sol) :-
  ida_star_dfs(S, Visited, Bound, Sol).

% se fallisce la ricerca in profondità con Bound
ida_star_aux(S, Visited, Bound, Sol) :-
  findall(FScore, FScore-node(_,_,_,_), Bounds),  % trovo tutti i nodi (nel DB) che sono stati esplorati
  exclude(>=(Bound), Bounds, HigherBounds),
  sort(HigherBounds, [MinBound | _]), % il minimo bound più grande di Bound
  ida_star_aux(S, Visited, MinBound, Sol).
  
  
ida_star_dfs(_-node(Pos, Actions, _, _), _, _, Actions) :-
  finale(Pos).

ida_star_dfs(_-node(S, SActions, GScore, _), Visited, Bound, [Action | OtherActions]) :-
  applicabile(Action, S),
  trasforma(Action, S, SNew),
  \+member(SNew, Visited),
  cost(Action, GScoreEdge),
  GScoreNew is GScore+GScoreEdge,
  f(SNew, GScoreNew, HScoreNew, FScoreNew),
  assert(FScoreNew-node(SNew, [Action|OtherActions], GScoreNew, HScoreNew)),
  FScoreNew =< Bound,
  ida_star_dfs(FScoreNew-node(SNew, SActions, GScoreNew, HScoreNew), [SNew | Visited], Bound, OtherActions).


