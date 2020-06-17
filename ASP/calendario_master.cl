
%------------------- KB ------------------------

% Insegnamento, Docente, Ore totali
insegnamento(
    presentazione_master, presentatore, 2;
    % ore di recupero
    recupero, none, 4;
    project_management, muzzetto, 14;
    fondamenti_di_ICT_e_paradigmi_di_programmazione,pozzato, 14;
    linguaggi_di_markup, gena, 20;
    la_gestione_della_qualita, tomatis, 10;
    ambienti_di_sviluppo_e_linguaggi_client_side_per_il_web, micalizio, 20;
    progettazione_grafica_e_design_di_interfacce, terranova, 10;
    progettazione_di_basi_di_dati, mazzei, 20;
    strumenti_e_metodi_di_interazione_nei_social_media, giordani, 14;
    acquisizione_ed_elaborazione_di_immagini_statiche_grafica, zanchetta, 14;
    accessibilita_e_usabilita_nella_progettazione_multimediale, gena, 14;
    marketing_digitale, muzzetto, 10;
    elementi_di_fotografia_digitale, vargiu, 10;
    risorse_digitali_per_il_progetto_collaborazione_e_documentazione, boniolo, 10;
    tecnologie_server_side_per_il_web, damiano, 20;
    tecniche_e_strumenti_di_marketing_digitale, zanchetta, 10;
    introduzione_al_social_media_management, suppini, 14;
    acquisizione_ed_elaborazione_del_suono, valle, 10;
    acquisizione_ed_elaborazione_di_sequenze_di_immagini_digitali, ghidelli, 20;
    comunicazione_pubblicitaria_e_comunicazione_pubblica, gabardi, 14;
    semiologia_e_multimedialita, santangelo, 10;
    crossmedia_articolazione_delle_scritture_multimediali, taddeo, 20;
    grafica_3D, gribaudo, 20;
    progettazione_e_sviluppo_di_applicazioni_web_su_dispositivi_mobile_I, pozzato, 10;
    progettazione_e_sviluppo_di_applicazioni_web_su_dispositivi_mobile_II, schifanella, 10;
    la_gestione_delle_risorse_umane, lombardo, 10;
    i_vincoli_giuridici_del_progetto_diritto_dei_media, travostino, 10;
    ).


% Giorni
giorno(a_lun; b_mar; c_mer; d_gio; e_ven; f_sab).
giorni_lun_to_gio(a_lun;b_mar;c_mer;d_gio).

% Orario
orario( 9, 10;
        10, 11;
        11, 12;
        12, 13;
        14, 15; 
        15, 16;
        17, 18;
        18, 19).

settimane(1..25).
settimane_full(7;16).
settimane_part(1..6;8..15;17..25).

% 
% esami_propedeutici(A, B)
% 
% Il corso B può inziare solo dopo che sono state 
% terminate le lezioni del corso A

esami_propedeutici(fondamenti_di_ICT_e_paradigmi_di_programmazione,
                    ambienti_di_sviluppo_e_linguaggi_client_side_per_il_web).
esami_propedeutici(ambienti_di_sviluppo_e_linguaggi_client_side_per_il_web,
                    progettazione_e_sviluppo_di_applicazioni_web_su_dispositivi_mobile_I).
esami_propedeutici(progettazione_e_sviluppo_di_applicazioni_web_su_dispositivi_mobile_I,
                    progettazione_e_sviluppo_di_applicazioni_web_su_dispositivi_mobile_II).
esami_propedeutici(progettazione_di_basi_di_dati,
                    tecnologie_server_side_per_il_web).
esami_propedeutici(linguaggi_di_markup,
                    ambienti_di_sviluppo_e_linguaggi_client_side_per_il_web).
esami_propedeutici(project_management,
                    marketing_digitale).
esami_propedeutici(marketing_digitale,
                    tecniche_e_strumenti_di_marketing_digitale).
esami_propedeutici(project_management,
                    strumenti_e_metodi_di_interazione_nei_social_media).
esami_propedeutici(project_management,
                    progettazione_grafica_e_design_di_interfacce).
esami_propedeutici(acquisizione_ed_elaborazione_di_immagini_statiche_grafica,
                    progettazione_grafica_e_design_di_interfacce).
esami_propedeutici(elementi_di_fotografia_digitale,
                    acquisizione_ed_elaborazione_di_sequenze_di_immagini_digitali).
esami_propedeutici(acquisizione_ed_elaborazione_di_immagini_statiche_grafica,
                    grafica_3D).

% 
% propedeuticidita_specifica(A, B)
% 
% Il corso B può inziare solo dopo che sono state 
% svolte almeno le prima 4 lezioni del corso A
%

propedeuticidita_specifica(fondamenti_di_ICT_e_paradigmi_di_programmazione,
                    progettazione_di_basi_di_dati).
propedeuticidita_specifica(tecniche_e_strumenti_di_marketing_digitale,
                    introduzione_al_social_media_management).
propedeuticidita_specifica(comunicazione_pubblicitaria_e_comunicazione_pubblica,
                    la_gestione_delle_risorse_umane).
propedeuticidita_specifica(tecnologie_server_side_per_il_web,
                    progettazione_e_sviluppo_di_applicazioni_web_su_dispositivi_mobile_I).

% ------------------ Costruzione modello --------------------

% Predicato che rappresenta tutte le combinazioni possibili di : (Settimana, Giorno, Ora inizio lezione, Ora fine lezione)
1 {orario_completo(Settimana, Giorno, Inizio, Fine) } 1 :- 
    settimane(Settimana),
    orario(Inizio,Fine),
    giorno(Giorno).

% Ad ogni insegnamento corrispondono N orari complet : insegnamento(..) 1 -> N orario_completo(..)
% la cardinalità di N viene successivamente fissata al numero di ore totali da svolgere per 
% quel corso
1{ slot(Giorno, Inizio, Fine, Corso, Docente, Oretotali, Settimana):
    orario_completo(Settimana, Giorno, Inizio, Fine) }:- 
    insegnamento(Corso,Docente,Oretotali).

% ----------- Predicati di utilità -------------------

ore_per_corso_erogate(Corso, Count) :-
    Count = #count{ Giorno, Inizio, Fine, Settimana : slot(Giorno, Inizio, Fine, Corso, _, _, Settimana) },
    slot(_, _, _, Corso, _, _, _).

ore_giornaliere_docente(Count, Docente, Giorno, Settimana) :-
    Count = #count{ Inizio, Fine : slot(Giorno, Inizio, Fine, _, Docente, _, _) },
    slot(Giorno, _, _, _, Docente, _, Settimana).

ore_giornaliere_corso(Count, Corso, Giorno, Settimana) :-
     Count = #count{ Inizio, Fine : slot(Giorno, Inizio, Fine, Corso, _, _, Settimana) },
     slot(Giorno, _, _, Corso, _, _, Settimana).

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

% ------------------ Vincoli consistenza realtà --------------------

% Le ore erogate devono essere pari al numero di ore da svolgere annuali assegnate al corso

:- insegnamento(Corso,_, Ore_tot) , 
   ore_per_corso_erogate(Corso, Count),
   Ore_tot != Count.

% Nelle settimane part time l'orario è previsto solo per venerdì e sabato 

:- slot(Giorno, Inizio, Fine, Corso, _, _, Settimana),
    settimane_part(Settimana),
    giorni_lun_to_gio(Giorno).

% Nella stassa data, ora, giorno, settimana non possono esserci 2 corsi diversi 

:-  slot(Giorno, Inizio, Fine, Corso, _, _, Settimana), 
    slot(Giorno, Inizio, Fine, Corso1, _, _, Settimana),
    Corso != Corso1.


% Al massimo 5 ore il sabato

:-  slot(Giorno, Inizio, Fine, Corso, _, _, Settimana),
    Giorno = f_sab,
    Fine > 15.

% ------------------ Vincoli ------------------------------


% • Un docente può svolgere al massimo 4 ore al giorno

:- ore_giornaliere_docente(Count, _, _, _),
    Count > 4. 

% • A ciascun insegnamento per vengono assegnate minimo 2 e massimo 4 ore nello stesso giorno 

:- ore_giornaliere_corso(Count, _, _, _),
    Count < 2.   

:- ore_giornaliere_corso(Count, _, _, _),
   Count > 4.     

%  • Nelle prime 2 ore di lezione delle prima settima c'è la presentazione del master

goal_presentazione_master :-  
    slot(Giorno, Inizio, _, Corso, _, _, Settimana),
    slot(Giorno, InizioOra2, _, Corso, _, _, Settimana),
    Giorno = e_ven,
    Settimana = 1,
    Inizio = 9,
    InizioOra2 = 10,
    Corso = presentazione_master.
:- not goal_presentazione_master.


% •  Il calendario deve prevedere almeno 2 blocchi liberi di 2 ore ciascuno
%    per eventuali recuperi di lezioni annullate o rinviate

goal_slot_liberi_contigui :- 
   slot(Giorno,InizioOra1,_ , Corso, _, _, _),
   slot(Giorno,InizioOra2,_ , Corso, _, _, _),
   InizioOra2 = InizioOra1 + 1,
   Corso = recupero.

:- not goal_slot_liberi_contigui.
:- ore_giornaliere_corso(4,recupero,_,_).

% • l’insegnamento “Project Management” deve concludersi non oltre la prima settimana full-time

:- slot(Giorno, Inizio, _, Corso, _, _, Settimana),
    Corso = project_management,
    Settimana > 8.

% • la prima lezione dell’insegnamento “Accessibilità e usabilità nella progettazione multimediale” deve essere collocata prima che siano
%   terminate le lezioni dell’insegnamento “Linguaggi di markup”

:- primo_slot_corso(Giorno, Inizio, Settimana, accessibilita_e_usabilita_nella_progettazione_multimediale),
   ultimo_slot_corso(GiornoX, InizioX, SettimanaX, linguaggi_di_markup),
   Settimana > SettimanaX.

:- primo_slot_corso(Giorno, Inizio, Settimana, accessibilita_e_usabilita_nella_progettazione_multimediale),
   ultimo_slot_corso(GiornoX, InizioX, SettimanaX, linguaggi_di_markup),
   Settimana = SettimanaX,
   GiornoX > Giorno.

:- primo_slot_corso(Giorno, Inizio, Settimana, accessibilita_e_usabilita_nella_progettazione_multimediale),
   ultimo_slot_corso(GiornoX, InizioX, SettimanaX, linguaggi_di_markup),
   Settimana = SettimanaX,
   GiornoX = Giorno,
   InizioX > Inizio.


% Il corso X deve iniziare dopo che termina il corso Y
% Per ogni slot X verifico che ci sia almeno slot Y tale che :
% - la settima di insegnamento sia maggiore della settima in cui si svolge X
% - a parità di settimana e giorno l' ora di fine lezione sia maggiore dell'ora in cui inizia X
%- a parità di settimana il giorno sia antecedente a quello in cui inizia X
% Scarto i modelli in cui questa condizione è soddisfatta               

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



%-------------------- Vincoli auspicabili---------------------

%  • la distanza tra la prima e l’ultima lezione di ciascun insegnamento non deve superare le 6 settimane

:- slot(Giorno, Inizio, Fine, Corso, _, _, Settimana),
   slot(GiornoX, InizioX, FineX, Corso, _, _, SettimanaX),
   SettimanaX > Settimana,
   SettimanaX - Settimana > 6.
 
% • la prima lezione degli insegnamenti “Crossmedia: articolazione delle scritture multimediali” 
%    e “Introduzione al social media management” devono essere collocate nella seconda settimana full-time

:- primo_slot_corso( _, _, Settimana, crossmedia_articolazione_delle_scritture_multimediali),
   Settimana < 7.

:- primo_slot_corso( _, _, Settimana, crossmedia_articolazione_delle_scritture_multimediali),  
   Settimana > 7.

:- primo_slot_corso( _, _, Settimana, introduzione_al_social_media_management),
   Settimana < 7.

:- primo_slot_corso( _, _, Settimana, introduzione_al_social_media_management),  
   Settimana > 7.

%  • la distanza fra l’ultima lezione di “Progettazione e sviluppo di applicazioni web su dispositivi mobile I” e la prima di “Progettazione e sviluppo di
%   applicazioni web su dispositivi mobile II” non deve superare le due settimane.

:- ultimo_slot_corso(_, _,Settimana1, progettazione_e_sviluppo_di_applicazioni_web_su_dispositivi_mobile_I),
   ultimo_slot_corso(_, _,Settimana2, progettazione_e_sviluppo_di_applicazioni_web_su_dispositivi_mobile_II),
   Settimana2 - Settimana1 > 2.

%  le lezioni dei vari insegnamenti devono rispettare le seguenti propedeuticità, in particolare la prima 
%  la prima lezione del CorsoY essere preceduta da almeno 4 ore del CorsoX 

:-  propedeuticidita_specifica(CorsoX, CorsoY),
    primo_slot_corso(GiornoY, InizioY, SettimanaY, CorsoY),
    SlotB_by_week = #count{ Giorno, Inizio, Fine, Settimana : slot(Giorno, Inizio, Fine, CorsoX, _, _, Settimana),
                Settimana < SettimanaY },
    SlotB_by_days = #count{ Giorno, Inizio, Fine, Settimana : slot(Giorno, Inizio, Fine, CorsoX, _, _, Settimana),
                Settimana = SettimanaY,
                Giorno < GiornoY },
    SlotB_by_hours = #count{ Giorno, Inizio, Fine, Settimana : slot(Giorno, Inizio, Fine, CorsoX, _, _, Settimana),
                Settimana = SettimanaY,
                Giorno = GiornoY,
                Inizio < InizioY },
    SlotB_by_week+SlotB_by_days+SlotB_by_hours < 4.


% Models       : 1+
% Calls        : 1
% Time         : 12008.787s (Solving: 11431.74s 1st Model: 11431.74s Unsat: 0.00s)
% CPU Time     : 11523.182s



#show slot/7.
%#show count_oregiornaliere_corso/4.
