

* Model 1
* output: m1.csv

{
local predicted mr1 mr2 covid_1_pc
local restriction alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach r of local restriction {
foreach y of local predicted {

import delimited "single_reghdfe_`y'_mun_date_local_`r'.csv", clear varnames(3) 


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

gen graph = "single `r'"

gen iden1 = "`y'"
gen iden2 = "`r'"
gen iden3 = "m1"

keep if strpos(v1,"std_local")>0

destring _all, replace

rename b coef 
order coef se ene avg df graph lb95 ub95 iden2 iden1 iden3
drop v1

save "`y'_`r'_m1.dta", replace
}
}

clear 

local predicted mr1 mr2 covid_1_pc
local restriction alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach r of local restriction {
foreach y of local predicted {
	append using "`y'_`r'_m1.dta"
	erase "`y'_`r'_m1.dta"
}
}

gen order1 = 1 if iden1 == "mr2"
replace order1 = 2 if iden1 == "mr1"
replace order1 = 3 if iden1 == "covid_1_pc"

sort iden1 iden2
by iden1: gen order = _n
sort order1 iden2

drop order1 
order coef se ene avg df graph lb95 ub95 order iden2 iden1 iden3
export delimited "m1.csv", replace


local predicted mr1 mr2 covid_1_pc
local restriction alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach r of local restriction {
foreach y of local predicted {

erase "single_reghdfe_`y'_mun_date_local_`r'.csv"
}
}

}
