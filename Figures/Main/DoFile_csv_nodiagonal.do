
cd "~/Dropbox/COVID-19 Mexico/Analysis/First stage/Graphs/v8/school_not_included/FE_municipiodate/heatmaps/"


local predicted mr2 mr1 covid_1_pc deaths_pc covid_1 deaths

local restrictions publicplaces checkpoints events masks mobility curfew businesses school alcohol fines publicplaces

local lags m5 m5_14 m5_21 m5_lags

local type fs rf

foreach y of local predicted {

foreach r of local restrictions {
	
foreach t of local type {

foreach l of local lags {

cap confirm file "csv/RCE_heatmap_nodiagonal/`y'_`r'_`t'_`l'_pds.csv"

if _rc==0 {

display "file exists"

import delimited "csv/RCE_heatmap_nodiagonal/`y'_`r'_`t'_`l'_pds.csv", clear 

rename v1 graph
rename v2 coef

keep if coef != ""

replace v3 = subinstr(v3, "            \\","",.)
replace v3 = subinstr(v3, "\\","",.)

keep if _n > 3
split v3, p(",")
rename v31 lb95 
rename v32 ub95
destring lb95, replace
destring ub95, replace


replace graph = subinstr(graph, "\_int","_`r'",.)
replace graph = subinstr(graph, "lag ","",.)
replace graph = subinstr(graph, " (7) ","_",.)
replace graph = subinstr(graph, " (14) ","_",.)
replace graph = subinstr(graph, " (21) ","_",.)
* for heatmaps with lags from t to t-7
replace graph = subinstr(graph, "std\_local1\_","local_",.)
replace graph = subinstr(graph, "std\_local2\_","local_",.)
replace graph = subinstr(graph, "std\_local3\_","local_",.)
replace graph = subinstr(graph, "std\_local4\_","local_",.)
replace graph = subinstr(graph, "std\_local5\_","local_",.)
replace graph = subinstr(graph, "std\_local6\_","local_",.)
replace graph = subinstr(graph, "std\_inflow1\_","inflow_",.)
replace graph = subinstr(graph, "std\_inflow2\_","inflow_",.)
replace graph = subinstr(graph, "std\_inflow3\_","inflow_",.)
replace graph = subinstr(graph, "std\_inflow4\_","inflow_",.)
replace graph = subinstr(graph, "std\_inflow5\_","inflow_",.)
replace graph = subinstr(graph, "std\_inflow6\_","inflow_",.)
*
replace graph = subinstr(graph, "std\_local7\_","local_",.)
replace graph = subinstr(graph, "std\_inflow7\_","inflow_",.)
replace graph = subinstr(graph, "std\_local14\_","local_",.)
replace graph = subinstr(graph, "std\_inflow14\_","inflow_",.)
replace graph = subinstr(graph, "std\_local21\_","local_",.)
replace graph = subinstr(graph, "std\_inflow21\_","inflow_",.)
replace graph = subinstr(graph, "std\_local\_","local_",.)
replace graph = subinstr(graph, "std\_inflow\_","inflow_",.)
replace graph = subinstr(graph, "        ","",.)
replace graph = subinstr(graph, "       ","",.)
replace graph = subinstr(graph, "   ","",.)
replace graph = subinstr(graph, "  ","",.)
replace graph = subinstr(graph, "  ","",.)

gen interaction = (strpos(graph,"$\times$") > 0)
replace graph = subinstr(graph, " $\times$ ","#",.)
replace graph = strtrim(graph)

gen interactionss = ((lb95>0 & ub95>0)|(lb95<0 & ub95<0))

gen ene  = coef if graph == "N"
destring ene, replace
gsort ene
replace ene = ene[1]

gen avg = coef if graph == "DepVar: Mean"
destring avg, replace
gsort avg
replace avg = avg[1]

drop if graph == "DF"|graph == "FE"|graph == "SE"|graph == "N"

destring coef, replace

keep if lb95!=. & ub95!=.

gen iden1 = "`y'"
gen iden2 = "`r'"
replace iden2 = "public places" if iden2 == "publicplaces"
gen iden3 = "`l'"

drop v3

split graph, p("#")
rename graph1 policy_1
rename graph2 policy_2


cap drop order*
gen order_1 = .
gen order_2 = .
local policy _1 _2
foreach p of local policy {
replace order`p' = 1 if policy`p' == "local_alcohol"
replace order`p' = 2 if policy`p' == "local_businesses"
replace order`p' = 3 if policy`p' == "local_checkpoints"
replace order`p' = 4 if policy`p' == "local_curfew"
replace order`p' = 5 if policy`p' == "local_events"
replace order`p' = 6 if policy`p' == "local_fines"
replace order`p' = 7 if policy`p' == "local_masks"
replace order`p' = 8 if policy`p' == "local_mobility"
replace order`p' = 9 if policy`p' == "local_publicplaces"
replace order`p' = 10 if policy`p' == "local_school"
replace order`p' = 11 if policy`p' == "inflow_alcohol"
replace order`p' = 12 if policy`p' == "inflow_businesses"
replace order`p' = 13 if policy`p' == "inflow_checkpoints"
replace order`p' = 14 if policy`p' == "inflow_curfew"
replace order`p' = 15 if policy`p' == "inflow_events"
replace order`p' = 16 if policy`p' == "inflow_fines"
replace order`p' = 17 if policy`p' == "inflow_masks"
replace order`p' = 18 if policy`p' == "inflow_mobility"
replace order`p' = 19 if policy`p' == "inflow_publicplaces"
replace order`p' = 20 if policy`p' == "inflow_school"

}

save "csv/RCE_heatmap_nodiagonal/`y'_`r'_`t'_`l'_pds.dta", replace

}
}
}
}
}

* APPEND
clear 
local predicted mr2 mr1 covid_1_pc deaths_pc covid_1 deaths

local restrictions publicplaces checkpoints events masks mobility curfew businesses school alcohol fines publicplaces

local lags m5 m5_14 m5_21 m5_lags

local type fs rf

foreach l of local lags {
	
foreach t of local type {
	
foreach y of local predicted {

foreach r of local restrictions {
	
	cap append using "csv/RCE_heatmap_nodiagonal/`y'_`r'_`t'_`l'_pds.dta"
	cap erase "csv/RCE_heatmap_nodiagonal/`y'_`r'_`t'_`l'_pds.dta"
}
}
}
}

replace graph = substr(graph,1,strlen(graph)-1) if substr(graph,-1,1) == " "
sort iden3 iden1 order_1 order_2
export delimited "m5_heatmap_nodiagonal.csv", replace
