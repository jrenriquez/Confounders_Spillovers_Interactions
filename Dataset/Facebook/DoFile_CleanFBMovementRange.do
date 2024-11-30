

clear all


********************************************************************************

* Merge polygon_id with code_INEGI (Movement Range data)

* Use index of municipalities:
{

use "Dataset/Lockdowns/Catalogo_municipios_2019.dta", clear
cap gen polygon_name = municipio
replace polygon_name = subinstr(polygon_name,"Á","-",.)
replace polygon_name = subinstr(polygon_name,"É","-",.)
replace polygon_name = subinstr(polygon_name,"Í","-",.)
replace polygon_name = subinstr(polygon_name,"Ó","-",.)
replace polygon_name = subinstr(polygon_name,"Ú","-",.)
replace polygon_name = subinstr(polygon_name,"á","-",.)
replace polygon_name = subinstr(polygon_name,"é","-",.)
replace polygon_name = subinstr(polygon_name,"í","-",.)
replace polygon_name = subinstr(polygon_name,"ó","-",.)
replace polygon_name = subinstr(polygon_name,"ú","-",.)
replace polygon_name = subinstr(polygon_name,"Ü","-",.)
replace polygon_name = subinstr(polygon_name,"ü","-",.)
replace polygon_name = subinstr(polygon_name,"Ñ","-",.)
replace polygon_name = subinstr(polygon_name,"ñ","-",.)
cap gen cve_edo = trunc(code_INEGI/1000)
replace polygon_name = "-lamos" if polygon_name == "Alamos" & cve_edo == 26
replace polygon_name = "-ngel R. Cabada" if polygon_name == "Angel R. Cabada" & cve_edo == 30
replace polygon_name = "-rsulo Galv-n" if polygon_name == "Ursulo Galv-n" & cve_edo == 30
save, replace

run "Dataset/Facebook/DoFile_PB Mexico Admin L3 (polygon).do"

import delimited "Dataset/Facebook/PB Mexico Admin L3 (polygon).csv", encoding(UTF-8) clear 
rename code_inegi code_INEGI

* merge by name since cve_mun (from Facebook classification) is wrong for some municipalities
merge 1:1 code_INEGI using "Dataset/Lockdowns/Catalogo_municipios_2019.dta", keep(1 3) nogen

// 9 municipalities are not included in FB database (the 5 most recent in Chiapas, the 2 most recent in Morelos, and the 2 most recent in Q Roo)


save polygon_code.dta,replace


}



* load Movement Range data

clear all

forval m = 3/8 {
forval d = 1/31 {

if `d' < 10 {
capture confirm file "Dataset/Facebook/Movement Range/Movement Range_MEX_gadm_2_2020-0`m'-0`d'.csv"
  if _rc==0 {
  	
	
	import delimited "Dataset/Facebook/Movement Range/Movement Range_MEX_gadm_2_2020-0`m'-0`d'.csv", clear
	  
	/*
	// drop all polygons with a repeated name
	bys polygon_name: gen dup = cond(_N == 1, 0,_n)
	drop if dup > 0 // keep unique polygon names only 
	rename polygon_id polygon_idlvl2
	*/

	merge 1:1 polygon_id using polygon_code.dta, keep(3) nogen
	// ~151 polygon_names that are unique in Movement Range, but no in the dictionary, so we cannot match them
	// we lose around 23% of the sample
	// update: June 9, 2020. Not anymore. We recuperate the full sample

	* Date
	split ds,p("-")
	gen aux = ds2+"/"+ds3+"/"+ds1
	gen date = date(aux,"MDY")
	format date %tdDD_Mon_YYYY
	drop ds1 ds2 ds3 aux ds
	drop crisis_name // identifies that data corresponds to municipal data

	order code_INEGI polygon_id
	*drop dup

	save mr0`m'`d'.dta, replace
	clear

	  }
  else {
  	display "file not found: `m' - `d'"
	  }
	}
	
	
	
if `d' >= 10 {
capture confirm file "Dataset/Facebook/Movement Range/Movement Range_MEX_gadm_2_2020-0`m'-`d'.csv"
  if _rc==0 {
  	
	
	import delimited "Dataset/Facebook/Movement Range/Movement Range_MEX_gadm_2_2020-0`m'-`d'.csv", clear 
	  
	
	/*
	// drop all polygons with a repeated name
	bys polygon_name: gen dup = cond(_N == 1, 0,_n)
	drop if dup > 0 // keep unique polygon names only 
	rename polygon_id polygon_idlvl2
	*/

	merge 1:1 polygon_id using polygon_code.dta, keep(3) nogen
	// ~151 polygon_names that are unique in Movement Range, but no in the dictionary, so we cannot match them
	// we lose around 23% of the sample
	// update: June 9, 2020. Not anymore. We recuperate the full sample

	* Date
	split ds,p("-")
	gen aux = ds2+"/"+ds3+"/"+ds1
	gen date = date(aux,"MDY")
	format date %tdDD_Mon_YYYY
	drop ds1 ds2 ds3 aux ds
	drop crisis_name // identifies that data corresponds to municipal data

	order code_INEGI polygon_id
	*drop dup

	save mr0`m'`d'.dta, replace
	clear

	
	  }
  else {
  	display "file not found: `m' - `d'"
	  }
	}

}
}

cap use mr0`m'`d'.dta, replace
forval m = 3/8 {
forval d = 1/31 {
cap append using mr0`m'`d'.dta
cap erase mr0`m'`d'.dta
}
}
sort code_INEGI date
order code_INEGI date
drop Pob_total Totaldeviviendashabitadas Pob_masculina Pob_femenina


label var all_day_bing_tiles_visited_relat "Movement Range all_day_bing_tiles_visited_relat"
label var all_day_ratio_single_tile_users "Movement Range all_day_ratio_single_tile_users"

rename all_day_bing_tiles_visited_relat mr1
rename all_day_ratio_single_tile_users mr2

label var code_INEGI "cve AGEM INEGI"
label var date "Date"
label var polygon_id "Polygon id Movement Range"
*label var polygon_idlvl4 "Polygon id Dictionary"
label var polygon_name "Polygon name"
label var age_bracket "Age Movement Range"
label var gender "Gender Movement Range"
label var baseline_name "MR month baseline"
label var baseline_type "MR day baseline"
*label var name_stack "Polygon name dictionary"
*label var feature_id "Feature ID"
*label var longitude "Longitude"
*label var latitude "Latitude"
label var entidad "Entidad"
label var municipio "Municipio"

save movement_range.dta, replace
erase polygon_code.dta

********************************************************************************


* Merge MR data with panel_COVID_Lockdowns.dta


merge 1:1 code date using panel_COVID_Lockdowns.dta, nogen


* Cases and deaths per capita

sort code_INEGI date 
tsset code_INEGI date

{
*log(cases + 1 in t) - log(cases + 1 in t-1)
cap drop totalcases
by code_INEGI: gen totalcases = sum(covid_1)
label var totalcases "Total cases up to time t"

cap drop logtotalcases1
gen logtotalcases1 = log(totalcases + 1)
label var logtotalcases1 "Log(total cases up to time t + 1)"

cap drop lagcases 
gen lagcases = logtotalcases1 - l1.logtotalcases1
label var lagcases "Log(total cases + 1 up to time t) - Log(total cases + 1 up to time t-1)"

*log(deaths + 1 in t) - log(deaths + 1 in t-1)
cap drop totaldeaths
by code_INEGI: gen totaldeaths = sum(deaths)
label var totaldeaths "Total deaths up to time t"

cap drop logtotaldeaths1
gen logtotaldeaths1 = log(totaldeaths + 1)
label var logtotaldeaths1 "Log(total deaths up to time t + 1)" 

cap drop lagdeaths 
gen lagdeaths = logtotaldeaths1 - l1.logtotaldeaths1
label var lagdeaths "Log(total deaths + 1 up to time t) - Log(total deaths + 1 up to time t-1)"

* new cases (covid_1)
replace covid_1 = 0 if covid_1 == . & lagcases!=.
replace lagcases = 0 if covid_1 == 0
replace lagcases = logtotalcases1 if lagcases == . & covid_1 == 1 & totalcases == 1

* new cases per capita (covid_1_pc)
gen code_inegi = code_INEGI
merge m:1 code_inegi using "Figures/Population/population_2020.dta", keep(3) nogen
drop Pob_total Pob_masculina Pob_femenina
gen covid_1_pc = (covid_1/pobtot)*100000
label var covid_1_pc "New COVID-19 cases per 100,000"

* new deaths (deaths)
replace deaths = 0 if deaths == . & lagdeaths!=.
replace lagdeaths = 0 if deaths == 0
replace lagdeaths = logtotaldeaths if lagdeaths == . & deaths == 1 & totaldeaths == 1

* new deaths per capita (covid_1_pc)
cap drop deaths_pc
gen deaths_pc = (deaths/pobtot)*100000
label var deaths_pc "New COVID-19 related deaths per 100,000"
}

rename pobtot totalpopulation

cap drop restrict_obs_may
gen restrict_obs_may = (date<=td(31May2020)) // restrict observations to earlier than May 31st
label var restrict_obs_may "Observations up to May 31st"

* we look at outcomes 7 / 14 / 21 days after May 31st
cap drop restrict_obs_june7 restrict_obs_june14 restrict_obs_june21
gen restrict_obs_june7 = (date<=td(7Jun2020)) // 7 days
gen restrict_obs_june14 = (date<=td(14Jun2020)) // 14 days
gen restrict_obs_june21 = (date<=td(21Jun2020)) // 21 days
label var restrict_obs_june7 "Observations up to June 7th"
label var restrict_obs_june14 "Observations up to June 14th"
label var restrict_obs_june21 "Observations up to June 21st"

drop if restrict_obs_june21 == 0

merge 1:1 code_INEGI date using "Dataset/Weights/weighted_sum_dow.dta", nogen

keep code_INEGI date mr1 mr2 covid_1 covid_0 covid_sospechoso deaths first_covid first_sintomas first_ingreso first_def fecha_med_sintomas fecha_med_ingreso fecha_med_def fecha_moda_sintomas fecha_moda_ingreso fecha_moda_def date_num cum_school cum_alcohol cum_fines cum_curfew cum_businesses cum_publicplaces cum_checkpoints cum_events cum_masks cum_mobility cum_any restrict_obs_may restrict_obs_june7 restrict_obs_june14 restrict_obs_june21 weighted_local_mw_school weighted_local_mw_alcohol weighted_local_mw_fines weighted_local_mw_curfew weighted_local_mw_businesses weighted_local_mw_publicplaces weighted_local_mw_checkpoints weighted_local_mw_events weighted_local_mw_masks weighted_local_mw_mobility weighted_inflow_mw_school weighted_inflow_mw_alcohol weighted_inflow_mw_fines weighted_inflow_mw_curfew weighted_inflow_mw_businesses weighted_inflow_mw_publicplaces weighted_inflow_mw_checkpoints weighted_inflow_mw_events weighted_inflow_mw_masks weighted_inflow_mw_mobility totalpopulation covid_1_pc deaths_pc

drop if code_INEGI == .

export delimited panel_COVIDTreatMR.csv, replace


cap erase panel.dta
cap erase movement_range.dta
cap erase panel_COVID_Treatment_fixdates.dta
cap erase panel_COVID_Lockdowns.dta
cap erase treatments.dta
cap erase aux.dta
cap erase panel_COVID_fixdates.dta
cap erase panel_COVID_fixdates.csv
