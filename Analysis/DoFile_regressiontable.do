********************************************************************************
****		EVALUATING COVID-19: INCIDENCE AND SPREAD IN MEXICO				****
********************************************************************************
* September 24, 2021
* Drop Schools
* COVID per capita

clear all


set maxvar 120000, perm

****************               LOAD DATA           *****************************

*run Dataset/COVID/DoFile_CleanPanelCOVID.do // change name of GOBMX file to mmddyyyy if this line doesn't run; if entidad_res not found, update datebase
*run Dataset/Lockdowns/DoFile_CleanLockdowns.do
*run Dataset/Facebook/DoFile_CleanFBMovementRange.do

import delimited "panel_COVIDTreatMR.csv", clear

********************************************************************************
*************							Dates
********************************************************************************


foreach var of varlist date first_covid first_sintomas first_ingreso first_def fecha_med_sintomas fecha_med_ingreso fecha_med_def fecha_moda_sintomas fecha_moda_ingreso fecha_moda_def {
	gen `var'_date = date(`var',"DMY")
	format `var'_date %td
	drop `var'
	rename `var'_date `var'
}

order code_inegi date mr1 mr2 covid_1 covid_0 covid_sospechoso deaths_pc first_covid first_sintomas first_ingreso first_def fecha_med_sintomas fecha_med_ingreso fecha_med_def fecha_moda_sintomas fecha_moda_ingreso fecha_moda_def totalpopulation date_num cum_school cum_alcohol cum_fines cum_curfew cum_businesses cum_publicplaces cum_checkpoints cum_events cum_masks cum_mobility cum_any restrict_obs_may restrict_obs_june7 restrict_obs_june14 restrict_obs_june21


****************			SET DATA AS PANEL		****************************

sort code_inegi date
tset code_inegi date

****************				DEP VARS			****************************


*mr1 
*mr2

* cases per capita

********************************************************************************
***************************		 Standardized 		****************************
********************************************************************************


********************************************************************************
***************************    Direct effects & Spillovers   *******************
********************************************************************************


*  							No weights until we introduce spillovers (model 3)




* MODEL 1

*********************		single policy (1 policy in regression)


{
	
* MR1 and MR2

{
cap drop std*
	
* FE: Municipio + Date
local predicted mr1 mr2 //


foreach y of local predicted {


reghdfe `y' cum_* if restrict_obs_may == 1,absorb(code date) cluster(code_inegi)
cap drop samplestd
gen samplestd = 1 if e(sample) == 1


local restriction alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach r of local restriction {
cap drop mean`r'
egen mean`r' = mean(cum_`r') if samplestd == 1
cap drop sd`r'
egen sd`r' = sd(cum_`r') if samplestd == 1
*standardize
cap drop std_local_`r'
gen std_local_`r' = (cum_`r' - mean`r') / sd`r'
}



local restriction alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach k of local restriction {

label var std_local_`k' "Local policy"

reghdfe `y' std_local_`k' if restrict_obs_may == 1,absorb(code date) cluster(code_inegi)
est sto m1`y'`k'
estadd scalar df1 = e(df_r)
estadd local FE "Municipio"
estadd local FE2 "Day"
estadd local Cluster "Municipio"
qui summarize `y' if e(sample)==1
estadd scalar Min = r(min)
estadd scalar Max = r(max)
estadd scalar Count = r(N)
estadd scalar Mean = r(mean)
estadd scalar SD = r(sd)
estadd scalar Mpios = e(N_clust)

}

}



}


* covid_1_pc

{	
sort code_inegi date
cap drop std*
	
* FE: Municipio + Date
local predicted covid_1_pc //


foreach y of local predicted {


reghdfe `y' l7.cum_* if restrict_obs_june7 == 1,absorb(code date) cluster(code_inegi)
cap drop samplestd
gen samplestd = 1 if e(sample) == 1


local restriction alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach r of local restriction {
cap drop mean`r'
egen mean`r' = mean(l7.cum_`r') if samplestd == 1
cap drop sd`r'
egen sd`r' = sd(l7.cum_`r') if samplestd == 1
*standardize
cap drop std_local_`r'
gen std_local_`r' = (l7.cum_`r' - mean`r') / sd`r'
}


local restriction alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach k of local restriction {

label var std_local_`k' "Local policy"

reghdfe `y' std_local_`k' if restrict_obs_june7 == 1,absorb(code date) cluster(code_inegi)
est sto m1`y'`k'
estadd scalar df1 = e(df_r)
estadd local FE "Municipio"
estadd local FE2 "Day"
estadd local Cluster "Municipio"
qui summarize `y' if e(sample)==1
estadd scalar Min = r(min)
estadd scalar Max = r(max)
estadd scalar Count = r(N)
estadd scalar Mean = r(mean)
estadd scalar SD = r(sd)
estadd scalar Mpios = e(N_clust)

}

}


}


}


* MODEL 2

*********************		only local (10 policies same time)


{
	
* MR1 and MR2

{	
cap drop std*

* FE: Municipio + Date
local predicted mr1 mr2 //


foreach y of local predicted {

reghdfe `y' cum_* if restrict_obs_may == 1,absorb(code date) cluster(code_inegi)
cap drop samplestd
gen samplestd = 1 if e(sample) == 1


local restriction alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach r of local restriction {
cap drop mean`r'
egen mean`r' = mean(cum_`r') if samplestd == 1
cap drop sd`r'
egen sd`r' = sd(cum_`r') if samplestd == 1
*standardize
cap drop std_local_`r'
gen std_local_`r' = (cum_`r' - mean`r') / sd`r'

label var std_local_`r' "Local policy"
}

reghdfe `y' std* if restrict_obs_may == 1,absorb(code date) cluster(code_inegi)
est sto m2`y'
estadd scalar df1 = e(df_r)
estadd local FE "Municipio"
estadd local FE2 "Day"
estadd local Cluster "Municipio"
qui summarize `y' if e(sample)==1
estadd scalar Min = r(min)
estadd scalar Max = r(max)
estadd scalar Count = r(N)
estadd scalar Mean = r(mean)
estadd scalar SD = r(sd)
estadd scalar Mpios = e(N_clust)


}



}

* covid_1_pc

{
sort code_inegi date	
cap drop std*

* FE: Municipio + Date
local predicted covid_1_pc //


foreach y of local predicted {

reghdfe `y' l7.cum_* if restrict_obs_june7 == 1,absorb(code date) cluster(code_inegi)
cap drop samplestd
gen samplestd = 1 if e(sample) == 1


local restriction alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach r of local restriction {
cap drop mean`r'
egen mean`r' = mean(l7.cum_`r') if samplestd == 1
cap drop sd`r'
egen sd`r' = sd(l7.cum_`r') if samplestd == 1
*standardize
cap drop std_local_`r'
gen std_local_`r' = (l7.cum_`r' - mean`r') / sd`r'
}

reghdfe `y' std* if restrict_obs_june7 == 1,absorb(code date) cluster(code_inegi)
est sto m2`y'
estadd scalar df1 = e(df_r)
estadd local FE "Municipio"
estadd local FE2 "Day"
estadd local Cluster "Municipio"
qui summarize `y' if e(sample)==1
estadd scalar Min = r(min)
estadd scalar Max = r(max)
estadd scalar Count = r(N)
estadd scalar Mean = r(mean)
estadd scalar SD = r(sd)
estadd scalar Mpios = e(N_clust)

}


}


}


* MODEL 3

*  						weights on both local and foreign policies

*********************		spillovers (10 policies same time controlling for other municipios)


{
	
* MR1 and MR2
{
	
* FE: Municipio + Date
local predicted mr1 mr2 ///


foreach y of local predicted {

reghdfe `y' weighted_local_mw* weighted_inflow_mw* if restrict_obs_may == 1,absorb(code date) cluster(code_inegi)
cap drop samplestd
gen samplestd = 1 if e(sample) == 1

local type local inflow
foreach t of local type {
local restriction alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach r of local restriction {
cap drop mean`t'`r'
egen mean`t'`r' = mean(weighted_`t'_mw_`r') if samplestd == 1
cap drop sd`t'`r'
egen sd`t'`r' = sd(weighted_`t'_mw_`r') if samplestd == 1
*standardize
cap drop std_`t'_`r'
gen std_`t'_`r' = (weighted_`t'_mw_`r' - mean`t'`r') / sd`t'`r'
}
}

reghdfe `y' std* if restrict_obs_may == 1,absorb(code date) cluster(code_inegi)
est sto m3`y'
estadd scalar df1 = e(df_r)
estadd local FE "Municipio"
estadd local FE2 "Day"
estadd local Cluster "Municipio"
estadd local Weight "Weighted"
qui summarize `y' if e(sample)==1
estadd scalar Min = r(min)
estadd scalar Max = r(max)
estadd scalar Count = r(N)
estadd scalar Mean = r(mean)
estadd scalar SD = r(sd)
estadd scalar Mpios = e(N_clust)


}



}

* covid_1_pc
{
sort code_inegi date
	
* FE: Municipio + Date
local predicted covid_1_pc ///


foreach y of local predicted {

reghdfe `y' l7.weighted_local_mw* l7.weighted_inflow_mw* if restrict_obs_june7 == 1,absorb(code date) cluster(code_inegi)
cap drop samplestd
gen samplestd = 1 if e(sample) == 1

local type local inflow
foreach t of local type {
local restriction alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach r of local restriction {
cap drop mean`t'`r'
egen mean`t'`r' = mean(l7.weighted_`t'_mw_`r') if samplestd == 1
cap drop sd`t'`r'
egen sd`t'`r' = sd(l7.weighted_`t'_mw_`r') if samplestd == 1
*standardize
cap drop std_`t'_`r'
gen std_`t'_`r' = (l7.weighted_`t'_mw_`r' - mean`t'`r') / sd`t'`r'
}
}

reghdfe `y' std* if restrict_obs_june7 == 1,absorb(code date) cluster(code_inegi)
est sto m3`y'
estadd scalar df1 = e(df_r)
estadd local FE "Municipio"
estadd local FE2 "Day"
estadd local Cluster "Municipio"
estadd local Weight "Weighted"
qui summarize `y' if e(sample)==1
estadd scalar Min = r(min)
estadd scalar Max = r(max)
estadd scalar Count = r(N)
estadd scalar Mean = r(mean)
estadd scalar SD = r(sd)
estadd scalar Mpios = e(N_clust)

}

}

}


********************************************************************************
********************************************************************************


* MODEL 4

*********************		Lasso without lags (t-7 for control policies and for policy of interest)


{
	
sort code_inegi date 
cap log close

* MR1 and MR2
{
log using "log_FS_m4_regressiontable.smcl", replace

{
* FE: Municipio + Date

local predicted mr2 mr1

foreach y of local predicted {
	
local restrictions  alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach r of local restrictions {

* change name of variable of interest

rename weighted_local_mw_`r' localtbs
rename weighted_inflow_mw_`r' inflowtbs


*std coefficients

* manual standardization 
if "`y'" == "mr1" & "`r'" == "publicplaces" {
	cap drop samplestd
	quiet lasso2 `y' localtbs inflowtbs weighted_local_mw_* weighted_inflow_mw_* i.date if restrict_obs_may == 1,fe partial(i.date) notpen(localtbs inflowtbs)
	quiet local lambda = e(laicc)
	quiet lasso2 mr1 localtbs inflowtbs weighted_local_mw_* weighted_inflow_mw_* i.date if restrict_obs_may == 1,fe lam(`lambda')
	gen samplestd = 1 if e(sample) == 1
}
else if "`y'" != "mr1" & "`r'" != "publicplaces" {
	cap drop samplestd
	quiet lasso2 `y' localtbs inflowtbs weighted_local_mw_* weighted_inflow_mw_* i.date if restrict_obs_may == 1,fe partial(i.date) notpen(localtbs inflowtbs)
	quiet local lambda = e(laicc)
	quiet lasso2 `y' localtbs inflowtbs weighted_local_mw_* weighted_inflow_mw_* i.date if restrict_obs_may == 1,fe partial(i.date) notpen(localtbs inflowtbs) lam(`lambda') nor
	gen samplestd = 1 if e(sample) == 1
	}
	
local type local inflow
foreach t of local type {
local restriction alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach k of local restriction {
	
cap drop mean`t'`k'
cap egen mean`t'`k' = mean(weighted_`t'_mw_`k') if samplestd == 1
cap drop sd`t'`k'
cap egen sd`t'`k' = sd(weighted_`t'_mw_`k') if samplestd == 1
*standardize
cap drop std_`t'_`k'
cap gen std_`t'_`k' = (weighted_`t'_mw_`k' - mean`t'`k') / sd`t'`k'

}
}


cap drop local_lasso
cap drop inflow_lasso
egen local_lasso = std(localtbs)
label var local_lasso "local `r'"
egen inflow_lasso = std(inflowtbs)
label var inflow_lasso "inflow `r'"

/*
cap drop local_lasso
cap drop inflow_lasso
cap drop meanlasso
cap drop sdlasso
egen meanlasso = mean(localtbs) if samplestd == 1
egen sdlasso = sd(localtbs) if samplestd == 1
gen local_lasso = (localtbs - meanlasso)/sdlasso if samplestd == 1
label var local_lasso "local `r'"
cap drop meanlasso
cap drop sdlasso
egen meanlasso = mean(inflowtbs) if samplestd == 1
egen sdlasso = sd(inflowtbs) if samplestd == 1
gen inflow_lasso = (inflowtbs - meanlasso)/sdlasso if samplestd == 1
label var inflow_lasso "inflow `r'"
*/

cap drop mean* sd*


* select controls
cap drop local_int
gen local_int = local_lasso
cap drop inflow_int
gen inflow_int = inflow_lasso
ds std_*
local scontrols "`r(varlist)'"
local controls c.(`scontrols')
display "`controls'"


*** Inference

* pdslasso
pdslasso `y' local_lasso inflow_lasso (i.date `controls') if restrict_obs_may == 1,fe partial(i.date) olsoptions(cluster(code))

est sto m4`y'`r'
estadd local FE "Municipio"
estadd local FE2 "Day"
estadd local SE "Clustered"
estadd local Weight "Weighted"
qui summarize `y' if e(sample)==1
estadd scalar Min = r(min)
estadd scalar Max = r(max)
estadd scalar Count = r(N)
estadd scalar Mean = r(mean)
estadd scalar SD = r(sd)
estadd scalar Mpios = e(N_g)

*

rename localtbs weighted_local_mw_`r'
rename inflowtbs weighted_inflow_mw_`r'

}
}

}

log close
}

* covid_1_pc

{
cap log close

log using "log_RF_m4_regressiontable.smcl", replace

* Model 4
*** Lasso No Interactions, No Lags

{

forvalues l = 0/7 {
	cap drop l`l'*
}

local restrictions  alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach r of local restrictions {
forvalues l = 0/7 {
	gen l`l'_wlocal_`r' = l`l'.weighted_local_mw_`r'
	gen l`l'_winflow_`r' = l`l'.weighted_inflow_mw_`r'
}
}

* FE: Municipio + Date

local predicted covid_1_pc
foreach y of local predicted {

local restrictions  alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach r of local restrictions {

cap drop std*

foreach m in 7 {
rename l`m'_wlocal_`r' lag_local_`m'
rename l`m'_winflow_`r' lag_inflow_`m'
}


*std coefficients
cap drop samplestd
quiet lasso2 `y' lag_local_7 l7_wlocal_* l6_wlocal_* l5_wlocal_* l4_wlocal_* l3_wlocal_* l2_wlocal_* l1_wlocal_* lag_inflow_7 l7_winflow_* l6_winflow_* l5_winflow_* l4_winflow_* l3_winflow_* l2_winflow_* l1_winflow_* i.date if restrict_obs_june7 == 1,fe partial(i.date) notpen(lag_local_7 lag_inflow_7)
quiet local lambda = e(laicc)
quiet lasso2 `y' lag_local_7 l7_wlocal_* l6_wlocal_* l5_wlocal_* l4_wlocal_* l3_wlocal_* l2_wlocal_* l1_wlocal_* lag_inflow_7 l7_winflow_* l6_winflow_* l5_winflow_* l4_winflow_* l3_winflow_* l2_winflow_* l1_winflow_* i.date if restrict_obs_june7 == 1,fe partial(i.date) notpen(lag_local_7 lag_inflow_7) lam(`lambda') nor
gen samplestd = 1 if e(sample) == 1
	
local type local inflow
foreach t of local type {
local restriction alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach k of local restriction {
foreach z in 7 {
cap drop mean`t'`z'`k'
cap egen mean`t'`z'`k' = mean(l`z'_w`t'_`k') if samplestd == 1
cap drop sd`t'`z'`k'
cap egen sd`t'`z'`k' = sd(l`z'_w`t'_`k') if samplestd == 1
*standardize
cap drop std_`t'`z'_`k'
cap gen std_`t'`z'_`k' = (l`z'_w`t'_`k' - mean`t'`z'`k') / sd`t'`z'`k'
}
}
}


cap drop local_lasso
cap drop inflow_lasso
egen local_lasso = std(lag_local_7) if samplestd == 1
label var local_lasso "lag local (7) `r'"
egen inflow_lasso = std(lag_inflow_7) if samplestd == 1
label var inflow_lasso "lag inflow (7) `r'"


cap drop mean* sd*


* select controls
cap drop local_int
gen local_int = local_lasso
cap drop inflow_int
gen inflow_int = inflow_lasso
ds std_*
local controls "`r(varlist)'"
display "`controls'"


*** Inference

* pdslasso
*pdslasso `y' local_lasso inflow_lasso (i.date i.code `controls'), partial(i.date i.code) olsoptions(cluster(code))
pdslasso `y' local_lasso inflow_lasso (i.date `controls') if restrict_obs_june7 == 1,fe partial(i.date) olsoptions(cluster(code))

est sto m4`y'`r'
estadd local FE "Municipio"
estadd local FE2 "Day"
estadd local SE "Clustered"
estadd local Weight "Weighted"
qui summarize `y' if e(sample)==1
estadd scalar Min = r(min)
estadd scalar Max = r(max)
estadd scalar Count = r(N)
estadd scalar Mean = r(mean)
estadd scalar SD = r(sd)
estadd scalar Mpios = e(N_g)

*

foreach m in 7 {
rename lag_local_`m' l`m'_wlocal_`r'
rename lag_inflow_`m' l`m'_winflow_`r'
}

}
}

}

log close
}
}


*********************		Lasso with lags (t-7,...,t for control policies; only t-7 for policy of interest) --- this only applies to Reduced Form

* MR1 and MR2
* Doesn't apply here (we expect instant, at day-level, effects on mobility)

* covid_1_pc (7 days)
{
sort code date
cap log close
log using "log_RF_m4_lags_regressiontable.smcl", replace

* Model 4
*** Lasso No Interactions, Lags

{

forvalues l = 0/7 {
	cap drop l`l'*
}

local restrictions  alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach r of local restrictions {
forvalues l = 0/7 {
	gen l`l'_wlocal_`r' = l`l'.weighted_local_mw_`r'
	gen l`l'_winflow_`r' = l`l'.weighted_inflow_mw_`r'
}
}
	
* FE: Municipio + Date

local predicted covid_1_pc
foreach y of local predicted {

local restrictions  alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach r of local restrictions {

cap drop std*

forvalues m = 0/7 {
rename l`m'_wlocal_`r' lag_local_`m'
rename l`m'_winflow_`r' lag_inflow_`m'
}

*std coefficients
cap drop samplestd
quiet lasso2 `y' lag_local_7 l7_wlocal_* l6_wlocal_* l5_wlocal_* l4_wlocal_* l3_wlocal_* l2_wlocal_* l1_wlocal_* lag_inflow_7 l7_winflow_* l6_winflow_* l5_winflow_* l4_winflow_* l3_winflow_* l2_winflow_* l1_winflow_* i.date if restrict_obs_june7 == 1,fe partial(i.date) notpen(lag_local_7 lag_inflow_7)
quiet local lambda = e(laicc)
quiet lasso2 `y' lag_local_7 l7_wlocal_* l6_wlocal_* l5_wlocal_* l4_wlocal_* l3_wlocal_* l2_wlocal_* l1_wlocal_* lag_inflow_7 l7_winflow_* l6_winflow_* l5_winflow_* l4_winflow_* l3_winflow_* l2_winflow_* l1_winflow_* i.date if restrict_obs_june7 == 1,fe partial(i.date) notpen(lag_local_7 lag_inflow_7) lam(`lambda') nor
gen samplestd = 1 if e(sample) == 1
	
local type local inflow
foreach t of local type {
local restriction alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach k of local restriction {
forvalues z = 0/7 {
cap drop mean`t'`z'`k'
cap egen mean`t'`z'`k' = mean(l`z'_w`t'_`k') if samplestd == 1
cap drop sd`t'`z'`k'
cap egen sd`t'`z'`k' = sd(l`z'_w`t'_`k') if samplestd == 1
*standardize
cap drop std_`t'`z'_`k'
cap gen std_`t'`z'_`k' = (l`z'_w`t'_`k' - mean`t'`z'`k') / sd`t'`z'`k'
}
}
}


cap drop local_lasso
cap drop inflow_lasso
egen local_lasso = std(lag_local_7) if samplestd == 1
label var local_lasso "lag local (7) `r'"
egen inflow_lasso = std(lag_inflow_7) if samplestd == 1
label var inflow_lasso "lag inflow (7) `r'"


cap drop mean* sd*


* select controls
cap drop local_int
gen local_int = local_lasso
cap drop inflow_int
gen inflow_int = inflow_lasso
ds std_*
local controls "`r(varlist)'"
display "`controls'"


*** Inference

* pdslasso
*pdslasso `y' local_lasso inflow_lasso (i.date i.code `controls'), partial(i.date i.code) olsoptions(cluster(code))
pdslasso `y' local_lasso inflow_lasso (i.date `controls') if restrict_obs_june7 == 1,fe partial(i.date) olsoptions(cluster(code))

est sto m4l`y'`r'
estadd local FE "Municipio"
estadd local FE2 "Day"
estadd local SE "Clustered"
estadd local Weight "Weighted"
qui summarize `y' if e(sample)==1
estadd scalar Min = r(min)
estadd scalar Max = r(max)
estadd scalar Count = r(N)
estadd scalar Mean = r(mean)
estadd scalar SD = r(sd)
estadd scalar Mpios = e(N_g)


*

forvalues m = 0/7 {
rename lag_local_`m' l`m'_wlocal_`r'
rename lag_inflow_`m' l`m'_winflow_`r'
}

}
}

}

log close
}





* MR2, COVID_PC

local predicted mr2 covid_1_pc //
foreach y of local predicted {
local restriction alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach k of local restriction {


if "`y'" == "mr2" {
	
esttab m1`y'`k' m2`y' m3`y' m4`y'`k' ///
using "`y'`k'.tex", replace noomitted label nobaselevels keep(std_local_`k' local_*) scalars("FE" "FE" "SE") stats(N Mpios Mean SD Min Max Weight FE FE2 Cluster, label("Observations" "\# Municipios" "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "Weights" "FE" "FE" "Cluster SE")) star(* 0.10 ** 0.05 *** 0.01) mtitles("M1" "M2" "M3" "M4") notes addnotes("") nonumbers b(a3) se(a3)

}

if "`y'" != "mr2" {
	
esttab m1`y'`k' m2`y' m3`y' m4`y'`k' m4l`y'`k' ///
using "`y'`k'.tex", replace noomitted label nobaselevels keep(std_local_`k' local_*) scalars("FE" "FE" "SE") stats(N Mpios Mean SD Min Max Weight FE FE2 Cluster, label(N "Mpios" "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "Weights" "FE" "FE" "Cluster SE")) star(* 0.10 ** 0.05 *** 0.01) mtitles("M1" "M2" "M3" "M4" "M4 lags") notes addnotes("") nonumbers b(a3) se(a3)

}

}
}


* APPEND 

include "https://raw.githubusercontent.com/steveofconnell/PanelCombine/master/PanelCombineSutex.do"

local predicted mr2 covid_1_pc //
foreach y of local predicted {
panelcombinesutex, use(`y'alcohol.tex `y'businesses.tex `y'checkpoints.tex `y'curfew.tex `y'events.tex  `y'fines.tex  `y'masks.tex `y'publicplaces.tex `y'mobility.tex) ///
paneltitles("Alcohol" "Businesses" "Checkpoints" "Curfew" "Events" "Fines" "Masks" "Public Spaces" "Transportation") columncount(3) save(`y'.tex) ///
addcustomnotes("\begin{minipage}{`linewidth'\linewidth} \footnotesize \smallskip \textbf{Note:} Dependent variable: `y'.\end{minipage}" ) //cleanup
}


keep code_inegi date _est*
save "regression_table_dataset.dta",replace


* TEST COEFFICIENTS


* models 1-3

cap drop model y variable1 variable2 b1 var1 b2 var2 zscore pvalue
gen model = ""
gen y = ""
gen variable1 = ""
gen variable2 = ""
gen b1 = .
gen var1 = .
gen b2 = .
gen var2 = .
gen zscore = .
gen pvalue = .


local models m1 m2 m3
local models2 m2 m3
local i = 1

local predicted mr2 covid_1_pc
foreach y of local predicted {

foreach m of local models {
foreach n of local models2 {

local regressors alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach x of local regressors {
	
replace y = "`y'" in `i'
replace model = "`m' vs. `n'" in `i'

if "`m'" == "m1" {
estimates restore `m'`y'`x'
local var1 = _se[std_local_`x']
local b1 = _b[std_local_`x']
display "`y' vs.`m' - `x' - `b1' - `var1'"
replace variable1 = "`x'" in `i'
replace b1 = `b1' in `i'
replace var1 = `var1' in `i'

estimates restore `n'`y'
local var2 = _se[std_local_`x']
local b2 = _b[std_local_`x']
display "`y' vs. `n' - `x' - `b2' - `var2'"
replace variable2 = "`x'" in `i'
replace b2 = `b2' in `i'
replace var2 = `var2' in `i'
replace zscore = (`b1' - `b2')/sqrt(`var1'^2 + `var2'^2) in `i'
replace pvalue = 2*(1-normal(abs((`b1' - `b2')/sqrt(`var1'^2 + `var2'^2)))) in `i'

local i = `i' + 1

}

if "`m'" != "m1" {
estimates restore `m'`y'
local var1 = _se[std_local_`x']
local b1 = _b[std_local_`x']
display "`y' vs. `m' - `x' - `b1' - `var1'"
replace variable1 = "`x'" in `i'
replace b1 = `b1' in `i'
replace var1 = `var1' in `i'

estimates restore `n'`y'
local var2 = _se[std_local_`x']
local b2 = _b[std_local_`x']
display "`y' vs. `n' - `x' - `b2' - `var2'"
replace variable2 = "`x'" in `i'
replace b2 = `b2' in `i'
replace var2 = `var2' in `i'
replace zscore = (`b1' - `b2')/sqrt(`var1'^2 + `var2'^2) in `i'
replace pvalue = 2*(1-normal(abs((`b1' - `b2')/sqrt(`var1'^2 + `var2'^2)))) in `i'

local i = `i' + 1
} 


}

}
}
}


* model 4


local models m1 m2 m3 m4 m4l
local models2 m2 m3 m4 
local i = 163

local predicted mr2 covid_1_pc
foreach y of local predicted {

foreach m of local models {
foreach n of local models2 {
	
local regressors alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach x of local regressors {
	
cap replace y = "`y'" in `i'
cap replace model = "`m' vs. `n'" in `i'

if "`m'" == "m1"|"`m'" == "m4" {
cap estimates restore `m'`y'`x'
cap local var1 = _se[std_local_`x']
cap local b1 = _b[std_local_`x']
cap display "`y' vs. `m' - `x' - `b1' - `var1'"
cap replace variable1 = "`x'" in `i'
cap replace b1 = `b1' in `i'
cap replace var1 = `var1' in `i'

cap estimates restore `n'`y'`x'
capture gen aux = _se[local_lasso]
cap if aux[1] != . {
cap local var2 = _se[local_lasso]
cap local b2 = _b[local_lasso]
cap display "`y' vs. `n' - `x' - `b2' - `var2'"
cap replace variable2 = "`x'" in `i'
cap replace b2 = `b2' in `i'
cap replace var2 = `var2' in `i'
cap replace zscore = (`b1' - `b2')/sqrt(`var1'^2 + `var2'^2) in `i'
cap replace pvalue = 2*(1-normal(abs((`b1' - `b2')/sqrt(`var1'^2 + `var2'^2)))) in `i'

cap local i = `i' + 1
}
cap if aux[1] == . {
cap local var2 = _se[local_int]
cap local b2 = _b[local_int]
cap display "`y' vs. `n' - `x' - `b2' - `var2'"
cap replace variable2 = "`x'" in `i'
cap replace b2 = `b2' in `i'
cap replace var2 = `var2' in `i'
cap replace zscore = (`b1' - `b2')/sqrt(`var1'^2 + `var2'^2) in `i'
cap replace pvalue = 2*(1-normal(abs((`b1' - `b2')/sqrt(`var1'^2 + `var2'^2)))) in `i'

cap local i = `i' + 1
}

}
cap drop aux

cap if "`m'" == "m2"|"`m'" == "m3" {
cap estimates restore `m'`y'
cap local var1 = _se[std_local_`x']
cap local b1 = _b[std_local_`x']
cap display "`y' vs. `m' - `x' - `b1' - `var1'"
cap replace variable1 = "`x'" in `i'
cap replace b1 = `b1' in `i'
cap replace var1 = `var1' in `i'

cap estimates restore `n'`y'`x'
capture gen aux = _se[local_lasso]
cap if aux[1] != . {
cap local var2 = _se[local_lasso]
cap local b2 = _b[local_lasso]
cap display "`y' vs. `n' - `x' - `b2' - `var2'"
cap replace variable2 = "`x'" in `i'
cap replace b2 = `b2' in `i'
cap replace var2 = `var2' in `i'
cap replace zscore = (`b1' - `b2')/sqrt(`var1'^2 + `var2'^2) in `i'
cap replace pvalue = 2*(1-normal(abs((`b1' - `b2')/sqrt(`var1'^2 + `var2'^2)))) in `i'

cap local i = `i' + 1
}
cap if aux[1] == . {
cap local var2 = _se[local_int]
cap local b2 = _b[local_int]
cap display "`y' vs. `n' - `x' - `b2' - `var2'"
cap replace variable2 = "`x'" in `i'
cap replace b2 = `b2' in `i'
cap replace var2 = `var2' in `i'
cap replace zscore = (`b1' - `b2')/sqrt(`var1'^2 + `var2'^2) in `i'
cap replace pvalue = 2*(1-normal(abs((`b1' - `b2')/sqrt(`var1'^2 + `var2'^2)))) in `i'

cap local i = `i' + 1
}
} 
cap drop aux

}

}

}
}


preserve
gsort -y variable1 model
*br y model variable1 b1 var1 b2 var2 zscore pvalue if model == "m1 vs. m2"|model == "m1 vs. m3"|model == "m1 vs. m4"|model == "m2 vs. m3"|model == "m2 vs. m4"|model == "m3 vs. m4"
cap drop pvalue_str
*format pvalue_str %3.2f
gen pvalue_str = string(pvalue, "%4.3f")
replace pvalue_str = "$<$ 0.001" if pvalue < 0.001
keep y model variable1 b1 var1 b2 var2 zscore pvalue pvalue_str 
keep if model == "m1 vs. m2"|model == "m1 vs. m3"|model == "m1 vs. m4"|model == "m1 vs. m4l"|model == "m2 vs. m3"|model == "m2 vs. m4"|model == "m2 vs. m4l"|model == "m3 vs. m4"|model == "m3 vs. m4l"
cap drop latex
gen latex = "\textit{p-value " + model + ":} & " + pvalue_str + " & & & \\" if y == "mr2"
replace latex = "\textit{p-value " + model + ":} & " + pvalue_str + " & & & \\" if y != "mr2"
replace model = subinstr(model,"m","M",.) 
replace model = subinstr(model,"M4l","M4 lags",.)
replace latex = subinstr(latex,"m4l","m4 lags",.)
export delimited "pvalues_models1-4.csv", replace
restore

local predicted mr2 covid_1_pc //
foreach y of local predicted {
local restriction alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach k of local restriction {

cap erase `y'.tex
cap erase `y'`k'.tex

cap erase regression_table_dataset.dta

cap erase log_FS_m4_regressiontable.smcl
cap erase log_RF_m4_regressiontable.smcl
cap erase log_RF_m4_lags_regressiontable.smcl
}
}
