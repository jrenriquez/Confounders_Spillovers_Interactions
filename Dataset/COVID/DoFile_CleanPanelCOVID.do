clear all

use "Dataset/Lockdowns/Catalogo_municipios_2019.dta", clear

********************************************************************************

* Set up panel: municipio - day (since the first case of Coronavirus until today)

gen date = "27 Feb 2020" // INITIAL DATE (1st case of coronavirus in Mexico was reported on Feb 27)
gen date_num = date(date, "DMY") // There are 3 positive cases registered before (Jan 8, Jan 14, Jan 28) in GobMX database

expand 2 // start and end date

bys code_INEGI: gen dup = cond(_N==1,0,_n)
replace date = "$S_DATE" if dup == 2 				// Today's date
replace date_num = date(date, "DMY")
drop dup

// ADD new municipality (San Quintín, Baja California)
expand 2 if code_INEGI == 2005, gen(aux)
replace code_INEGI = 2006 if aux == 1
replace municipio = "San Quintín" if aux == 1
replace Pob_total = . if aux == 1
replace Totaldeviviendashabitadas = . if aux == 1
replace Pob_masculina = . if aux == 1
replace Pob_femenina = . if aux == 1
drop aux

tsset code_INEGI date_num
tsfill

foreach v of varlist entidad municipio Pob_total Totaldeviviendashabitadas Pob_masculina Pob_femenina {
bys code_INEGI: replace `v' = `v'[1]
}

gen aux = date_num
format aux %tdDD_Mon_YYYY
drop date
rename aux date

save "panel.dta", replace

********************************************************************************

* Merge COVID data

clear all 


* Load data

import delimited "Dataset/COVID/08232020COVID19MEXICO.csv"

/*
local today: di %tdNDCY daily("$S_DATE", "DMY")
local yesterday: di %tdNDCY daily("`c(current_date)'", "DMY") - 1

capture confirm file "~/Dropbox/COVID-19 Mexico/Nature Communications submission/Dataset/COVID/`today'COVID19MEXICO.csv"
  if _rc==0 {
  	noi display "Database: `today'COVID19MEXICO.csv"
    import delimited "~/Dropbox/COVID-19 Mexico/Nature Communications submission/Dataset/COVID/`today'COVID19MEXICO.csv", encoding(UTF-8)
  }
  else {
	capture confirm file "~/Dropbox/COVID-19 Mexico/Nature Communications submission/Dataset/COVID/`yesterday'COVID19MEXICO.csv"
	if _rc==0 {
		noi display "Database: `yesterday'COVID19MEXICO.csv"
		import delimited "~/Dropbox/COVID-19 Mexico/Nature Communications submission/Dataset/COVID/`yesterday'COVID19MEXICO.csv", encoding(UTF-8)
  }
  else {
  	display "Update GOB MX COVID datasets!"
  }
  }
*/

* INEGI
gen code_INEGI = entidad_res*1000 + municipio_res

* ORIGEN: USMER (Unidades Monitoras de Enfermedad Respiratoria Viral)
gen usmer_1 = (origen == 1)
gen usmer_0 = (origen == 2)
gen usmer_na = (origen == 99)

* SECTOR:
gen cruzroja = (sector == 1)
gen DIF = (sector == 2)
gen clinica_estatal = (sector == 3)
gen IMSS = (sector == 4)
gen IMSSBienestar = (sector == 5)
gen ISSSTE = (sector == 6)
gen unidad_municipal = (sector == 7)
gen PEMEX = (sector == 8)
gen privada = (sector == 9)
gen SEDENA = (sector == 10)
gen SEMAR = (sector == 11)
gen SSA = (sector == 12)
gen unidad_universitaria = (sector == 13)
gen unidad_na = (sector == 99)

* UNIDAD MÉDICA: ENTIDAD
label var entidad_um "Entidad de Unidad Médica" 

* SEXO
gen aux = "Mujer" if sexo == 1
replace aux = "Hombre" if sexo == 2
replace aux = "NA" if sexo == 99
label def female 0 "Hombre" 1 "Mujer" 
encode aux, gen(female) label(female)
drop aux

* ENTIDAD NACIMIENTO
label var entidad_nac "Entidad de nacimiento"

* ENTIDAD RESIDENCIA
label var entidad_res "Entidad de residencia"

* MUNICIPIO RESIDENCIA
label var municipio_res "Municipio de residencia"

* TIPO DE PACIENTE
gen paciente_ambulatorio = (tipo_paciente == 1)
gen paciente_hospitalizado = (tipo_paciente == 2)
gen paciente_na = (tipo_paciente == 99)
gen hospitalizados = (paciente_hospitalizado == 1)

* INTUBADO
gen intubado_1 = (intubado == 1)
gen intubado_0 = (intubado == 2)
gen intubado_na = (intubado == 99)

* NEUMONIA
gen neumonia_1 = (neumonia == 1)
gen neumonia_0 = (neumonia == 2)
gen neumonia_na = (neumonia == 99)

* NACIONALIDAD
gen mexicano_1 = (nacionalidad == 1)
gen mexicano_0 = (nacionalidad == 2)
gen mexicano_na = (nacionalidad == 99)

* PAÍS DE ORIGEN
label var pais_nacionalidad "País de nacionalidad"

* EMBARAZO
gen embarazo_1 = (embarazo == 1)
gen embarazo_0 = (embarazo == 2)
gen embarazo_na = (embarazo == 99)
replace embarazo_1 = . if embarazo == 97
replace embarazo_0 = . if embarazo == 97
replace embarazo_na = . if embarazo == 97

* LENGUA INDÍGENA
gen indigena_1 = (habla_lengua_indig == 1)
gen indigena_0 = (habla_lengua_indig == 0)
gen indigena_na = (habla_lengua_indig == 99)

* DIABETES
gen diabetes_1 = (diabetes == 1)
gen diabetes_0 = (diabetes == 0)
gen diabetes_na = (diabetes == 99)

* EPOC
gen epoc_1 = (epoc == 1)
gen epoc_0 = (epoc == 0)
gen epoc_na = (epoc == 99)

* ASMA
gen asma_1 = (asma == 1)
gen asma_0 = (asma == 0)
gen asma_na = (asma == 99)

* INMUNOSUPRESIÓN
gen inmusupr_1 = (inmusupr == 1)
gen inmusupr_0 = (inmusupr == 0)
gen inmusupr_na = (inmusupr == 99)

* HIPERTENSIÓN
gen hipertension_1 = (hipertension == 1)
gen hipertension_0 = (hipertension == 0)
gen hipertension_na = (hipertension == 99)

* OTRA COMORBILIDAD
gen comorbilidad_1 = (otra_com == 1)
gen comorbilidad_0 = (otra_com == 0)
gen comorbilidad_na = (otra_com == 99)

* ENFERMEDADES CARDIOVASCULARES
gen cardiovascular_1 = (cardiovascular == 1)
gen cardiovascular_0 = (cardiovascular == 0)
gen cardiovascular_na = (cardiovascular == 99)

* OBESIDAD
gen obesidad_1 = (obesidad == 1)
gen obesidad_0 = (obesidad == 0)
gen obesidad_na = (obesidad == 99)

* RENAL CRÓNICA
gen renal_cronica_1 = (renal_cronica == 1)
gen renal_cronica_0 = (renal_cronica == 0)
gen renal_cronica_na = (renal_cronica == 99)

* TABAQUISMO
gen tabaquismo_1 = (tabaquismo == 1)
gen tabaquismo_0 = (tabaquismo == 0)
gen tabaquismo_na = (tabaquismo == 99)

* CONTACTO CON PACIENTE SON COVID (OTRO CASO) 
gen otro_caso_1 = (otro_caso == 1)
gen otro_caso_0 = (otro_caso == 0)
gen otro_caso_na = (otro_caso == 99)

* MIGRANTE
gen migrante_1 = (migrante == 1)
gen migrante_0 = (migrante == 0)
gen migrante_na = (migrante == 99)

* UNIDAD DE CIUDADOS INTENSIVOS (UCI)
gen uci_1 = (uci == 1)
gen uci_0 = (uci == 0)
gen uci_na = (uci == 99)

* COVID-19
gen covid_1 = (resultado == 1)
gen covid_0 = (resultado == 2)
gen covid_sospechoso = (resultado == 3)

* MUERTES
gen defunciones = (fecha_def!="9999-99-99" & covid_1 == 1)

* FECHA INGRESO
split fecha_ingreso, p("-")
drop fecha_ingreso
gen date = fecha_ingreso3+" "+fecha_ingreso2+" "+fecha_ingreso1
gen fecha_ingreso_num = date(date, "DMY")
gen fecha_ingreso = fecha_ingreso_num
format fecha_ingreso %tdDD_Mon_YYYY
drop fecha_ingreso1 fecha_ingreso2 fecha_ingreso3 date

* FECHA MUERTE
split fecha_def, p("-")
destring fecha_def*, replace
gen fecha_def_num = mdy(fecha_def2,fecha_def3,fecha_def1) if fecha_def!="9999-99-99"
drop fecha_def
gen fecha_def = fecha_def_num
format fecha_def %tdDD_Mon_YYYY
drop fecha_def1 fecha_def2 fecha_def3

* FECHA SÍNTOMAS
split fecha_sintomas, p("-")
destring fecha_sintomas*, replace
gen fecha_sintomas_num = mdy(fecha_sintomas2,fecha_sintomas3,fecha_sintomas1)
drop fecha_sintomas
gen fecha_sintomas = fecha_sintomas_num
format fecha_sintomas %tdDD_Mon_YYYY
drop fecha_sintomas1 fecha_sintomas2 fecha_sintomas3

* PRIMER FECHA CON SÍNTOMAS por municipio
bys code_INEGI: gen first_sintomas = fecha_sintomas

* PRIMER FECHA INGRESO por municipio
bys code_INEGI: gen first_ingreso = fecha_ingreso

* PRIMER FECHA DEFUNCIÓN por municipio
bys code_INEGI: gen first_def = fecha_def

* PRIMER FECHA CASO POSITIVO por municipio
bys code_INEGI: gen first_covid = first_ingreso if covid_1 == 1

* FECHA MODA Y MEDIANA DE SÍNTOMAS por municipio
bys code_INEGI: egen fecha_moda_sintomas = mode(fecha_sintomas_num)
bys code_INEGI: egen fecha_med_sintomas = median(fecha_sintomas_num)

* FECHA MODA Y MEDIANA DE INGRESO por municipio
bys code_INEGI: egen fecha_moda_ingreso = mode(fecha_ingreso_num)
bys code_INEGI: egen fecha_med_ingreso = median(fecha_ingreso_num)

* FECHA MODA Y MEDIANA DE MUERTES por municipio
bys code_INEGI: egen fecha_moda_def = mode(fecha_def_num)
bys code_INEGI: egen fecha_med_def = median(fecha_def_num)


* DÍAS ENTRE SÍNTOMAS E INGRESO
gen dias_sintomas_ingreso = fecha_ingreso_num - fecha_sintomas_num
bys code_INEGI: egen moda_sintomas_ingreso = mode(dias_sintomas_ingreso)
bys code_INEGI: egen median_sintomas_ingreso = median(dias_sintomas_ingreso)

* DÍAS ENTRE SÍNTOMAS Y MUERTE
gen dias_sintomas_def = fecha_def_num - fecha_sintomas_num
replace dias_sintomas_def = 0 if dias_sintomas_def < 0 // 9 cases with errors (syntomps occurred after death)
bys code_INEGI: egen moda_sintomas_def = mode(dias_sintomas_def)
bys code_INEGI: egen median_sintomas_def = median(dias_sintomas_def)

* DÍAS ENTRE INGRESO Y MUERTE
gen dias_ingreso_def = fecha_def_num - fecha_ingreso_num
replace dias_ingreso_def = 0 if dias_ingreso_def<0 // 35 cases with errors (ingreso occurred after death)
bys code_INEGI: egen moda_ingreso_def = mode(dias_ingreso_def)
bys code_INEGI: egen median_ingreso_def = median(dias_ingreso_def)


* ENTIDAD DE UNIDAD MÉDICA MÁS COMÚN
bys code_INEGI: egen moda_entidad_um = mode(entidad_um)

* ENTIDAD DE NACIMIENTO MÁS COMÚN // proxy for social connectedness to other places
bys code_INEGI: egen moda_entidad_nac = mode(entidad_nac)

* PAÍS DE NACIONALIDAD DE EXTRANJEROS MÁS COMÚN
bys code_INEGI: egen moda_pais_nac = mode(pais_nacionalidad) if pais_nacionalidad!="Mexico" & pais_nacionalidad!="México"

foreach v of varlist fecha_moda_sintomas fecha_moda_ingreso moda_sintomas_ingreso moda_sintomas_def moda_ingreso_def moda_entidad_um moda_entidad_nac fecha_med_sintomas fecha_med_ingreso fecha_med_def median_sintomas_ingreso median_sintomas_def median_ingreso_def {
sort code_INEGI `v'
cap replace `v' = `v'[1] if `v' == .
cap replace `v' = `v'[1] if `v' == ""
}

foreach v of varlist moda_pais_nac {
gsort code_INEGI -`v'
cap replace `v' = `v'[1] if `v' == .
cap replace `v' = `v'[1] if `v' == ""
}

* ID municipio
gen id = 1


********************************************************************************

* fix dates: 

cap drop fecha
gen fecha = .

*cases: replace registration date for symptoms date

replace fecha = fecha_sintomas if covid_1 == 1

*deaths: replace registration date for death date

expand 2 if defunciones == 1 & fecha_sintomas != fecha_def, gen(auxdate)

replace fecha = fecha_def if defunciones == 1 & auxdate == 1
*avoid overcounting:
replace defunciones = 0 if fecha == fecha_sintomas & auxdate == 0
replace covid_1 = 0 if fecha == fecha_def & auxdate == 1

format fecha %tdDD_Mon_YYYY
drop auxdate

********************************************************************************

* Collapse by municipio 
sort code_INEGI fecha
collapse (mean) usmer_1 usmer_0 usmer_na cruzroja DIF clinica_estatal IMSS IMSSBienestar ISSSTE unidad_municipal PEMEX privada SEDENA SEMAR SSA unidad_universitaria unidad_na female paciente_ambulatorio paciente_hospitalizado paciente_na intubado_1 intubado_0 intubado_na neumonia_1 neumonia_0 neumonia_na mexicano_1 mexicano_0 mexicano_na embarazo_1 embarazo_0 embarazo_na indigena_1 indigena_0 indigena_na diabetes_1 diabetes_0 diabetes_na epoc_1 epoc_0 epoc_na asma_1 asma_0 asma_na inmusupr_1 inmusupr_0 inmusupr_na hipertension_1 hipertension_0 hipertension_na comorbilidad_1 comorbilidad_0 comorbilidad_na cardiovascular_1 cardiovascular_0 cardiovascular_na obesidad_1 obesidad_0 obesidad_na renal_cronica_1 renal_cronica_0 renal_cronica_na tabaquismo_1 tabaquismo_0 tabaquismo_na otro_caso_1 otro_caso_0 otro_caso_na migrante_1 migrante_0 migrante_na dias_sintomas_ingreso dias_sintomas_def dias_ingreso_def ///
(sum) id hospitalizados uci_1 uci_0 uci_na covid_1 covid_0 covid_sospechoso defunciones ///
(first) fecha_actualizacion moda_entidad_um moda_entidad_nac first_covid first_sintomas first_ingreso first_def fecha_med_sintomas fecha_med_ingreso fecha_med_def fecha_moda_sintomas fecha_moda_ingreso fecha_moda_def moda_sintomas_ingreso moda_sintomas_def moda_ingreso_def moda_pais_nac median_sintomas_ingreso median_sintomas_def median_ingreso_def ///
, by(code_INEGI fecha)


* LABELS
label var code_INEGI "cve AGEM INEGI"
label var fecha "Casos: Fecha síntomas; Muertes: Fecha defunción"
label var usmer_na "Unidades Monitoras de Enfermedad Respiratoria Viral: NA"
label var usmer_0 "No es de Unidades Monitoras de Enfermedad Respiratoria Viral"
label var usmer_1 "Unidades Monitoras de Enfermedad Respiratoria Viral"
foreach v of varlist cruzroja-unidad_na {
label var `v' "Unidad médica de ingreso: `v'"
}
label var female "Female"
label var moda_entidad_um "Entidad de Unidad Médica más común (moda)" 
label var moda_entidad_nac "Entidad de nacimiento más común (moda)"
label var paciente_na "Tipo de paciente: NA"
label var paciente_hospitalizado "Tipo de paciente: hospitalizado"
label var paciente_ambulatorio "Tipo de paciente: ambulatorio"
label var intubado_na "Intubado: NA"
label var intubado_0 "No intubado"
label var intubado_1 "Intubado"
label var neumonia_na "Neumonía: NA"
label var neumonia_0 "No neumonía"
label var neumonia_1 "Neumonía"
label var mexicano_na "Nacionalidad desconocida"
label var mexicano_0 "Extranjero"
label var mexicano_1 "Mexicano"
label var moda_pais_nac "País de nacionalidad de extranjeros más frecuente"
label var embarazo_na "Embarazo: NA"
label var embarazo_0 "No embarazo"
label var embarazo_1 "Embarazo"
label var indigena_na "Habla lengua indígena: NA"
label var indigena_0 "No habla lengua indígena"
label var indigena_1 "Habla lengua indígena"
label var diabetes_na "Diabetes: NA"
label var diabetes_0 "Sin diabetes"
label var diabetes_1 "Diabetes"
label var epoc_na "EPOC: NA"
label var epoc_0 "Sin EPOC"
label var epoc_1 "EPOC"
label var asma_na "Asma: NA"
label var asma_0 "Sin asma"
label var asma_1 "Asma"
label var inmusupr_na "Inmunosupresión: NA"
label var inmusupr_0 "Sin inmunosupresión"
label var inmusupr_1 "Inmunosupresión"
label var hipertension_na "Hipertensión: NA"
label var hipertension_0 "Sin hipertensión"
label var hipertension_1 "Hipertensión"
label var comorbilidad_na "Otra comorbilidad: NA"
label var comorbilidad_0 "Sin otra comorbilidad"
label var comorbilidad_1 "Otra comorbilidad"
label var cardiovascular_na "Enfermedad cardiovascular: NA"
label var cardiovascular_0 "Sin enfermedad cardiovascular"
label var cardiovascular_1 "Enfermedad cardiovascular"
label var obesidad_na "Obesidad: NA"
label var obesidad_0 "Sin obesidad"
label var obesidad_1 "Obesidad"
label var renal_cronica_na "Enfermedad renal crónica: NA"
label var renal_cronica_0 "Sin enfermedad renal crónica"
label var renal_cronica_1 "Enfermedad renal crónica"
label var tabaquismo_na "Tabaquismo: NA"
label var tabaquismo_0 "Sin tabaquismo"
label var tabaquismo_1 "Tabaquismo"
label var otro_caso_na "Contacto con otro paciente COVID: NA"
label var otro_caso_0 "Sin contacto con otro paciente con COVID"
label var otro_caso_1 "Contacto con otro paciente con COVID"
label var migrante_na "Migrante: NA"
label var migrante_0 "No es migrante"
label var migrante_1 "Migrante"
label var hospitalizados "Número de pacientes hospitalizados"
label var uci_na "Unidad de cuidados intensivos: NA"
label var uci_0 "Pacientes que no están en Unidad de Cuidados Intensivos"
label var uci_1 "Pacientes en Unidad de Cuidados Intensivos"
label var covid_sospechoso "Número de pacientes pendiente resultado COVID-19"
label var covid_0 "Number of pacientes negativos COVID-19"
label var covid_1 "New COVID-19 cases"
label var dias_sintomas_ingreso "Días transcurridos entre síntomas e ingreso"
label var dias_sintomas_def "Días transcurridos entre síntomas y defunción"
label var dias_ingreso_def "Días transcurridos entre ingreso y defunción"
label var id "Casos totales (municipio-día)"
label var defunciones "Number of new deaths by day (municipio)"
label var fecha_actualizacion "Fecha de base de datos"
label var first_covid "Primer caso de COVID (municipio)"
label var first_sintomas "Fecha de primeros síntomas (municipio)"
label var first_ingreso "Fecha de primer ingreso (municipio)"
label var first_def "Fecha de primera muerte (municipio)"
label var fecha_moda_sintomas "Fecha más común de primeros síntomas (municipio)"
label var fecha_moda_ingreso "Fecha más común de ingreso (municipio)"
label var fecha_moda_def "Fecha más común de defunción (municipio)"
label var fecha_med_sintomas "Fecha mediana de síntomas (municipio)"
label var fecha_med_ingreso "Fecha mediana de ingreso (municipio)"
label var fecha_med_def "Fecha mediana de defunciones (municipio)"
label var moda_sintomas_ingreso "Número de días moda entre síntomas e ingreso (municipio)"
label var moda_sintomas_def "Número de días moda entre síntomas y defunción (municipio)"
label var moda_ingreso_def "Número de días moda entre ingreso y defunción (municipio)"
label var median_sintomas_ingreso "Mediana de número de días entre síntomas e ingreso (municipio)"
label var median_sintomas_def "Mediana de número de días entre síntomas y defunción (municipio)"
label var median_ingreso_def "Mediana de número de días entre ingreso y defunción (municipio)"

*Rename variables
rename id casos_totales
rename fecha date // date = fecha de ingreso a unidad médica

foreach v of varlist fecha_moda_sintomas fecha_moda_ingreso fecha_moda_def fecha_med_sintomas fecha_med_ingreso fecha_med_def first_sintomas first_ingreso first_def first_covid {
format `v' %tdDD_Mon_YYYY
}

order code_INEGI date casos_totales covid*

* Merge
// First case of Coronavirus in Mexico was reported on Feb 28 (https://elpais.com/sociedad/2020/02/28/actualidad/1582897294_203408.html) //
// There are 3 cases reported before, which may be an error //
keep if date > td(26Feb2020)

noi display "_merge == 1 are observations with wrong or no municipality id:"
noi merge 1:1 code_INEGI date using "panel.dta"
drop if _m == 1 // ~24 observations with no (~) or wrong Municipality identifier (~)
drop _m

cap drop aux
gen aux = 1 if covid_1 != . // replace to zero if at least one case is reported

foreach v of varlist casos_totales covid_1 covid_0 covid_sospechoso usmer_1 usmer_0 usmer_na cruzroja DIF clinica_estatal IMSS IMSSBienestar ISSSTE unidad_municipal PEMEX privada SEDENA SEMAR SSA unidad_universitaria unidad_na female paciente_ambulatorio paciente_hospitalizado paciente_na intubado_1 intubado_0 intubado_na neumonia_1 neumonia_0 neumonia_na mexicano_1 mexicano_0 mexicano_na embarazo_1 embarazo_0 embarazo_na indigena_1 indigena_0 indigena_na diabetes_1 diabetes_0 diabetes_na epoc_1 epoc_0 epoc_na asma_1 asma_0 asma_na inmusupr_1 inmusupr_0 inmusupr_na hipertension_1 hipertension_0 hipertension_na comorbilidad_1 comorbilidad_0 comorbilidad_na cardiovascular_1 cardiovascular_0 cardiovascular_na obesidad_1 obesidad_0 obesidad_na renal_cronica_1 renal_cronica_0 renal_cronica_na tabaquismo_1 tabaquismo_0 tabaquismo_na otro_caso_1 otro_caso_0 otro_caso_na migrante_1 migrante_0 migrante_na dias_sintomas_ingreso dias_sintomas_def dias_ingreso_def hospitalizados uci_1 uci_0 uci_na defunciones {

replace `v' = 0 if `v' == . & aux == 1

}

cap drop aux

foreach v of varlist moda_entidad_um moda_entidad_nac first_covid first_sintomas first_ingreso first_def fecha_med_sintomas fecha_med_ingreso fecha_med_def fecha_moda_sintomas fecha_moda_ingreso fecha_moda_def moda_sintomas_ingreso moda_sintomas_def moda_ingreso_def median_sintomas_ingreso median_sintomas_def median_ingreso_def {
sort code_INEGI `v'
bys code_INEGI: replace `v' = `v'[1]
}

foreach v of varlist moda_pais_nac {
gsort code_INEGI -`v'
cap replace `v' = `v'[1] if `v' == .
cap replace `v' = `v'[1] if `v' == ""
}

replace fecha_actualizacion = "$S_DATE"


sort code_INEGI date


********************************************************************************


*	Save dataset

save "panel_COVID_fixdates.dta", replace
erase "panel.dta"
