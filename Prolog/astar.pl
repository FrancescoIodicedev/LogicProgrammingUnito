:- [azioni].
:- [costi].
%:- [labirinto20].
%:- [labirinto_noexit].
%:- [labirinto].
%:- [labirinto_2exit].
:- [labirinto_50_4exit].
%:- [labirinto_50].
%:- [labirinto_ostacolato].

cls :- write('\e[H\e[2J').

start :-
    statistics(walltime, [TimeSinceStart | [_]]),
    astar,
    statistics(walltime, [NewTimeSinceStart | [ExecutionTime]]),
    write('Execution took '), write(ExecutionTime), write(' ms.'), nl.

astar():-
  iniziale(S),
  f(S, 0, HStart, FStart),
  astar_aux(FStart-node(S, [], 0, HStart), [FStart-node(S, [], 0, HStart)], [], Res),
  write('Risultato: '), write(Res), write('\n').

astar_aux(_-node(N, ActionsToE, _, _), _, _, ActionsToE) :- 
    finale(N),
    !. % ho raggiunto il node finale -> cut

astar_aux(N, Open, Closed, Res) :-
    %write('Parto da nodo N='), write(N),  write('\n'),
    %write('\n open='), write(Open),
    % espando il nodo N
    expandNode(N, Open, Closed, NewOpen),
    % la lista open è una key-value pair dove key=FScore
    keysort(NewOpen, [LowestNode | OtherNodes]),
    %write('Nodi espansi: '), write(LowestNode), write(' '), write(OtherNodes), write('\n\n'),
    % continuo da nodo con lowest FScore
    astar_aux(LowestNode, OtherNodes, [N | Closed], Res).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% genNode(Action, A, B)
genNode(Action, _-node(A, ActionsToA, GScoreA, _), FScoreB-node(B, [Action | ActionsToA], GScoreB, HScoreB)) :-
    trasforma(Action, A, B),
    cost(Action, GEdge),
    GScoreB is GScoreA+GEdge,
    f(B, GScoreB, HScoreB, FScoreB).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1. se il nodo non è già in open, allora di default ha uno score migliore
nodeHasBetterScore(_, []) :-
    %\+member(N, Open),
    %write('\t\t(Nodo '), write(N), write(' non in Open)\n')
    true.

% 2. se nella lista open esiste un nodo con stessa posizione, allora è migliore
% se GScore1 < GScore2
nodeHasBetterScore(_-node(pos(X,Y), _, GScore1, _), [ _-node(pos(X,Y), _, GScore2, _) | _]) :-
    %write('\t\t (GScore1='), write(GScore1), write(', GScore2='), write(GScore2), write(')\n'),
    !,GScore1 @< GScore2
    %write('\t\t Nodo ha score minore '), write(GScore1), write('<'), write(GScore2), write('\n')
    .

% 3. Scorro tutta la lista degli open
% il check passa a 1. (che sicuramente fallisce altrimenti non sarei qui)
% e poi a 2 che controlla se l'elemento successivo è lo stesso nodo
nodeHasBetterScore(N, [ _ | OpenTail ]) :- nodeHasBetterScore(N, OpenTail).
    %write('\t\t (nodeHasBetterScore Pos='), write(Pos), write(' OpenTail='), write(OpenTail), write(')\n'),

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
samePos(_-node(Pos1, _, _, _), _-node(Pos1, _, _, _)).

isClosed(_-node(pos(X,Y), _, _, _), [ _-node(pos(X,Y), _, _, _) | _]).
isClosed(N, [ _ | ClosedTail ]) :- isClosed(N, ClosedTail).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% expandAll(node, open, azioni applicabili, newopen)
expandAll(_, Open, [], _, Open) :- !. % caso base serve per costruire la lista NewOpen

expandAll(N, Open, [Action | OtherActions], Closed, [ Neighbor | NewOpen ] ) :-
    % genero un figlio in base all'Action in testa
    genNode(Action, N, Neighbor),
    %write('\tCon Action='), write(Action), write(' vado a '), write(Neighbor), write('\n'),

    \+isClosed(Neighbor, Closed),

    % non torno indietro da dove sono appena arrivato
    %\+samePos(N, Neighbor),

    % voglio tenerlo solo se il costo che ho trovato ora è migliore
    nodeHasBetterScore(Neighbor, Open),
    %write('\tIl nodo ha score migliore, lo tengo\n'),
    % espandi i neighbors rimanenti
    expandAll(N, Open, OtherActions, Closed, NewOpen), !.

% fallisce se non è better score -> lo ignoro
expandAll(N, Open, [_ | OtherActions], Closed, NewOpen) :-
    %write('\tIl nodo ha score peggiore o era di provenienza, lo scarto\n'),
    expandAll(N, Open, OtherActions, Closed, NewOpen), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% expandNode(N, Open, NewOpen)
% Espande un nodo N e aggiorna la lista dei nodi Open in NewOpen

expandNode(N, Open, Closed, NewOpen) :-
    findall(Action, applicabile(Action, N), ApplicableActions),
    %write('Le azioni applicabili sono: '), write(ApplicableActions), write('\n'),
    %write('Espando nodo '), write(N), write('\n'),
    %write('Closed='), write(Closed), write('\n'),
    expandAll(N, Open, ApplicableActions, Closed, NewOpen).
