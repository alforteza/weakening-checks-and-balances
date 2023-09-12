/*   
Forteza, Mussio and Pereyra (2023): Can political gridlock undermine checks and balances? A lab experiment.
{https://github.com/alforteza/weakening-checks-and-balances/tree/main}
MASTER do file.
*/

if  ("`c(hostname)'"=="MacBook-Pro-de-Alvaro.local") global path "/Users/alvaroforteza/Documents/Agency/Experimento dismantling CB/Analisis"  
  

cd "$path"
clear all



do Weakening_CB_DATABASE.do

do Weakening_CB_SIMULATIONS.do

do Weakening_CB_DESCRIPTIVE.do

do Weakening_CB_TESTS.do
