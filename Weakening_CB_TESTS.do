/* 
Weakening checks and balances. Processing of experimental data.
 
Based on: main.tex, in project: Experiment Special Powers.

We use mhtreg to control the familywise error rate (FWER, the probability of making any type I error). See Barsabai et al 2020, List et al 2019 and Romano and Wolf 2010. 

*/
*global path = "C:\Users\alvar\Documents\Agency\Separation of Powers\Experimento\Analisis\DATOS"
*global path = "C:\Research\Checks and Balances\Analysis\DATOS" 
if  ("`c(hostname)'"=="MacBook-Pro-de-Alvaro.local") global path "/Users/alvaroforteza/Documents/Agency/Experimento dismantling CB/Analisis/DATOS" 
cd "$path"
clear all


********************************************************************************************************************************************************************
* 1. Generating variables
********************************************************************************************************************************************************************
  
use "$path/data.dta",clear
  
* Dummies for the 14 tasks in part 2 of the experiment 
foreach j of num 1/14 {
	gen d`j'=(t==`j')
}

* Dummies for the nine main hypotheses (treated observations as depicted in table {table:treatmentsandcontrols}).
 
 g h1 = (p_X==1 & p_L==0 & X_pref==1 & L_pref==0 & q>0.5)
 g h2 = (p_X==1 & p_L==0 & X_pref==2 )
 g h3 = (p_X==1 & p_L==0 & X_pref==1 & L_pref==0 & q<0.5)
 g h4 = (p_X==1 & p_L==0 & L_pref==2 )
 g h5 = (p_X==1 & p_L==0 & X_pref==1 & L_pref==0 & q>0.5)
 g h6 = r==96
 g h7 = corruption
 g h8 = political
 g h9 = T <= 2       // low frequency of political gridlock in priming phase
 tabulate i, g(id)  // Dummies for individual effects.
 
* Note: h1 and h5 are tested with the same treated observations, but different controls (see {table:treatmentsandcontrols})  
 
* Errors 
g check_morethan1 = check_2nd >1 
label var check_morethan1 "=1 if number of attempts at answering the right-wrong questions is 2 or more"

sum i
global numi = r(max)

capture drop check_2nd_i
g check_2nd_i = .
forvalues x=1(1)$numi {
	sum check_2nd if i == `x'
	replace check_2nd_i = r(mean) if i == `x'
}
label var check_2nd_i "Average number of attempts by individual in part 2"

* Risk aversion
codebook riskaverse 
sum riskaverse

* Female
encode genero_nac, gen(female) 
recode female 2=0 

sum Vi if female == 0
sum Vi if female == 1


* Right wing
xtile right = izquierda_derecha, nq(2) 
replace right = right -1
label variable right "=1 if subject to the right of the median, =0 otherwise" 

table right, stat(mean Vi)

* Strong leader
encode gobierno_lider, gen(strong_leader)
recode strong_leader 3=1 2=0 4=0
label drop strong_leader
label define strong_leader 1"Good or very good" 0"Bad or very bad"
label value strong_leader strong_leader
 
table strong_leader, stat(mean Vi) 

* Interaction variables 
foreach var in "check_morethan1" "riskaverse" "female" "right" "strong" "corruption" "political" {
	forvalues i=1(1)4{
		g h`i'_`var'= h`i'*`var'
	}
}

* Age range

g a19less  = nacimiento == "19 años o menos"
replace a19less = . if nacimiento == ""
label var a19less "= 1, if aged 19 or less, = 0, otherwise"

save "$path/data1.dta", replace
*****************************************************************************
* 2. Balance of covariates in treated and control groups
*****************************************************************************
/* For each hypothesis, we analyze the balance of several covariates between treatment and control groups as depicted in table {table:treatmentsandcontrols}. 
*/

use "$path/data1.dta", clear
*****************************************************************************
* 2.1. Defining dummies that identify controls (non-treated observations) for each hypothesis. 
*****************************************************************************

forvalues x=1(1)4 {
	g h`x'_control = ((p_X==0 & p_L==0) | (p_X==0 & p_L==1) | (p_X==1 & p_L==1))
	label var h`x'_control "= 1, if no political gridlock; and = 0, otherwise"
}

g h5_control = (p_X==1 & p_L==0 & X_pref==1 & L_pref==0 & q<0.5)
label var h5_control "= 1, if prob. reform is beneficial is low; and = 0, otherwise"

g h6_control = r!=96
label var h6_control "= 1, if low rents; and = 0, otherwise"

g h7_control =  T!=6
label var h7_control "= 1, if no-corruption framing; and = 0, otherwise"

g h8_control =  T!=7
label var h8_control "= 1, if non-political framing; and = 0, otherwise"

g h9_control = T > 2
label var h9_control "= 1, if high frequency of gridlock; and = 0, otherwise"

*****************************************************************************
* 2.2. Redefining variables for the analysis of balance
*****************************************************************************

g private_pr = (educ_primaria == "Privada" )
replace private_pr = . if educ_primaria == ""
label var private_pr "=1, if primary education in private school, and = 0, otherwise"

g private_hs = (educ_secundaria == "Privada" )
replace private_hs = . if educ_secundaria == ""
label var private_hs "=1, if secondary education in private school, and = 0, otherwise"

g father_uni = (educ_padre == "Terciaria incompleta" | educ_padre == "Terciaria completa")
replace father_uni = . if educ_padre == ""
label var father_uni "=1, if father attended university, and = 0, otherwise"

g mother_uni = (educ_madre == "Terciaria incompleta" | educ_madre == "Terciaria completa")
replace mother_uni = . if educ_madre == ""
label var mother_uni "=1, if mother attended university, and = 0, otherwise"

save "$path/data2.dta", replace

*****************************************************************************
* 2.3. Analysis of balance
*****************************************************************************

/* I test whether the frequency of the covariate `var' is different in the treated and pooled (treated and non-treated) observations. The frequency in the pooled sample is fr_`var'_h`x'_and_control (where h`x' stands for hypothesis `x', with `x' going from 1 to 9). The values of `var' in the treated subsample are `var'_h`x'
H0: n * fr_`var'_h`x' = n * V1h`x' , Ha: n * fr_`var'_h`x' != n * V1h`x' . Reject H0 if Pr(n*fr_`var'_h`x' != n*V1h`x'  |H0) < threshold.

I do not run an analysis of balance for h2 and h4 because these hypotheses are tested comparing different decisions of the same sets of subjects (only within-subject comparisons). 
*/


*local x = 1

foreach x in 1 3 5 6 7 8 9 {	
*foreach x in 1 {	 
	matrix balance_h`x' = J(6,3,.)
	global varlist "female a19less private_pr private_hs father_uni mother_uni"
	use "$path/data2.dta", clear  
	keep  i t h`x' h`x'_control $varlist
	keep if h`x'==1 | h`x'_control ==1
	local i = 1
	foreach var in $varlist {
*		dis "`var'"
		sum `var' if h`x'==1 
		global fr_`var'_h`x' = r(mean)   // mean of `var' in h`x'-treated observations
		sum `var' if h`x'_control ==1 
		global fr_`var'_h`x'control = r(mean)   // mean of `var' in h`x'-control observations
		sum `var' if h`x'==1 | h`x'_control == 1
		global fr_`var'_h`x'_and_control = r(mean)   //  mean of `var' in h`x- treated and control observations

		capture drop `var'_h`x'
		g `var'_h`x' = `var' if h`x'==1    // observations of `var' in the treated subsample
		
		keep if h`x'==1 
		collapse (mean)   `var'_h`x' , by(i) //Individuals must be counted only once for bitest
		bitest `var'_h`x' == ${fr_`var'_h`x'_and_control}, detail  
		
		global pv_`var'_h`x'  = r(p)   //two-sided test p-value

		dis ${fr_`var'_h`x'_and_control} ${fr_`var'_h`x'control} ${fr_`var'_h`x'} ${pv_`var'_h`x'}

		matrix balance_h`x'[`i',1] = ${fr_`var'_h`x'}
		matrix balance_h`x'[`i',2] = ${fr_`var'_h`x'control}
		matrix balance_h`x'[`i',3] = ${pv_`var'_h`x'}

		
		use "$path/data2.dta", clear  
		keep  i t h`x' h`x'_control $varlist
		keep if h`x'==1 | h`x'_control ==1
		local ++i
	}


	matrix list balance_h`x'

	mat roweq balance_h`x' = "Female" "Aged 19 and less " "Private primary school" "Private high scool" "Father attended university" "Mother attended university" //I use roweq rather than rownames to use it with esttab and get a latex table. 
	matrix colnames balance_h`x' = "Treated" "Control" "P-values"

	esttab matrix(balance_h`x', fmt(%9.3f)) using balance_h`x'.tex, eqlabels(,merge)  tex substitute(:r1 "" :r2 "" :r3 "" :r4 "" :r5 "" :r6 "" ) replace
}

* Note: I decided not to use prtest because of small sample size. In some cases n(1-p) or np is not larger than 5.

********************************************************************************************************************************************************************
* 3. Regressions without controlling for mht. 
********************************************************************************************************************************************************************
/* We run these regressions to determine (i) the control mean and (ii) the number of observations in tables \ref{table:main} and 
\ref{table:excessSP}. The set of hypotheses to be tested is:

	H1: pg (weakly) raises SP if biased $X$ and $L$ ($X_R$ and $L_C$) and the reform is ex ante beneficial ($q>1/2$)
	H2: pg (weakly) raises SP if unbiased $X$ ($X_M$)
 	H3: pg (weakly) decreases SP if biased $X$ and $L$ ($X_R$ and $L_C$) and the reform is ex ante harmful ($q<=1/2$).
	H4: pg (weakly) decreases SP if unbiased $L$ ($L_M$)
	H5: SP weakly rises with q when $X_R$ and $L_C$ 
	H6: SP weakly decreases with r
	H7: SP decreases with corruption framing
	H8: SP decresases with corruption + political framing
	H9: SP does not depend on priming.
	H3*errors
	H4*errors
	H3*risk averse
	H4*risk averse
	H3*female
	H4*female
	H3*right wing
	H4*right wing
	H3*strong leader
	H4*strong leader
	H4*corruption
	H4*political framing
	*/
 ********************************************************************************************************************************************************************

use "$path/data1.dta", clear
 
 * Hypotheses h1 to h9
capture drop controls
capture drop num_obs
g controls = .
g num_obs = .  

global list = " check_morethan1 riskaverse female right strong_leader"
* global list = " check_morethan1 rowfirst female izquierda_derecha strong_leader" // Checking: we substitute the ten-point scale rowfirst and izquierda_derecha for the two-point scale riskaverse and right.

reg Vi i.h1 i.h2 i.h3 i.h4 	i.h6 i.h7 i.h8 i.h9	$list	
replace num_obs = e(N) if _n <= 9

margins i.h1, at(h2==0 h3==0 h4==0)
matrix x = r(b)
replace controls = x[1,1] if _n == 1   	// Control for H1. 

margins i.h2, at(h1==0 h3==0 h4==0)
matrix x = r(b)
replace controls = x[1,1] if _n == 2   	// Control for H2. 

margins i.h3, at(h1==0 h2==0 h4==0)
matrix x = r(b)
replace controls = x[1,1] if _n == 3   	// Control for H3. 

margins i.h4, at(h1==0 h2==0 h3==0)
matrix x = r(b)
replace controls = x[1,1] if _n == 4   	// Control for H4. 

margins i.h1 i.h2 i.h3 i.h4 i.h6 i.h7 i.h8 i.h9
matrix x = r(b)
replace controls = x[1,6] if _n == 5  // x[1,6]=1.h3 is the control for H5, since H5 compares h1==1 (treated) and h3==1 (control) (see table {table:treatmentsandcontrols}).
replace controls = x[1,9] if _n == 6	// Control for H6.
replace controls = x[1,11] if _n == 7	// Control for H7.
replace controls = x[1,13] if _n == 8	// Control for H8.
replace controls = x[1,15] if _n == 9	// Control for H9.

* Interactions of h3 and h4 with several covariates.
local row = 10
foreach var in "check_morethan1" "riskaverse" "female" "right" "strong"  {
	reg Vi i.h3 i.h4  i.h3#i.`var' i.h4#i.`var'  i.h1 i.h2  $list
	replace num_obs = e(N) if _n==`row' | _n == `row'+1
	margins i.h3#i.`var', at(h1==0 h2==0 h4==0)
	matrix x = r(b)
	replace controls = x[1,3] - x[1,1] if _n== `row'
	margins i.h4#i.`var', at(h1==0 h2==0 h3==0)
	matrix x = r(b)
	replace controls = x[1,3] - x[1,1] if _n== `row'+1
	local row = `row' + 2
*	dis "FILA: `row'"
}

local row = 20
foreach var in "corruption" "political"   {
	reg Vi i.h4  i.h4#i.`var' i.h1 i.h2 i.h3  $list
	replace num_obs = e(N) if _n==`row' 
	margins i.h4#i.`var', at(h1==0 h2==0 h3==0)
	matrix x = r(b)
	replace controls = x[1,3] - x[1,1] if _n== `row'
	local row = `row' + 1
*	dis "FILA: `row'"
}

list num_obs controls if  _n<=23	

export excel controls num_obs using "$path/controls" if _n<22, replace firstrow(variables) // Copy in Weakening-CB-Experiment-TABLES.xlsx, sheet controls.

********************************************************************************************************************************************************************
* 4. Adjusting for multiple hypothesis testing.
********************************************************************************************************************************************************************
 
/* Clustering: we have nested clusters in individuals and between-subjects treatments (T1 to T7). We decided to cluster at
individuals because of few treatment clusters and low correlation of regressors within treatments. Clustering at
the highest aggregation level (treatments) would severely reduce precision without adding much in terms of consistency. 
* Copy from the STATA results window using copy as HTML and paste in Weakening-CB-Experiment-TABLES.xlsx, sheet mhtreg.
*/


mhtreg 	(Vi h1 h2 h3 h4 h6 h7 h8 h9 $list) 		(Vi h2 h3 h4 h1 h6 h7 h8 h9 $list) (Vi h3 h4 h1 h2 h6 h7 h8 h9 $list) 		/*
*/		(Vi h4 h1 h2 h3 h6 h7 h8 h9 $list) 		(Vi h1 $list if h1 == 1 | h3 == 1) (Vi h6 h1 h2 h3 h4 h6 h7 h8 h9 $list)   	/*
*/		(Vi h7 h1 h2 h3 h4 h6 h8 h9 $list) 		(Vi h8 h1 h2 h3 h4 h6 h7 h9 $list) (Vi h9 h1 h2 h3 h4 h6 h7 h8 $list)  		/*
*/      (Vi h3_check_morethan1 h4_check_morethan1 h3 h4 $list)	(Vi h4_check_morethan1 h3_check_morethan1 h3 h4 $list) 	/*
*/		(Vi h3_riskaverse h4_riskaverse  h3 h4 $list) 			(Vi h4_riskaverse h3_riskaverse  h3 h4 $list)				/*
*/		(Vi h3_female h4_female h3 h4 $list)					(Vi h4_female h3_female h3 h4 $list)					/*
*/		(Vi h3_right h4_right h3 h4 $list)						(Vi h4_right h3_right h3 h4 $list)					/*
*/		(Vi h3_strong h4_strong  h3 h4 $list)					(Vi h4_strong h3_strong  h3 h4 $list) 					/*
*/		(Vi h4_corruption h4 $list)								(Vi h4_political h4 $list)  , cluster(i) cltype(3) seed(13035561)

 
*****************************************************************************
* 5. Fisher tests (Appendix of the document)
***************************************************************************** 

clear all
use "$path/data.dta",clear 
 
******************************************************************************
* 5.1. The effects of political gridlock  ({table:frequencies})
******************************************************************************
/* 
H1.  biased $X$ and $L$ ($X_R$ and $L_C$) and the reform is ex ante beneficial ($q>1/2$)
H2.  unbiased $X$ ($X_M$)
H3.  biased $X$ and $L$ ($X_R$ and $L_C$) and the reform is ex ante harmful ($q<=1/2$).
H4.  unbiased $L$ ($L_M$)
*/
 
/* Methodological note: I do not use prtest because the conditions n*p>5 & n*(1-p)>5 are not always fulfilled. So I use bitest ("Fisher's exact test"). 
*/ 

capture log close
log using tabulados, replace text 

* a) Overview 1: T3 = ex ante beneficial reforms
capture drop  gridlock_4point
g gridlock_4point = .  if T == 3
replace gridlock_4point = 0 if (T == 3 & p_X == 0 & p_L == 0 & X_pref==0 & L_pref==0)
replace gridlock_4point = 1 if (T == 3 & p_X == 1 & p_L == 0 & X_pref==1 & L_pref==0)
replace gridlock_4point = 2 if (T == 3 & p_X == 1 & p_L == 0 & X_pref==2)
replace gridlock_4point = 3 if (T == 3 & p_X == 1 & p_L == 0 & L_pref==2)
label define point_labels  0 "no gridlock" 1 "gr, biased X & L " 2 "gr, biased L " 3 "gr, biased X", replace
label values gridlock_4point  point_labels
*table gridlock_4point if T == 3, c(mean Vi sd Vi count Vi)  
 
logout, save("$path/DATOS/SPHq") excel noauto replace fixcut(21 34 49 65): ///
   table gridlock_4point if T == 3, c(mean Vi count Vi)  	 

* b) Overview 2: T4 = ex ante harmful reforms   
capture drop  gridlock_4pointT4
g gridlock_4pointT4 = .  if T == 4
replace gridlock_4pointT4 = 0 if (T == 4 & p_X == 0 & p_L == 0 & X_pref==0 & L_pref==0)
replace gridlock_4pointT4 = 1 if (T == 4 & p_X == 1 & p_L == 0 & X_pref==1 & L_pref==0)
replace gridlock_4pointT4 = 2 if (T == 4 & p_X == 1 & p_L == 0 & X_pref==2)
replace gridlock_4pointT4 = 3 if (T == 4 & p_X == 1 & p_L == 0 & L_pref==2)
label define point_labels  0 "no gridlock" 1 "gr, biased X & L " 2 "gr, biased L " 3 "gr, biased X", replace
label values gridlock_4pointT4  point_labels
table gridlock_4pointT4 if T == 4, statistic(mean Vi ) statistic(count Vi)  
logout, save("$path/DATOS/SPLq") excel noauto replace fixcut(21 34 49 65): ///
   table gridlock_4pointT4 if T == 4, c(mean Vi count Vi)   
  

/* 5.1.1. H1a: A political gridlock raises the probability of $SP$ if the gridlock occurs with (i) biased $X$ and $L$ ($X_R$ and $L_C$) and the reform is ex ante beneficial ($q>1/2$), or (ii) unbiased $X$ ($X_M$).
*/ 
 

***************************************************************************************************************************************************************** 
* 5.1.1.1.  Biased $X$ and $L$ ($X_R$ and $L_C$) and the reform is ex ante beneficial ($q>1/2$). 
/* The reform is ex ante beneficial in T1, T3, T5, T6 and T7. I run first various tests using only T3, and then consider all treatments.  */
******************************************************************************************************************************************************************

* a) Compute the probabilities of SP and perform power tests to compute needed sample size.
* Conservative L. Conservative vs reformist X. 
sum Vi if T==3 & L_pref ==0 & X_pref==0							// T3, X & L biased towards the status quo (X_C, L_C)
global frSP_3XCLC = r(mean)
sum Vi if T==3 & L_pref ==0 & X_pref==1							// T3, X biased towards reform (X_R) & L biased towards the status quo (L_C)
global frSP_3XRLC = r(mean)
sum Vi if T==3 & L_pref ==0 & (X_pref==0 | X_pref==1 )			// T3, X_R or X_C & L biased towards the status quo (L_C)
global frSP_3XBLC = r(mean)
power twoproportions $frSP_3XBLC $frSP_3XRLC   

* Are these differences statistically significant? This is the matter of the following tests... 

* b) Check whether the probabilities are statistically different using bitest.

/* According to the STATA help, "bitest performs exact hypothesis tests for binomial random variables". 
*/

* I assume the two samples (X_pref=0 and X_pref=1) have the same proportion of SP. I compute this proportion
* in the pooled sample.

sum Vi if T==3 & L_pref ==0 & (X_pref==0 | X_pref==1)			// T3,  L biased towards the status quo (L_C)
global frSP_3XLC = r(mean)

/* I test whether the frequency of SP is larger with a reformist X than in the pooled sample with conservative and reformist X. The reform is ex ante beneficial and L is
conservative. The frequency in the subsample with reformist X is frSP_3XRLC and in the pooled sample is frSP_3XLC.
H0: n * frSP_3XLC = n * frSP_3XRLC  , Ha: n * frSP_3XLC < n * frSP_3XRLC . Reject H0 if Pr(n*frSP_3XLC >= n*frSP_3XRLC |H0) < threshold.
*/

g V1T3 = Vi if T==3 & X_pref == 1 & L_pref ==0
bitest V1T3 == $frSP_3XLC, detail  // I reject H0: Pr(n*frSP_3XLC=k >= n*frSP_3XRLC =20 |H0)
global pvT3_1  = r(p_u)

* Note: I decided not to use prtest because of small sample size. In some cases n(1-p) or np is not larger than 5.  
  
**********************************************
* 5.1.1.2.  Unbiased $X$ ($X_M$)
* I compare rounds 1 (both conservative) and 10 (unbiased X proposing reform and conservative legislature)
************************************************************************************************************************************
* Using T3

* a) Compute the probabilities of SP and perform power tests to compute needed sample size.
* 	Conservative L. Conservative vs unbiased X proposing reform. 
sum Vi if T==3 & t==10						// T3, X unbiased with p_X=1 and L conservative
global frSP_T3t10 = r(mean)
sum Vi if T==3 & (t == 1 | t == 10)			// T3, both conservatives or X unbiased with p_X=1 and L conservative
global frSP_T3t1t10 = r(mean)
power twoproportions $frSP_T3t1t10  $frSP_T3t10  		

/* A gridlock caused by an unbiased X raises the probability of SP, 0.775 vs 0.425, respectively. We need 60 observations to detect this difference.
*/

* b) Check whether the probabilities are statistically different using bitest.
* 	Conservative L. Conservative vs unbiased X proposing reform.

capture drop V1T3
g V1T3 = Vi if T==3 & t == 10
bitest V1T3 == $frSP_T3t1t10, detail  // I reject H0: Pr(k >= 31) = 0.000007. 
global pvT3_2  = r(p_u)

* Using T4
 
sum Vi if T==4 & (t == 1 | t == 10)				// T4, X unbiased with p_X=1 or X_C & L biased towards the status quo (L_C)
global frSP_T4t1t10 = r(mean)

capture drop V1T4
g V1T4 = Vi if t==10
bitest V1T4 == $frSP_T4t1t10, detail 
global pvT4_2  = r(p_u)

*Conservative L. Reformist vs unbiased X proposing reform. I test whether an unbiased X proposing reform convince more subjects to grant SP 
* than a reformist X. I do it for  treatments 3 and 4 (ex ante beneficial and harmful reforms).

sum Vi if T==3 & L_pref ==0 & (X_pref==1 | (X_pref==2 & p_X==1))			// T3,  L biased towards the status quo (L_C), unbiased X proposing reform or reformist X.
global frSP_3XRorXULC = r(mean)

capture drop V1T3
g V1T3 = Vi if T==3 & X_pref==2 & p_X==1 & L_pref ==0
bitest V1T3 == $frSP_3XRorXULC, detail  // I reject H0 at 5% significance:  Pr(k >= 31) = 0.046516.  

sum Vi if T==4 & L_pref ==0 & (X_pref==1 | (X_pref==2 & p_X==1))			// T4,  L biased towards the status quo (L_C), unbiased X proposing reform or reformist X.
global frSP_4XRorXULC = r(mean)

capture drop V1T4
g V1T4 = Vi if T==4 & X_pref==2 & p_X==1 & L_pref ==0
bitest V1T4 == $frSP_4XRorXULC, detail // I do not reject H0: Pr(n*frSP_T4t1t5=k <= n*p1T2=4|H0)= 0.965705
global pvT4_1  = r(p_u)   // In this case, given Ha, I choose the "upper one-sided p-value".

/* Conclusion: I cannot reject that the probability of SP is the same with X_pref=1 and X_pref=0. 
*/

*****************************************************
/* 5.1.2. H1b: A political gridlock REDUCES the probability of $SP$ if the gridlock occurs with (i) biased $X$ and $L$ ($X_R$ and $L_C$) 
and the reform is ex ante harmful ($q\leq 1/2$), or (ii) unbiased $L$ ($L_M$).
*/ 
******************************************************************************************************************************************* 
* 5.1.2.1.  biased $X$ and $L$ ($X_R$ and $L_C$) and the reform is ex ante harmful ($q<=1/2$).
/* The reform is harmful in T2 and T4. To see the effect of changing from p_X=0 to p_X=1, with p_L = 0 and both biased, I compare rounds 1 and 5. */
*******************************************************************************************************************************************

* a) Compute the probabilities of SP and perform power tests to compute needed sample size.
* Conservative L. Conservative vs reformist X. 
sum Vi if T==4 & t==1					// T4, X & L biased towards the status quo (X_C, L_C)
global frSP_T4t1 = r(mean)
sum Vi if T==4 & t==5					// T4, X biased towards reform (X_R) & L biased towards the status quo (L_C)
global frSP_T4t5 = r(mean)
sum Vi if T==4 & (t==1 | t == 5)			// T4, X_R or X_C & L biased towards the status quo (L_C)
global frSP_T4t1t5 = r(mean)
power twoproportions $frSP_T4t1t5 $frSP_T4t5   

* b) Check whether the probabilities are statistically different using bitest

* I assume the two samples (X_pref=0 and X_pref=1) have the same proportion of SP. I compute this proportion
* in the pooled sample. This is $frSP_T4t1t5. 

/* I test whether the probability of SP when X_pref == 1 (p1T2) is equal to frSP_T4t1t5. The alternative is that it is greater. 
H0: n * frSP_T4t1t5  = n * p1T2 , Ha: n * frSP_T4t1t5  < n * p1T2. Reject H0 if Pr(n*frSP_T4t1t5 =k <= n*p1T2|H0) < threshold.
*/
capture drop V1T4
g V1T4 = Vi if T==4 & t == 5
bitest V1T4 == $frSP_T4t1t5, detail  // I do not reject H0: Pr(n*frSP_T4t1t5=k <= n*p1T2=4|H0)
global pvT4_1  = r(p_u)   // In this case, given Ha, I choose the "upper one-sided p-value".

*******************************
* 5.1.2.2.  unbiased $L$ ($L_M$). 
**********************************************************************************************************************
/* With unbiased L, a political gridlock reduces the probability of SP (even if the reform is a priori beneficial!). 
I compare round 1, with both biased, and round 7, with a gridlock due to a biased X proposing reform and an unbiased L proposing status quo. 

I analyze first treatment 3 and then run regressions for all treatments.
*/
**********************************************************************************************************************

* Using T3
* a) Compute the probabilities of SP and perform power tests to compute needed sample size.

sum Vi if T==3 & t == 1							// T3, L & X biased towards the status quo (row 1)
global frSP_T3t1 = r(mean)		
sum Vi if T==3 & (t== 1 | t == 7)			// T3, L unbiased, p_L=0 & X biased towards the status quo (X_C) or reform (X_R) 
global frSP_T3t1t7 = r(mean)
power twoproportions $frSP_T3t1 $frSP_T3t1t7   								

* b) Check whether the probabilities are statistically different using bitest

capture drop V1T3
g V1T3 = Vi if T==3 & t == 7
bitest V1T3 == $frSP_T3t1t7, detail  // Pr(k >= 8)           = 0.176192 
global pvT3_3 =  r(p_u)       //  upper one-sided p-value
 
* Using T4
* a) Compute the probabilities of SP and perform power tests to compute needed sample size.

sum Vi if T==4 & t == 1							// T4, L & X biased towards the status quo (row 1)
global frSP_T4t1 = r(mean)		
sum Vi if T==4 & (t== 1 | t == 7)			// T4, L unbiased, p_L=0 & X biased towards the status quo (X_C) or reform (X_R) 
global frSP_T4t1t7 = r(mean)
power twoproportions $frSP_T4t1 $frSP_T4t1t7   								

* b) Check whether the probabilities are statistically different using bitest

capture drop V1T4
g V1T4 = Vi if T==4 & t == 7
bitest V1T4 == $frSP_T4t1t7, detail  // Pr(k >= 13)           = 0.139949 
global pvT4_3 =  r(p_u)       //  upper one-sided p-value

************************************************************************************** 
* P values of the Fisher tests of differences in proportions. Within-subjects comparisons.
***************************************************************************************

capture drop pv3 pv4   
g pv3 = $pvT3_1 if _n == 1
g pv4 = $pvT4_1 if _n == 1  
replace pv3 = $pvT3_2 if _n == 2
replace pv4 = $pvT4_2 if _n == 2     
replace pv3 = $pvT3_3 if _n == 3
replace pv4 = $pvT4_3 if _n == 3     

export excel pv3 pv4 using "$path/DATOS/pv-proportions" in 1/3, firstrow(variables) nolabel replace  
  

***************************************************************************************
* 5.2. The effects of rents 

*  Effects by within-subject conditions. 
* Fisher tests of equal frequency of SP with low and high rents. I compare treatments 3 and 5 row by row
***************************************************************************************

capture drop withincondition fr3 fr5 pv5  
g withincondition = _n if _n <=14
g fr3 = .
g fr5 = .
g pv5 = .

forvalues x=1(1)14 {
	display `x'
	sum Vi if T == 3 & t == `x'
	replace fr3 = r(mean) if withincondition == `x'
	replace fr3 = r(N) if _n == 15
	sum Vi if T == 5 & t == `x'
	replace fr5 = r(mean) if withincondition == `x'
	replace fr5 = r(N) if _n == 15
	sum Vi if (T == 3 | T == 5) & t == `x'
	global frSP = r(mean)
	capture drop VT5
	g VT5 = Vi if T == 5 & t == `x'
	bitest VT5 == $frSP, detail
	replace pv5  = r(p_l) if withincondition == `x'
}
export excel withincondition fr3 fr5 pv5 using "$path/DATOS/highvslowrents.xls" in 1/15, firstrow(variables) nolabel replace

********************************************************************************************************************************************************************
* 5.3. The effects of the history of political gridlock.

/* According to the theoretical model, the results should be the same with different histories, so T1 and T3, and T2 and T4 should give the same results. The frequencies of SP in these treatments across all rounds should be the same. 
*/
***************************************************************************************

* Effects by within-subject conditions. 
* Fisher tests of equal frequency of SP with low and high rents. I compare treatments 1 and 3 row by row
*********************************************************************************************************************

capture drop withincondition 
capture drop fr1 
capture drop fr3
capture drop pv1  
g withincondition = _n if _n <=14
g fr1 = .
g fr3 = .
g pv1 = .

forvalues x=1(1)14 {
	display `x'
	sum Vi if T == 1 & t == `x'
	replace fr1 = r(mean) if withincondition == `x'
	replace fr1 = r(N) if _n == 15
	sum Vi if T == 3 & t == `x'
	replace fr3 = r(mean) if withincondition == `x'
	replace fr3 = r(N) if _n == 15
	sum Vi if (T == 1 | T == 3) & t == `x'
	global frSP = r(mean)
	capture drop VT1
	g VT1 = Vi if T == 1 & t == `x'
	bitest VT1 == $frSP, detail
	replace pv1  = r(p_l) if withincondition == `x'
}
export excel withincondition fr1 fr3 pv1 using "$path\lowfreqpriming.xls" in 1/15, firstrow(variables) nolabel replace

************************************************************************************
* 5.4. The effects of framing (corruption and political framings)
***********************************************************************************
 
* Fisher tests of equal frequency of SP with different framings. I compare treatments 3, 6 and 7 row by row
************************************************************************************

capture drop withincondition 
capture drop fr3 
capture drop fr6
capture drop fr7
capture drop pv6  
capture drop pv7  
g withincondition = _n if _n <=14
g fr3 = .
g fr6 = .
g fr7 = .
g pv6 = .
g pv7 = .


forvalues x=1(1)14 {
	display `x'
	sum Vi if T == 3 & t == `x'
	replace fr3 = r(mean) if withincondition == `x'
	replace fr3 = r(N) if _n == 15
* T6 vs T3
	sum Vi if T == 6 & t == `x'
	replace fr6 = r(mean) if withincondition == `x'
	replace fr6 = r(N) if _n == 15
	sum Vi if (T == 3 | T == 6) & t == `x'
	global frSP = r(mean)
	capture drop VT6
	g VT6 = Vi if T == 6 & t == `x'
	bitest VT6 == $frSP, detail
	replace pv6  = r(p) if withincondition == `x'
* T7 vs T6	
	sum Vi if T == 7 & t == `x'
	replace fr7 = r(mean) if withincondition == `x'
	replace fr7 = r(N) if _n == 15
	sum Vi if (T == 6 | T == 7) & t == `x'
	global frSP = r(mean)
	capture drop VT7
	g VT7 = Vi if T == 7 & t == `x'
	bitest VT7 == $frSP, detail
	replace pv7  = r(p) if withincondition == `x'
}

export excel withincondition fr3 fr6 pv6 fr7 pv7 using "$path/DATOS/framing.xls" in 1/15, firstrow(variables) nolabel replace

*edit if T==7 & t == 8 //Unusual case: nobody chose SP.

***************************************************************************************
* 5.5. The effect of the probability that the reform is ex ante beneficial 
***************************************************************************************

capture drop pv_benharm  
g pv_benharm = .
capture drop withincondition 
g withincondition = _n if _n <=14

forvalues x=1(1)14 {
dis "`x'"
sum Vi if (T==3 | T==4) & t==`x'						
global frSP_T3T4 = r(mean)

capture drop aux
g aux = Vi if T==4 & t==`x'
bitest aux == $frSP_T3T4, detail  
global pv_benharm  = r(p_u)
replace pv_benharm = $pv_benharm if withincondition == `x'
}

export excel withincondition pv_benharm using "$path/DATOS/pvbenharm.xls" in 1/14, firstrow(variables) nolabel replace  
  
  
log close

********************************************************************************************************************************************************************
* 6. Miscellaneous: computations mentioned and marked with {miscellaneous*}in the tex file.
********************************************************************************************************************************************************************

use "$path/data1.dta",clear

* Proportion of tasks in which subjects checked more than one time in part 2 of the experiment {miscellaneous1}
sum check_morethan1 

* Proportion of subjects classified as risk averse based on part 3 of the experiment {miscellaneous2}
sum riskaverse  

* Potential issues with learning or tiring: gridlock XR-LC in task 5, gridlock XR-LU in task 8 and gridlock XU-LC in task 10. 
/*
reg Vi h3 h4 t 		, vce(cluster i)  	// order of task is not statistically significant. No changes in h1 to h4. 
*/
 
* Frequency of SP among risk averse subjects {miscellaneous4}
sum Vi if riskaverse==1
sum Vi if riskaverse==0

* The impact of h3 on SP among subjects who did and did not make errors {miscellaneous3 and miscellaneous5}
global list = " check_morethan1 riskaverse female right strong_leader"
reg Vi i.h3 i.h4  i.h3#i.check_morethan1 i.h4#i.check_morethan1  i.h1 i.h2 $list
margins i.h3#i.check_morethan1, at(h1==0 h2==0 h4==0)
matrix x = r(b)
matrix d_noerrors = x[1,3] - x[1,1] // Control group: individuals who answered correctly at the first attempt.
matrix d_errors = x[1,4] - x[1,2]
matrix dd_errors = d_errors - d_noerrors
matrix list d_noerrors    // {miscellaneous5}
matrix list d_errors      // {miscellaneous5}
matrix list dd_errors
local xx = d_errors[1,1]
local zz = d_noerrors[1,1]
power twoproportions `xx' `zz'  // Minimum sample size to detect differences in SP associated to h3_check_morethan1 {miscellaneous3}

* The impact of h3 on SP among female and male {miscellaneous6 and miscellaneous7}
global list = " check_morethan1 riskaverse female right strong_leader"
reg Vi i.h3 i.h4  i.h3#i.female i.h4#i.female i.h1 i.h2  $list
margins i.h3#i.female, at(h1==0 h2==0 h4==0)
matrix x = r(b)
matrix d_noerrors = x[1,3] - x[1,1] // Control group: males.
matrix d_errors = x[1,4] - x[1,2]
matrix dd_errors = d_errors - d_noerrors
matrix list d_noerrors    // {miscellaneous6}
matrix list d_errors      // {miscellaneous6}
matrix list dd_errors
local xx = d_errors[1,1]
local zz = d_noerrors[1,1]
power twoproportions `xx' `zz'  // Minimum sample size to detect differences in SP associated to h3_check_morethan1 {miscellaneous7}

sum female if e(sample)	
dis r(N)*r(mean)/14  // females
dis r(N)*(1-r(mean))/14  // males
