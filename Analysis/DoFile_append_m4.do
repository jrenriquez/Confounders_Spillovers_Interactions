

* Model 4
* output: m4.csv

* m4
{

local predicted mr1 mr2 covid_1_pc
local restriction alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach r of local restriction {
foreach y of local predicted {

if "`y'" == "mr1" | "`y'" == "mr2" {
import delimited "`y'_`r'_fs_m4_pds.csv", clear varnames(3) 
}

if "`y'" == "covid_1_pc" {
import delimited "`y'_`r'_rf_m4_pds.csv", clear varnames(3) 
}

foreach var of varlist v1 b ci95 {
replace `var' = subinstr(`var',`"="',"",.)
replace `var' = subinstr(`var',`"""',"",.)
}

split ci95, p(",")
drop ci95
rename ci951 lb95
rename ci952 ub95

gen ene = b if v1 == "N"
gsort -ene
replace ene = ene[1]

gen avg = b if v1 == "DepVar: Mean"
gsort -avg
replace avg = avg[1]

gen graph = v1 if lb95!="" & ub95!=""
replace graph = "lasso " + graph if graph != ""
replace graph = subinstr(graph, " lag ", " ", .)
replace graph = subinstr(graph, " (7) ", " ", .)

gen iden1 = "`y'"
gen iden2 = "`r'"
gen iden3 = "m4"

keep if graph != ""

destring _all, replace

rename b coef 
order coef ene avg graph lb95 ub95 iden2 iden1 iden3
drop v1

save "`y'_`r'_m4.dta", replace
}
}
}


clear 


* Append

local predicted mr1 mr2 covid_1_pc
local restriction alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach r of local restriction {
foreach y of local predicted {
	cap append using "`y'_`r'_m4.dta"
	cap erase "`y'_`r'_m4.dta"
}
}

* Sort and export
gen orderaux = 1 if iden3 == "m4"

gen order1 = 1 if iden1 == "covid_1_pc"
replace order1 = 3 if iden1 == "mr1"
replace order1 = 4 if iden1 == "mr2"

gen aux = (strpos(graph,"inflow")>0)

gsort orderaux iden1 -aux iden2
by orderaux iden1: gen order = _n
sort orderaux order1 order

drop orderaux order1 aux
order graph	coef lb95 ub95 ene avg iden1 iden2 iden3 order
export delimited "m4.csv", replace


* Erase

local predicted mr1 mr2 covid_1_pc
local restriction alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach r of local restriction {
foreach y of local predicted {

if "`y'" == "mr1" | "`y'" == "mr2" {
erase "`y'_`r'_fs_m4_pds.csv" 
}

if "`y'" == "covid_1_pc" {
erase "`y'_`r'_rf_m4_pds.csv"
}

}
}
