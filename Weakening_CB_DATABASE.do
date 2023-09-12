/* 
Forteza, Mussio and Pereyra (2023): Can political gridlock undermine checks and balances? A lab experiment.
{https://github.com/alforteza/weakening-checks-and-balances/tree/main}

Weakening checks and balances. Building the database. 

This do file process the databases produced by ztree and produces a workable database called data.dta.
**************************************************************
Previous processing of ztree outcomes
**************************************************************
ztree produces two files: *.xls and *.sbj
1. *.xls: (i) delete the first two rows; (ii) delete columns B-D; (iii) introduce the word "Session" in cell A1; (iv) delete all the rows following the row that
registers information of the last Subject in the session; (v) save the file as *.xlsx.
2. *.sbj. (i) read from excel (choose type of file: delimited); (ii) select the cells A3 ("Subject") to the last cell with information and copy; (iii) pick an empty cell
below the database in column A, choose paste special and transpose; (iv) delete the rows above the first pasted row; (v) save as xlsx with name *q.xlsx.
3. In section "1.1. Questionnaires" of this do file add the newly created *q.xlsx.
4. In section "1.2. Parts 1 to 3" of this do file add the newly created *.xlsx. Adjust the T value according to the treatment in the session.
5. Add the newly created excel files to list3 and list6 (or add new lists if the number of elements in each list grows large; if so adjust the loops accordingly).
6. Run the present do file. Check the correspondence between the number of subjects in the database and in the sessions (table Session, c(count aux)). Explain any discrepancy. 
7. Check that contradiction == 0 (last command in this do file).
*/

* 1. Loading the database

if  ("`c(hostname)'"=="MacBook-Pro-de-Alvaro.local") global path "/Users/alvaroforteza/Documents/Agency/Experimento dismantling CB/Analisis/DATOS"  
* global path = "C:\Users/alvar/Documents/Agency/Separation of Powers/Experimento/Analisis/DATOS"
*global path = "C:\Research/Checks and Balances/Analysis/DATOS" 
cd "$path"
clear all

* 1.1. Questionnaires

clear all
import excel "$path/T1/20190813_S3 Sala Chica/190813_1340q.xlsx", sheet("190813_1340") firstrow
save "$path/intermediate/190813_1340q.dta", replace

clear all
import excel "$path/T2/20190813_S2/190813_1334q.xlsx", sheet("190813_1334") firstrow
save "$path/intermediate/190813_1334q.dta", replace

clear all
import excel "$path/T3/20190812_S2/190812_1411q.xlsx", sheet("190812_1411") firstrow
save "$path/intermediate/190812_1411q.dta", replace

clear all
import excel "$path/T3/20190812_S2_SalaChica/190812_1346q.xlsx", sheet("190812_1346") firstrow
save "$path/intermediate/190812_1346q.dta", replace

clear all
import excel "$path/T3/20190814_S1/190814_1017q.xlsx", sheet("190814_1017") firstrow
save "$path/intermediate/190814_1017q.dta", replace

clear all
import excel "$path/T3/20190814_S2/190814_1320q.xlsx", sheet("190814_1320") firstrow
save "$path/intermediate/190814_1320q.dta", replace

clear all
import excel "$path/T4/20190815_S1/190815_1137q.xlsx", sheet("190815_1137") firstrow
save "$path/intermediate/190815_1137q.dta", replace

clear all
import excel "$path/T4/20190815_S2/190815_1319q.xlsx", sheet("190815_1319") firstrow
save "$path/intermediate/190815_1319q.dta", replace

clear all
import excel "$path/T4/20190815_S3/190815_1550q.xlsx", sheet("190815_1550") firstrow
save "$path/intermediate/190815_1550q.dta", replace

clear all
import excel "$path/T4/20190815_S3 Sala Chica/190815_1532q.xlsx", sheet("190815_1532") firstrow
save "$path/intermediate/190815_1532q.dta", replace

clear all
import excel "$path/T4/20190815_S4 Sala Chica/190815_1827q.xlsx", sheet("190815_1827") firstrow
save "$path/intermediate/190815_1827q.dta", replace

clear all
import excel "$path/T5/20190813_S1/190813_1043q.xlsx", sheet("190813_1043") firstrow
save "$path/intermediate/190813_1043q.dta", replace

clear all
import excel "$path/T5/20190819_S1/190819_1327q.xlsx", sheet("190819_1327") firstrow
save "$path/intermediate/190819_1327q.dta", replace

clear all
import excel "$path/T5/20190820_S1/190820_1051q.xlsx", sheet("190820_1051") firstrow
save "$path/intermediate/190820_1051q.dta", replace

clear all
import excel "$path/T5/20190820_S2/190820_1345q.xlsx", sheet("190820_1345") firstrow
save "$path/intermediate/190820_1345q.dta", replace

clear all
import excel "$path/T5/20190820_S3/190820_1603q.xlsx", sheet("190820_1603") firstrow
save "$path/intermediate/190820_1603q.dta", replace

clear all
import excel "$path/T5/20190820_S4/190820_1831q.xlsx", sheet("190820_1831") firstrow
save "$path/intermediate/190820_1831q.dta", replace

clear all
import excel "$path/T5/20190927_S1/190927_1731q.xlsx", sheet("190927_1731") firstrow
save "$path/intermediate/190927_1731q.dta", replace

clear all
import excel "$path/T6/20191003_S1/191003_0848q.xlsx", sheet("191003_0848") firstrow
save "$path/intermediate/191003_0848q.dta", replace

clear all
import excel "$path/T6/20191004_S1/191004_1843q.xlsx", sheet("191004_1843") firstrow
save "$path/intermediate/191004_1843q.dta", replace


clear all
import excel "$path/T6/20191009_S1/191009_0932q.xlsx", sheet("191009_0932") firstrow
save "$path/intermediate/191009_0932q.dta", replace

clear all
import excel "$path/T6/20191010_S1/191010_1835q.xlsx", sheet("191010_1835") firstrow
save "$path/intermediate/191010_1835q.dta", replace

clear all
import excel "$path/T6/20191011_S1/191011_1829q.xlsx", sheet("191011_1829") firstrow
save "$path/intermediate/191011_1829q.dta", replace

clear all
import excel "$path/T7/20190821_S1/190821_1054q.xlsx", sheet("190821_1054") firstrow
save "$path/intermediate/190821_1054q.dta", replace

clear all
import excel "$path/T7/20190822_S1/190822_1054q.xlsx", sheet("190822_1054") firstrow
save "$path/intermediate/190822_1054q.dta", replace

clear all
import excel "$path/T7/20190822_S3/190822_1637q.xlsx", sheet("190822_1637") firstrow
save "$path/intermediate/190822_1637q.dta", replace

clear all
import excel "$path/T7/20190822_S4/190822_1832q.xlsx", sheet("190822_1832") firstrow
save "$path/intermediate/190822_1832q.dta", replace

clear all
import excel "$path/T7/20190823_S1/190823_1240q.xlsx", sheet("190823_1240") firstrow
save "$path/intermediate/190823_1240q.dta", replace


* 1.2. Parts 1 to 3

* global path = "C:\Users/alvar/Documents/Agency/Separation of Powers/Experimento/Analisis/DATOS"
*global path = "C:\Research/Checks and Balances/Analysis/DATOS" 
*cd "$path"


clear all
import excel "$path/T1/20190813_S3/190813_1602.xlsx", sheet("190813_1602") firstrow
generate T = 1
save "$path/intermediate/190813_1602.dta", replace

clear all
import excel "$path/T1/20190813_S3 Sala Chica/190813_1340.xlsx", sheet("190813_1340") firstrow
merge 1:1 Subject using "$path/intermediate/190813_1340q.dta"
drop _merge
generate T = 1
save "$path/intermediate/190813_1340.dta", replace

clear all
import excel "$path/T2/20190813_S2/190813_1334.xlsx", sheet("190813_1334") firstrow
merge 1:1 Subject using "$path/intermediate/190813_1334q.dta"
drop _merge
generate T = 2
save "$path/intermediate/190813_1334.dta", replace

clear all
import excel "$path/T3/20190812_S2/190812_1411.xlsx", sheet("190812_1411") firstrow
generate T = 3
save "$path/intermediate/190812_1411.dta", replace

clear all
import excel "$path/T3/20190814_S1/190814_1017.xlsx", sheet("190814_1017") firstrow
generate T = 3
save "$path/intermediate/190814_1017.dta", replace

clear all
import excel "$path/T3/20190814_S2/190814_1320.xlsx", sheet("190814_1320") firstrow
generate T = 3
save "$path/intermediate/190814_1320.dta", replace

clear all
import excel "$path/T3/20190812_S2_SalaChica/190812_1346.xlsx", sheet("190812_1346") firstrow
generate T = 3
save "$path/intermediate/190812_1346.dta", replace

clear all
import excel "$path/T4/20190815_S1/190815_1137.xlsx", sheet("190815_1137") firstrow
generate T = 4
save "$path/intermediate/190815_1137.dta", replace

clear all
import excel "$path/T4/20190815_S2/190815_1319.xlsx", sheet("190815_1319") firstrow
generate T = 4
save "$path/intermediate/190815_1319.dta", replace

clear all
import excel "$path/T4/20190815_S3/190815_1550.xlsx", sheet("190815_1550") firstrow
generate T = 4
save "$path/intermediate/190815_1550.dta", replace

clear all
import excel "$path/T4/20190815_S3 Sala Chica/190815_1532.xlsx", sheet("190815_1532") firstrow
generate T = 4
save "$path/intermediate/190815_1532.dta", replace

clear all
import excel "$path/T4/20190815_S4 Sala Chica/190815_1827.xlsx", sheet("190815_1827") firstrow
generate T = 4
save "$path/intermediate/190815_1827.dta", replace


clear all
import excel "$path/T5/20190813_S1/190813_1043.xlsx", sheet("190813_1043") firstrow
generate T = 5
save "$path/intermediate/190813_1043.dta", replace

clear all
import excel "$path/T5/20190819_S1/190819_1327.xlsx", sheet("190819_1327") firstrow
generate T = 5
save "$path/intermediate/190819_1327.dta", replace

clear all
import excel "$path/T5/20190820_S1/190820_1051.xlsx", sheet("190820_1051") firstrow
generate T = 5
save "$path/intermediate/190820_1051.dta", replace

clear all
import excel "$path/T5/20190820_S2/190820_1345.xlsx", sheet("190820_1345") firstrow
generate T = 5
save "$path/intermediate/190820_1345.dta", replace

clear all
import excel "$path/T5/20190820_S3/190820_1603.xlsx", sheet("190820_1603") firstrow
generate T = 5
save "$path/intermediate/190820_1603.dta", replace

clear all
import excel "$path/T5/20190820_S4/190820_1831.xlsx", sheet("190820_1831") firstrow
generate T = 5
save "$path/intermediate/190820_1831.dta", replace

clear all
import excel "$path/T5/20190927_S1/190927_1731.xlsx", sheet("190927_1731") firstrow
generate T = 5
save "$path/intermediate/190927_1731.dta", replace

clear all
import excel "$path/T6/20191003_S1/191003_0848.xlsx", sheet("191003_0848") firstrow
generate T = 6
save "$path/intermediate/191003_0848.dta", replace

clear all
import excel "$path/T6/20191004_S1/191004_1843.xlsx", sheet("191004_1843") firstrow
generate T=6
save "$path/intermediate/191004_1843.dta", replace


clear all
import excel "$path/T6/20191009_S1/191009_0932.xlsx", sheet("191009_0932") firstrow
generate T=6
save "$path/intermediate/191009_0932.dta", replace

clear all
import excel "$path/T6/20191010_S1/191010_1835.xlsx", sheet("191010_1835") firstrow
generate T=6
save "$path/intermediate/191010_1835.dta", replace

clear all
import excel "$path/T6/20191011_S1/191011_1829.xlsx", sheet("191011_1829") firstrow
generate T=6
save "$path/intermediate/191011_1829.dta", replace

clear all
import excel "$path/T7/20190821_S1/190821_1054.xlsx", sheet("190821_1054") firstrow
generate T = 7
save "$path/intermediate/190821_1054.dta", replace

clear all
import excel "$path/T7/20190822_S1/190822_1054.xlsx", sheet("190822_1054") firstrow
generate T = 7
save "$path/intermediate/190822_1054.dta", replace

clear all
import excel "$path/T7/20190822_S2/190822_1410.xlsx", sheet("190822_1410") firstrow
generate T = 7
save "$path/intermediate/190822_1410.dta", replace

clear all
import excel "$path/T7/20190822_S3/190822_1637.xlsx", sheet("190822_1637") firstrow
generate T = 7
save "$path/intermediate/190822_1637.dta", replace

clear all
import excel "$path/T7/20190822_S4/190822_1832.xlsx", sheet("190822_1832") firstrow
generate T = 7
save "$path/intermediate/190822_1832.dta", replace

clear all
import excel "$path/T7/20190823_S1/190823_1240.xlsx", sheet("190823_1240") firstrow
generate T = 7
drop  if  Session == "190823_1240" & Subject == 2  // This subject abondoned the session without completing part 1.
save "$path/intermediate/190823_1240.dta", replace

* 1.3. Merging and appending
/* Some data bases were not included in the merging process due to missing questionnaires: 190813_1602.dta, 190822_1410.dta. All data bases were included in the appending
process.
*/


global list1 = "190813_1334 190812_1411 190815_1137 190815_1319 190815_1550 190815_1532 190813_1043 190819_1327 190814_1017 190814_1320 190815_1827 190812_1346 "
global list2 = "190813_1340 190820_1051 190820_1345 190820_1603 190820_1831 190821_1054 190822_1054  190822_1637 190822_1832 190823_1240 190927_1731 191003_0848"
global list3 = "191004_1843 191009_0932 191010_1835 191011_1829"
clear all

foreach x in $list1 $list2 $list3 {
use "$path/intermediate/`x'.dta",clear
merge 1:1 Subject using "$path/intermediate/`x'q.dta"
drop if _merge != 3
drop _merge
save "$path/intermediate/`x'.dta", replace
}
* We checked all the data bases matched save for 190823_1240 with a missing in the master file: Subject 2 withdrew from the session.

global list4 = "190813_1334 190812_1411 190815_1137 190815_1319 190815_1550 190815_1532 190813_1043 190819_1327 190814_1017 190814_1320 190815_1827 190812_1346 "
global list5 = "190813_1340 190820_1051 190820_1345 190820_1603 190820_1831 190821_1054 190822_1054 190822_1410 190822_1637 190822_1832 190823_1240 190927_1731 191003_0848"
global list6 = "191004_1843 191009_0932 191010_1835 191011_1829"
clear all

use "$path/intermediate/190813_1602.dta"

foreach x in $list4 $list5 $list6 {
append using "$path/intermediate/`x'.dta", force
capture erase "$path/intermediate/`x'.dta"
}
erase "$path/intermediate/190813_1602.dta"

foreach x in $list1 $list2 $list3{
capture erase "$path/intermediate/`x'q.dta"
}

* 1.4. Generate individual codes, recode and rename elijoregla, and reshape database

g i = _n

global list1 = "accionX11-accionX110 accionL11-accionL110 bloqueo11-bloqueo110 accion1R11-accion1R110 accion1R21-accion1R210" 
global list2 = "bloqueo21-bloqueo214 accion2R11-accion2R114 accion2R21-accion2R214"
global list3 = "elijoregla11-elijoregla110 elijoregla21-elijoregla214"
global list4 = "genero_nac-gobierno_propiedad"
global list5 = "chequeoL1-chequeoL10 chequeoL21-chequeoL214"
global list6 = "correctaL1-correctaL10 correctaL21-correctaL214"
global list7 = "rpref1-rpref10 Totalpayoff"

keep Session T i $list1 $list2 $list3 $list4 $list5 $list6 $list7

* Recoding (see DiccionarioDeVariables20190725.docx)

/*  accionX1[1] = acción propuesta por X en decision 1 (1=verde, 2=azul)
accionL1[1] = acción propuesta por L en decision 1 (1=verde, 2=azul)
bloqueo1[1] = hay bloqueo? En decision 1 (1=si, 2=no)
accion1R1[1] = acción bajo regla 1 en decision 1 (1=verde, 2=azul)
accion1R2[1] = acción bajo regla 2 en decision 1 (1=verde, 2=azul)
elijoregla1[1] = elección de regla en decision 1 (1 = regla 1,  2= regla2)
*/
foreach x in $list1 $list2 {
recode `x' (1 = 1) (2 = 0)
}

foreach x in $list3 {
recode `x' (1 = 0) (2 = 1) 
}

global num_i =_N 

forvalues x=1(1)14 {
rename chequeoL2`x' check_2nd`x'
}

reshape long elijoregla2 check_2nd, i(i) j(t) 
rename elijoregla2 Vi 
label var check_2nd "Number of attempts at answering the right-wrong questions in part 2"

forvalues x=1(1)10 {
rename chequeoL`x' check_1st`x'
}


* Some checking
/*
order Session T i t Vi check_2nd check_1st*
edit if Session == "190812_1411" & t == 1
edit if Session == "190812_1411" & t == 2
*/

* 1.5. Preferences and proposals of politicians in part 2 of the experiment (table 4 in "Experimento EL juego del bloqueo político - 20190321.docx" ).

g X_pref = 0 		// X_pref = 0 means X is biased towards 0.
g L_pref = 0  
g p_X = 0
g p_L = 0

replace X_pref = 1 	if t >= 5 & t <= 8	
replace X_pref = 2 	if t >= 9            // X_pref == 2 means X prefers the matching of policy and the state of nature.
replace L_pref = 1 	if t == 2 | t == 6 | t == 11 | t == 12
replace L_pref = 2 	if t == 3 | t == 4 | t == 7 | t == 8 | t == 13 | t == 14  
replace p_X = 1 	if (t >= 5 & t <= 8) | t == 10 | t == 12 | t == 14
replace p_L = 1 	if t == 2 | t == 4 | t == 6 | t == 8 | t == 11 | t == 12 | t == 14

label variable X_pref "Executive policy preference"
label define xpref 0 "Conservative" 1 "Reformist" 2 "Unbiased"
label values X_pref xpref

* 1.6. Parameters of each treatment

global UM 	= 25*8						// Payoff of a matching between the policy and the state of nature
global a 	=  $UM/2.5   				// Utility of reform
global r_L 	= $a*0.3					// Low rents
global r_H 	= $a*1.2      				// High rents
global q_L 	= 0.2						// Low probability of s=1.
global q_H 	= 0.9						// High probabilty of s=1.

* 1.7. Setting values of treatment invariant variables

g r = $r_L  		 
replace r = $r_H if  T == 5

g q = $q_H
replace q = $q_L if T == 2 | T == 4

g low_fr_stalemate = ( T == 1 | T == 2 )  //  low_fr_stalemate = 1 if low frequency in the priming phase
label var low_fr_stalemate "frequency of stalemate: 0 = high, 1 = low frequency"

g corruption = 0  
replace corruption = 1 if T == 6  // corr=1 designs the treatments where r is explicitly identified with corruption.
label var corruption "framing: 1 = corruption, 0=other"

g political = 0    	// political identifies the framing. It is binary: political = 1 if "political", and =0 otherwise.
replace political = 1 if T == 7
label var political "framing: 1=political, 0=other"

sort T i t
label var T "Treatments"

save "$path/data_aux.dta", replace    // Intermediate database without risk aversion

* 1.8. Checking number of participants per session and treatment

* Including cases without questionnaire
* Number of subjects per session
capture drop subjects
g subjects = i if t == 14
count if subjects != .
table Session, stat(count subjects)
*logout, save("$path/NumberSubjectsPerSession") excel noauto replace fix: table Session, c(count subjects) 

* Number of sessions and subjects per treatment
capture drop y
encode Session, g(y)
generate order = _n
sort y order 
capture drop session
by y: gen session = 1 if  _n == 1 
sort order
drop order
table T, stat(count session) stat(count subjects)
* logout, save("$path/NumberSubjectsPerTreatment") excel noauto replace fix: table T, c(count session count subjects)
* Command logout is not working properly with this table! It produces an *.xml and a *.txt file. 
* The first one is incomplete. The text file is complete.

* Excluding cases without questionnaire
capture drop subjects
g subjects = i if t == 14 & nacimiento != ""
table Session, stat(count subjects)
table T, stat(count subjects)
*logout, save("$path/NumberSubjectsNoQPerTreatment") excel noauto replace fix: table T, c(count session count subjects) 
* Command logout is not working properly with this table! It produces an *.xml and a *.txt file. The first one is incomplete. The text file is complete.
capture drop subjects

* 1.9. Checking and fixing potential issues in the database

clear all
use "$path/data_aux.dta"

* 1.9.1. Identifying potential issues 

* a) Codebook
codebook , problems detail
/*
               potential problem   variables
------------------------------------------------------------------------------------------------------------------------------------
  constant (or all missing) vars   bloqueo212 accion2R112 accion2R28 
  str# vars that may be compressed   genero_nac
  string vars with trailing blanks   departamento_10 departamento_hoy montevideo_localidad
  string vars with embedded blanks   genero_hoy nacimiento departamento_10 departamento_hoy montevideo_localidad educ_padre
                                   educ_madre interes_politica voto_partido gobierno_lider gobierno_expertos gobierno_militar
                                   gobierno_democratico
------------------------------------------------------------------------------------------------------------------------------------

a) bloqueo212 == 0 means all individuals said there was no gridlock when p_X = p_L = 1, which is correct.
b) accion2R112 == 1 means all individuals said the action with rule 1 is 1 when p_X = p_L = 1, which is correct.
c) accion2R28 == 1 means all individuals said the action with rule 1 is 1 when p_X = p_L = 1, which is correct.
d) genero_nac. I compress this variable below.
e) departamento_10 has trailing and embedded blanks. More serious flaw: non standardized strings. Examples: MONTEVIDEO,
Montevideo, montevideo, etc. I solve these issues below.
*/

* b) Several tabulates to identify wrong codes in string variables
global varlist1 = "genero_hoy nacimiento montevideo_localidad educ_padre educ_madre interes_politica" 
global varlist2 = "voto_partido gobierno_lider gobierno_expertos gobierno_militar gobierno_democratico"
global varlist3 = "departamento_10 departamento_hoy montevideo_localidad"
foreach x in $varlist1 $varlist2 {
	tab `x', missing
}  


* 1.9.2. Fixing potential issues

* genero_nac
compress genero_nac

* departamento_10
replace departamento_10 = trim(departamento_10)
tab departamento_10    // Serious issues with the codes!
replace departamento_10 = "Canelones (sin ciudad costa)" if departamento_10 == "CANELONES" | departamento_10 == "canelones"
replace departamento_10 = "Canelones, ciudad de la costa" if departamento_10 == "Canelones- Ciudad de la costa"
replace departamento_10 = "Florida" if departamento_10 == "Folorida"
replace departamento_10 = "Maldonado" if departamento_10 == "MALDONADO"
replace departamento_10 = "Montevideo" if departamento_10=="montevideo" | departamento_10=="MONTEVIDEO" /*
*/                      | departamento_10=="Montevideo "
replace departamento_10 = "Salto" if departamento_10 == "SALTO" | departamento_10 == "salto"
replace departamento_10 = "Artigas" if departamento_10 == "artigas"
replace departamento_10 = "Colonia" if departamento_10 == "colonia"
replace departamento_10 = "Maldonado" if departamento_10 == "maldonado"
replace departamento_10 = "No vivía en Uruguay" if departamento_10 == "No vivia en Uruguay" | /*
*/ departamento_10 == "No vivia en Uruguay." | departamento_10 == "No vivía en Uruguay." | /*
*/ departamento_10 == "no vivia en Uruguay"
codebook departamento_10, problems detail // I decided to keep embedded blanks in departamento_10

* departamento_hoy
replace departamento_hoy = trim(departamento_hoy)
tab departamento_hoy    // Serious issues with the codes!
replace departamento_hoy = "Canelones (sin ciudad costa)" if departamento_hoy == "CANELONES" /*
*/	| departamento_hoy == "canelones" | departamento_hoy == "Canelones"
replace departamento_hoy = "Canelones, ciudad de la costa" if departamento_hoy == "Canelones- Ciudad de la costa"
replace departamento_hoy = "Montevideo" if departamento_hoy == "MONTEVIDEO" | departamento_hoy == "Monevideo" | /*
*/	departamento_hoy == "Motevideo" | departamento_hoy == "montevideo"
replace departamento_hoy = "Maldonado" if departamento_hoy == "maldonado"  

* montevideo_localidad
replace montevideo_localidad = trim(montevideo_localidad)

* Luciana:  Recodificar montevideo_localidad!


save "$path/data_aux.dta", replace    // Intermediate database without risk aversion

*****************************************************************************************************************
* 2. Description of the database
*****************************************************************************************************************
* Distribution of errors in the first part

capture drop num_check_1st
capture drop row

g num_check_1st = .
g row = _n if _n <=10
forvalues x=1(1)10 {
dis "t = `x'"
sum check_1st`x', d
replace num_check_1st = r(mean) if _n == `x'
}
/*
twoway (line num_check_1st row if _n <=10), title(Mean number of attempts along the priming phase)
graph save Graph "Number of attempts priming phase.gph", replace
*/
* Distribution of errors in the second part

codebook check_2nd
sum check_2nd, d

capture drop num_check_2nd
capture drop row
g num_check_2nd = .
g row = _n if _n <=14
forvalues x=1(1)14 {
dis "t = `x'"
sum check_2nd if t == `x', d
replace num_check_2nd = r(mean) if _n == `x'
}

/*
twoway (line num_check_2nd row if _n <=14), title(Mean number of attempts along part 2)
*/
g proposals01 = (p_X == 0 & p_L==1)
table proposals01, stat(mean check_2nd)

/* Conclusions: 
1) I found two individuals (Session 190812_1411) with check_1st2 = 0 (in the Ztree labeling: chequeoL[2]=0). I also found two individuals with 
check_2nd = 0. I do not know what that means.
2) There seems to be learning in the priming phase. 
3) There is also some learning in part 2, but with larger oscilations. The latter could be due to the coordination of situations and rows in part 2. Apparently,
rows 2, 4 and 11, all of them with p_X=0 and p_L=1, involved more difficulties. 
*/


* 2.1. Checking some control variables
/* check_1st*  = # times the subject pushed the buttom "verificar" in the first part. If chequeoL[i]<= 4, the contents of variables accionX1[], accionL1[], bloqueo1[], accion1R1[] y accion1R2 should be all correct. Otherwise, there should be at least one mistake. 
*/

capture drop correct
capture drop contradiction
g correct = .
g contradiction = 0

replace correct = 1 if (  T==1 & t == 1 & accionX11== 0 & accionL11==0 & bloqueo11==0 & accion1R11==0 & accion1R21==0)
replace correct = 0 if T==1 & t==1 & correct !=1
replace contradiction = 1 if correct== 1  & t==1 & check_1st1 > 4 //If the subject provided the correct answer, check_1st1 <4
replace contradiction = 1 if correct == 0 & t==1 & check_1st1 < 4

replace correct = 1 if  T==1 & t == 2 & accionX12== 0 & accionL12==1 & bloqueo12==0 & accion1R12==0 & accion1R22==0
replace correct = 0 if T==1 & t==2 & correct !=1
replace contradiction = 1 if correct== 1 & t==2 & check_1st2 > 4 //If the subject provided the correct answer, check_1st2 <4
replace contradiction = 1 if correct == 0 & t==2 &   check_1st2 < 4

replace correct = 1 if  T==3 & t == 10 & accionX110== 1 & accionL110==0 & bloqueo110==1 & accion1R110==0 & accion1R210==1
replace correct = 0 if T==3 & t==10 & correct !=1
replace contradiction = 1 if correct== 1 & T == 3 & t==10 & check_1st10 > 4 //If the subject provided the correct answer, check_1st10 <4
replace contradiction = 1 if correct == 0 & T == 3 &  t==10 &   check_1st10 < 4

replace correct = 1 if  T==4 & t == 10 & accionX110== 0 & accionL110==0 & bloqueo110==0 & accion1R110==0 & accion1R210==0
replace correct = 0 if T==1 & t==10 & correct !=1
replace contradiction = 1 if correct== 1 & T == 4 & t==10 & check_1st10 > 4 //If the subject provided the correct answer, check_1st10 <4
replace contradiction = 1 if correct == 0 & T == 4 &  t==10 &   check_1st10 < 4

* The cases with check_1st* == 0
/* I found two individuals (Session 190812_1411) with check_1st2 = 0 (in the Ztree labeling: chequeoL[2]=0). I do not know what that means. I check whether the recorded answers were correct and they were.
*/
replace correct = 1 if  T==7 & t == 2 & accionX12== 0 & accionL12==0 & bloqueo12==0 & accion1R12==0 & accion1R22==0
replace correct = 0 if T==7 & t==2 & correct !=1
replace contradiction = 1 if correct== 1 & T == 7 & t==2 & check_1st2 > 4 //If the subject provided the correct answer, check_1st10 <4
replace contradiction = 1 if correct == 0 & T == 7 &  t==2 &   check_1st2 < 4

sum contradiction //It should always be zero.

/* Conclusion: check_1st* is consistent with the specific answers in all the checked rounds. There is an ambiguity when check_1st* == 4: the answers could be correct or incorrect.
*/

* 3. Risk aversion measures from Holt and Laury (2002) MPL task 

use "$path/data_aux.dta", clear 

** keep one observation
keep i t Session rpref*
keep if t==1

** reshape database to show the 10 risk decisions in a single column for each individual 
reshape long rpref, i(i Session) j(rowchoice)

** find the individuals who did not understand the task (aka: chosen option for row 1 was Option B. individuals 4, 138 and 218)
tab rpref if rowchoice==1

* 3 individuals did not understand the task. I created a variable to reflect it:
gen RT_nu=0
bysort i: replace RT_nu=1 if rpref==2 & rowchoice==1

** find the switches (in whatever direction)
gen ns=0

bysort i: replace ns=1 if rpref[_n] != rpref[_n-1] & rowchoice!=1

** individuals who are inconsistent (aka: who switched more than once along the 10 row list)
bysort i: egen NS=sum(ns)

** who is inconsistent and how many switches (NOTE: 240 understood the task out of 243, 206 are consistent among 243) 
* all participants 
tab NS if rowchoice==1 
* participants who did not understand the task
tab NS if rowchoice==1 & RT_nu==0

** find the row where they first switch (regardless of consistence - that is we force monotonicity in this variable), but leave out the 3 who did not understand)
gen rowswitches=rowchoice if ns==1
bys i: egen rowfirst=min(rowswitches) 

** gen a variable that only collects the rowswitched for the CONSISTENT participants
gen rowfirstCONS=rowfirst if NS==1
* the missing are the 37 individuals who did not understand the task (243-206)
tab rowfirstC if rowchoice==1, m

* define all variables for risk aversion 
label variable RT_nu "1 if individual did not understand the task, 0 otherwise"
label variable ns "states all the rows where there is a switch (regardless of the direction of the switch)"
label variable NS "number of switches" 
label variable rowfirst "row where the participants make the first switch, not forcing monotonicity, excluding the ones who did not understand the task"
label variable rowfirstCONS "row where participants make the first switch, forcing monotonicity, excluding the ones who did not understand the task"

* create risk aversion measure based on HL (2002) for those who understood the task

gen riskaverse=0
replace riskaverse=1 if rowfirst>=5 & RT_nu==0 & NS==1
replace riskaverse=. if RT_nu==1

label variable riskaverse "1 if individual switches in row 5 or more and is consistent, 0 if switches <=4, . if did not understand the task"

tab riskaverse, m
tab riskaverse NS

* SAVE RISK DATABASE (merging will lose the information on all rows switched but we keep the DB to not lose this information if needed)

save "$path/datarisk.dta", replace

* keep if row==1 so we can merge databases 

keep if rowchoice==1

tab NS RT_nu, m

tab rowfirstC, m

save "$path/datariskTOMERGE.dta", replace

* 4. Merge original database with risk aversion measure

use "$path/data_aux.dta", clear 

merge m:1 i using "$path/datariskTOMERGE.dta"

sort i t

drop _merge

tab NS riskaverse if t==1, m

save "$path/data.dta", replace

erase "$path/data_aux.dta"
erase "$path/datarisk.dta"
erase "$path/datariskTOMERGE.dta"



