* Analysis of CORONANET data (on policies enacted)
* 	Article: https://www.nature.com/articles/s41562-020-0909-7#MOESM2
* 	Data: https://www.coronanet-project.org/
*		  version: CoronaNet Database Version 1.0 (core)
*   Covid Data: https://github.com/owid/covid-19-data/tree/master/public/data
*		  version: January 10, 2020
* 6 Jan 2021

cd "~/Dropbox/COVID-19 Mexico/Nature Communications submission/Figures/Coronanet/"

*** COVID CASES

import delimited "owid-covid-data.csv", clear 
drop if total_cases == .
duplicates drop iso_code, force
keep if continent != ""
keep iso_code date
rename date date_str
gen date = date(date_str,"YMD")
format date %td
local today "$S_DATE"
drop if date > td(`today')
expand 2, gen(first_covid_case)
replace date = td(`today') if first_covid_case == 1
sort iso_code date
encode iso_code, gen(country)
xtset country date
tsfill
replace iso_code = iso_code[_n-1] if country == country[_n-1]
sort iso_code date
by iso_code: gen days_first_case = _n - 1
keep iso_code date days_first_case
recast str3 iso_code, force 
save "panel_first_case.dta",replace

*** SOCIAL DISTANCING POLICIES

import delimited "coronanet_release.csv", varnames(1) clear 

* Fix date
keep if date_start != ""
gen date = date(date_start,"YMD")
format date %td
keep if date != .

keep date_start country iso_a3 init_country_level domestic_policy province city type type_sub_cat type_text institution_status target* date

* Keep obs before August 1st
keep if date < td(01Aug2020)
order date
sort date

* iso_code
rename iso_a3 iso_code
drop if iso_code == "-"
recast str3 iso_code, force 

* Alcohol
gen alcohol = 0
replace alcohol = 1 if strpos(type_text,"Alcohol cannot be sold or consumed")>0|strpos(type_text,"Limitation of retail sales of alcoholic beverages")>0
* Businesses
gen businesses = (type == "Restriction and Regulation of Businesses")
replace businesses = 0 if type_text == "new hygiene rules for retail trade: customers have to wear masks covering mouth and nose when entering supermarkets; supermarkets have to proivde masks for free"
* Checkpoints 
*gen checkpoints = 0 // MISSING
* Curfew
gen curfew = (type == "Curfew")
* Events
gen events = (type == "Restrictions of Mass Gatherings")
replace events = 1 if type_text == "The Rivers State Executive Council has approved Guidelines for Marraiges/Weddings in the state during the period of Covid 19.  Prospective Couples would need to get an approval/ apply to the Governor through the Commisioner for Social Welfare.  All Weddings/Marraiges have an attendance limit of 50 people.  The names, addresses and phone number of all attendees made available with the application (To enable quick contact tracing if the need arises).  Soap and running water has to be kept at the entrance to the venue in not less than three places while all attendees are to wear face masks and maintain social distancing of not less than 2 meters.  Church weddings are to be conducted between 9am and 12noon, while traditional weddings are to be conducted between 4pm and 7pm.  A representative of the Ministry would be present to observe the event.  A fine of N10,000,000 is to be paid by anyone that puts people at risk by breaking this regulation."
* Fines
gen fines = 0
replace fines = 1 if type_text == "Violations of the commands and prohibitions contained in the mitigation measures constitute an administrative offence and can be punished with a fine of 50 to 25000 euros according to the new catalogue of fines and penalties."
replace fines = 1 if type_text == "The governor of Osun state signed a new law. Anybody who violates the sit-at-home order will be sentenced to six-month imprisonment or an option of fine upon conviction."
replace fines = 1 if type_text == "imposition of fines and imprisonment on those who violate the imposed restrictions against the spread of the Coronavirus"
replace fines = 1 if type_text == "The police can fine persons who are violating the restrictions on mass gatherings"
replace fines = 1 if type_text == "Haiti subjects the intentional/voluntary spreading of the coronavirus to fines."
replace fines = 1 if type_text == "The Rivers State Executive Council has approved Guidelines for Marraiges/Weddings in the state during the period of Covid 19.  Prospective Couples would need to get an approval/ apply to the Governor through the Commisioner for Social Welfare.  All Weddings/Marraiges have an attendance limit of 50 people.  The names, addresses and phone number of all attendees made available with the application (To enable quick contact tracing if the need arises).  Soap and running water has to be kept at the entrance to the venue in not less than three places while all attendees are to wear face masks and maintain social distancing of not less than 2 meters.  Church weddings are to be conducted between 9am and 12noon, while traditional weddings are to be conducted between 4pm and 7pm.  A representative of the Ministry would be present to observe the event.  A fine of N10,000,000 is to be paid by anyone that puts people at risk by breaking this regulation."
replace fines = 1 if type_text == "amendment to the Infectious Disease Act to increase the penalty for anyone who does not comply with official directives for the coronavirus outbreak"
* Masks
gen masks = 0
replace masks = 1 if strpos(type_text,"masks")>0|strpos(type_sub_cat,"Masks")>0 & type != "Health Resources"
replace masks = 0 if masks == 1 & strpos(type_text,"wear") == 0|masks == 1 & strpos(type_text,"Wear")
replace masks = 1 if strpos(type_text,"obligatory use of masks")>0
replace masks = 1 if strpos(type_text,"Wearing of face masks is obligatory")>0
replace masks = 1 if strpos(type_sub_cat,"Wearing Masks")>0
replace masks = 1 if strpos(type_sub_cat,"Wearing masks")>0
replace masks = 1 if strpos(type_text, "anyone seen outside without proper use of the face mask will be arrested")>0
replace masks = 1 if type_sub_cat == "Other Mask Wearing Policy"
replace masks = 1 if type_sub_cat == "Unspecified Mask Wearing Policy"
* Mobility
gen mobility = 0
replace mobility = 1 if strpos(type_text,"public transport")>0 & !(strpos(type_text,"wear masks")>0)
replace mobility = 1 if strpos(type_sub_cat,"public transport")>0 & !(strpos(type_sub_cat,"wear masks")>0)
replace mobility = 0 if type_text == "The policy allows for temporary infrastructure changes (cycleways) to promote social distancing capacity on public transport."
replace mobility = 0 if type_text == "Pilot protocol to test reopening of public transport"
replace mobility = 1 if type_sub_cat == "Restrictions on  private vehicles in public circulation"
replace mobility = 1 if type_sub_cat == "Restrictions on ridership of buses"
replace mobility = 1 if type_sub_cat == "Restrictions on ridership of trains"
replace mobility = 1 if type_sub_cat == "Restrictions on ridership of subways and trams"
replace mobility = 1 if type_sub_cat == "Restrictions ridership of other forms of public transportation (please include details in the text entry)"
replace mobility = 0 if type_text == "The policy necessitates people boarding public transport to wear a certain item as form of protection."
replace mobility = 0 if type_text == "On May 27, 2020 the State Executive Council Meeting presided over by Governor Wike at Government House, Port Harcourt, approved the implementation of the Free Bus Scheme to further address the public transportation system and check the community spread of Coronavirus in the state. Implementation of the scheme began on June 1, 2020 with a total of 28 luxury buses deployed for the pilot scheme and will operate strictly in line with advisories on social distancing, use of hand sanitizers and wearing of face masks."
replace mobility = 0 if type_text == "By July 31st, 2020, the government would commence strict enforcement of the Kwara State Infectious Diseases Regulations 2020. Thenceforth, anyone seen outside without proper use of the face mask will be arrested, prosecuted in a mobile court, and taken to any of our quarantine centres. Their samples will then be taken and they will be held until their status is known. We want to emphasise that shop owners or business managers, drivers of commercial or private vehicles who allow persons without face masks into their shops or vehicles would be arrested alongside offending passengers and be taken to quarantine centres, have their samples taken and be held until their result is out."
* Public places
gen publicplaces = 0
replace publicplaces = 1 if type_sub_cat == "Beaches"
replace publicplaces = 1 if type_sub_cat == "Campsites"
replace publicplaces = 1 if type_sub_cat == "Other public facilities"
replace publicplaces = 1 if type_sub_cat == "Other public outdoor spaces"
replace publicplaces = 1 if type_sub_cat == "Parks"
replace publicplaces = 1 if type_sub_cat == "Public libraries"
replace publicplaces = 1 if type_sub_cat == "Public courts"
replace publicplaces = 1 if type_sub_cat == "Public museums/galleries"
replace publicplaces = 1 if type_sub_cat == "Tourist Sites"
replace publicplaces = 1 if type_sub_cat == "Unspecified outdoor spaces"
replace publicplaces = 1 if type_sub_cat == "Unspecified public facilities"
replace publicplaces = 1 if type_text == "No person for directly recreational purposes may remain on the beaches, rivers, lakes, spas or tourist centers throughout the national territory, from the entrance in force of this decree."
replace publicplaces = 1 if type_text == "This policy ensures that people don't access public swimming areas."
* Schools
gen school = (type == "Closure and Regulation of Schools")

* Drop if one of the ten policies is not present
egen row = rowtotal(alcohol businesses curfew events fines masks mobility publicplaces school)
drop if row == 0
* Keep one entry per day per policy
expand 2 if row == 2, gen(aux)
replace fines = 0 if row == 2 & aux == 0
replace events = 0 if row == 2 & aux == 1
drop aux
expand 2 if row == 3, gen(aux)
replace fines = 0 if row == 3 & aux == 0
replace events = 0 if row == 3 & aux == 0
replace masks = 0 if row == 3 & aux == 1
drop aux
expand 2 if row == 3 & fines == 1, gen(aux)
replace fines = 0 if row == 3 & aux == 1
replace events = 0 if row == 3 & aux == 0
drop aux row
sort country date

preserve 
*** 		NATIONAL
* apply national policy on one of the dimensions
keep if init_country_level == "National"
keep date country iso_code alcohol businesses curfew events fines masks mobility publicplaces school
duplicates drop date country iso_code alcohol businesses curfew events fines masks mobility publicplaces school, force
merge m:1 iso_code date using "panel_first_case.dta", nogen
sort iso_code date
by iso_code: gen aux = date if days_first_case == 0
gsort iso_code aux
by iso_code: replace aux = aux[1]
sort iso_code date
replace days_first_case = date - aux if days_first_case == .
drop aux
gsort iso_code -country date
by iso_code:replace country = country[1] if iso_code == iso_code[_n-1]
sort iso_code date

* no. of countries by days_first_case and restrictions
* cum sum of restrictions by country
local restriction school alcohol fines curfew businesses publicplaces events masks mobility
foreach r of local restriction {
bys iso_code: gen cum_`r' = sum(`r')
replace cum_`r' = 1 if cum_`r' > 0
}
drop school alcohol fines curfew businesses publicplaces events masks mobility
duplicates drop iso_code date, force

collapse (sum) cum*, by(days_first_case)
* from Jan 1, 2020 to July 31, 2020 = 212 days
keep if days_first_case >= -20 & days_first_case <= 212
export delimited "national_policies.csv", replace
*twoway(line cum_school days_first_case)(line cum_alcohol days_first_case)(line cum_fines days_first_case)(line cum_curfew days_first_case)(line cum_businesses days_first_case)(line cum_publicplaces days_first_case)(line cum_events days_first_case)(line cum_masks days_first_case)(line cum_mobility days_first_case)

restore

*** 		PROVINCIAL
* apply at least one policy on the dimension at the provincial/national/municipal level
keep date country iso_code alcohol businesses curfew events fines masks mobility publicplaces school
duplicates drop date country iso_code alcohol businesses curfew events fines masks mobility publicplaces school, force
merge m:1 iso_code date using "panel_first_case.dta", nogen
sort iso_code date
by iso_code: gen aux = date if days_first_case == 0
gsort iso_code aux
by iso_code: replace aux = aux[1]
sort iso_code date
replace days_first_case = date - aux if days_first_case == .
drop aux
gsort iso_code -country date
by iso_code:replace country = country[1] if iso_code == iso_code[_n-1]
sort iso_code date

* no. of countries by days_first_case and restrictions
* cum sum of restrictions by country
local restriction school alcohol fines curfew businesses publicplaces events masks mobility
foreach r of local restriction {
bys iso_code: gen cum_`r' = sum(`r')
replace cum_`r' = 1 if cum_`r' > 0
}
drop school alcohol fines curfew businesses publicplaces events masks mobility
duplicates drop iso_code date, force

collapse (sum) cum*, by(days_first_case)
* from Jan 1, 2020 to July 31, 2020 = 212 days
keep if days_first_case >= -20 & days_first_case <= 212
export delimited "any_policies.csv", replace
