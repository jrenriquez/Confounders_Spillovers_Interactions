clear all


* load data
import excel "Dataset/Lockdowns/Entidad.xlsx", sheet("Policy") firstrow clear

* clean
{
drop J
drop if entidad == "" | entidad == "Sources"
destring entidad, replace

* code INEGI
replace municipio = entidad*1000 if municipio_name == ""

* date
format date %tdDD_Mon_YYYY
format end_date %tdDD_Mon_YYYY

rename municipio cve_mun
rename entidad cve_entidad
rename municipio_name municipio
rename entidad_name entidad

********* append policy_action.csv

preserve

* load data
import delimited "Dataset/Lockdowns/policy_action.csv", encoding(UTF-8) clear
* fix date 
split date,p("T")
replace date_policy = date1 if date_policy == ""
drop date date1 date2 
rename date_policy date
split date,p("-")
replace date2 = substr(date2,2,strlen(date2)-1) if substr(date2, 1, 1) == "0"
gen aux = date2+"/"+date3+"/"+"2020"
gen aux2 = aux if aux != "//2020"
replace aux2 = date if aux == "//2020"
drop date date1 date2 date3 aux
replace aux2 = subinstr(aux2,"/20","/2020",5) if substr(aux2, -3, 3) == "/20"
split end_date,p("-")
gen aux = end_date2+"/"+end_date3+"/"+end_date1
replace aux = "" if aux=="//"
replace aux = substr(aux,2,strlen(aux)-1) if substr(aux, 1, 1) == "0"
drop end_date end_date1 end_date2 end_date3
gen date = date(aux2, "MDY")
gen end_date = date(aux, "MDY")
drop aux aux2
format date %tdDD_Mon_YYYY
format end_date %tdDD_Mon_YYYY
* fix state/municipality names
replace name_entidad = proper(name_entidad)
replace municipio_name = proper(municipio_name)
* note
split note,p("-")
gen aux =note2+"/"+note3+"/"+note1
gen aux2 = date(aux,"MDY")
replace end_date = aux2 if note!=""
drop note1 note2 note3 aux aux2 
replace note = title
* ID
gen policy_append = 1
* Drop variables
drop parameter newspaper title entidad municipio search_ type_newspaper state_date_first
*save
save policy_action.dta, replace

restore

append using policy_action.dta
erase policy_action.dta

drop if nivel == "federal"
replace name_entidad = "Ciudad de México" if name_entidad == "Cdmx"
replace name_entidad = "México" if name_entidad == "Estado De México" | name_entidad == "Estado De Mexico"
replace name_entidad = "Nuevo León" if name_entidad == "Nuevo Elon" | name_entidad == "Nuevo Leon"
replace name_entidad = "Querétaro" if name_entidad == "Queretaro"
replace name_entidad = "Yucatán" if name_entidad == "Yucatan"
replace entidad = name_entidad if policy_append == 1
drop name_entidad

replace municipio_name = subinstr(municipio_name,"áN","án",.)
replace municipio_name = subinstr(municipio_name,"éN","én",.)
replace municipio_name = subinstr(municipio_name,"íN","ín",.)
replace municipio_name = subinstr(municipio_name,"úN","ún",.)
replace municipio_name = subinstr(municipio_name,"óN","ón",.)
replace municipio_name = subinstr(municipio_name,"áS","ás",.)
replace municipio_name = subinstr(municipio_name,"éS","és",.)
replace municipio_name = subinstr(municipio_name,"éH","éh",.)
replace municipio_name = subinstr(municipio_name,"éU","éu",.)
replace municipio_name = subinstr(municipio_name,"íO","ío",.)
replace municipio_name = subinstr(municipio_name,"áL","ál",.)
replace municipio_name = subinstr(municipio_name," De "," de ",.)
replace municipio_name = subinstr(municipio_name," Del "," del ",.)
replace municipio = municipio_name if policy_append == 1
drop municipio_name


***************

* fix state names
replace entidad = "Coahuila de Zaragoza" if entidad == "Coahuila"
replace entidad = "México" if entidad == "Estado de México"
replace entidad = "Michoacán de Ocampo" if entidad == "Michoacán"
replace entidad = "Veracruz de Ignacio de la Llave" if entidad == "Veracruz"

* fix municipality names
replace municipio = "Rincón de Romos" if municipio == "Rincón de los Romo"
replace municipio = "Los Cabos" if municipio == "San José del Cabo"
replace municipio = "Campeche" if municipio == "San Francisco Kobén"
replace municipio = "Comitán de Domínguez" if municipio == "Comitán"
replace municipio = "Frontera Comalapa" if municipio == "Comalapa"
replace municipio = "San Cristóbal de las Casas" if municipio == "San Cristobal de las Casas"
replace municipio = "Juárez" if municipio == "Ciudad Juárez"
replace municipio = "Meoqui" if municipio == "Meoquii"
replace municipio = "Nonoava" if municipio == "Nonoavaa"
replace municipio = "Hidalgo del Parral" if municipio == "Parral"
replace municipio = "Valle de Zaragoza" if municipio == "Zaragoza"
replace municipio = "López" if municipio == "Villa López"
replace municipio = "Cuajimalpa de Morelos" if municipio == "Cuajimalpa"
replace municipio = "La Magdalena Contreras" if municipio == "Magdalena Contreras"
replace municipio = "San Juan de Sabinas" if municipio == "Nueva Rosita"
replace municipio = "Parras" if municipio == "Parras de la Fuente"
replace municipio = "Otáez" if municipio == "Otaez"
replace municipio = "San Juan del Río" if municipio == "San Juán del Río"
replace municipio = "Dolores Hidalgo Cuna de la Independencia Nacional" if municipio == "Dolores Hidalgo"
replace municipio = "Acapulco de Juárez" if municipio == "Acapulco"
replace municipio = "Atoyac de Álvarez" if municipio == "Atoyac"
replace municipio = "Chilpancingo de los Bravo" if municipio == "Chilpancingo"
replace municipio = "Pungarabato" if municipio == "Ciudad Altamirano"
replace municipio = "Cuautepec" if municipio == "El Salto"
replace municipio = "General Heliodoro Castillo" if municipio == "Heliodoro Castillo"
replace municipio = "Huitzuco de los Figueroa" if municipio == "Huitzuco"
replace municipio = "Iguala de la Independencia" if municipio == "Iguala"
replace municipio = "Pedro Ascencio Alquisiras" if municipio == "Ixcapuzalco"
replace municipio = "Taxco de Alarcón" if municipio == "Taxco"
replace municipio = "Técpan de Galeana" if municipio == "Tecpan de Galeana"
replace municipio = "Tixtla de Guerrero" if municipio == "Tixtla"
replace municipio = "General Heliodoro Castillo" if municipio == "Tlaotepec"
replace municipio = "Pachuca de Soto" if municipio == "Pachuca"
replace municipio = "Tulancingo de Bravo" if municipio == "Tulancingo"
replace municipio = "Tingambato" if municipio == "Pichataro"
replace municipio = "Tangamandapio" if municipio == "Santiago Tangamandapio"
replace municipio = "Cherán" if municipio == "Terán"
replace municipio = "Salvador Escalante" if municipio == "Zirahuen"
replace municipio = "Tetela del Volcán" if municipio == "Hueyapan"
replace municipio = "Tetela del Volcán" if municipio == "Huayapan"
replace municipio = "Ecatepec de Morelos" if municipio == "Ecatepec"
replace municipio = "Naucalpan de Juárez" if municipio == "Naucalpan" | municipio == "Naucalpan de Juarez"
replace municipio = "La Paz" if municipio == "Reyes la Paz"
replace municipio = "Valle de Chalco Solidaridad" if municipio == "Valle de Chalco"
replace municipio = "Cadereyta Jiménez" if municipio == "Cadereyta de Jiménez"
replace municipio = "Cadereyta de Montes" if municipio == "Cadereyta" & entidad == "Querétaro"
replace municipio = "Hualahuises" if municipio == "Hualauises"
replace municipio = "Capulálpam de Méndez" if municipio == "Capulalpam de Méndez" | municipio == "Calpulálpam de Méndez"
replace municipio = "Chalcatongo de Hidalgo" if municipio == "Chalcatongo"
replace municipio = "Santiago Pinotepa Nacional" if municipio == "Corralero"
replace municipio = "Villa de Etla" if municipio == "Etla"
replace municipio = "Chalcatongo de Hidalgo" if municipio == "Cañada de Morelos" & cve_entidad == 20
replace municipio = "San Juan Bautista Suchitepec" if municipio == "Guadalupe Cuatepec"
replace municipio = "Santiago Pinotepa Nacional" if municipio == "Guadalupe Victoria" & cve_entidad == 20
replace municipio = "Ciudad Ixtepec" if municipio == "Ixtepec"
replace municipio = "Ixtlán de Juárez" if municipio == "Ixtlán" & cve_entidad == 20
replace municipio = "Santiago Jamiltepec" if municipio == "Jamiltepec"
replace municipio = "Juchitán de Zaragoza" if municipio == "Juchitán"
replace municipio = "Villa de Tututepec" if municipio == "Lagunas de Chacahua"
replace municipio = "Santiago Pinotepa Nacional" if municipio == "Mancuernas"
replace municipio = "Santiago Pinotepa Nacional" if municipio == "Pinotepa Nacional"
replace municipio = "San Juan Guichicovi" if municipio == "Plan de San Luis"
replace municipio = "San Pedro Pochutla" if municipio == "Pochutla"
replace municipio = "San Pedro Mixtepec Distrito 22" if municipio == "Puerto Escondido"
replace municipio = "San Pedro Pochutla" if municipio == "Puerto Ángel"
replace municipio = "San Antonino Monte Verde" if municipio == "San Antonio Monteverde"
replace municipio = "San Mateo Río Hondo" if municipio == "San José del Pacífico"
replace municipio = "San Juan Bautista Cuicatlán" if municipio == "San Juan Bautista Cuicatlá"
replace municipio = "San Juan Mixtepec Distrito 08" if municipio == "San Juan Mixtepec"
replace municipio = "Ixtlán de Juárez" if municipio == "San Juan Yagila"
replace municipio = "Santa Catarina Juquila" if municipio == "San Marcos Zacatepec"
replace municipio = "San Juan Bautista Valle Nacional" if municipio == "San Mateo Yetla" & cve_entidad == 20
replace municipio = "San Miguel Tulancingo" if municipio == "San Miguel Tlancingo"
replace municipio = "San Francisco Telixtlahuaca" if municipio == "San Pablo Telixtlahuaca"
replace municipio = "San Pedro Pochutla" if municipio == "San Pedro" & cve_entidad == 20
replace municipio = "San Pedro Quiatoni" if municipio == "San Pedro Quiationi"|municipio == "San Pedro Quitioni"
replace municipio = "San Pedro Yólox" if municipio == "San Pedro Yolox"
replace municipio = "Santa María Jaltianguis" if municipio == "Santa María Jaltinaguis"
replace municipio = "San Juan Colorado" if municipio == "Santa María Nutio"
replace municipio = "Ixtlán de Juárez" if municipio == "Santa María Yahuiche"
replace municipio = "Santiago Lalopa" if municipio == "Santiago Lalopan"
replace municipio = "Santiago Pinotepa Nacional" if municipio == "Santiago Pinetopa Nacional"
replace municipio = "Santa María Petapa" if municipio == "Septune"
replace municipio = "Silacayoápam" if municipio == "Silacayoapam"
replace municipio = "Villa Talea de Castro" if municipio == "Talea de Castro"
replace municipio = "Heroica Villa Tezoatlán de Segura y Luna, Cuna de la Independencia de Oaxaca" if municipio == "Tezoatlán de Segura y Luna"
replace municipio = "Heroica Ciudad de Tlaxiaco" if municipio == "Tlaxiaco"
replace municipio = "Villa de Tututepec" if municipio == "Tututepec"
replace municipio = "San Juan Bautista Valle Nacional" if municipio == "Valle Nacional"
replace municipio = "San Ildefonso Villa Alta" if municipio == "Villa Alta"
replace municipio = "Villa Hidalgo" if municipio == "Villa Hidalgo Yalalág"
replace municipio = "San Pablo Huixtepec" if municipio == "Villa de San Pablo Huixtepec"
replace municipio = "Heroica Villa Tezoatlán de Segura y Luna, Cuna de la Independencia de Oaxaca" if municipio == "Yucumi de Ocampo"
replace municipio = "Teteles de Avila Castillo" if municipio == "Teteles de Ávila Castillo"
replace municipio = "Teziutlán" if municipio == "Teziultán"
replace municipio = "Tulcingo" if municipio == "Tulncingo"
replace municipio = "Jalpan de Serra" if municipio == "Jalpan"
replace municipio = "Lázaro Cárdenas" if municipio == "Holbox"
replace municipio = "José María Morelos" if municipio == "Sabán"
replace municipio = "Zaragoza" if municipio == "Valle de Zaragoza"
replace municipio = "Salvador Alvarado" if municipio == "Guamúchil"
replace municipio = "Guasave" if municipio == "Guasaveq"
replace municipio = "Nácori Chico" if municipio == "Nacori Chico"
replace municipio = "Nacozari de García" if municipio == "Nacozari"
replace municipio = "Nacozari de García" if municipio == "Nacozari"
replace municipio = "Santa Ana" if municipio == "Santa Aana"
replace municipio = "Trincheras" if municipio == "Trinchera"
replace municipio = "Alamos" if municipio == "Álamos"
replace municipio = "Imuris" if municipio == "Ímuris"
replace municipio = "Centro" if municipio == "Villahermosa"
replace municipio = "Centro" if municipio == "Villahermosa"
replace municipio = "Victoria" if municipio == "Ciudad Victoria"
replace municipio = "Tetla de la Solidaridad" if municipio == "Tetla"
replace municipio = "Tekax" if municipio == "Bacal"
replace municipio = "Yobaín" if municipio == "Chabihau"
replace municipio = "Progreso" if municipio == "Chelem"
replace municipio = "Chicxulub Pueblo" if municipio == "Chicxulub"
replace municipio = "Tlaltenango de Sánchez Román" if municipio == "Tlaltenango"
replace municipio = "Ignacio Zaragoza" if municipio == "Zaragoza" & cve_entidad == 8
replace municipio = "Medellín de Bravo" if municipio == "Medellín"
replace municipio = "Nanchital de Lázaro Cárdenas del Río" if municipio == "Nanchital" | municipio == "Nanchitala"
replace municipio = "Poza Rica de Hidalgo" if municipio == "Poza Rica"
replace municipio = "Chimalhuacán" if municipio == "Chimalhuacan"
replace municipio = "San Luis Río Colorado" if municipio == "San Luis Rio Colorado"
replace municipio = "San Juan del Río" if municipio == "San Juan del Rio"
replace municipio = "Nezahualcóyotl" if municipio == "Nezahualcoyotl"
replace municipio = "Tultitlán" if municipio == "Tultitlan"
replace municipio = "Querétaro" if municipio == "Queretaro"
replace municipio = "Mérida" if municipio == "Merida"
replace municipio = "Jesús María" if municipio == "Jesus Maria"
replace municipio = "Cuautitlán Izcalli" if municipio == "Cuautitlan Izcalli" | municipio == "Cuautitlan" & entidad == "México"
replace municipio = "Ciénega de Flores" if municipio == "Cienega de Flores"
replace municipio = "Nicolás Romero" if municipio == "Nicolas Romero"
replace municipio = "Coacalco de Berriozábal" if municipio == "Coacalco de Berriozabal"
replace municipio = "Tecámac" if municipio == "Tecamac"
replace municipio = "Tlalnepantla de Baz" if municipio == "Tlaneplantla de Baz"
replace municipio = "Chacsinkín" if municipio == "Chacksinkín"
replace municipio = "Dzán" if municipio == "Dzan"
replace municipio = "Huhí" if municipio == "Huhi"
replace municipio = "Telchac Puerto" if municipio == "Telchacpuerto"
replace municipio = "Tixmehuac" if municipio == "Tixméhuac"
replace municipio = "Tixpéhual" if municipio == "Tixpéual"
replace municipio = "Xalapa" if municipio == "Xlapa"


replace cve_entidad = 9 if entidad == "Ciudad de México" & cve_entidad == .
replace cve_entidad = 14 if entidad == "Jalisco" & cve_entidad == .
replace cve_entidad = 15 if entidad == "México" & cve_entidad == .
replace cve_entidad = 26 if entidad == "Sonora" & cve_entidad == .
replace cve_entidad = 22 if entidad == "Querétaro" & cve_entidad == .
replace cve_entidad = 31 if entidad == "Yucatán" & cve_entidad == .
replace cve_entidad = 32 if entidad == "Zacatecas" & cve_entidad == .

save aux.dta, replace

}

*** Merge cve INEGI
{
use "Dataset/Lockdowns/Catalogo_municipios_2019.dta", clear
merge 1:m entidad municipio using aux.dta
replace code_INEGI = 2006 if municipio == "San Quintín"
replace code_INEGI = cve_mun if code_INEGI == . & cve_mun != .

replace code_INEGI = cve_entidad*1000 if policy_append == 1 & nivel == "estatal"
replace code_INEGI = cve_entidad*1000 if municipio == "" & code_INEGI == .

sort entidad municipio
duplicates drop

keep if _m!=1
drop _m
drop Pob_total Totaldeviviendashabitadas Pob_masculina Pob_femenina
}

**** Restrictions
{

*We are focusing on restrictions, therefore we drop all "carrot-type" policies

drop if date == .

**** Generate stick-type policy dummies "restrictions"

replace measure = lower(measure)

cap drop restrictions*
cap drop aux

gen	restrictions_school = (strpos(measure,"escolares")|strpos(measure,"escuela"))

gen	restrictions_alcohol = (strpos(measure,"seca")|strpos(measure,"alcohol")|strpos(measure,"bebida"))

gen	restrictions_fines = (strpos(measure,"multa")|strpos(measure,"sanci"))

gen	restrictions_curfew = (strpos(measure,"toque"))

gen	restrictions_businesses = (strpos(measure,"establecimiento")|strpos(measure,"comerci")|strpos(measure,"restaurante")|strpos(measure,"bar")|strpos(measure,"antro")|strpos(measure,"centros comerciales")|strpos(measure,"hotel")|strpos(measure,"tianguis")|strpos(measure,"empresas")|strpos(measure,"obras")|strpos(measure,"funerari")|strpos(measure,"no esencial")|strpos(measure,"industria"))

gen	restrictions_publicplaces = (strpos(measure,"lugares públicos")|strpos(measure,"parque")|strpos(measure,"turístic")|strpos(measure,"playa")|strpos(measure,"espacios públicos")|strpos(measure,"áreas naturales")|strpos(measure,"museo")|strpos(measure,"administración")|strpos(measure,"visitas"))

gen	restrictions_checkpoints = (strpos(measure,"retén")|strpos(measure,"retenes")|strpos(measure,"cerco")|strpos(measure,"filtro")|strpos(measure,"restricción de paso a turistas")|strpos(measure,"puente")|strpos(measure,"módulo"))

gen	restrictions_events = (strpos(measure,"eventos")|strpos(measure,"masiv")|strpos(measure,"feria")|strpos(measure,"religio")|strpos(measure,"misas")|strpos(measure,"templos")|strpos(measure,"actividades deportivas"))

gen	restrictions_masks = (strpos(measure,"cubreboca")|strpos(measure,"mascarilla")|strpos(measure,"careta"))

gen restrictions_mobility = (strpos(measure,"movilidad")|strpos(measure,"circula")|strpos(measure,"vuelo")|strpos(measure,"aeropuerto")|strpos(measure,"crucero")|strpos(measure,"transporte")|strpos(measure,"trasnporte publico")|strpos(measure,"cuarentena obligatoria")|strpos(measure,"apsajeros máximo en coche")|strpos(measure,"medidas de asilamiento obligatorias")|strpos(measure,"restriccion de acceso al centor historico")|strpos(measure,"automovil una sola persona")|strpos(measure,"restriccion de metro"))

egen aux = rowtotal(restrictions_school restrictions_alcohol restrictions_fines restrictions_curfew restrictions_businesses restrictions_publicplaces restrictions_checkpoints restrictions_events restrictions_masks restrictions_mobility)
gen restrictions_any = aux>0
drop if aux == 0
replace restrictions_mobility = 0 if strpos(measure,"filtros sanitarios en los aero")|strpos(measure,"filtro sanitario en el aero")|strpos(measure,"filtros sanitarios en el aero")|strpos(measure,"filtros sanitarios en aero")|strpos(measure,"filtro sanitario para los vuelos")
drop aux


*IDENTIFY POLICIES IMPLEMENTED STATE-WIDE
cap drop aux*
gen aux = trunc(code_INEGI/1000)
gen aux2 = trunc(code_INEGI/1000)*1000
gen aux3 = (aux2 == code_INEGI) // 252 policies


foreach i of numlist 1/`=_N' {
display `i'

expand 11 if aux == 1 & _n == `i' & aux3 == 1
expand 6 if aux == 2 & _n == `i' & aux3 == 1
expand 5 if aux == 3 & _n == `i' & aux3 == 1
expand 11 if aux == 4 & _n == `i' & aux3 == 1
expand 38 if aux == 5 & _n == `i' & aux3 == 1
expand 10 if aux == 6 & _n == `i' & aux3 == 1
expand 123 if aux == 7 & _n == `i' & aux3 == 1
expand 67 if aux == 8 & _n == `i' & aux3 == 1
expand 16 if aux == 9 & _n == `i' & aux3 == 1
expand 39 if aux == 10 & _n == `i' & aux3 == 1
expand 46 if aux == 11 & _n == `i' & aux3 == 1
expand 81 if aux == 12 & _n == `i' & aux3 == 1
expand 84 if aux == 13 & _n == `i' & aux3 == 1
expand 125 if aux == 14 & _n == `i' & aux3 == 1
expand 125 if aux == 15 & _n == `i' & aux3 == 1
expand 113 if aux == 16 & _n == `i' & aux3 == 1
expand 35 if aux == 17 & _n == `i' & aux3 == 1
expand 20 if aux == 18 & _n == `i' & aux3 == 1
expand 51 if aux == 19 & _n == `i' & aux3 == 1
expand 570 if aux == 20 & _n == `i' & aux3 == 1
expand 217 if aux == 21 & _n == `i' & aux3 == 1
expand 18 if aux == 22 & _n == `i' & aux3 == 1
expand 11 if aux == 23 & _n == `i' & aux3 == 1
expand 58 if aux == 24 & _n == `i' & aux3 == 1
expand 18 if aux == 25 & _n == `i' & aux3 == 1
expand 72 if aux == 26 & _n == `i' & aux3 == 1
expand 17 if aux == 27 & _n == `i' & aux3 == 1
expand 43 if aux == 28 & _n == `i' & aux3 == 1
expand 60 if aux == 29 & _n == `i' & aux3 == 1
expand 212 if aux == 30 & _n == `i' & aux3 == 1
expand 106 if aux == 31 & _n == `i' & aux3 == 1
expand 58 if aux == 32 & _n == `i' & aux3 == 1		
}

bys code_INEGI measure: gen dup = cond(_N==1,0,_n) 
*weird numbering (not consecutive) in Baja California Sur, Chiapas, and CDMX
replace dup = 8 if dup == 4 & cve_entidad == 3
replace dup = 9 if dup == 5 & cve_entidad == 3
replace dup = dup+1 if dup>94 & cve_entidad == 7
replace dup = dup+1 if cve_entidad == 9
replace aux2 = aux2 + dup
replace code_INEGI = aux2 if aux3 == 1
drop dup

sort code_INEGI date

rename aux3 policy_statewide
drop aux aux2 cve_mun

* This is the panel of restrictions!


**** Generate variables indicating first day of restrictions (in the municipio, in the state. and statewide)
cap drop municipal_date_first
cap drop statewide_date_first
drop state_date_first

sort code_INEGI date
gen municipal_date_first = date
bys code_INEGI: replace municipal_date_first = date[1]
format municipal_date_first %tdDD_Mon_YYYY

sort cve_entidad date
gen state_date_first = date
bys cve_entidad: replace state_date_first = date[1]
format state_date_first %tdDD_Mon_YYYY

sort cve_entidad date
gen statewide_date_first = .
by cve_entidad: gen long obsno = _n
by cve_entidad : gen countnonmissing = sum(!missing(date)) if !missing(date) & policy_statewide == 1
bysort cve_entidad (countnonmissing) : replace statewide_date_first = date[1]
format statewide_date_first %tdDD_Mon_YYYY
drop obsno countnonmissing

sort code_INEGI date

**** Generate start data by type of restriction and municipio/state

* Start date

* municipio
local rest school alcohol fines curfew businesses publicplaces checkpoints events masks mobility any
foreach v of local rest {
gen restrictions_`v'_day_m = date if restrictions_`v' ==1
}
* statewide
local rest school alcohol fines curfew businesses publicplaces checkpoints events masks mobility any
foreach v of local rest {
gen restrictions_`v'_day_sw = date if restrictions_`v' ==1 & policy_statewide == 1
}
* state
local rest school alcohol fines curfew businesses publicplaces checkpoints events masks mobility any
foreach v of local rest {
if restrictions_`v'_day_m < restrictions_`v'_day_sw {
	gen restrictions_`v'_day_s = restrictions_`v'_day_m
 }
 else {
 	gen restrictions_`v'_day_s = restrictions_`v'_day_sw if restrictions_`v'_day_m >= restrictions_`v'_day_sw
 } 
}

foreach v of varlist restrictions_school_day_m restrictions_alcohol_day_m restrictions_fines_day_m restrictions_curfew_day_m restrictions_businesses_day_m restrictions_publicplaces_day_m restrictions_checkpoints_day_m restrictions_events_day_m restrictions_masks_day_m restrictions_mobility_day_m restrictions_any_day_m restrictions_school_day_s restrictions_alcohol_day_s restrictions_fines_day_s restrictions_curfew_day_s restrictions_businesses_day_s restrictions_publicplaces_day_s restrictions_checkpoints_day_s restrictions_events_day_s restrictions_masks_day_s restrictions_mobility_day_s restrictions_any_day_s {
format `v' %tdDD_Mon_YYYY
}

*********** COLLAPSE INTO A MUNICIPIO-DAY PANEL 

collapse ///
(first) entidad municipio cve_entidad municipal_date_first state_date_first statewide_date_first ///
restrictions_school_day_m restrictions_alcohol_day_m restrictions_fines_day_m restrictions_curfew_day_m restrictions_businesses_day_m restrictions_publicplaces_day_m restrictions_checkpoints_day_m restrictions_events_day_m restrictions_masks_day_m restrictions_mobility_day_m restrictions_any_day_m ///
restrictions_school_day_s restrictions_alcohol_day_s restrictions_fines_day_s restrictions_curfew_day_s restrictions_businesses_day_s restrictions_publicplaces_day_s restrictions_checkpoints_day_s restrictions_events_day_s restrictions_masks_day_s restrictions_mobility_day_s restrictions_any_day_s ///
restrictions_school_day_sw restrictions_alcohol_day_sw restrictions_fines_day_sw restrictions_curfew_day_sw restrictions_businesses_day_sw restrictions_publicplaces_day_sw restrictions_checkpoints_day_sw restrictions_events_day_sw restrictions_masks_day_sw restrictions_mobility_day_sw restrictions_any_day_sw ///
(sum) restrictions_school restrictions_alcohol restrictions_fines restrictions_curfew restrictions_businesses restrictions_publicplaces restrictions_checkpoints restrictions_events restrictions_masks restrictions_mobility ///
, by(code_INEGI date)


*** Any restriction
egen aux = rowtotal(restrictions_school restrictions_alcohol restrictions_fines restrictions_curfew restrictions_businesses restrictions_publicplaces restrictions_checkpoints restrictions_events restrictions_masks restrictions_mobility)
gen restrictions_any = aux>0
drop aux

label var code_INEGI "clave AGEM INEGI"
label var date "Date"
label var entidad "Entidad"
label var municipio "Municipio"
label var cve_entidad "Entidad numérico"
label var municipal_date_first "First date on which any restriction was applied (municipio)"
label var state_date_first "First date on which any restriction was applied (state)"
label var statewide_date_first "First date on which any statewide restriction was applied"
label var restrictions_school_day_m "Date (municipio) Suspensión de actividades escolares"
label var restrictions_alcohol_day_m "Date (municipio) Ley seca"
label var restrictions_fines_day_m "Date (municipio) multas por deambular"
label var restrictions_curfew_day_m "Date (municipio) toque de queda"
label var restrictions_businesses_day_m "Date (municipio) bars, antros, restaurantes, comercios, establecimientos, plazas comerciales"
label var restrictions_publicplaces_day_m "Date (municipio) parques, zonas turísticas"
label var restrictions_checkpoints_day_m "Date (municipio) cercos, filtros sanitarios"
label var restrictions_events_day_m "Date (municipio) eventos masivos"
label var restrictions_masks_day_m "Date (municipio) cubrebocas"
label var restrictions_mobility_day_m "Date (municipio) movilidad: hoy no circula, transporte público, transporte privado"
label var restrictions_any_day_m "Date (municipio) any restriction"
label var restrictions_school_day_s "Date (state) Suspensión de actividades escolares"
label var restrictions_alcohol_day_s "Date (state) Ley seca"
label var restrictions_fines_day_s "Date (state) multas por deambular"
label var restrictions_curfew_day_s "Date (state) toque de queda"
label var restrictions_businesses_day_s "Date (state) bars, antros, restaurantes, comercios, establecimientos, plazas comerciales"
label var restrictions_publicplaces_day_s "Date (state) parques, zonas turísticas"
label var restrictions_checkpoints_day_s "Date (state) cercos, filtros sanitarios"
label var restrictions_events_day_s "Date (state) eventos masivos"
label var restrictions_masks_day_s "Date (state) cubrebocas"
label var restrictions_mobility_day_s "Date (state) movilidad: hoy no circula, transporte público, transporte privado"
label var restrictions_any_day_s "Date (state) any restriction"
label var restrictions_school_day_sw "Date (statewide) Suspensión de actividades escolares"
label var restrictions_alcohol_day_sw "Date (statewide) Ley seca"
label var restrictions_fines_day_sw "Date (statewide) multas por deambular"
label var restrictions_curfew_day_sw "Date (statewide) toque de queda"
label var restrictions_businesses_day_sw "Date (statewide) bars, antros, restaurantes, comercios, establecimientos, plazas comerciales"
label var restrictions_publicplaces_day_sw "Date (statewide) parques, zonas turísticas"
label var restrictions_checkpoints_day_sw "Date (statewide) cercos, filtros sanitarios"
label var restrictions_events_day_sw "Date (statewide) eventos masivos"
label var restrictions_masks_day_sw "Date (statewide) cubrebocas"
label var restrictions_mobility_day_sw "Date (statewide) movilidad: hoy no circula, transporte público, transporte privado"
label var restrictions_any_day_sw "Date (statewide) any restriction"
label var restrictions_school "Suspensión de actividades escolares"
label var restrictions_alcohol "Ley seca"
label var restrictions_fines "multas por deambular"
label var restrictions_curfew "toque de queda"
label var restrictions_businesses "bars, antros, restaurantes, comercios, establecimientos, plazas comerciales"
label var restrictions_publicplaces "parques, zonas turísticas"
label var restrictions_checkpoints "cercos, filtros sanitarios"
label var restrictions_events "eventos masivos"
label var restrictions_masks "cubrebocas"
label var restrictions_mobility "movilidad: hoy no circula, transporte público, transporte privado"
label var restrictions_any "Any restriction"

*** Fix Querétaro (first sanitary filter was installed in January but panel starts in February

replace date = td(27Feb2020) if date < td(26Feb2020) & entidad == "Querétaro" // 18 obs that correspond to a sanitary filter in QTO airport installed in January

}


**** Save
save treatments.dta, replace


**** MERGE with panel (daily data)

noi merge 1:1 code_INEGI date using panel_COVID_fixdates.dta, nogen

label var date_num "Date (numeric)"
label var Pob_total "Total population"
label var Pob_masculina "Total male population"
label var Pob_femenina "Total female population"
label var Totaldeviviendashabitadas "Total number of households"


sort code_INEGI date
foreach v of varlist municipal_date_first state_date_first statewide_date_first restrictions_school_day_m restrictions_alcohol_day_m restrictions_fines_day_m restrictions_curfew_day_m restrictions_businesses_day_m restrictions_publicplaces_day_m restrictions_checkpoints_day_m restrictions_events_day_m restrictions_masks_day_m restrictions_mobility_day_m restrictions_any_day_m restrictions_school_day_s restrictions_alcohol_day_s restrictions_fines_day_s restrictions_curfew_day_s restrictions_businesses_day_s restrictions_publicplaces_day_s restrictions_checkpoints_day_s restrictions_events_day_s restrictions_masks_day_s restrictions_mobility_day_s restrictions_any_day_s restrictions_school_day_sw restrictions_alcohol_day_sw restrictions_fines_day_sw restrictions_curfew_day_sw restrictions_businesses_day_sw restrictions_publicplaces_day_sw restrictions_checkpoints_day_sw restrictions_events_day_sw restrictions_masks_day_sw restrictions_mobility_day_sw restrictions_any_day_sw {
sort code_INEGI `v'
bys code_INEGI: replace `v' = `v'[1] if `v'[1]!= .
}


*** Accumulative Variables: once there is a restriction in place it turns to 1 and keeps 1


sort code_INEGI date
cap drop aux_*
cap drop cum_*
local rest school alcohol fines curfew businesses publicplaces checkpoints events masks mobility
foreach v of local rest {
bys code_INEGI: gen aux_`v' = sum(restrictions_`v')
replace aux_`v' = 1 if aux_`v'>0
rename aux_`v' cum_`v'
label var cum_`v' "Restriction on `v' (dummy if restriction is or was on place)"
}


* Any restriction
egen aux = rowtotal(cum_school cum_alcohol cum_fines cum_curfew cum_businesses cum_publicplaces cum_checkpoints cum_events cum_masks cum_mobility)
gen cum_any = aux>0
drop aux
label var cum_any "Any restriction"


/*
cap drop cum_*
sort code_INEGI date
local rest school alcohol fines curfew businesses publicplaces checkpoints events masks mobility any
foreach v of local rest {
bys code_INEGI: egen cum_`v'=sum(restrictions_`v')
replace cum_`v' = 1 if cum_`v'>0 & cum_`v'!=.
label var cum_`v' "Restriction on `v' (dummy if restriction is or was on place)"
}
*/

*** NEW COVID CASES PER 100,000 INHABITANTS

gen covid_pc = (covid_1 / Pob_total)*100000 // 10 municipalities with missing population data
label var covid_pc "New COVID-19 cases per day per 100,000"

*** DEATHS PER 100,000 INHABITANTS

rename defunciones deaths
gen deaths_pc = (deaths / Pob_total)*100000 // 10 municipalities with missing population data
label var deaths_pc "New COVID-19 deaths per day per 100,000"


********************************************************************************


*****	Event Study

* Any kind of restriction
sort code_INEGI date
cap drop event_time_*
local rest school alcohol fines curfew businesses publicplaces checkpoints events masks mobility any
foreach r of local rest {
sort code_INEGI date
cap drop aux aux2 aux3
bys code_INEGI cum_`r': gen aux = _n
gen aux2 = (cum_`r' == 0)
bys code_INEGI: egen aux3 = total(aux2) if cum_`r' == 0
replace aux = aux - aux3 -1 if cum_`r' == 0
cap drop aux2 aux3
rename aux event_time_`r'
label var event_time_`r' "Time (in # of days) since restriction on `r' was implemented"
}

***** 	State Code

gen aux = trunc(code_INEGI/1000)
replace cve_entidad = aux if cve_entidad == .
drop aux

********************************************************************************

*	Save dataset

save "panel_COVID_Lockdowns.dta", replace

