% Insegnamento (Corso, Docenti, Ore da svolgere annuali)

insegnamento(
    la_gestione_della_qualita, genax, 20;
    project_management2, gena2, 14;
    project_management3, gena3, 14;
    project_management, gena1, 14;
    la_gestione_della_qualita3, gena3, 10;

).


% Giorni
giorno(a_lun;b_mar;c_mer;d_gio;e_ven;f_sab).

settimane(1..9).

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

% • la prima lezione dell’insegnamento “Accessibilità e usabilità nella progettazione multimediale” deve essere collocata prima che siano
%   terminate le lezioni dell’insegnamento “Linguaggi di markup”

:- primo_slot_corso(Giorno, Inizio, Settimana, accessibilita_e_usabilita_nella_progettazione_multimediale),
   ultimo_slot_corso(GiornoX, InizioX, SettimaX, linguaggi_di_markup),
   Settimana > SettimanaX.

:- primo_slot_corso(Giorno, Inizio, Settimana, accessibilita_e_usabilita_nella_progettazione_multimediale),
   ultimo_slot_corso(GiornoX, InizioX, SettimaX, linguaggi_di_markup),
   Settimana = SettimanaX,
   GiornoX > Giorno.

:- primo_slot_corso(Giorno, Inizio, Settimana, accessibilita_e_usabilita_nella_progettazione_multimediale),
   ultimo_slot_corso(GiornoX, InizioX, SettimaX, linguaggi_di_markup),
   Settimana = SettimanaX,
   GiornoX = Giorno,
   InizioX > Inizio.

% Nella stassa data, ora, giorno, settimana non possono esserci 2 corsi diversi 
:-  slot(Giorno, Inizio, Fine, Corso, _, _, Settimana), 
    slot(Giorno, Inizio, Fine, Corso1, _, _, Settimana),
    Corso != Corso1.

% • lo stesso docente non può svolgere più di 4 ore di lezione in un giorno
count_oregiornaliere_docente(Count, Docente, Giorno, Settimana) :-
    Count = #count{ Inizio, Fine : slot(Giorno, Inizio, Fine, _, Docente, _, _) },
    slot(Giorno, _, _, _, Docente, _, Settimana).

:- count_oregiornaliere_docente(Count, _, _, _),
    Count > 4.   

% • A ciascun insegnamento vengono assegnate minimo 2 e massimo 4 ore nello stesso giorno 
count_oregiornaliere_corso(Count, Corso, Giorno, Settimana) :-
    Count = #count{ Inizio, Fine : slot(Giorno, Inizio, Fine, Corso, _, _, Settimana)},
    slot(Giorno, _, _, Corso, _, _, Settimana).

:- count_oregiornaliere_corso(Count, _, _, _),
    Count < 2.   
%:- count_oregiornaliere_corso(Count, _, _, _),
%    Count > 4.   

%  • Nelle prime 2 ore di lezione delle prima settima c'è la presentazione del master

%* goal_presentazione_master :-  
     slot(Giorno, Inizio, _, Corso, _, _, Settimana),
     slot(Giorno, InizioOra2, _, Corso, _, _, Settimana),
     Giorno = a_lun,
     Settimana = 1,
     Inizio = 9,
     InizioOra2 = 10,
     Corso = presentazione_master.

:- not goal_presentazione_master.

goal_slot_liberi_contigui :- 
   slot(Giorno,InizioOra1,_ , Corso, _, _, _),
   slot(Giorno,InizioOra2,_ , Corso, _, _, _),
   InizioOra2 = InizioOra1 + 1,
   Corso = recupero.

:- not goal_slot_liberi_contigui.
:- count_oregiornaliere_corso(4,recupero,_,_). *%


:- slot(Giorno, Inizio, _, Corso, _, _, Settimana),
    Corso = la_gestione_della_qualita,
    Settimana > 2.

%:- propedeuticita_esami(project_management2, project_management3).

% Se il corso X deve iniziare dopo che termina il corso Y
% Per ogni slot X verifico che ci sia almeno slot Y tale che :
% - la sua settima di insegnamento sia maggiore della settima in cui si svolge X
% - A parità di settimana e giorno che la sua ora di fine lezione
%   sia maggiore di dell'ora in cui inizia X
% - la sua settima di insegnamento sia maggiore della settima in cui si svolge X 
%   e il giorno in cui si svolge quello slot sia maggiore del giorno di Y
% Scarta i modelli in cui questa condizione è soddisfatta

esami_propedeutici(project_management,project_management2). 
esami_propedeutici(project_management2,project_management3). 
esami_propedeutici(la_gestione_della_qualita,la_gestione_della_qualita3). 

:- esami_propedeutici(Corso1,Corso2),
    slot(Giorno, Inizio, Fine, Corso2, _, _, Settimana),
    Count = #count{ Giorno1,Fine1, Settimana1 : slot(Giorno1, _, Fine1, Corso1, _, _, Settimana1), 
                Settimana1 > Settimana },
    Count > 0.

:-  esami_propedeutici(Corso1,Corso2),
    slot(Giorno, Inizio, Fine, Corso2, _, _, Settimana),
    Count = #count{ Giorno1,Fine1, Settimana1 : slot(Giorno1, _, Fine1, Corso1, _, _, Settimana1), 
                Settimana1 = Settimana,
                Giorno1 > Giorno },
    Count > 0. 
 
:- esami_propedeutici(Corso1,Corso2),
    slot(Giorno, Inizio, Fine, Corso2, _, _, Settimana),
    Count = #count{ Giorno1,Fine1, Settimana1 : slot(Giorno1, Inizio1, Fine1, Corso1, _, _, Settimana1), 
                 Settimana1 = Settimana, Giorno1 = Giorno, Inizio1 > Inizio},
    Count > 0.

primo_slot_corso(Giorno,Inizio,Settimana,Corso):-
    slot(Giorno, Inizio, _, Corso, _, _, Settimana),
    Count_week = #count{ SettimanaX : slot(_, _, _, Corso, _, _, SettimanaX), 
                SettimanaX < Settimana },
    Count_day = #count{ GiornoX, SettimanaX : slot(GiornoX, _, _, Corso, _, _, SettimanaX), 
                SettimanaX = Settimana,
                GiornoX < Giorno },
    Count_hour = #count{ GiornoX,InizioX, SettimanaX : slot(GiornoX, InizioX, _, Corso, _, _, SettimanaX), 
                 SettimanaX = Settimana, GiornoX = Giorno, InizioX < Inizio},
    Count_hour = 0,
    Count_week = 0,
    Count_day = 0.

ultimo_slot_corso(Giorno,Inizio,Settimana,Corso):-
    slot(Giorno, Inizio, _, Corso, _, _, Settimana),
    Count_week = #count{ SettimanaX : slot(_, _, _, Corso, _, _, SettimanaX), 
                SettimanaX > Settimana },
    Count_day = #count{ GiornoX, SettimanaX : slot(GiornoX, _, _, Corso, _, _, SettimanaX), 
                SettimanaX = Settimana,
                GiornoX > Giorno },
    Count_hour = #count{ GiornoX,InizioX, SettimanaX : slot(GiornoX, InizioX, _, Corso, _, _, SettimanaX), 
                 SettimanaX = Settimana, GiornoX = Giorno, InizioX > Inizio},
    Count_hour = 0,
    Count_week = 0,
    Count_day = 0.


% Vincoli auspicabili.
 
%* :- slot(Giorno, Inizio, Fine, Corso, _, _, Settimana),
    slot(GiornoX, InizioX, FineX, Corso, _, _, SettimanaX),
    SettimanaX > Settimana,
    SettimanaX-Settimana > 4.

:- prima_settima_corso(la_gestione_della_qualita,Settimana),
   Settimana < 3.

:- prima_settima_corso(la_gestione_della_qualita,Settimana),  
   Settimana > 3.

:- prima_settima_corso(la_gestione_della_qualita3,Settimana),
   Settimana < 3.

:- prima_settima_corso(la_gestione_della_qualita3,Settimana),  
   Settimana > 3.
  *%
#show slot/7.
%#show ore_per_corso_erogate/2.
%#show count_oregiornaliere_docente/4.
%#show corso_settima_inizio_fine/5.
%#show prova/5.
%#show ultima_settima_corso/2.
%#show diff/4.
#show primo_giorno_corso/4.
#show ultimo_giorno_corso/4.