********************************************************************************
****		EVALUATING COVID-19: INCIDENCE AND SPREAD IN MEXICO				****
********************************************************************************
* No Schools
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
*************	Restrict observations from February 27th to May 31st
********************************************************************************


* restricted to observations before June 21st (lags 7, 14, 21 days)

keep if date <= td(21jun2020)

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

reghdfe `y' std_local_`k' if restrict_obs_may == 1,absorb(code date) cluster(code_inegi)
est sto md`y'`k'
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

esttab md`y'`k' using "single_reghdfe_`y'_mun_date_local_`k'.csv", replace cells("b se ci") noomitted nobaselevels label se r2 title("All restrictions in one regression") scalars("DF" "FE" "FE" "Cluster") stats(N r2 Mean SD Min Max df1 FE FE2 Cluster, label(N \(R^{2}\) "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "DF" "FE" "FE" "Cluster")) star(* 0.10 ** 0.05 *** 0.01) mtitles("") notes addnotes("") nonumbers b(a3) se(a3)
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

reghdfe `y' std_local_`k' if restrict_obs_june7 == 1,absorb(code date) cluster(code_inegi)
est sto md`y'`k'
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

esttab md`y'`k' using "single_reghdfe_`y'_mun_date_local_`k'.csv", replace cells("b se ci") noomitted nobaselevels label se r2 title("All restrictions in one regression") scalars("DF" "FE" "FE" "Cluster") stats(N r2 Mean SD Min Max df1 FE FE2 Cluster, label(N \(R^{2}\) "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "DF" "FE" "FE" "Cluster")) star(* 0.10 ** 0.05 *** 0.01) mtitles("") notes addnotes("") nonumbers b(a3) se(a3)
}

}


}


* export results to m1.csv
preserve
run "Analysis/DoFile_append_m1.do"
restore

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
}

reghdfe `y' std* if restrict_obs_may == 1,absorb(code date) cluster(code_inegi)
est sto md`y'
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

esttab md`y' using "local_reghdfe_`y'_mun_date_local.csv", replace cells("b se ci") noomitted nobaselevels label se r2 title("All restrictions in one regression") scalars("DF" "FE" "FE" "Cluster") stats(N r2 Mean SD Min Max df1 FE FE2 Cluster, label(N \(R^{2}\) "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "DF" "FE" "FE" "Cluster")) star(* 0.10 ** 0.05 *** 0.01) mtitles("") notes addnotes("") nonumbers b(a3) se(a3)
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
est sto md`y'
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

esttab md`y' using "local_reghdfe_`y'_mun_date_local.csv", replace cells("b se ci") noomitted nobaselevels label se r2 title("All restrictions in one regression") scalars("DF" "FE" "FE" "Cluster") stats(N r2 Mean SD Min Max df1 FE FE2 Cluster, label(N \(R^{2}\) "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "DF" "FE" "FE" "Cluster")) star(* 0.10 ** 0.05 *** 0.01) mtitles("") notes addnotes("") nonumbers b(a3) se(a3)
}

}

* export results to m2.csv
preserve
run "Analysis/DoFile_append_m2.do"
restore
}


* MODEL 3

*  						weights on both local and foreign policies

*********************		spillovers (10 policies same time controlling for other municipios)


{

sort code_inegi date
tset code_inegi date
	
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
est sto md`y'
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

esttab md`y' using "all_same_reghdfe_`y'_mun_date.csv", replace cells("b se ci") noomitted nobaselevels label se r2 title("All restrictions in one regression") scalars("DF" "FE" "FE" "Cluster") stats(N r2 Mean SD Min Max df1 FE FE2 Cluster, label(N \(R^{2}\) "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "DF" "FE" "FE" "Cluster")) star(* 0.10 ** 0.05 *** 0.01) mtitles("") notes addnotes("") nonumbers b(a3) se(a3)
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
est sto md`y'
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

esttab md`y' using "all_same_reghdfe_`y'_mun_date.csv", replace cells("b se ci") noomitted nobaselevels label se r2 title("All restrictions in one regression") scalars("DF" "FE" "FE" "Cluster") stats(N r2 Mean SD Min Max df1 FE FE2 Cluster, label(N \(R^{2}\) "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "DF" "FE" "FE" "Cluster")) star(* 0.10 ** 0.05 *** 0.01) mtitles("") notes addnotes("") nonumbers b(a3) se(a3)
}


}

* export results to m3.csv
preserve
run "Analysis/DoFile_append_m3.do"
restore
}


********************************************************************************
********************************************************************************


* MODEL 4

*********************		Lasso without lags (t-7 for control policies and for policy of interest)


{
	
sort code_inegi date 
tset code_inegi date

* MR1 and MR2
{

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

est sto md4`y'`r'
estadd local FE "Municipio"
estadd local FE2 "Day"
estadd local SE "Clustered"
qui summarize `y' if e(sample)==1
estadd scalar Min = r(min)
estadd scalar Max = r(max)
estadd scalar Count = r(N)
estadd scalar Mean = r(mean)
estadd scalar SD = r(sd)

if _b[local_lasso] != 0 & _b[inflow_lasso] != 0 {
esttab md4`y'`r' using "`y'_`r'_fs_m4_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_lasso inflow_lasso) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
}
if _b[local_lasso] != 0 & _b[inflow_lasso] == 0 {
esttab md4`y'`r' using "`y'_`r'_fs_m4_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_lasso inflow_int) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
}
if _b[local_lasso] == 0 & _b[inflow_lasso] != 0 {
esttab md4`y'`r' using "`y'_`r'_fs_m4_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_int inflow_lasso) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
}
if _b[local_lasso] == 0 & _b[inflow_lasso] == 0 {
esttab md4`y'`r' using "`y'_`r'_fs_m4_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_int inflow_int) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
}

*

rename localtbs weighted_local_mw_`r'
rename inflowtbs weighted_inflow_mw_`r'

}
}

}

}

* covid_1_pc
{

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

est sto md4`y'`r'
estadd local FE "Municipio"
estadd local FE2 "Day"
estadd local SE "Clustered"
qui summarize `y' if e(sample)==1
estadd scalar Min = r(min)
estadd scalar Max = r(max)
estadd scalar Count = r(N)
estadd scalar Mean = r(mean)
estadd scalar SD = r(sd)

if _b[local_lasso] != 0 & _b[inflow_lasso] != 0 {
esttab md4`y'`r' using "`y'_`r'_rf_m4_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_lasso inflow_lasso) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
}
if _b[local_lasso] != 0 & _b[inflow_lasso] == 0 {
esttab md4`y'`r' using "`y'_`r'_rf_m4_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_lasso inflow_int) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
}
if _b[local_lasso] == 0 & _b[inflow_lasso] != 0 {
	if _b[local_lasso] == 0 & _b[local_int] != 0 {	
esttab md4`y'`r' using "`y'_`r'_rf_m4_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_int inflow_lasso) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
	}
	if _b[local_lasso] == 0 & _b[local_int] == 0 {
		
	mat b = e(b) 
	local names : colnames b 
	di "`names'"
	reghdfe `y' local_lasso inflow_lasso `names' if restrict_obs_june7 == 1, absorb(code date) cluster(code)
	
	est sto md4`y'`r'
	estadd local FE "Municipio"
	estadd local FE2 "Day"
	estadd local SE "Clustered"
	qui summarize `y' if e(sample)==1
	estadd scalar Min = r(min)
	estadd scalar Max = r(max)
	estadd scalar Count = r(N)
	estadd scalar Mean = r(mean)
	estadd scalar SD = r(sd)
	esttab md4`y'`r' using "`y'_`r'_rf_m4_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_lasso inflow_lasso) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
	}
}
if _b[local_lasso] == 0 & _b[inflow_lasso] == 0 {
	if _b[local_lasso] == 0 & _b[local_int] != 0 {	
esttab md4`y'`r' using "`y'_`r'_rf_m4_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_int inflow_int) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
	}
	if _b[local_lasso] == 0 & _b[local_int] == 0 {
		
	mat b = e(b) 
	local names : colnames b 
	di "`names'"
	reghdfe `y' local_lasso inflow_lasso `names' if restrict_obs_june7 == 1, absorb(code date) cluster(code)
	
	est sto md4`y'`r'
	estadd local FE "Municipio"
	estadd local FE2 "Day"
	estadd local SE "Clustered"
	qui summarize `y' if e(sample)==1
	estadd scalar Min = r(min)
	estadd scalar Max = r(max)
	estadd scalar Count = r(N)
	estadd scalar Mean = r(mean)
	estadd scalar SD = r(sd)
	esttab md4`y'`r' using "`y'_`r'_rf_m4_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_lasso inflow_lasso) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
	}
}

*

foreach m in 7 {
rename lag_local_`m' l`m'_wlocal_`r'
rename lag_inflow_`m' l`m'_winflow_`r'
}

}
}

}

}

* export results
{
* export results to m4.csv
preserve
run "Analysis/DoFile_append_m4.do"
restore
}

}


********************************************************************************
********************************************************************************


*keep code date mr2 mr1 covid_1_pc deaths_pc weighted_* restrict_obs_may // keep relevant variables


* MODEL 5

*********************		Lasso with interactions and no lags (t-7 for control policies and for policy of interest)


{
	
* MR1 and MR2
{
sort code date

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
local scontrols2 "`scontrols' local_int inflow_int"
local controls c.(`scontrols2')##c.(`scontrols2')
display "`controls'"

*** Inference

* pdslasso
pdslasso `y' local_lasso inflow_lasso (i.date `controls') if restrict_obs_may == 1,fe partial(i.date) olsoptions(cluster(code))

est sto md4`y'`r'
estadd local FE "Municipio"
estadd local FE2 "Day"
estadd local SE "Clustered"
qui summarize `y' if e(sample)==1
estadd scalar Min = r(min)
estadd scalar Max = r(max)
estadd scalar Count = r(N)
estadd scalar Mean = r(mean)
estadd scalar SD = r(sd)

if _se[local_lasso] == 0|_se[local_int] == 0 { // no confidence intervals

	mat b = e(b) 
	local names : colnames b 
	di "`names'"
	areg `y' local_lasso inflow_lasso `names' i.date if restrict_obs_may == 1, absorb(code) cluster(code)

	est sto md4`y'`r'
	estadd local FE "Municipio"
	estadd local FE2 "Day"
	estadd local SE "Clustered"
	qui summarize `y' if e(sample)==1
	estadd scalar Min = r(min)
	estadd scalar Max = r(max)
	estadd scalar Count = r(N)
	estadd scalar Mean = r(mean)
	estadd scalar SD = r(sd)
	
	esttab md4`y'`r' using "`y'_`r'_fs_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_lasso inflow_lasso) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
	
	esttab md4`y'`r' using "heatmaps_`y'_`r'_fs_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local* inflow* c.* c.std*) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
	
}

if _se[local_lasso] != 0 & _se[local_int] != 0 { // confidence intervals

if _b[local_lasso] != 0 & _b[inflow_lasso] != 0 {
esttab md4`y'`r' using "`y'_`r'_fs_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_lasso inflow_lasso) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))

esttab md4`y'`r' using "heatmaps_`y'_`r'_fs_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local* inflow* c.* c.std*) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
}
if _b[local_lasso] != 0 & _b[inflow_lasso] == 0 {
esttab md4`y'`r' using "`y'_`r'_fs_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_lasso inflow_int) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))

esttab md4`y'`r' using "heatmaps_`y'_`r'_fs_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local* inflow* c.* c.std*) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
}
if _b[local_lasso] == 0 & _b[inflow_lasso] != 0 {
	if _b[local_int] != 0 {
esttab md4`y'`r' using "`y'_`r'_fs_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_int inflow_lasso) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))

esttab md4`y'`r' using "heatmaps_`y'_`r'_fs_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local* inflow* c.* c.std*) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
	}
	if _b[local_int] == 0 {
		
	mat b = e(b) 
	local names : colnames b 
	di "`names'"
	reghdfe `y' local_lasso inflow_lasso `names' if restrict_obs_may == 1, absorb(code date) cluster(code)
	est sto md4`y'`r'
	estadd local FE "Municipio"
	estadd local FE2 "Day"
	estadd local SE "Clustered"
	qui summarize `y' if e(sample)==1
	estadd scalar Min = r(min)
	estadd scalar Max = r(max)
	estadd scalar Count = r(N)
	estadd scalar Mean = r(mean)
	estadd scalar SD = r(sd)
	
	esttab md4`y'`r' using "`y'_`r'_fs_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_lasso inflow_lasso) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
	
	esttab md4`y'`r' using "heatmaps_`y'_`r'_fs_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local* inflow* c.* c.std*) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
	
	}	
}
if _b[local_lasso] == 0 & _b[inflow_lasso] == 0 {
	if _b[local_int] != 0 & _b[inflow_int] != 0 {
esttab md4`y'`r' using "`y'_`r'_fs_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_int inflow_int) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))

esttab md4`y'`r' using "heatmaps_`y'_`r'_fs_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local* inflow* c.* c.std*) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
}
	if _b[local_int] == 0 {
		
	mat b = e(b) 
	local names : colnames b 
	di "`names'"
	reghdfe `y' local_lasso inflow_lasso `names' if restrict_obs_may == 1, absorb(code date) cluster(code)
	est sto md4`y'`r'
	estadd local FE "Municipio"
	estadd local FE2 "Day"
	estadd local SE "Clustered"
	qui summarize `y' if e(sample)==1
	estadd scalar Min = r(min)
	estadd scalar Max = r(max)
	estadd scalar Count = r(N)
	estadd scalar Mean = r(mean)
	estadd scalar SD = r(sd)
	
	esttab md4`y'`r' using "`y'_`r'_fs_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_lasso inflow_lasso) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
	
	esttab md4`y'`r' using "heatmaps_`y'_`r'_fs_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local* inflow* c.* c.std*) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
	
	}	
}

}


*

rename localtbs weighted_local_mw_`r'
rename inflowtbs weighted_inflow_mw_`r'

}
}

}

}

* covid_1_pc (7 days)
{
sort code date

* Model 5
*** Lasso Interactions, No Lags

{

forvalues l = 1/7 {
	cap drop l`l'*
}

local restrictions  alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach r of local restrictions {
forvalues l = 1/7 {
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
quiet lasso2 `y' lag_local_7 l7_wlocal_* lag_inflow_7 l7_winflow_* i.date if restrict_obs_june7 == 1,fe partial(i.date) notpen(lag_local_7 lag_inflow_7)
quiet local lambda = e(laicc)
quiet lasso2 `y' lag_local_7 l7_wlocal_* lag_inflow_7 l7_winflow_* i.date if restrict_obs_june7 == 1,fe partial(i.date) notpen(lag_local_7 lag_inflow_7) lam(`lambda') nor
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
local scontrols "`r(varlist)'"
local scontrols2 "`scontrols' local_int inflow_int"
local controls c.(`scontrols2')##c.(`scontrols2')
display "`controls'"

*** Inference

* pdslasso
*pdslasso `y' local_lasso inflow_lasso (i.date i.code `controls'), partial(i.date i.code) olsoptions(cluster(code))
pdslasso `y' local_lasso inflow_lasso (i.date `controls') if restrict_obs_june7 == 1,fe partial(i.date) olsoptions(cluster(code))

est sto md4`y'`r'
estadd local FE "Municipio"
estadd local FE2 "Day"
estadd local SE "Clustered"
qui summarize `y' if e(sample)==1
estadd scalar Min = r(min)
estadd scalar Max = r(max)
estadd scalar Count = r(N)
estadd scalar Mean = r(mean)
estadd scalar SD = r(sd)


if _se[local_lasso] == 0|_se[local_int] == 0 { // no confidence intervals

	mat b = e(b) 
	local names : colnames b 
	di "`names'"
	areg `y' local_lasso inflow_lasso `names' i.date if restrict_obs_june7 == 1, absorb(code) cluster(code)
	
	est sto md4`y'`r'
	estadd local FE "Municipio"
	estadd local FE2 "Day"
	estadd local SE "Clustered"
	qui summarize `y' if e(sample)==1
	estadd scalar Min = r(min)
	estadd scalar Max = r(max)
	estadd scalar Count = r(N)
	estadd scalar Mean = r(mean)
	estadd scalar SD = r(sd)
	esttab md4`y'`r' using "`y'_`r'_rf_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_lasso inflow_lasso) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
	
	esttab md4`y'`r' using "heatmaps_`y'_`r'_rf_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local* inflow* c.* c.std*) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
	
}

if _se[local_lasso] != 0 & _se[local_int] != 0 { // confidence intervals

if _b[local_lasso] != 0 & _b[inflow_lasso] != 0 {
esttab md4`y'`r' using "`y'_`r'_rf_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_lasso inflow_lasso) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))

esttab md4`y'`r' using "heatmaps_`y'_`r'_rf_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local* inflow* c.* c.std*) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
}
if _b[local_lasso] != 0 & _b[inflow_lasso] == 0 {
esttab md4`y'`r' using "`y'_`r'_rf_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_lasso inflow_int) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))

esttab md4`y'`r' using "heatmaps_`y'_`r'_rf_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local* inflow* c.* c.std*) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
}
if _b[local_lasso] == 0 & _b[inflow_lasso] != 0 {
	if _b[local_lasso] == 0 & _b[local_int] != 0 {	
esttab md4`y'`r' using "`y'_`r'_rf_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_int inflow_lasso) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))

esttab md4`y'`r' using "heatmaps_`y'_`r'_rf_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local* inflow* c.* c.std*) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
	}
	if _b[local_lasso] == 0 & _b[local_int] == 0 {
		
	mat b = e(b) 
	local names : colnames b 
	di "`names'"
	reghdfe `y' local_lasso inflow_lasso `names' if restrict_obs_june7 == 1, absorb(code date) cluster(code)
	
	est sto md4`y'`r'
	estadd local FE "Municipio"
	estadd local FE2 "Day"
	estadd local SE "Clustered"
	qui summarize `y' if e(sample)==1
	estadd scalar Min = r(min)
	estadd scalar Max = r(max)
	estadd scalar Count = r(N)
	estadd scalar Mean = r(mean)
	estadd scalar SD = r(sd)
	esttab md4`y'`r' using "`y'_`r'_rf_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_lasso inflow_lasso) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
	
	esttab md4`y'`r' using "heatmaps_`y'_`r'_rf_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local* inflow* c.* c.std*) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
	}
}
if _b[local_lasso] == 0 & _b[inflow_lasso] == 0 {
	if _b[local_lasso] == 0 & _b[local_int] != 0 {	
esttab md4`y'`r' using "`y'_`r'_rf_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_int inflow_int) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))

esttab md4`y'`r' using "heatmaps_`y'_`r'_rf_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local* inflow* c.* c.std*) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
	}
	if _b[local_lasso] == 0 & _b[local_int] == 0 {
		
	mat b = e(b) 
	local names : colnames b 
	di "`names'"
	reghdfe `y' local_lasso inflow_lasso `names' if restrict_obs_june7 == 1, absorb(code date) cluster(code)
	
	est sto md4`y'`r'
	estadd local FE "Municipio"
	estadd local FE2 "Day"
	estadd local SE "Clustered"
	qui summarize `y' if e(sample)==1
	estadd scalar Min = r(min)
	estadd scalar Max = r(max)
	estadd scalar Count = r(N)
	estadd scalar Mean = r(mean)
	estadd scalar SD = r(sd)
	esttab md4`y'`r' using "`y'_`r'_rf_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local_lasso inflow_lasso) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
	
	esttab md4`y'`r' using "heatmaps_`y'_`r'_rf_m5_pds.csv", replace cells("b ci") noomitted nobaselevels label ci keep(local* inflow* c.* c.std*) scalars("FE" "FE" "SE") stats(N Mean SD Min Max FE FE2 SE, label(N "DepVar: Mean" "DepVar: Std.Dev." "Scale: min" "Scale: max" "FE" "FE" "SE"))
	}
}

}

*

foreach m in 7 {
rename lag_local_`m' l`m'_wlocal_`r'
rename lag_inflow_`m' l`m'_winflow_`r'
}

}
}

}

}

* export results
{
* export results to m5.csv
preserve
run "Analysis/DoFile_append_m5.do"
run "Analysis/DoFile_append_m5_heatmaps.do"
restore
}

}


********************************************************************************
********************************************************************************
