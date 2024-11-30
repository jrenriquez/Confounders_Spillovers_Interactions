

* Model 3
* output: m3.csv

	
	
local predicted mr1 mr2 covid_1_pc
foreach y of local predicted {

import delimited "all_same_reghdfe_`y'_mun_date.csv", clear varnames(3) 

foreach var of varlist v1 b se ci95 {
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

gen df = b if v1 == "DF"
gsort -df
replace df = df[1]

split v1, p("std_")
gen graph = subinstr(v12,"_"," ",.) if strpos(v1,"std_")>0
replace graph = "spillovers " + graph if strpos(v1,"std_")>0

gen iden1 = "`y'"
gen iden2 = subinstr(graph,"local ","",.)
replace iden2 = subinstr(iden2,"inflow ","",.)
gen iden3 = "m3"

keep if graph!="" & se != ""

destring _all, replace

rename b coef 
order coef se ene avg df graph lb95 ub95 iden2 iden1 iden3
drop v1
drop v11 v12

save "`y'_m3.dta", replace
}

clear 

local predicted mr1 mr2 covid_1_pc
foreach y of local predicted {
	append using "`y'_m3.dta"
	erase "`y'_m3.dta"
}


gen order1 = 1 if iden1 == "mr2"
replace order1 = 2 if iden1 == "mr1"
replace order1 = 3 if iden1 == "covid_1_pc"

gen aux = (strpos(graph,"inflow")>0)

gsort iden1 -aux iden2
by iden1: gen order = _n
sort order1 order

drop order1 aux
order coef se ene avg df graph lb95 ub95 order iden2 iden1 iden3
export delimited "m3.csv", replace


local predicted mr1 mr2 covid_1_pc
foreach y of local predicted {

erase "all_same_reghdfe_`y'_mun_date.csv"

}
