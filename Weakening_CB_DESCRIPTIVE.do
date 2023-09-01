/* Forteza, Mussio and Pereyra: Does Political Gridlock Undermine Checks and Balances? A Lab Experiment.
	Descriptive Statistics


Outline
* 1. Table \ref{table:descriptive1}: Descriptive statistics 1
* 	1.1. Table \ref{table:descriptive1}: characteristics and beliefs of the subjects in the experiment
* 	1.2. Table \ref{table:descriptive1}: characteristics and beliefs of Uruguayans according to WVS6
* 2. Table \ref{table:descriptive2}: Descriptive statistics 2

*/

if  ("`c(hostname)'"=="MacBook-Pro-de-Alvaro.local") global path "/Users/alvaroforteza/Documents/Agency/Experimento dismantling CB/Analisis/DATOS" 
cd "$path"
clear all
use "$path/data.dta",clear


**********************************************************************************************************************
* 1. Table \ref{table:descriptive1}: Descriptive statistics 1
**********************************************************************************************************************
/* 	This table provides information regarding two questions: 
		(i)  Who are the subjects in our experiment?, and 
		(ii) what do they think?
	We also put this information in context using data from the WVS. 
*/

**********************************************************************************************************************
* 1.1. Table \ref{table:descriptive1}: characteristics and beliefs of the subjects in the experiment
**********************************************************************************************************************

encode genero_nac, gen(female) 
recode female 2=0

gen 	Montevideo = 0 if departamento_10 != "Montevideo" & departamento_10 != ""
replace Montevideo = 1 if departamento_10 == "Montevideo" 
label var Montevideo " 1 if Montevideo, 0 otherwise"
* tab departamento_10, missing
* tab Montevideo, missing
* compare departamento_10 Montevideo

g father_university = 1 if educ_padre == "Terciaria completa" | educ_padre == "Terciaria incompleta"
replace father_university = 0 if father_university != 1 & educ_padre != "" 
tab father_university educ_padre, missing

g mother_university = 1 if educ_madre == "Terciaria completa" | educ_madre == "Terciaria incompleta"
replace mother_university = 0 if mother_university != 1 & educ_madre != "" 
tab mother_university educ_madre, missing

*generate public_primary and public_high_school variables*

encode educ_primaria, gen(public_primary)
recode public_primary 1=0 2=1
label values public_primary        // I drop the value labels

encode educ_secundaria, gen(public_high_school)
recode public_high_school 1=0 2=1
label values public_high_school        // I drop the value labels

/* 
sum public_primary public_high, d

Comment: the mean and sd of public_primary and public_high_school are suprisingly similar. They differ in the third and following figures after
the decimal point.
*/


* income_2
/* Note: the variable name in Spanish is gobierno_propiedad, which suggests a completely different question. However, on March 18, 2020, I checked 
with Irene who checked the z-tree code and this variable is indeed auto perceived location in income scale (see also DiccionarioDeVariables20190725.docx). 
Hence, while this is a misleading name, once noted there are no errors. 
*/
gen income_10 = gobierno_propiedad

gen income_2 = .
replace income_2=0 if income_10<=5 & income_10!=. 
replace income_2=1 if income_10>5 & income_10!=.
tab income_10 income_2, missing

*generate interested_politics which represents the percentage of people with some or a lot of interest in politics*

g 		interested_politics = 0 if interes_politica == "No muy interesado" | interes_politica == "Nada interesado"
replace interested_politics = 1 if interes_politica == "Algo interesado" | interes_politica == "Muy interesado"

label define interes_politica 1"Algo o muy interesado" 0"Nada o no muy interesado"
label value interested_politics interes_politica
tab interested_politics , missing
* Note: there are only 23 subjects declaring "Nada o no muy interesado". 

*generate left variable - those who respond <=5 in question izquierda_derecha were associated with left preferences*
gen left_right_10=izquierda_derecha
gen left_right_2=.
replace left_right_2=0 if izquierda_derecha<=5 & izquierda_derecha!=. 
replace left_right_2=1 if izquierda_derecha>5 & izquierda_derecha!=.
tab left_right_10 left_right_2, missing

/*generate larger_income_differences variable - those who respond <=5 in question opinion_ingresos were associated with the believe that more 
equal income is necessary*/
gen larger_income_differences_10=opinion_ingresos

gen larger_income_differences_2=.
replace larger_income_differences_2=0 if opinion_ingresos<=5 & opinion_ingresos!=. 
replace larger_income_differences_2=1 if opinion_ingresos>5 & opinion_ingresos!=.
tab larger_income_differences_10 larger_income_differences_2, missing

/*generate greater_state_own_2 variable - those who respond <=5 in question opinion_propiedad_rec were associated with those who believe 
that the state ownership of industry and business must be greater*/

gen greater_state_own_10=opinion_propiedad

gen greater_state_own_2=.
replace greater_state_own_2=1 if opinion_propiedad>5 & opinion_propiedad!=. 
replace greater_state_own_2=0 if opinion_propiedad<=5 & opinion_propiedad!=.
tab greater_state_own_10 greater_state_own_2, missing

/*generate greater_people_res_2 variable - those who respond <=5 in question opinion_estado were associated with those who believe 
that the responsibility of the state to guarantee the safety of all must be greater*/
gen greater_people_res_10=opinion_estado

gen greater_people_res_2=.
replace greater_people_res_2=0 if opinion_estado<=5 & opinion_estado!=. 
replace greater_people_res_2=1 if opinion_estado>5 & opinion_estado!=.
tab greater_people_res_10 greater_people_res_2, missing

/*generate competition_harmful_2 variable - those who respond <=5 in question opinion_competencia_rec were associated with those who believe 
that competition is harmful*/

gen competition_harmful_10=opinion_competencia

gen competition_harmful_2=.
replace competition_harmful_2=1 if competition_harmful_10>5 & competition_harmful_10!=. 
replace competition_harmful_2=0 if competition_harmful_10<=5 & competition_harmful_10!=.
tab competition_harmful_10 competition_harmful_2, missing

/* Note: I find the mean of competition_harmful_2 (0.31) and competition_harmful_10 (4.6) surprisingly low. Nevertheless, the correlation with
other covariates goes in the expected direction, so it does not seem to be a coding problem. I run the following: corr left opinion_competencia, 
corr greater_people_res_10 opinion_competencia, reg competition_harmful left, and obtained the expected results.
*/

/*generate luck_contacts_2 variable - those who respond <=5 in question opinion_esfuerzo_rec were associated with those who believe 
that success depends on having luck or contacts*/

gen luck_contacts_10=opinion_esfuerzo

gen luck_contacts_2=.
replace luck_contacts_2=1 if opinion_esfuerzo>5 & opinion_esfuerzo!=. 
replace luck_contacts_2=0 if opinion_esfuerzo<=5 & opinion_esfuerzo!=.
tab luck_contacts_10 luck_contacts_2, missing

/* strong_leader (=1 if subject thinks that having a strong leader is good or very good for the country, =0 otherwise)*/
encode gobierno_lider, gen(strong_leader)
recode strong_leader 3=1 2=0 4=0
label drop strong_leader
label define strong_leader 1"Bueno o Muy bueno" 0"Malo o Muy malo"
label value strong_leader strong_leader
tab gobierno_lider strong_leader, missing


/*generate experts (=1 if subject thinks that having experts rather than government taking decisions is good or very good for the country, =0 otherwise)*/
encode gobierno_expertos, gen(experts)
recode experts 3=1 2=0 4=0
label drop experts
label define experts 1"Bueno o Muy bueno" 0"Malo o Muy malo"
label value experts experts
tab gobierno_expertos experts, missing


/*generate military_gov (=1 if subject thinks that having a military government is good or very good for the country, =0 otherwise)*/
encode gobierno_militar, gen(military_gov)
recode military_gov 3=1 2=0 4=0
label drop military_gov
label define military_gov 1"Bueno o Muy bueno" 0"Malo o Muy malo"
label value military_gov military_gov
tab gobierno_militar military_gov, missing

/*generate democratic_gov (=1 if subject thinks that having a democratic government is good or very good for the country, =0 otherwise)*/
encode gobierno_democratico, gen(democratic_gov)
recode democratic_gov 3=1 2=0 
label drop democratic_gov
label define democratic_gov 1"Bueno o Muy bueno" 0"Malo o Muy malo"
label value democratic_gov democratic_gov
tab gobierno_democratico democratic_gov, missing

order female Montevideo father_university mother_university public_primary /*
*/     	public_high_school income_10 income_2 interested_politics left_right_10 left_right_2 larger_income_differences_10 larger_income_differences_2 /*
*/     	greater_state_own_10 greater_state_own_2 greater_people_res_10 greater_people_res_2 competition_harmful_10 competition_harmful_2 luck_contacts_10 /*
*/		luck_contacts_2 strong_leader experts military_gov democratic_gov

set matsize 1600
outreg2 using  descriptive_experiment1.xls , replace sum(log) auto(2) keep(female Montevideo father_university mother_university public_primary /*
*/     	public_high_school income_10 income_2 interested_politics left_right_10 left_right_2 larger_income_differences_10 larger_income_differences_2 /*
*/     	greater_state_own_10 greater_state_own_2 greater_people_res_10 greater_people_res_2 competition_harmful_10 competition_harmful_2 luck_contacts_10 /*
*/		luck_contacts_2 strong_leader experts military_gov democratic_gov)

save "$path/descriptive1.dta", replace
**********************************************************************************************************************
* 1.2. Table \ref{table:descriptive1}: characteristics and beliefs of Uruguayans according to WVS6
**********************************************************************************************************************
* The WVS database was downloaded on May 2020 from http://www.worldvaluessurvey.org/WVSDocumentationWV6.jsp. The codes are available in 
* F00007756-WV6_Results_Uruguay_2011_v20180912.pdf

clear all
use "$path/WVS/WV6_Data_Uruguay_2011_Stata_v20180912.dta",clear

*generate female variable*
gen female=V240
recode female 1=0 2=1
tab V240, missing

*generate perception_low_income*
gen income_10=V239 if V239!=-2 & V239!=-1 
tab income_10 V239, missing


gen income_2=. 
replace income_2=1 if V239>5 & V239!=-2 & V239!=-1
replace income_2=0 if V239<=5 & V239!=-2 & V239!=-1

*generate interested_politics which represents the percentage of people with some or a lot of interest in politics*
gen interested_politics=V84
recode interested_politics 2=1 3=0 4=0 -1=. -2=.
tab V84 interested_politics, missing

*generate left variable - those who respond <=5 in question V95 were associated with left preferences*
tab V95
gen left_right_10=V95 if V95!=-1 & V95!=-2 

gen left_right_2=.
replace left_right_2=1 if V95>5 & V95!=-1 & V95!=-2 
replace left_right_2=0 if V95<=5 & V95!=-1 & V95!=-2
tab left_right_10 left_right_2, missing

/*larger_income_differences */

gen larger_income_differences_10=V96 if V96!=-1 & V96!=-2 

gen larger_income_differences_2=.
replace larger_income_differences_2=0 if V96<=5 & V96!=-1 & V96!=-2 
replace larger_income_differences_2=1 if V96>5 & V96!=-1 & V96!=-2
tab larger_income_differences_10  larger_income_differences_2, missing

/*generate greater_state_own */
tab V97, missing
gen greater_state_own_10=V97 if V97!=-1 & V97!=-2

gen greater_state_own_2=.
replace greater_state_own_2=0 if V97<=5 & V97!=-1 & V97!=-2 
replace greater_state_own_2=1 if V97>5 & V97!=-1 & V97!=-2
tab greater_state_own_10 greater_state_own_2, missing

/*generate greater_people_res */
tab V98, missing
gen greater_people_res_10=V98 if V98!=-1 & V98!=-2  

gen greater_people_res_2=.
replace greater_people_res_2=0 if V98<=5 & V98!=-1 & V98!=-2 
replace greater_people_res_2=1 if V98>5 & V98!=-1 & V98!=-2
tab greater_people_res_10 greater_people_res_2, missing

/*generate competition_harmful*/
tab V99
gen competition_harmful_10=V99 if V99!=-1 & V99!=-2

gen competition_harmful_2=.
replace competition_harmful_2=0 if V99<=5 & V99!=-1 & V99!=-2 
replace competition_harmful_2=1 if V99>5 & V99!=-1 & V99!=-2
tab competition_harmful_10 competition_harmful_2, missing

/*generate luck_contacts variable */
tab V100, missing
gen luck_contacts_10=V100 if V100!=-1 & V100!=-2

gen luck_contacts_2=.
replace luck_contacts_2=0 if V100<=5 & V100!=-1 & V100!=-2 
replace luck_contacts_2=1 if V100>5 & V100!=-1 & V100!=-2
tab luck_contacts_10 luck_contacts_2, missing

/*strong_leader = proportion of people who think that having a strong leader is good or very good for the country*/
tab V127
gen strong_leader=V127
recode strong_leader 2=1 3=0 4=0 -2=. -1=.
label define strong_leader 1"Bueno o Muy bueno" 0"Malo o Muy malo"
label value strong_leader strong_leader
tab strong_leader, missing

/* technocrats which = proportion of people who think that having experts and not a government taking decisions
is good or very good for the country*/
tab V128
gen experts=V128
recode experts 2=1 3=0 4=0 -2=. -1=.
label define experts 1"Bueno o Muy bueno" 0"Malo o Muy malo"
label value experts experts
tab experts, missing

/* military_gov = proportion of people who think that having a military government is good or very good 
for the country*/
tab V129
gen military_gov=V129
recode military_gov 2=1 3=0 4=0 -2=. -1=.
label define military_gov 1"Bueno o Muy bueno" 0"Malo o Muy malo"
label value military_gov military_gov
tab military_gov, missing

/* democratic_gov = proportion of people who think that having a democratic government is good or very good 
for the country*/
tab V130
gen democratic_gov=V130
recode democratic_gov 2=1 3=0 4=0 -2=. -1=.
label define democratic_gov 1"Bueno o Muy bueno" 0"Malo o Muy malo"
label value democratic_gov democratic_gov
tab democratic_gov

order female income_10 income_2 interested_politics left_right_10 left_right_2 larger_income_differences_10 larger_income_differences_2 /*
*/     	greater_state_own_10 greater_state_own_2 greater_people_res_10 greater_people_res_2 competition_harmful_10 competition_harmful_2 luck_contacts_10 /*
*/		luck_contacts_2 strong_leader experts military_gov democratic_gov


set matsize 3000
outreg2 using  "descriptive_Uruguay.xls" , replace sum(log) keep(female income_10 income_2 interested_politics left_right_10 /*
*/		left_right_2 larger_income_differences_10 larger_income_differences_2 greater_state_own_10 greater_state_own_2 greater_people_res_10  /*
*/		greater_people_res_2 competition_harmful_10 competition_harmful_2 luck_contacts_10 luck_contacts_2 strong_leader experts military_gov democratic_gov)

**********************************************************************************************************************
* 2. Table \ref{table:descriptive2}: Descriptive statistics 2
**********************************************************************************************************************
/* 	How did the subjects play?  
*/
clear all
use "$path/descriptive1.dta", clear

g  subject = "" 
g zero = .
g one = .

global varlist1 "female Montevideo father_university mother_university public_primary public_high_school income_2"
global varlist2 "left_right_2 larger_income_differences_2 greater_state_own_2 greater_people_res_2 competition_harmful_2"
global varlist3 "luck_contacts_2 interested_politics strong_leader experts military_gov democratic_gov"

local s = 1
foreach x in $varlist1 $varlist2 $varlist3 {
	replace subject = "`x'" if _n == `s'
	sum Vi if `x'== 0
	replace zero = r(mean) if  _n == `s'
	sum Vi if `x'== 1
	replace one = r(mean) if  _n == `s'
	local s = `s' + 1 
	dis `s'
}

export excel subject zero one using descriptive_experiment2, replace firstrow(variables)

erase "$path/descriptive1.dta"
