% Insegnamento (Corso, Docenti, Ore da svolgere annuali)

insegnamento(
    linguaggi_di_markup, gena2, 8;
    project_management, gena4, 14;
    la_gestione_della_qualita, gena3, 20;
    la_gestione_della_qualita2, gena2, 20;

).

% Giorni
giorno(lun;mar;mer;gio;ven; sab).
giorni_lun_to_gio(lun;mar;mer;gio).

settimane_full(7).
settimane_part(1..6).

settimane(1;2;3;4;5;6;7).

% Orario
orario( 9, 10;
        10, 11;
        11, 12;
        12, 13).

% Predicato tutte le combinazioni possibili di : 
% (Settimana, Giorno, Ora inizio lezione, Ora fine lezione)
1 {orario_completo(Settimana, Giorno, Inizio, Fine) } 1 :- settimane(Settimana),orario(Inizio,Fine),giorno(Giorno).


% Ad ogni insegnamento corrispondono al più 1 orario completo 
%   insegnamento(..) 1 -> N orario_completo(..)
1{ slot(Giorno, Inizio, Fine, Corso, Docente, CFU, Settimana):orario_completo(Settimana, Giorno, Inizio, Fine) }:- insegnamento(Corso,Docente,CFU).


% Le ore erogate devono essere pari al numero di ore da svolgere annuali assegnate al corso
ore_per_corso_erogate(Corso, Count) :-
    Count = #count{ Giorno, Inizio, Fine, Settimana : slot(Giorno, Inizio, Fine, Corso, _, _, Settimana) },
    slot(_, _, _, Corso, _, _, _).

:- insegnamento(Corso,_, Ore_tot) , 
   ore_per_corso_erogate(Corso, Count),
   Ore_tot != Count.

% Nella stassa data, ora, giorno, settimana non possono esserci 2 corsi diversi 
:-  slot(Giorno, Inizio, Fine, Corso, _, _, Settimana), 
    slot(Giorno, Inizio, Fine, Corso1, _, _, Settimana),
    Corso != Corso1.

% Solo 2 ore di sabato
:-  slot(Giorno, Inizio, Fine, Corso, _, _, Settimana),
    Giorno = sab,
    Fine > 12.

% Nelle settimane part time l'orario è previsto solo per venerdì e sabato 
:- slot(Giorno, Inizio, Fine, Corso, _, _, Settimana),
    settimane_part(Settimana),
    giorni_lun_to_gio(Giorno).

% • lo stesso docente non può svolgere più di 2 ore di lezione in un giorno
count_oregiornaliere_docente(Count, Docente, Giorno, Settimana) :-
    Count = #count{ Inizio, Fine : slot(Giorno, Inizio, Fine, _, Docente, _, _) },
    slot(Giorno, _, _, _, Docente, _, Settimana).

:- count_oregiornaliere_docente(Count, _, _, _),
    Count < 2.   

% • A ciascun insegnamento vengono assegnate minimo 2 e massimo 4 ore nello stesso giorno 
count_oregiornaliere_corso(Count, Corso, Giorno, Settimana) :-
    Count = #count{ Inizio, Fine : slot(Giorno, Inizio, Fine, Corso, _, _, _) },
    slot(Giorno, _, _, Corso, _, _, Settimana).



#show slot/7.
%#show ore_per_corso_erogate/2.
%#show count_oregiornaliere_corso/4.

