/* 
Weakening checks and balances. Forteza, Mussio and Pereyra. Simulations. 

This do file produces the expected net gains from SP in each and every within- and between-subjects treatment. For
stochastic simulations of the model used to calibrate the experiment see Juego_del_bloqueo_politico_PANEL_20190717.do.

*/

*global path = "C:\Users\alvar\Documents\Agency\Separation of Powers\Experimento\Analisis\Simulaciones"
*global path = "C:\Users\alvar\Documents\Agency\Separation of Powers\Experimento\Analisis\DATOS"
if  ("`c(hostname)'"=="MacBook-Pro-de-Alvaro.local") global path "/Users/alvaroforteza/Documents/Agency/Experimento dismantling CB/Analisis/DATOS" 
cd "$path"

***************************************************************************************************************************
* 1. Setting the database and parameters
***************************************************************************************************************************
clear all
global num_T = 7						// Number of treatments
global num_ixT = 50						// Number of individuals per treatment
global num_i = $num_ixT * $num_T        // Total number of individuals
global num_j = 14                       // Number of rounds
global num_obs = $num_i * $num_j        // Number of observations
global UM 	= 25*8						// Payoff of a matching between the policy and the state of nature
global a 	=  $UM /2.5   				// Utility of reform
global r_L 	= $a *0.3					// Low rents
global r_H 	= $a *1.2      				// High rents
global q_L 	= 0.2						// Low probability of s=1.
global q_H 	= 0.9						// High probabilty of s=1.
global sd_it = 3*8 						// Standard deviation of the idiosyncratic popularity shock
global sd_i =  10						// Standard deviation of the individual effect
*global sd_i = 0

set seed  13035561						// Seed of the shocks
global q_star = ($a + $r_L )/(2*$a )
dis $q_star

set obs $num_i

* Creating individuals
g i = _n

* Generating individual preference shock
g eta_i = rnormal(0,$sd_i ) //

expand $num_j
sort i

* Generating treatments
g T = $num_T   
forvalues s = 1(1)$num_T {
replace T = $num_T - `s'  if _n <= ($num_T -`s')*($num_i /$num_T )*$num_j
}

* Generating rounds
g j = _n
replace j = j - $num_j *(i-1) 

* Setting values of variables
g r = $r_L  		 
replace r = $r_H if  T == 5

g q = $q_H
replace q = $q_L if T == 2 | T == 4

g stalemate = 1  	// stalemate is the frequency of stalemate. It is binary: stalemate = 1 if high frequency.
replace stalemate = 0 if T == 1 | T == 2 

g corruption = 0  
replace corruption = 1 if T == 6  // corr=1 designs the treatments where r is explicitly identified with corruption.

g political = 0    	// political identifies the framing. It is binary: political = 0 if  "neutral" and = 1 if "political"
replace political = 0 if T == 7

****************************************************************************************************************************************************
* 2. Preferences and proposals of politicians in part 2 of the experiment (table 4 in "Experimento EL juego del bloqueo político - 20190321.docx" ).
****************************************************************************************************************************************************
g X_pref = 0 		// X_pref = 0 means X is biased towards 0.
g L_pref = 0  
g p_X = 0
g p_L = 0

replace X_pref = 1 	if j >= 5 & j <= 8	
replace X_pref = 2 	if j >= 9            // X_pref == 2 means X prefers the matching of policy and the state of nature.
replace L_pref = 1 	if j == 2 | j == 6 | j == 11 | j == 12
replace L_pref = 2 	if j == 3 | j == 4 | j == 7 | j == 8 | j == 13 | j == 14  
replace p_X = 1 	if (j >= 5 & j <= 8) | j == 10 | j == 12 | j == 14
replace p_L = 1 	if j == 2 | j == 4 | j == 6 | j == 8 | j == 11 | j == 12 | j == 14

****************************************************************************************************************************************************
* 3. Policies and utility 
****************************************************************************************************************************************************

g p_1 = 0       // Policy implemented with rule 1 (checks and balances)
replace p_1 = 1 if p_X == 1 & p_L == 1  // There is reform with rule 1 iff both propose a reform.
g p_2 = p_X		// Policy implemented with rule 2 (special powers): X proposals are implemented.

/* Expected payoffs u_1 and u_2, conditional on politicians proposals. These payoffs take into account the Bayesian updating of the
probabilities of state of nature. I present each and every round subjects will play in the second part of the experiment 
(see table 6 in "Experimento EL juego del bloqueo político - 20190321.docx" ).
*/ 
g u_1 = $UM
replace u_1 = $UM - $a *q 	if j==1 | j==2 | j==5 
replace u_1 = $UM - $a		if j==4 | j==10
 
g u_2 = $UM - r
replace u_2 = $UM - $a *q - r 		if j==1 | j==2 
replace u_2 = $UM - $a  - r 		if j==4 | j==7 
replace u_2 = $UM - $a *(1-q) - r 	if j==5


********************************************************************************************************************************************************************
* 4. Expected responses with popularity shocks, if subjects understand the game and only consider the monetary payments
* ("correct" filling of \label{table:SPgains} in Weakening-CB-Experiment.tex)
********************************************************************************************************************************************************************
 
/* I simulate an experimental database adding a popularity shock of CB (e). Voters grant SP if u_2 + e > u_1. I allow subjects 
experience various realizations of the popularity shock, since they face different X and L and in different circumstances.
For the moment, the shock is iid (I am not considering shocks /eta_i and /eta_t yet). 
*/

* 4.1. 	I generate iid shocks and a binary variable equal to 1 if the subject votes for SP (rule 2) and 0 otherwise.

g eta_it 	= rnormal(0,$sd_it )

g e = eta_i + eta_it


* 4.2. Subjects responses if they understand the game and base their response exclusively on monetary payments.

g SPgain = u_2 - u_1
g Vi = (u_2 + e > u_1)			// Vote of subject i for the rule. Vi = 0 if he votes for CB (rule 1) and Vi = 1 if he votes for SP (rule 2).

order T i j p_X p_L u_1 u_2 eta_i eta_it e SPgain Vi

* 4.3. Tables of (i) net expected gains with SP and (ii) probability of SP.

/* Note these payoffs use the Bayesian updating of the probabilities of the state of nature. The probability of choosing rule 2 is monotonically increasing in the advantage of rule 2 over 1. The tables summarize all the cases in the experiment. For a similar construct see table 4 in "Experimento EL juego del bloqueo político - 20190321.docx"
*/
 

/*
* Computing the net gain from SP and the probability of SP (equations \ref{eq:vSP-vCB} and \ref{eq:probSP} in Weakening-CB-Experiment-20190711.tex).
preserve  // I comment this part that was already computed and saved in excel.  
keep if i == 1 | i == ($num_ixT + 1) | i == ($num_ixT *2 + 1) | i == ($num_ixT *3 + 1) | i == ($num_ixT *4 + 1) | i == ($num_ixT *5 + 1) | i == ($num_ixT *6 + 1)
keep  j T SPgain X_pref L_pref p_X p_L
reshape wide SPgain X_pref L_pref p_X p_L, i(j) j(T)

order j X_pref* L_pref* p_X* p_L* SPgain*

keep j X_pref1 L_pref1 p_X1 p_L1 SPgain*

rename X_pref1  X_pref
rename L_pref1  L_pref 
rename p_X1  p_X
rename p_L1  p_L

rename j round
forvalues i =1(1)7 {
label variable SPgain`i' "v_SP-v_CB in T`i'"
}
export excel net_gain_from_SP, firstrow(variables) replace

forvalues i =1(1)7 {   //WARNING: This computation is correct only when sd_i =  0
g prSP_T`i'= normal(SPgain`i'/$sd_it )
}  


drop SPgain* 
export excel Probability_of_SP, firstrow(variables) replace
restore
*/
