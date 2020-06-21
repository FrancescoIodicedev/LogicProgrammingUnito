:- [azioni].
:- [costi].

%:- [labirinto].
%:- [labirinto20].
%:- [labirinto_noexit].
%:- [labirinto_ostacolato].
%:- [labirinto_2exit].
%:- [labirinto_50].
:- [labirinto_50_4exit].

:- dynamic(currentBound/1).
:- dynamic(minHigherBound/1).

multi :-
  findall(P, finaleM(P), Finali),
  multi_aux(Finali).

multi_aux([Finale | _]) :-
  assert(finale(Finale)),
  write('Uso il finale: '), write(Finale), write('\n'),
  start.

multi_aux([_ | AltriFinali]) :-
  retractall(finale(_)),
  write('Finale non raggiungibile, skippo\n'),
  multi_aux(AltriFinali).
  

start :-
  statistics(walltime, [_ | [_]]),
  ida_star,
  statistics(walltime, [_ | [ExecutionTime]]),
  write('Execution took '), write(ExecutionTime), write(' ms.'), nl.


ida_star() :-
  iniziale(S),
  f(S, 0, HScore, FScore),
  ida_star_aux(FScore-node(S, [], 0, HScore), [S], FScore, Solution),
  write('Sol: '), write(Solution), write('\n'),
  length(Solution, D),
  write('Depth='), write(D), write('\n').

ida_star_aux(S, Visited, Bound, Sol) :-
  assert(currentBound(Bound)),
  assert(minHigherBound(1000)),
  %write('Parto con bound='), write(Bound), write('\n'),
  ida_star_dfs_ordered(S, Visited, Bound, Sol), !.

% se fallisce la ricerca in profondità con Bound
ida_star_aux(S, Visited, Bound, Sol) :-
  minHigherBound(MinHigherBound),
  %write('MinHigherBound='), write(MinHigherBound), write('\n'),
  retractall(currentBound(_)),
  retractall(minHigherBound(_)),
  BoundC is ceiling(MinHigherBound),
  ida_star_aux(S, Visited, BoundC, Sol).

zip([L1H], [L2H], [L1H-L2H]) :- !.
zip([], [], _).
zip([L1H | L1], [L2H | L2], [L1H-L2H | Pairs]):-
  zip(L1, L2, Pairs).

unzip([L1H-L2H], [L1H], [L2H]) :- !.
unzip([], [], _).
unzip([L1H-L2H | Pairs], [L1H | L1], [L2H | L2]) :-
  unzip(Pairs, L1, L2).

sort_actions(S, GScore, SortedActions) :-
  findall(Action, (applicabile(Action, S)), ApplicableActions),
  maplist(cost, ApplicableActions, EdgeActionsCost),
  maplist(plus(GScore), EdgeActionsCost, ActionsCost),
  maplist(trasforma(S), ApplicableActions, Nodes),
  maplist(f, Nodes, ActionsCost, _, FScores),

  zip(FScores, ApplicableActions, SortableActions),
  keysort(SortableActions, SortedKActions),  
  unzip(SortedKActions, _, SortedActions).


update_min_higher_bound(FScore) :-
  currentBound(Bound),
  minHigherBound(MinHigherBound),
  FScore > Bound,
  FScore < MinHigherBound,
  retractall(minHigherBound(_)),
  assert(minHigherBound(FScore)).

update_min_higher_bound(_).


ida_star_dfs(_-node(Pos, Actions, _, _), _, _, _, Actions) :-
  finale(Pos), !.

ida_star_dfs(_-node(S, SActions, GScore, _), Visited, Bound, Action, Sol) :-
  trasforma(Action, S, SNew),
  \+member(SNew, Visited),
  cost(Action, GScoreEdge),
  GScoreNew is GScore+GScoreEdge,
  f(SNew, GScoreNew, HScoreNew, FScoreNew),
  update_min_higher_bound(FScoreNew),
  FScoreNew =< Bound,
  ida_star_dfs_ordered(FScoreNew-node(SNew, [Action | SActions], GScoreNew, HScoreNew), [SNew | Visited], Bound, Sol).

ida_star_dfs_it([Action | _], FScore-node(S, SActions, GScore, HScore), Visited, Bound, Sol) :-
  ida_star_dfs(FScore-node(S, SActions, GScore, HScore), Visited, Bound, Action, Sol).

ida_star_dfs_it([_ | OtherActions], FScore-node(S, SActions, GScore, HScore), Visited, Bound, Sol) :-
  ida_star_dfs_it(OtherActions, FScore-node(S, SActions, GScore, HScore), Visited, Bound, Sol).

ida_star_dfs_ordered(FScore-node(S, SActions, GScore, HScore), Visited, Bound, Sol) :-
  sort_actions(S, GScore, SortedActions),
  ida_star_dfs_it(SortedActions, FScore-node(S, SActions, GScore, HScore), Visited, Bound, Sol).