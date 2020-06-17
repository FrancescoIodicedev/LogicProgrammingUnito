:- [azioni].
:- [labirinto_noexit].
%:- [labirinto].
%:- [labirinto20].
%:- [labirinto_2exit].
%:- [labirinto_ostacolato].
%:- [labirinto_50_4exit].
%:- [labirinto_50].

iterative_deepening(Soluzione, Profondita) :-
    iterative_deepening_aux(Soluzione, 1),
    length(Soluzione, Profondita),
    write('Risultato: '), write(Soluzione), write('\n'),
    write('Execution took '), write(ExecutionTime), write(' ms.'), nl.
  
iterative_deepening_aux(Soluzione, SogliaIniziale) :-
  depth_limit_search(Soluzione,SogliaIniziale).

iterative_deepening_aux(Soluzione, SogliaIniziale) :-
  NuovaSoglia is SogliaIniziale+1,
  write('Soglia attuale:'),write(NuovaSoglia),write('\n'),
  iterative_deepening_aux(Soluzione, NuovaSoglia),!.

depth_limit_search(Soluzione, Soglia) :-
  iniziale(S),
  dfs_aux(S, Soluzione, [S], Soglia).

dfs_aux(S, [], _, _) :- finale(S).
dfs_aux(S, [Azione|AzioniTail], Visitati, Soglia) :-
  Soglia>0,
  applicabile(Azione, S),
  trasforma(Azione, S, SNuovo),
  \+member(SNuovo, Visitati),
  NuovaSoglia is Soglia-1,
  dfs_aux(SNuovo, AzioniTail, [SNuovo|Visitati], NuovaSoglia).