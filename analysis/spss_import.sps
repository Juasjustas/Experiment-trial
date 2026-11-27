* Encoding: UTF-8.
* Import the study data into SPSS.
* 1) Download the participant files from OSF (DataPipe saves two per person).
* 2) Merge them with analysis/combine.html into summary_all.csv and events_all.csv.
* 3) Put both files in one folder, change the CD line below to that folder, then run this whole file (Run > All).
* Result: dataset "summary" (one row per participant) and dataset "events" (one row per logged action),
* also saved as summary.sav and events.sav in the same folder.
* Missing answers are blank in the CSV and become system-missing.
* Coded answers come twice: the number (e.g. gender = 2) and the answer as shown (gender_text = Moteris).

* Read Lithuanian letters correctly and use the dot as decimal mark (the CSV files always use a dot).
SET UNICODE=ON.
SET DECIMAL=DOT.

CD 'C:\Users\YOU\Documents\study_data'.

* Events: one row per logged action (long format; link to summary by pid).
GET DATA
  /TYPE=TXT
  /FILE='events_all.csv'
  /ENCODING='UTF8'
  /ARRANGEMENT=DELIMITED
  /DELCASE=LINE
  /FIRSTCASE=2
  /DELIMITERS=","
  /QUALIFIER='"'
  /VARIABLES=
    pid A40
    condition F1.0
    condition_text A40
    event A20
    screen A15
    study_ms F12.0
    t_ms F12.0
    clock A24
    spin_n F6.0
    balance F8.0
    inventory_n F6.0
    inventory_value F8.0
    latency_ms F10.0
    balance_before F8.0
    tier A10
    item A60
    item_p F6.2
    value F6.0
    credited F6.0
    amount F6.0
    withdrawal_n F4.0
    held_ms F10.0
    obtained_spin F6.0
    while_out_of_coins F1.0
    hidden_ms F10.0
    inactive_from_ms F12.0
    inactive_to_ms F12.0
    inactive_ms F10.0
    phase A4
    valence F1.0
    arousal F1.0
    dominance F1.0
    reason A12
    seed F10.0.
EXECUTE.
DATASET NAME events WINDOW=FRONT.

VARIABLE LABELS
  pid 'Participant ID'
  condition 'Group'
  condition_text 'Group (text)'
  event 'Event type'
  screen 'Screen the participant was on'
  study_ms 'Time since the first screen (ms)'
  t_ms 'Time since the game started (ms; blank before the game)'
  clock 'Clock time (UTC, ISO 8601)'
  spin_n 'Cases opened so far'
  balance 'Coin balance'
  inventory_n 'Avatars in inventory (sell mode)'
  inventory_value 'Inventory value (sell mode)'
  latency_ms 'spin_click: pause since last result; withdraw: pause since running out (ms)'
  balance_before 'Balance before this case'
  tier 'Rarity tier won'
  item 'Avatar won'
  item_p 'Chance of this avatar (%)'
  value 'Value of the avatar (coins)'
  credited 'Coins added to balance'
  amount 'Coins withdrawn'
  withdrawal_n 'Withdrawal number'
  held_ms 'How long an avatar was kept before selling (ms)'
  obtained_spin 'Case on which a sold avatar was won'
  while_out_of_coins 'Sold while out of coins'
  hidden_ms 'How long the tab was hidden (ms)'
  inactive_from_ms 'Inactivity: last action before the pause (study ms)'
  inactive_to_ms 'Inactivity: first action after the pause (study ms)'
  inactive_ms 'Inactivity: length of the pause (ms)'
  phase 'SAM: pre or post'
  valence 'SAM valence (1-9)'
  arousal 'SAM arousal (1-9)'
  dominance 'SAM dominance (1-9)'
  reason 'Game end reason'
  seed 'Outcome sequence seed'.

VALUE LABELS
  condition 1 'Skins (rarity shown)' 2 'Plain skins (no rarity)'
  /while_out_of_coins 0 'No' 1 'Yes'.

SAVE OUTFILE='events.sav'.

* Summary: one row per participant (read last, so it is the dataset in front when the syntax finishes).
GET DATA
  /TYPE=TXT
  /FILE='summary_all.csv'
  /ENCODING='UTF8'
  /ARRANGEMENT=DELIMITED
  /DELCASE=LINE
  /FIRSTCASE=2
  /DELIMITERS=","
  /QUALIFIER='"'
  /VARIABLES=
    pid A40
    condition F1.0
    condition_text A40
    started_at A19
    study_duration_s F10.1
    game_duration_s F10.1
    n_spins F6.0
    inactive_n F4.0
    inactive_total_s F10.1
    pgsi_1 F1.0
    pgsi_1_text A30
    pgsi_2 F1.0
    pgsi_2_text A30
    pgsi_3 F1.0
    pgsi_3_text A30
    pgsi_4 F1.0
    pgsi_4_text A30
    pgsi_5 F1.0
    pgsi_5_text A30
    pgsi_6 F1.0
    pgsi_6_text A30
    pgsi_7 F1.0
    pgsi_7_text A30
    pgsi_8 F1.0
    pgsi_8_text A30
    pgsi_9 F1.0
    pgsi_9_text A30
    pgsi_total F2.0
    sam_pre_valence F1.0
    sam_pre_arousal F1.0
    sam_pre_dominance F1.0
    sam_post_valence F1.0
    sam_post_arousal F1.0
    sam_post_dominance F1.0
    gender F1.0
    gender_text A20
    age F3.0
    education F1.0
    education_text A100
    pilot_clarity F1.0
    pilot_clarity_comment A4000
    pilot_questionnaires F1.0
    pilot_questionnaires_comment A4000
    pilot_game F1.0
    pilot_game_comment A4000
    completion_code A6.
EXECUTE.
DATASET NAME summary WINDOW=FRONT.

VARIABLE LABELS
  pid 'Participant ID'
  condition 'Group'
  condition_text 'Group (text)'
  started_at 'Study start (participant local time)'
  study_duration_s 'Whole study duration (s)'
  game_duration_s 'Game duration (s)'
  n_spins 'Cases opened (presses of the open-case button)'
  inactive_n 'Inactivity periods (1 min or more), whole study'
  inactive_total_s 'Total inactive time, whole study (s)'
  pgsi_1 'PGSI 1: bet more than could afford to lose'
  pgsi_1_text 'PGSI 1: bet more than could afford to lose (text)'
  pgsi_2 'PGSI 2: needed larger amounts for the same excitement'
  pgsi_2_text 'PGSI 2: needed larger amounts for the same excitement (text)'
  pgsi_3 'PGSI 3: went back to win back losses'
  pgsi_3_text 'PGSI 3: went back to win back losses (text)'
  pgsi_4 'PGSI 4: borrowed or sold to gamble'
  pgsi_4_text 'PGSI 4: borrowed or sold to gamble (text)'
  pgsi_5 'PGSI 5: felt might have a gambling problem'
  pgsi_5_text 'PGSI 5: felt might have a gambling problem (text)'
  pgsi_6 'PGSI 6: gambling caused health problems'
  pgsi_6_text 'PGSI 6: gambling caused health problems (text)'
  pgsi_7 'PGSI 7: criticised for gambling'
  pgsi_7_text 'PGSI 7: criticised for gambling (text)'
  pgsi_8 'PGSI 8: gambling caused financial problems'
  pgsi_8_text 'PGSI 8: gambling caused financial problems (text)'
  pgsi_9 'PGSI 9: felt guilty about gambling'
  pgsi_9_text 'PGSI 9: felt guilty about gambling (text)'
  pgsi_total 'PGSI total (0-27)'
  sam_pre_valence 'SAM before game: valence (1-9)'
  sam_pre_arousal 'SAM before game: arousal (1-9)'
  sam_pre_dominance 'SAM before game: dominance (1-9)'
  sam_post_valence 'SAM after game: valence (1-9)'
  sam_post_arousal 'SAM after game: arousal (1-9)'
  sam_post_dominance 'SAM after game: dominance (1-9)'
  gender 'Lytis'
  gender_text 'Lytis (text)'
  age 'Amžius'
  education 'Išsilavinimo lygis'
  education_text 'Išsilavinimo lygis (text)'
  pilot_clarity 'Pilot: test clarity (1-5)'
  pilot_clarity_comment 'Pilot: comment on clarity'
  pilot_questionnaires 'Pilot: questionnaires (1-5)'
  pilot_questionnaires_comment 'Pilot: comment on questionnaires'
  pilot_game 'Pilot: chance game (1-5)'
  pilot_game_comment 'Pilot: comment on the game'
  completion_code 'Completion code'.

VALUE LABELS
  condition 1 'Skins (rarity shown)' 2 'Plain skins (no rarity)'
  /pgsi_1 pgsi_2 pgsi_3 pgsi_4 pgsi_5 pgsi_6 pgsi_7 pgsi_8 pgsi_9 0 'Niekada' 1 'Kartais' 2 'Dažnai' 3 'Beveik visada'
  /gender 1 'Vyras' 2 'Moteris' 3 'Kita'
  /education 1 'Pagrindinis' 2 'Vidurinis' 3 'Profesinis' 4 'Aukštasis koleginis (profesinis bakalauras)'
    5 'Aukštasis universitetinis (bakalauras)' 6 'Aukštasis universitetinis (magistras)' 7 'Mokslų daktaras'
  /pilot_clarity pilot_questionnaires pilot_game 1 'Labai prastai' 5 'Labai gerai'
  /sam_pre_valence sam_post_valence 1 'Unhappy' 9 'Happy'
  /sam_pre_arousal sam_post_arousal 1 'Calm' 9 'Excited'
  /sam_pre_dominance sam_post_dominance 1 'Controlled' 9 'In control'.

VARIABLE LEVEL
  condition gender education (NOMINAL)
  /pgsi_1 pgsi_2 pgsi_3 pgsi_4 pgsi_5 pgsi_6 pgsi_7 pgsi_8 pgsi_9 pilot_clarity pilot_questionnaires pilot_game
   sam_pre_valence sam_pre_arousal sam_pre_dominance sam_post_valence sam_post_arousal sam_post_dominance (ORDINAL).

* Derived variables: PGSI risk category (standard cut-offs) and SAM change (after - before).
RECODE pgsi_total (0=0) (1 THRU 2=1) (3 THRU 7=2) (8 THRU 27=3) INTO pgsi_category.
VARIABLE LABELS pgsi_category 'PGSI category'.
VALUE LABELS pgsi_category 0 'Non-problem (0)' 1 'Low risk (1-2)' 2 'Moderate risk (3-7)' 3 'Problem gambling (8+)'.
VARIABLE LEVEL pgsi_category (ORDINAL).
FORMATS pgsi_category (F1.0).
COMPUTE sam_change_valence = sam_post_valence - sam_pre_valence.
COMPUTE sam_change_arousal = sam_post_arousal - sam_pre_arousal.
COMPUTE sam_change_dominance = sam_post_dominance - sam_pre_dominance.
VARIABLE LABELS
  sam_change_valence 'SAM valence change (after - before)'
  sam_change_arousal 'SAM arousal change (after - before)'
  sam_change_dominance 'SAM dominance change (after - before)'.
FORMATS sam_change_valence sam_change_arousal sam_change_dominance (F2.0).
EXECUTE.

SAVE OUTFILE='summary.sav'.
