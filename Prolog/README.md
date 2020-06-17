# Prolog

## Progetto

E’ richiesta la realizzazione di un progetto (sviluppato anche in gruppo) che
comprende la seguente attività:
uso del Prolog per l'implementazione di strategie di ricerca. Si
richiede di implementare le seguenti strategie di ricerca:
1. strategie non informate
   - iterative deepening
2. strategie basate su euristica
   - algoritmo IDA*
   - algoritmo A*
   
applicandole al problema del labirinto descritto a lezione, in cui un sistema intelligente è collocato in uno spazio di n riche e m colonne, in cui sono posti degli ostacoli. Il sistema si trova in una delle celle del labirinto e, muovendosi all’interno dello stesso, deve raggiungere una casella di uscita.
Il sistema può muoversi nelle quattro direzioni (nord, sud, est, ovest) e non in diagonale e, ovviamente, non può raggiungere una cella contenente un ostacolo. Il sistema intelligente conosce la configurazione del labirinto
(dimensioni, posizione degli ostacoli, uscite). Si considerino:
 - diverse dimensioni del labirinto;
 - diverse disposizioni degli ostacoli (ad esempio, labirinti con pochi ostacoli e, di conseguenza, molti percorsi alternativi, e labirinti con molti ostacoli e pochi percorsi);
 - la possibilità che ci siano più uscite dal labirinto;
 - la possibilità che nessuna delle uscite risulti raggiungibile dalla posizione iniziale, quindi che il sistema intelligente riconosca di non poter raggiungere l’obiettivo.
