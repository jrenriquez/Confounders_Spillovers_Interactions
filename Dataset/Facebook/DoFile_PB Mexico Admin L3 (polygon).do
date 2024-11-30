clear all

forvalues m = 5/6 {
forvalues d = 1/31 {
	
	if `d'<10 {

	cap import delimited "Dataset/Facebook/Movement Range/Movement Range_MEX_gadm_2_2020-0`m'-0`d'.csv", clear 

	if _rc==0 {
		
		cap split external_polygon_id, p(".")
		
		if _rc==0 {

		split external_polygon_id3, p("_")
		rename external_polygon_id2 cve_entidad
		rename external_polygon_id31 cve_mun
		destring cve_entidad, replace
		destring cve_mun, replace

		gen code_INEGI = cve_entidad * 1000 + cve_mun // gen code_INEGI (and not code_INEGI) since some code of them are wrong (do not match INEGI's)

		keep polygon_id polygon_name code_INEGI cve_mun

		save "Dataset/Facebook/Movement Range/aux`m'`d'.dta",replace
	
		}

	}

	}
	
	if `d'>=10 {
	
	cap import delimited "Dataset/Facebook/Movement Range/Movement Range_MEX_gadm_2_2020-0`m'-`d'.csv", clear 

	if _rc==0 {
		
		cap split external_polygon_id, p(".")
		
		if _rc==0 {

		split external_polygon_id3, p("_")
		rename external_polygon_id2 cve_entidad
		rename external_polygon_id31 cve_mun
		destring cve_entidad, replace
		destring cve_mun, replace

		gen code_INEGI = cve_entidad * 1000 + cve_mun

		keep polygon_id polygon_name code_INEGI cve_mun

		save "Dataset/Facebook/Movement Range/aux`m'`d'.dta",replace
	
		}
	
	}

	}
}
}


use "Dataset/Facebook/Movement Range/aux527.dta", clear
forvalues m = 5/6 {
forvalues d = 1/31 {

cap append using "Dataset/Facebook/Movement Range/aux`m'`d'.dta"
}
}

replace polygon_name = "Poncitl-n" if polygon_name == "Lago de Chapala"

duplicates drop

sort code_INEGI
gen cve_edo = trunc(code_INEGI/1000)
gen aux = .
replace aux = 2 if cve_edo == 3 // BC is 2, not 3
replace aux = 3 if cve_edo == 2 // BCS is 3, not 2
replace aux = 5 if cve_edo == 7 // Coah is 5, not 7
replace aux = 6 if cve_edo == 8 // Coah is 5, not 7
replace aux = 7 if cve_edo == 5 // CHIS is 7, not 5
replace aux = 8 if cve_edo == 6 // CHIH is 8, not 6
replace cve_edo = aux if aux != .
replace code_INEGI = cve_edo*1000 + cve_mun
drop cve_mun aux

{

replace code_INEGI = 1001 if polygon_name == "Aguascalientes" & cve_edo == 1
replace code_INEGI = 1002 if polygon_name == "Asientos" & cve_edo == 1
replace code_INEGI = 1003 if polygon_name == "Calvillo" & cve_edo == 1
replace code_INEGI = 1004 if polygon_name == "Cos-o" & cve_edo == 1
replace code_INEGI = 1005 if polygon_name == "Jes-s Mar-a" & cve_edo == 1
replace code_INEGI = 1006 if polygon_name == "Pabell-n de Arteaga" & cve_edo == 1
replace code_INEGI = 1007 if polygon_name == "Rinc-n de Romos" & cve_edo == 1
replace code_INEGI = 1008 if polygon_name == "San Jos- de Gracia" & cve_edo == 1
replace code_INEGI = 1009 if polygon_name == "Tepezal-" & cve_edo == 1
replace code_INEGI = 1010 if polygon_name == "El Llano" & cve_edo == 1
replace code_INEGI = 1011 if polygon_name == "San Francisco de los Romo" & cve_edo == 1

replace code_INEGI = 2001 if polygon_name == "Ensenada" & cve_edo == 2
replace code_INEGI = 2002 if polygon_name == "Mexicali" & cve_edo == 2
replace code_INEGI = 2003 if polygon_name == "Tecate" & cve_edo == 2
replace code_INEGI = 2004 if polygon_name == "Tijuana" & cve_edo == 2
replace code_INEGI = 2005 if polygon_name == "Playas de Rosarito" & cve_edo == 2

replace code_INEGI = 3001 if polygon_name == "Comond-" & cve_edo == 3
replace code_INEGI = 3002 if polygon_name == "Muleg-" & cve_edo == 3
replace code_INEGI = 3003 if polygon_name == "La Paz" & cve_edo == 3
replace code_INEGI = 3008 if polygon_name == "Los Cabos" & cve_edo == 3
replace code_INEGI = 3009 if polygon_name == "Loreto" & cve_edo == 3

replace code_INEGI = 4001 if polygon_name == "Calkin-" & cve_edo == 4
replace code_INEGI = 4002 if polygon_name == "Campeche" & cve_edo == 4
replace code_INEGI = 4003 if polygon_name == "Carmen" & cve_edo == 4
replace code_INEGI = 4004 if polygon_name == "Champot-n" & cve_edo == 4
replace code_INEGI = 4005 if polygon_name == "Hecelchak-n" & cve_edo == 4
replace code_INEGI = 4006 if polygon_name == "Hopelch-n" & cve_edo == 4
replace code_INEGI = 4007 if polygon_name == "Palizada" & cve_edo == 4
replace code_INEGI = 4008 if polygon_name == "Tenabo" & cve_edo == 4
replace code_INEGI = 4009 if polygon_name == "Esc-rcega" & cve_edo == 4
replace code_INEGI = 4010 if polygon_name == "Calakmul" & cve_edo == 4
replace code_INEGI = 4011 if polygon_name == "Candelaria" & cve_edo == 4

replace code_INEGI = 5001 if polygon_name == "Abasolo" & cve_edo == 5
replace code_INEGI = 5002 if polygon_name == "Acu-a" & cve_edo == 5
replace code_INEGI = 5003 if polygon_name == "Allende" & cve_edo == 5
replace code_INEGI = 5004 if polygon_name == "Arteaga" & cve_edo == 5
replace code_INEGI = 5005 if polygon_name == "Candela" & cve_edo == 5
replace code_INEGI = 5006 if polygon_name == "Casta-os" & cve_edo == 5
replace code_INEGI = 5007 if polygon_name == "Cuatro Ci-negas" & cve_edo == 5
replace code_INEGI = 5008 if polygon_name == "Escobedo" & cve_edo == 5
replace code_INEGI = 5009 if polygon_name == "Francisco I. Madero" & cve_edo == 5
replace code_INEGI = 5010 if polygon_name == "Frontera" & cve_edo == 5
replace code_INEGI = 5011 if polygon_name == "General Cepeda" & cve_edo == 5
replace code_INEGI = 5012 if polygon_name == "Guerrero" & cve_edo == 5
replace code_INEGI = 5013 if polygon_name == "Hidalgo" & cve_edo == 5
replace code_INEGI = 5014 if polygon_name == "Jim-nez" & cve_edo == 5
replace code_INEGI = 5015 if polygon_name == "Ju-rez" & cve_edo == 5
replace code_INEGI = 5016 if polygon_name == "Lamadrid" & cve_edo == 5
replace code_INEGI = 5017 if polygon_name == "Matamoros" & cve_edo == 5
replace code_INEGI = 5018 if polygon_name == "Monclova" & cve_edo == 5
replace code_INEGI = 5019 if polygon_name == "Morelos" & cve_edo == 5
replace code_INEGI = 5020 if polygon_name == "M-zquiz" & cve_edo == 5
replace code_INEGI = 5021 if polygon_name == "Nadadores" & cve_edo == 5
replace code_INEGI = 5022 if polygon_name == "Nava" & cve_edo == 5
replace code_INEGI = 5023 if polygon_name == "Ocampo" & cve_edo == 5
replace code_INEGI = 5024 if polygon_name == "Parras" & cve_edo == 5
replace code_INEGI = 5025 if polygon_name == "Piedras Negras" & cve_edo == 5
replace code_INEGI = 5026 if polygon_name == "Progreso" & cve_edo == 5
replace code_INEGI = 5027 if polygon_name == "Ramos Arizpe" & cve_edo == 5
replace code_INEGI = 5028 if polygon_name == "Sabinas" & cve_edo == 5
replace code_INEGI = 5029 if polygon_name == "Sacramento" & cve_edo == 5
replace code_INEGI = 5030 if polygon_name == "Saltillo" & cve_edo == 5
replace code_INEGI = 5031 if polygon_name == "San Buenaventura" & cve_edo == 5
replace code_INEGI = 5032 if polygon_name == "San Juan de Sabinas" & cve_edo == 5
replace code_INEGI = 5033 if polygon_name == "San Pedro" & cve_edo == 5
replace code_INEGI = 5034 if polygon_name == "Sierra Mojada" & cve_edo == 5
replace code_INEGI = 5035 if polygon_name == "Torre-n" & cve_edo == 5
replace code_INEGI = 5036 if polygon_name == "Viesca" & cve_edo == 5
replace code_INEGI = 5037 if polygon_name == "Villa Uni-n" & cve_edo == 5
replace code_INEGI = 5038 if polygon_name == "Zaragoza" & cve_edo == 5

replace code_INEGI = 6001 if polygon_name == "Armer-a" & cve_edo == 6
replace code_INEGI = 6002 if polygon_name == "Colima" & cve_edo == 6
replace code_INEGI = 6003 if polygon_name == "Comala" & cve_edo == 6
replace code_INEGI = 6004 if polygon_name == "Coquimatl-n" & cve_edo == 6
replace code_INEGI = 6005 if polygon_name == "Cuauht-moc" & cve_edo == 6
replace code_INEGI = 6006 if polygon_name == "Ixtlahuac-n" & cve_edo == 6
replace code_INEGI = 6007 if polygon_name == "Manzanillo" & cve_edo == 6
replace code_INEGI = 6008 if polygon_name == "Minatitl-n" & cve_edo == 6
replace code_INEGI = 6009 if polygon_name == "Tecom-n" & cve_edo == 6
replace code_INEGI = 6010 if polygon_name == "Villa de -lvarez" & cve_edo == 6

replace code_INEGI = 7001 if polygon_name == "Acacoyagua" & cve_edo == 7
replace code_INEGI = 7002 if polygon_name == "Acala" & cve_edo == 7
replace code_INEGI = 7003 if polygon_name == "Acapetahua" & cve_edo == 7
replace code_INEGI = 7004 if polygon_name == "Altamirano" & cve_edo == 7
replace code_INEGI = 7005 if polygon_name == "Amat-n" & cve_edo == 7
replace code_INEGI = 7006 if polygon_name == "Amatenango de la Frontera" & cve_edo == 7
replace code_INEGI = 7007 if polygon_name == "Amatenango del Valle" & cve_edo == 7
replace code_INEGI = 7008 if polygon_name == "Angel Albino Corzo" & cve_edo == 7
replace code_INEGI = 7009 if polygon_name == "Arriaga" & cve_edo == 7
replace code_INEGI = 7010 if polygon_name == "Bejucal de Ocampo" & cve_edo == 7
replace code_INEGI = 7011 if polygon_name == "Bella Vista" & cve_edo == 7
replace code_INEGI = 7012 if polygon_name == "Berrioz-bal" & cve_edo == 7
replace code_INEGI = 7013 if polygon_name == "Bochil" & cve_edo == 7
replace code_INEGI = 7014 if polygon_name == "El Bosque" & cve_edo == 7
replace code_INEGI = 7015 if polygon_name == "Cacahoat-n" & cve_edo == 7
replace code_INEGI = 7016 if polygon_name == "Catazaj-" & cve_edo == 7
replace code_INEGI = 7017 if polygon_name == "Cintalapa" & cve_edo == 7
replace code_INEGI = 7018 if polygon_name == "Coapilla" & cve_edo == 7
replace code_INEGI = 7019 if polygon_name == "Comit-n de Dom-nguez" & cve_edo == 7
replace code_INEGI = 7020 if polygon_name == "La Concordia" & cve_edo == 7
replace code_INEGI = 7021 if polygon_name == "Copainal-" & cve_edo == 7
replace code_INEGI = 7022 if polygon_name == "Chalchihuit-n" & cve_edo == 7
replace code_INEGI = 7023 if polygon_name == "Chamula" & cve_edo == 7
replace code_INEGI = 7024 if polygon_name == "Chanal" & cve_edo == 7
replace code_INEGI = 7025 if polygon_name == "Chapultenango" & cve_edo == 7
replace code_INEGI = 7026 if polygon_name == "Chenalh-" & cve_edo == 7
replace code_INEGI = 7027 if polygon_name == "Chiapa de Corzo" & cve_edo == 7
replace code_INEGI = 7028 if polygon_name == "Chiapilla" & cve_edo == 7
replace code_INEGI = 7029 if polygon_name == "Chicoas-n" & cve_edo == 7
replace code_INEGI = 7030 if polygon_name == "Chicomuselo" & cve_edo == 7
replace code_INEGI = 7031 if polygon_name == "Chil-n" & cve_edo == 7
replace code_INEGI = 7032 if polygon_name == "Escuintla" & cve_edo == 7
replace code_INEGI = 7033 if polygon_name == "Francisco Le-n" & cve_edo == 7
replace code_INEGI = 7034 if polygon_name == "Frontera Comalapa" & cve_edo == 7
replace code_INEGI = 7035 if polygon_name == "Frontera Hidalgo" & cve_edo == 7
replace code_INEGI = 7036 if polygon_name == "La Grandeza" & cve_edo == 7
replace code_INEGI = 7037 if polygon_name == "Huehuet-n" & cve_edo == 7
replace code_INEGI = 7038 if polygon_name == "Huixt-n" & cve_edo == 7
replace code_INEGI = 7039 if polygon_name == "Huitiup-n" & cve_edo == 7
replace code_INEGI = 7040 if polygon_name == "Huixtla" & cve_edo == 7
replace code_INEGI = 7041 if polygon_name == "La Independencia" & cve_edo == 7
replace code_INEGI = 7042 if polygon_name == "Ixhuat-n" & cve_edo == 7
replace code_INEGI = 7043 if polygon_name == "Ixtacomit-n" & cve_edo == 7
replace code_INEGI = 7044 if polygon_name == "Ixtapa" & cve_edo == 7
replace code_INEGI = 7045 if polygon_name == "Ixtapangajoya" & cve_edo == 7
replace code_INEGI = 7046 if polygon_name == "Jiquipilas" & cve_edo == 7
replace code_INEGI = 7047 if polygon_name == "Jitotol" & cve_edo == 7
replace code_INEGI = 7048 if polygon_name == "Ju-rez" & cve_edo == 7
replace code_INEGI = 7049 if polygon_name == "Larr-inzar" & cve_edo == 7
replace code_INEGI = 7050 if polygon_name == "La Libertad" & cve_edo == 7
replace code_INEGI = 7051 if polygon_name == "Mapastepec" & cve_edo == 7
replace code_INEGI = 7052 if polygon_name == "Las Margaritas" & cve_edo == 7
replace code_INEGI = 7053 if polygon_name == "Mazapa de Madero" & cve_edo == 7
replace code_INEGI = 7054 if polygon_name == "Mazat-n" & cve_edo == 7
replace code_INEGI = 7055 if polygon_name == "Metapa" & cve_edo == 7
replace code_INEGI = 7056 if polygon_name == "Mitontic" & cve_edo == 7
replace code_INEGI = 7057 if polygon_name == "Motozintla" & cve_edo == 7
replace code_INEGI = 7058 if polygon_name == "Nicol-s Ru-z" & cve_edo == 7
replace code_INEGI = 7059 if polygon_name == "Ocosingo" & cve_edo == 7
replace code_INEGI = 7060 if polygon_name == "Ocotepec" & cve_edo == 7
replace code_INEGI = 7061 if polygon_name == "Ocozocoautla de Espinosa" & cve_edo == 7
replace code_INEGI = 7062 if polygon_name == "Ostuac-n" & cve_edo == 7
replace code_INEGI = 7063 if polygon_name == "Osumacinta" & cve_edo == 7
replace code_INEGI = 7064 if polygon_name == "Oxchuc" & cve_edo == 7
replace code_INEGI = 7065 if polygon_name == "Palenque" & cve_edo == 7
replace code_INEGI = 7066 if polygon_name == "Pantelh-" & cve_edo == 7
replace code_INEGI = 7067 if polygon_name == "Pantepec" & cve_edo == 7
replace code_INEGI = 7068 if polygon_name == "Pichucalco" & cve_edo == 7
replace code_INEGI = 7069 if polygon_name == "Pijijiapan" & cve_edo == 7
replace code_INEGI = 7070 if polygon_name == "El Porvenir" & cve_edo == 7
replace code_INEGI = 7071 if polygon_name == "Villa Comaltitl-n" & cve_edo == 7
replace code_INEGI = 7072 if polygon_name == "Pueblo Nuevo Solistahuac-n" & cve_edo == 7
replace code_INEGI = 7073 if polygon_name == "Ray-n" & cve_edo == 7
replace code_INEGI = 7074 if polygon_name == "Reforma" & cve_edo == 7
replace code_INEGI = 7075 if polygon_name == "Las Rosas" & cve_edo == 7
replace code_INEGI = 7076 if polygon_name == "Sabanilla" & cve_edo == 7
replace code_INEGI = 7077 if polygon_name == "Salto de Agua" & cve_edo == 7
replace code_INEGI = 7078 if polygon_name == "San Crist-bal de las Casas" & cve_edo == 7
replace code_INEGI = 7079 if polygon_name == "San Fernando" & cve_edo == 7
replace code_INEGI = 7080 if polygon_name == "Siltepec" & cve_edo == 7
replace code_INEGI = 7081 if polygon_name == "Simojovel" & cve_edo == 7
replace code_INEGI = 7082 if polygon_name == "Sital-" & cve_edo == 7
replace code_INEGI = 7083 if polygon_name == "Socoltenango" & cve_edo == 7
replace code_INEGI = 7084 if polygon_name == "Solosuchiapa" & cve_edo == 7
replace code_INEGI = 7085 if polygon_name == "Soyal-" & cve_edo == 7
replace code_INEGI = 7086 if polygon_name == "Suchiapa" & cve_edo == 7
replace code_INEGI = 7087 if polygon_name == "Suchiate" & cve_edo == 7
replace code_INEGI = 7088 if polygon_name == "Sunuapa" & cve_edo == 7
replace code_INEGI = 7089 if polygon_name == "Tapachula" & cve_edo == 7
replace code_INEGI = 7090 if polygon_name == "Tapalapa" & cve_edo == 7
replace code_INEGI = 7091 if polygon_name == "Tapilula" & cve_edo == 7
replace code_INEGI = 7092 if polygon_name == "Tecpat-n" & cve_edo == 7
replace code_INEGI = 7093 if polygon_name == "Tenejapa" & cve_edo == 7
replace code_INEGI = 7094 if polygon_name == "Teopisca" & cve_edo == 7
replace code_INEGI = 7096 if polygon_name == "Tila" & cve_edo == 7
replace code_INEGI = 7097 if polygon_name == "Tonal-" & cve_edo == 7
replace code_INEGI = 7098 if polygon_name == "Totolapa" & cve_edo == 7
replace code_INEGI = 7099 if polygon_name == "La Trinitaria" & cve_edo == 7
replace code_INEGI = 7100 if polygon_name == "Tumbal-" & cve_edo == 7
replace code_INEGI = 7101 if polygon_name == "Tuxtla Guti-rrez" & cve_edo == 7
replace code_INEGI = 7102 if polygon_name == "Tuxtla Chico" & cve_edo == 7
replace code_INEGI = 7103 if polygon_name == "Tuzant-n" & cve_edo == 7
replace code_INEGI = 7104 if polygon_name == "Tzimol" & cve_edo == 7
replace code_INEGI = 7105 if polygon_name == "Uni-n Ju-rez" & cve_edo == 7
replace code_INEGI = 7106 if polygon_name == "Venustiano Carranza" & cve_edo == 7
replace code_INEGI = 7107 if polygon_name == "Villa Corzo" & cve_edo == 7
replace code_INEGI = 7108 if polygon_name == "Villaflores" & cve_edo == 7
replace code_INEGI = 7109 if polygon_name == "Yajal-n" & cve_edo == 7
replace code_INEGI = 7110 if polygon_name == "San Lucas" & cve_edo == 7
replace code_INEGI = 7111 if polygon_name == "Zinacant-n" & cve_edo == 7
replace code_INEGI = 7112 if polygon_name == "San Juan Cancuc" & cve_edo == 7
replace code_INEGI = 7113 if polygon_name == "Aldama" & cve_edo == 7
replace code_INEGI = 7114 if polygon_name == "Benem-rito de las Am-ricas" & cve_edo == 7
replace code_INEGI = 7115 if polygon_name == "Maravilla Tenejapa" & cve_edo == 7
replace code_INEGI = 7116 if polygon_name == "Marqu-s de Comillas" & cve_edo == 7
replace code_INEGI = 7117 if polygon_name == "Montecristo de Guerrero" & cve_edo == 7
replace code_INEGI = 7118 if polygon_name == "San Andr-s Duraznal" & cve_edo == 7
replace code_INEGI = 7119 if polygon_name == "Santiago el Pinar" & cve_edo == 7
replace code_INEGI = 7120 if polygon_name == "Capit-n Luis -ngel Vidal" & cve_edo == 7
replace code_INEGI = 7121 if polygon_name == "Rinc-n Chamula San Pedro" & cve_edo == 7
replace code_INEGI = 7122 if polygon_name == "El Parral" & cve_edo == 7
replace code_INEGI = 7123 if polygon_name == "Emiliano Zapata" & cve_edo == 7
replace code_INEGI = 7124 if polygon_name == "Mezcalapa" & cve_edo == 7

replace code_INEGI = 8001 if polygon_name == "Ahumada" & cve_edo == 8
replace code_INEGI = 8002 if polygon_name == "Aldama" & cve_edo == 8
replace code_INEGI = 8003 if polygon_name == "Allende" & cve_edo == 8
replace code_INEGI = 8004 if polygon_name == "Aquiles Serd-n" & cve_edo == 8
replace code_INEGI = 8005 if polygon_name == "Ascensi-n" & cve_edo == 8
replace code_INEGI = 8006 if polygon_name == "Bach-niva" & cve_edo == 8
replace code_INEGI = 8007 if polygon_name == "Balleza" & cve_edo == 8
replace code_INEGI = 8008 if polygon_name == "Batopilas de Manuel G-mez Mor-n" & cve_edo == 8
replace code_INEGI = 8009 if polygon_name == "Bocoyna" & cve_edo == 8
replace code_INEGI = 8010 if polygon_name == "Buenaventura" & cve_edo == 8
replace code_INEGI = 8011 if polygon_name == "Camargo" & cve_edo == 8
replace code_INEGI = 8012 if polygon_name == "Carich-" & cve_edo == 8
replace code_INEGI = 8013 if polygon_name == "Casas Grandes" & cve_edo == 8
replace code_INEGI = 8014 if polygon_name == "Coronado" & cve_edo == 8
replace code_INEGI = 8015 if polygon_name == "Coyame del Sotol" & cve_edo == 8
replace code_INEGI = 8016 if polygon_name == "La Cruz" & cve_edo == 8
replace code_INEGI = 8017 if polygon_name == "Cuauht-moc" & cve_edo == 8
replace code_INEGI = 8018 if polygon_name == "Cusihuiriachi" & cve_edo == 8
replace code_INEGI = 8019 if polygon_name == "Chihuahua" & cve_edo == 8
replace code_INEGI = 8020 if polygon_name == "Ch-nipas" & cve_edo == 8
replace code_INEGI = 8021 if polygon_name == "Delicias" & cve_edo == 8
replace code_INEGI = 8022 if polygon_name == "Dr. Belisario Dom-nguez" & cve_edo == 8
replace code_INEGI = 8023 if polygon_name == "Galeana" & cve_edo == 8
replace code_INEGI = 8024 if polygon_name == "Santa Isabel" & cve_edo == 8
replace code_INEGI = 8025 if polygon_name == "G-mez Far-as" & cve_edo == 8
replace code_INEGI = 8026 if polygon_name == "Gran Morelos" & cve_edo == 8
replace code_INEGI = 8027 if polygon_name == "Guachochi" & cve_edo == 8
replace code_INEGI = 8028 if polygon_name == "Guadalupe" & cve_edo == 8
replace code_INEGI = 8029 if polygon_name == "Guadalupe y Calvo" & cve_edo == 8
replace code_INEGI = 8030 if polygon_name == "Guazapares" & cve_edo == 8
replace code_INEGI = 8031 if polygon_name == "Guerrero" & cve_edo == 8
replace code_INEGI = 8032 if polygon_name == "Hidalgo del Parral" & cve_edo == 8
replace code_INEGI = 8033 if polygon_name == "Huejotit-n" & cve_edo == 8
replace code_INEGI = 8034 if polygon_name == "Ignacio Zaragoza" & cve_edo == 8
replace code_INEGI = 8035 if polygon_name == "Janos" & cve_edo == 8
replace code_INEGI = 8036 if polygon_name == "Jim-nez" & cve_edo == 8
replace code_INEGI = 8037 if polygon_name == "Ju-rez" & cve_edo == 8
replace code_INEGI = 8038 if polygon_name == "Julimes" & cve_edo == 8
replace code_INEGI = 8039 if polygon_name == "L-pez" & cve_edo == 8
replace code_INEGI = 8040 if polygon_name == "Madera" & cve_edo == 8
replace code_INEGI = 8041 if polygon_name == "Maguarichi" & cve_edo == 8
replace code_INEGI = 8042 if polygon_name == "Manuel Benavides" & cve_edo == 8
replace code_INEGI = 8043 if polygon_name == "Matach-" & cve_edo == 8
replace code_INEGI = 8044 if polygon_name == "Matamoros" & cve_edo == 8
replace code_INEGI = 8045 if polygon_name == "Meoqui" & cve_edo == 8
replace code_INEGI = 8046 if polygon_name == "Morelos" & cve_edo == 8
replace code_INEGI = 8047 if polygon_name == "Moris" & cve_edo == 8
replace code_INEGI = 8048 if polygon_name == "Namiquipa" & cve_edo == 8
replace code_INEGI = 8049 if polygon_name == "Nonoava" & cve_edo == 8
replace code_INEGI = 8050 if polygon_name == "Nuevo Casas Grandes" & cve_edo == 8
replace code_INEGI = 8051 if polygon_name == "Ocampo" & cve_edo == 8
replace code_INEGI = 8052 if polygon_name == "Ojinaga" & cve_edo == 8
replace code_INEGI = 8053 if polygon_name == "Praxedis G. Guerrero" & cve_edo == 8
replace code_INEGI = 8054 if polygon_name == "Riva Palacio" & cve_edo == 8
replace code_INEGI = 8055 if polygon_name == "Rosales" & cve_edo == 8
replace code_INEGI = 8056 if polygon_name == "Rosario" & cve_edo == 8
replace code_INEGI = 8057 if polygon_name == "San Francisco de Borja" & cve_edo == 8
replace code_INEGI = 8058 if polygon_name == "San Francisco de Conchos" & cve_edo == 8
replace code_INEGI = 8059 if polygon_name == "San Francisco del Oro" & cve_edo == 8
replace code_INEGI = 8060 if polygon_name == "Santa B-rbara" & cve_edo == 8
replace code_INEGI = 8061 if polygon_name == "Satev-" & cve_edo == 8
replace code_INEGI = 8062 if polygon_name == "Saucillo" & cve_edo == 8
replace code_INEGI = 8063 if polygon_name == "Tem-sachic" & cve_edo == 8
replace code_INEGI = 8064 if polygon_name == "El Tule" & cve_edo == 8
replace code_INEGI = 8065 if polygon_name == "Urique" & cve_edo == 8
replace code_INEGI = 8066 if polygon_name == "Uruachi" & cve_edo == 8
replace code_INEGI = 8067 if polygon_name == "Valle de Zaragoza" & cve_edo == 8

replace code_INEGI = 9002 if polygon_name == "Azcapotzalco" & cve_edo == 9
replace code_INEGI = 9003 if polygon_name == "Coyoac-n" & cve_edo == 9
replace code_INEGI = 9004 if polygon_name == "Cuajimalpa de Morelos" & cve_edo == 9
replace code_INEGI = 9005 if polygon_name == "Gustavo A. Madero" & cve_edo == 9
replace code_INEGI = 9006 if polygon_name == "Iztacalco" & cve_edo == 9
replace code_INEGI = 9007 if polygon_name == "Iztapalapa" & cve_edo == 9
replace code_INEGI = 9008 if polygon_name == "La Magdalena Contreras" & cve_edo == 9 | polygon_name == "Magdalena Contreras" & cve_edo == 9
replace code_INEGI = 9009 if polygon_name == "Milpa Alta" & cve_edo == 9
replace code_INEGI = 9010 if polygon_name == "-lvaro Obreg-n" & cve_edo == 9 | polygon_name == "Alvaro Obreg-n" & cve_edo == 9
replace code_INEGI = 9011 if polygon_name == "Tl-huac" & cve_edo == 9
replace code_INEGI = 9012 if polygon_name == "Tlalpan" & cve_edo == 9
replace code_INEGI = 9013 if polygon_name == "Xochimilco" & cve_edo == 9
replace code_INEGI = 9014 if polygon_name == "Benito Ju-rez" & cve_edo == 9
replace code_INEGI = 9015 if polygon_name == "Cuauht-moc" & cve_edo == 9
replace code_INEGI = 9016 if polygon_name == "Miguel Hidalgo" & cve_edo == 9
replace code_INEGI = 9017 if polygon_name == "Venustiano Carranza" & cve_edo == 9

replace code_INEGI = 10001 if polygon_name == "Canatl-n" & cve_edo == 10
replace code_INEGI = 10002 if polygon_name == "Canelas" & cve_edo == 10
replace code_INEGI = 10003 if polygon_name == "Coneto de Comonfort" & cve_edo == 10
replace code_INEGI = 10004 if polygon_name == "Cuencam-" & cve_edo == 10
replace code_INEGI = 10005 if polygon_name == "Durango" & cve_edo == 10
replace code_INEGI = 10006 if polygon_name == "General Sim-n Bol-var" & cve_edo == 10
replace code_INEGI = 10007 if polygon_name == "G-mez Palacio" & cve_edo == 10
replace code_INEGI = 10008 if polygon_name == "Guadalupe Victoria" & cve_edo == 10
replace code_INEGI = 10009 if polygon_name == "Guanacev-" & cve_edo == 10
replace code_INEGI = 10010 if polygon_name == "Hidalgo" & cve_edo == 10
replace code_INEGI = 10011 if polygon_name == "Ind-" & cve_edo == 10
replace code_INEGI = 10012 if polygon_name == "Lerdo" & cve_edo == 10
replace code_INEGI = 10013 if polygon_name == "Mapim-" & cve_edo == 10
replace code_INEGI = 10014 if polygon_name == "Mezquital" & cve_edo == 10
replace code_INEGI = 10015 if polygon_name == "Nazas" & cve_edo == 10
replace code_INEGI = 10016 if polygon_name == "Nombre de Dios" & cve_edo == 10
replace code_INEGI = 10017 if polygon_name == "Ocampo" & cve_edo == 10
replace code_INEGI = 10018 if polygon_name == "El Oro" & cve_edo == 10
replace code_INEGI = 10019 if polygon_name == "Ot-ez" & cve_edo == 10
replace code_INEGI = 10020 if polygon_name == "P-nuco de Coronado" & cve_edo == 10
replace code_INEGI = 10021 if polygon_name == "Pe--n Blanco" & cve_edo == 10
replace code_INEGI = 10022 if polygon_name == "Poanas" & cve_edo == 10
replace code_INEGI = 10023 if polygon_name == "Pueblo Nuevo" & cve_edo == 10
replace code_INEGI = 10024 if polygon_name == "Rodeo" & cve_edo == 10
replace code_INEGI = 10025 if polygon_name == "San Bernardo" & cve_edo == 10
replace code_INEGI = 10026 if polygon_name == "San Dimas" & cve_edo == 10
replace code_INEGI = 10027 if polygon_name == "San Juan de Guadalupe" & cve_edo == 10
replace code_INEGI = 10028 if polygon_name == "San Juan del R-o" & cve_edo == 10
replace code_INEGI = 10029 if polygon_name == "San Luis del Cordero" & cve_edo == 10
replace code_INEGI = 10030 if polygon_name == "San Pedro del Gallo" & cve_edo == 10
replace code_INEGI = 10031 if polygon_name == "Santa Clara" & cve_edo == 10
replace code_INEGI = 10032 if polygon_name == "Santiago Papasquiaro" & cve_edo == 10
replace code_INEGI = 10033 if polygon_name == "S-chil" & cve_edo == 10
replace code_INEGI = 10034 if polygon_name == "Tamazula" & cve_edo == 10
replace code_INEGI = 10035 if polygon_name == "Tepehuanes" & cve_edo == 10
replace code_INEGI = 10036 if polygon_name == "Tlahualilo" & cve_edo == 10
replace code_INEGI = 10037 if polygon_name == "Topia" & cve_edo == 10
replace code_INEGI = 10038 if polygon_name == "Vicente Guerrero" & cve_edo == 10
replace code_INEGI = 10039 if polygon_name == "Nuevo Ideal" & cve_edo == 10

replace code_INEGI = 11001 if polygon_name == "Abasolo" & cve_edo == 11
replace code_INEGI = 11002 if polygon_name == "Ac-mbaro" & cve_edo == 11
replace code_INEGI = 11003 if polygon_name == "San Miguel de Allende" & cve_edo == 11
replace code_INEGI = 11004 if polygon_name == "Apaseo el Alto" & cve_edo == 11
replace code_INEGI = 11005 if polygon_name == "Apaseo el Grande" & cve_edo == 11
replace code_INEGI = 11006 if polygon_name == "Atarjea" & cve_edo == 11
replace code_INEGI = 11007 if polygon_name == "Celaya" & cve_edo == 11
replace code_INEGI = 11008 if polygon_name == "Manuel Doblado" & cve_edo == 11
replace code_INEGI = 11009 if polygon_name == "Comonfort" & cve_edo == 11
replace code_INEGI = 11010 if polygon_name == "Coroneo" & cve_edo == 11
replace code_INEGI = 11011 if polygon_name == "Cortazar" & cve_edo == 11
replace code_INEGI = 11012 if polygon_name == "Cuer-maro" & cve_edo == 11
replace code_INEGI = 11013 if polygon_name == "Doctor Mora" & cve_edo == 11
replace code_INEGI = 11014 if polygon_name == "Dolores Hidalgo Cuna de la Independencia Nacional" & cve_edo == 11 | polygon_name == "Dolores Hidalgo" & cve_edo == 11
replace code_INEGI = 11015 if polygon_name == "Guanajuato" & cve_edo == 11
replace code_INEGI = 11016 if polygon_name == "Huan-maro" & cve_edo == 11
replace code_INEGI = 11017 if polygon_name == "Irapuato" & cve_edo == 11
replace code_INEGI = 11018 if polygon_name == "Jaral del Progreso" & cve_edo == 11
replace code_INEGI = 11019 if polygon_name == "Jer-cuaro" & cve_edo == 11
replace code_INEGI = 11020 if polygon_name == "Le-n" & cve_edo == 11
replace code_INEGI = 11021 if polygon_name == "Morole-n" & cve_edo == 11
replace code_INEGI = 11022 if polygon_name == "Ocampo" & cve_edo == 11
replace code_INEGI = 11023 if polygon_name == "P-njamo" & cve_edo == 11
replace code_INEGI = 11024 if polygon_name == "Pueblo Nuevo" & cve_edo == 11
replace code_INEGI = 11025 if polygon_name == "Pur-sima del Rinc-n" & cve_edo == 11
replace code_INEGI = 11026 if polygon_name == "Romita" & cve_edo == 11
replace code_INEGI = 11027 if polygon_name == "Salamanca" & cve_edo == 11
replace code_INEGI = 11028 if polygon_name == "Salvatierra" & cve_edo == 11
replace code_INEGI = 11029 if polygon_name == "San Diego de la Uni-n" & cve_edo == 11
replace code_INEGI = 11030 if polygon_name == "San Felipe" & cve_edo == 11
replace code_INEGI = 11031 if polygon_name == "San Francisco del Rinc-n" & cve_edo == 11
replace code_INEGI = 11032 if polygon_name == "San Jos- Iturbide" & cve_edo == 11
replace code_INEGI = 11033 if polygon_name == "San Luis de la Paz" & cve_edo == 11
replace code_INEGI = 11034 if polygon_name == "Santa Catarina" & cve_edo == 11
replace code_INEGI = 11035 if polygon_name == "Santa Cruz de Juventino Rosas" & cve_edo == 11
replace code_INEGI = 11036 if polygon_name == "Santiago Maravat-o" & cve_edo == 11
replace code_INEGI = 11037 if polygon_name == "Silao de la Victoria" & cve_edo == 11
replace code_INEGI = 11038 if polygon_name == "Tarandacuao" & cve_edo == 11
replace code_INEGI = 11039 if polygon_name == "Tarimoro" & cve_edo == 11
replace code_INEGI = 11040 if polygon_name == "Tierra Blanca" & cve_edo == 11
replace code_INEGI = 11041 if polygon_name == "Uriangato" & cve_edo == 11
replace code_INEGI = 11042 if polygon_name == "Valle de Santiago" & cve_edo == 11
replace code_INEGI = 11043 if polygon_name == "Victoria" & cve_edo == 11
replace code_INEGI = 11044 if polygon_name == "Villagr-n" & cve_edo == 11
replace code_INEGI = 11045 if polygon_name == "Xich-" & cve_edo == 11
replace code_INEGI = 11046 if polygon_name == "Yuriria" & cve_edo == 11

replace code_INEGI = 12001 if polygon_name == "Acapulco de Ju-rez" & cve_edo == 12
replace code_INEGI = 12002 if polygon_name == "Ahuacuotzingo" & cve_edo == 12
replace code_INEGI = 12003 if polygon_name == "Ajuchitl-n del Progreso" & cve_edo == 12
replace code_INEGI = 12004 if polygon_name == "Alcozauca de Guerrero" & cve_edo == 12
replace code_INEGI = 12005 if polygon_name == "Alpoyeca" & cve_edo == 12
replace code_INEGI = 12006 if polygon_name == "Apaxtla" & cve_edo == 12
replace code_INEGI = 12007 if polygon_name == "Arcelia" & cve_edo == 12
replace code_INEGI = 12008 if polygon_name == "Atenango del R-o" & cve_edo == 12
replace code_INEGI = 12009 if polygon_name == "Atlamajalcingo del Monte" & cve_edo == 12
replace code_INEGI = 12010 if polygon_name == "Atlixtac" & cve_edo == 12
replace code_INEGI = 12011 if polygon_name == "Atoyac de -lvarez" & cve_edo == 12
replace code_INEGI = 12012 if polygon_name == "Ayutla de los Libres" & cve_edo == 12
replace code_INEGI = 12013 if polygon_name == "Azoy-" & cve_edo == 12
replace code_INEGI = 12014 if polygon_name == "Benito Ju-rez" & cve_edo == 12
replace code_INEGI = 12015 if polygon_name == "Buenavista de Cu-llar" & cve_edo == 12
replace code_INEGI = 12016 if polygon_name == "Coahuayutla de Jos- Mar-a Izazaga" & cve_edo == 12
replace code_INEGI = 12017 if polygon_name == "Cocula" & cve_edo == 12
replace code_INEGI = 12018 if polygon_name == "Copala" & cve_edo == 12
replace code_INEGI = 12019 if polygon_name == "Copalillo" & cve_edo == 12
replace code_INEGI = 12020 if polygon_name == "Copanatoyac" & cve_edo == 12
replace code_INEGI = 12021 if polygon_name == "Coyuca de Ben-tez" & cve_edo == 12
replace code_INEGI = 12022 if polygon_name == "Coyuca de Catal-n" & cve_edo == 12
replace code_INEGI = 12023 if polygon_name == "Cuajinicuilapa" & cve_edo == 12
replace code_INEGI = 12024 if polygon_name == "Cual-c" & cve_edo == 12
replace code_INEGI = 12025 if polygon_name == "Cuautepec" & cve_edo == 12
replace code_INEGI = 12026 if polygon_name == "Cuetzala del Progreso" & cve_edo == 12
replace code_INEGI = 12027 if polygon_name == "Cutzamala de Pinz-n" & cve_edo == 12
replace code_INEGI = 12028 if polygon_name == "Chilapa de -lvarez" & cve_edo == 12
replace code_INEGI = 12029 if polygon_name == "Chilpancingo de los Bravo" & cve_edo == 12
replace code_INEGI = 12030 if polygon_name == "Florencio Villarreal" & cve_edo == 12
replace code_INEGI = 12031 if polygon_name == "General Canuto A. Neri" & cve_edo == 12
replace code_INEGI = 12032 if polygon_name == "General Heliodoro Castillo" & cve_edo == 12
replace code_INEGI = 12033 if polygon_name == "Huamuxtitl-n" & cve_edo == 12
replace code_INEGI = 12034 if polygon_name == "Huitzuco de los Figueroa" & cve_edo == 12
replace code_INEGI = 12035 if polygon_name == "Iguala de la Independencia" & cve_edo == 12
replace code_INEGI = 12036 if polygon_name == "Igualapa" & cve_edo == 12
replace code_INEGI = 12037 if polygon_name == "Ixcateopan de Cuauht-moc" & cve_edo == 12
replace code_INEGI = 12038 if polygon_name == "Zihuatanejo de Azueta" & cve_edo == 12
replace code_INEGI = 12039 if polygon_name == "Juan R. Escudero" & cve_edo == 12
replace code_INEGI = 12040 if polygon_name == "Leonardo Bravo" & cve_edo == 12
replace code_INEGI = 12041 if polygon_name == "Malinaltepec" & cve_edo == 12
replace code_INEGI = 12042 if polygon_name == "M-rtir de Cuilapan" & cve_edo == 12
replace code_INEGI = 12043 if polygon_name == "Metlat-noc" & cve_edo == 12
replace code_INEGI = 12044 if polygon_name == "Mochitl-n" & cve_edo == 12
replace code_INEGI = 12045 if polygon_name == "Olinal-" & cve_edo == 12
replace code_INEGI = 12046 if polygon_name == "Ometepec" & cve_edo == 12
replace code_INEGI = 12047 if polygon_name == "Pedro Ascencio Alquisiras" & cve_edo == 12
replace code_INEGI = 12048 if polygon_name == "Petatl-n" & cve_edo == 12
replace code_INEGI = 12049 if polygon_name == "Pilcaya" & cve_edo == 12
replace code_INEGI = 12050 if polygon_name == "Pungarabato" & cve_edo == 12
replace code_INEGI = 12051 if polygon_name == "Quechultenango" & cve_edo == 12
replace code_INEGI = 12052 if polygon_name == "San Luis Acatl-n" & cve_edo == 12
replace code_INEGI = 12053 if polygon_name == "San Marcos" & cve_edo == 12
replace code_INEGI = 12054 if polygon_name == "San Miguel Totolapan" & cve_edo == 12
replace code_INEGI = 12055 if polygon_name == "Taxco de Alarc-n" & cve_edo == 12
replace code_INEGI = 12056 if polygon_name == "Tecoanapa" & cve_edo == 12
replace code_INEGI = 12057 if polygon_name == "T-cpan de Galeana" & cve_edo == 12
replace code_INEGI = 12058 if polygon_name == "Teloloapan" & cve_edo == 12
replace code_INEGI = 12059 if polygon_name == "Tepecoacuilco de Trujano" & cve_edo == 12
replace code_INEGI = 12060 if polygon_name == "Tetipac" & cve_edo == 12
replace code_INEGI = 12061 if polygon_name == "Tixtla de Guerrero" & cve_edo == 12
replace code_INEGI = 12062 if polygon_name == "Tlacoachistlahuaca" & cve_edo == 12
replace code_INEGI = 12063 if polygon_name == "Tlacoapa" & cve_edo == 12
replace code_INEGI = 12064 if polygon_name == "Tlalchapa" & cve_edo == 12
replace code_INEGI = 12065 if polygon_name == "Tlalixtaquilla de Maldonado" & cve_edo == 12
replace code_INEGI = 12066 if polygon_name == "Tlapa de Comonfort" & cve_edo == 12
replace code_INEGI = 12067 if polygon_name == "Tlapehuala" & cve_edo == 12
replace code_INEGI = 12068 if polygon_name == "La Uni-n de Isidoro Montes de Oca" & cve_edo == 12
replace code_INEGI = 12069 if polygon_name == "Xalpatl-huac" & cve_edo == 12
replace code_INEGI = 12070 if polygon_name == "Xochihuehuetl-n" & cve_edo == 12
replace code_INEGI = 12071 if polygon_name == "Xochistlahuaca" & cve_edo == 12
replace code_INEGI = 12072 if polygon_name == "Zapotitl-n Tablas" & cve_edo == 12
replace code_INEGI = 12073 if polygon_name == "Zir-ndaro" & cve_edo == 12
replace code_INEGI = 12074 if polygon_name == "Zitlala" & cve_edo == 12
replace code_INEGI = 12075 if polygon_name == "Eduardo Neri" & cve_edo == 12
replace code_INEGI = 12076 if polygon_name == "Acatepec" & cve_edo == 12
replace code_INEGI = 12077 if polygon_name == "Marquelia" & cve_edo == 12
replace code_INEGI = 12078 if polygon_name == "Cochoapa el Grande" & cve_edo == 12
replace code_INEGI = 12079 if polygon_name == "Jos- Joaqu-n de Herrera" & cve_edo == 12
replace code_INEGI = 12080 if polygon_name == "Juchit-n" & cve_edo == 12
replace code_INEGI = 12081 if polygon_name == "Iliatenco" & cve_edo == 12

replace code_INEGI = 13001 if polygon_name == "Acatl-n" & cve_edo == 13
replace code_INEGI = 13002 if polygon_name == "Acaxochitl-n" & cve_edo == 13
replace code_INEGI = 13003 if polygon_name == "Actopan" & cve_edo == 13
replace code_INEGI = 13004 if polygon_name == "Agua Blanca de Iturbide" & cve_edo == 13
replace code_INEGI = 13005 if polygon_name == "Ajacuba" & cve_edo == 13
replace code_INEGI = 13006 if polygon_name == "Alfajayucan" & cve_edo == 13
replace code_INEGI = 13007 if polygon_name == "Almoloya" & cve_edo == 13
replace code_INEGI = 13008 if polygon_name == "Apan" & cve_edo == 13
replace code_INEGI = 13009 if polygon_name == "El Arenal" & cve_edo == 13
replace code_INEGI = 13010 if polygon_name == "Atitalaquia" & cve_edo == 13
replace code_INEGI = 13011 if polygon_name == "Atlapexco" & cve_edo == 13
replace code_INEGI = 13012 if polygon_name == "Atotonilco el Grande" & cve_edo == 13
replace code_INEGI = 13013 if polygon_name == "Atotonilco de Tula" & cve_edo == 13
replace code_INEGI = 13014 if polygon_name == "Calnali" & cve_edo == 13
replace code_INEGI = 13015 if polygon_name == "Cardonal" & cve_edo == 13
replace code_INEGI = 13016 if polygon_name == "Cuautepec de Hinojosa" & cve_edo == 13
replace code_INEGI = 13017 if polygon_name == "Chapantongo" & cve_edo == 13
replace code_INEGI = 13018 if polygon_name == "Chapulhuac-n" & cve_edo == 13
replace code_INEGI = 13019 if polygon_name == "Chilcuautla" & cve_edo == 13
replace code_INEGI = 13020 if polygon_name == "Eloxochitl-n" & cve_edo == 13
replace code_INEGI = 13021 if polygon_name == "Emiliano Zapata" & cve_edo == 13
replace code_INEGI = 13022 if polygon_name == "Epazoyucan" & cve_edo == 13
replace code_INEGI = 13023 if polygon_name == "Francisco I. Madero" & cve_edo == 13
replace code_INEGI = 13024 if polygon_name == "Huasca de Ocampo" & cve_edo == 13
replace code_INEGI = 13025 if polygon_name == "Huautla" & cve_edo == 13
replace code_INEGI = 13026 if polygon_name == "Huazalingo" & cve_edo == 13
replace code_INEGI = 13027 if polygon_name == "Huehuetla" & cve_edo == 13
replace code_INEGI = 13028 if polygon_name == "Huejutla de Reyes" & cve_edo == 13
replace code_INEGI = 13029 if polygon_name == "Huichapan" & cve_edo == 13
replace code_INEGI = 13030 if polygon_name == "Ixmiquilpan" & cve_edo == 13
replace code_INEGI = 13031 if polygon_name == "Jacala de Ledezma" & cve_edo == 13
replace code_INEGI = 13032 if polygon_name == "Jaltoc-n" & cve_edo == 13
replace code_INEGI = 13033 if polygon_name == "Ju-rez Hidalgo" & cve_edo == 13
replace code_INEGI = 13034 if polygon_name == "Lolotla" & cve_edo == 13
replace code_INEGI = 13035 if polygon_name == "Metepec" & cve_edo == 13
replace code_INEGI = 13036 if polygon_name == "San Agust-n Metzquititl-n" & cve_edo == 13
replace code_INEGI = 13037 if polygon_name == "Metztitl-n" & cve_edo == 13
replace code_INEGI = 13038 if polygon_name == "Mineral del Chico" & cve_edo == 13
replace code_INEGI = 13039 if polygon_name == "Mineral del Monte" & cve_edo == 13
replace code_INEGI = 13040 if polygon_name == "La Misi-n" & cve_edo == 13
replace code_INEGI = 13041 if polygon_name == "Mixquiahuala de Ju-rez" & cve_edo == 13
replace code_INEGI = 13042 if polygon_name == "Molango de Escamilla" & cve_edo == 13
replace code_INEGI = 13043 if polygon_name == "Nicol-s Flores" & cve_edo == 13
replace code_INEGI = 13044 if polygon_name == "Nopala de Villagr-n" & cve_edo == 13
replace code_INEGI = 13045 if polygon_name == "Omitl-n de Ju-rez" & cve_edo == 13
replace code_INEGI = 13046 if polygon_name == "San Felipe Orizatl-n" & cve_edo == 13
replace code_INEGI = 13047 if polygon_name == "Pacula" & cve_edo == 13
replace code_INEGI = 13048 if polygon_name == "Pachuca de Soto" & cve_edo == 13
replace code_INEGI = 13049 if polygon_name == "Pisaflores" & cve_edo == 13
replace code_INEGI = 13050 if polygon_name == "Progreso de Obreg-n" & cve_edo == 13
replace code_INEGI = 13051 if polygon_name == "Mineral de la Reforma" & cve_edo == 13
replace code_INEGI = 13052 if polygon_name == "San Agust-n Tlaxiaca" & cve_edo == 13
replace code_INEGI = 13053 if polygon_name == "San Bartolo Tutotepec" & cve_edo == 13
replace code_INEGI = 13054 if polygon_name == "San Salvador" & cve_edo == 13
replace code_INEGI = 13055 if polygon_name == "Santiago de Anaya" & cve_edo == 13
replace code_INEGI = 13056 if polygon_name == "Santiago Tulantepec de Lugo Guerrero" & cve_edo == 13
replace code_INEGI = 13057 if polygon_name == "Singuilucan" & cve_edo == 13
replace code_INEGI = 13058 if polygon_name == "Tasquillo" & cve_edo == 13
replace code_INEGI = 13059 if polygon_name == "Tecozautla" & cve_edo == 13
replace code_INEGI = 13060 if polygon_name == "Tenango de Doria" & cve_edo == 13
replace code_INEGI = 13061 if polygon_name == "Tepeapulco" & cve_edo == 13
replace code_INEGI = 13062 if polygon_name == "Tepehuac-n de Guerrero" & cve_edo == 13
replace code_INEGI = 13063 if polygon_name == "Tepeji del R-o de Ocampo" & cve_edo == 13
replace code_INEGI = 13064 if polygon_name == "Tepetitl-n" & cve_edo == 13
replace code_INEGI = 13065 if polygon_name == "Tetepango" & cve_edo == 13
replace code_INEGI = 13066 if polygon_name == "Villa de Tezontepec" & cve_edo == 13
replace code_INEGI = 13067 if polygon_name == "Tezontepec de Aldama" & cve_edo == 13
replace code_INEGI = 13068 if polygon_name == "Tianguistengo" & cve_edo == 13
replace code_INEGI = 13069 if polygon_name == "Tizayuca" & cve_edo == 13
replace code_INEGI = 13070 if polygon_name == "Tlahuelilpan" & cve_edo == 13
replace code_INEGI = 13071 if polygon_name == "Tlahuiltepa" & cve_edo == 13
replace code_INEGI = 13072 if polygon_name == "Tlanalapa" & cve_edo == 13
replace code_INEGI = 13073 if polygon_name == "Tlanchinol" & cve_edo == 13
replace code_INEGI = 13074 if polygon_name == "Tlaxcoapan" & cve_edo == 13
replace code_INEGI = 13075 if polygon_name == "Tolcayuca" & cve_edo == 13
replace code_INEGI = 13076 if polygon_name == "Tula de Allende" & cve_edo == 13
replace code_INEGI = 13077 if polygon_name == "Tulancingo de Bravo" & cve_edo == 13
replace code_INEGI = 13078 if polygon_name == "Xochiatipan" & cve_edo == 13
replace code_INEGI = 13079 if polygon_name == "Xochicoatl-n" & cve_edo == 13
replace code_INEGI = 13080 if polygon_name == "Yahualica" & cve_edo == 13
replace code_INEGI = 13081 if polygon_name == "Zacualtip-n de -ngeles" & cve_edo == 13
replace code_INEGI = 13082 if polygon_name == "Zapotl-n de Ju-rez" & cve_edo == 13
replace code_INEGI = 13083 if polygon_name == "Zempoala" & cve_edo == 13
replace code_INEGI = 13084 if polygon_name == "Zimap-n" & cve_edo == 13

replace code_INEGI = 14001 if polygon_name == "Acatic" & cve_edo == 14
replace code_INEGI = 14002 if polygon_name == "Acatl-n de Ju-rez" & cve_edo == 14
replace code_INEGI = 14003 if polygon_name == "Ahualulco de Mercado" & cve_edo == 14
replace code_INEGI = 14004 if polygon_name == "Amacueca" & cve_edo == 14
replace code_INEGI = 14005 if polygon_name == "Amatit-n" & cve_edo == 14
replace code_INEGI = 14006 if polygon_name == "Ameca" & cve_edo == 14
replace code_INEGI = 14007 if polygon_name == "San Juanito de Escobedo" & cve_edo == 14
replace code_INEGI = 14008 if polygon_name == "Arandas" & cve_edo == 14
replace code_INEGI = 14009 if polygon_name == "El Arenal" & cve_edo == 14
replace code_INEGI = 14010 if polygon_name == "Atemajac de Brizuela" & cve_edo == 14
replace code_INEGI = 14011 if polygon_name == "Atengo" & cve_edo == 14
replace code_INEGI = 14012 if polygon_name == "Atenguillo" & cve_edo == 14
replace code_INEGI = 14013 if polygon_name == "Atotonilco el Alto" & cve_edo == 14
replace code_INEGI = 14014 if polygon_name == "Atoyac" & cve_edo == 14
replace code_INEGI = 14015 if polygon_name == "Autl-n de Navarro" & cve_edo == 14
replace code_INEGI = 14016 if polygon_name == "Ayotl-n" & cve_edo == 14
replace code_INEGI = 14017 if polygon_name == "Ayutla" & cve_edo == 14
replace code_INEGI = 14018 if polygon_name == "La Barca" & cve_edo == 14
replace code_INEGI = 14019 if polygon_name == "Bola-os" & cve_edo == 14
replace code_INEGI = 14020 if polygon_name == "Cabo Corrientes" & cve_edo == 14
replace code_INEGI = 14021 if polygon_name == "Casimiro Castillo" & cve_edo == 14
replace code_INEGI = 14022 if polygon_name == "Cihuatl-n" & cve_edo == 14
replace code_INEGI = 14023 if polygon_name == "Zapotl-n el Grande" & cve_edo == 14
replace code_INEGI = 14024 if polygon_name == "Cocula" & cve_edo == 14
replace code_INEGI = 14025 if polygon_name == "Colotl-n" & cve_edo == 14
replace code_INEGI = 14026 if polygon_name == "Concepci-n de Buenos Aires" & cve_edo == 14
replace code_INEGI = 14027 if polygon_name == "Cuautitl-n de Garc-a Barrag-n" & cve_edo == 14
replace code_INEGI = 14028 if polygon_name == "Cuautla" & cve_edo == 14
replace code_INEGI = 14029 if polygon_name == "Cuqu-o" & cve_edo == 14
replace code_INEGI = 14030 if polygon_name == "Chapala" & cve_edo == 14 | polygon_name == "Lago de Chapala" & cve_edo == 14
replace code_INEGI = 14031 if polygon_name == "Chimaltit-n" & cve_edo == 14
replace code_INEGI = 14032 if polygon_name == "Chiquilistl-n" & cve_edo == 14
replace code_INEGI = 14033 if polygon_name == "Degollado" & cve_edo == 14
replace code_INEGI = 14034 if polygon_name == "Ejutla" & cve_edo == 14
replace code_INEGI = 14035 if polygon_name == "Encarnaci-n de D-az" & cve_edo == 14
replace code_INEGI = 14036 if polygon_name == "Etzatl-n" & cve_edo == 14
replace code_INEGI = 14037 if polygon_name == "El Grullo" & cve_edo == 14
replace code_INEGI = 14038 if polygon_name == "Guachinango" & cve_edo == 14
replace code_INEGI = 14039 if polygon_name == "Guadalajara" & cve_edo == 14
replace code_INEGI = 14040 if polygon_name == "Hostotipaquillo" & cve_edo == 14
replace code_INEGI = 14041 if polygon_name == "Huej-car" & cve_edo == 14
replace code_INEGI = 14042 if polygon_name == "Huejuquilla el Alto" & cve_edo == 14
replace code_INEGI = 14043 if polygon_name == "La Huerta" & cve_edo == 14
replace code_INEGI = 14044 if polygon_name == "Ixtlahuac-n de los Membrillos" & cve_edo == 14
replace code_INEGI = 14045 if polygon_name == "Ixtlahuac-n del R-o" & cve_edo == 14
replace code_INEGI = 14046 if polygon_name == "Jalostotitl-n" & cve_edo == 14
replace code_INEGI = 14047 if polygon_name == "Jamay" & cve_edo == 14
replace code_INEGI = 14048 if polygon_name == "Jes-s Mar-a" & cve_edo == 14
replace code_INEGI = 14049 if polygon_name == "Jilotl-n de los Dolores" & cve_edo == 14
replace code_INEGI = 14050 if polygon_name == "Jocotepec" & cve_edo == 14
replace code_INEGI = 14051 if polygon_name == "Juanacatl-n" & cve_edo == 14
replace code_INEGI = 14052 if polygon_name == "Juchitl-n" & cve_edo == 14
replace code_INEGI = 14053 if polygon_name == "Lagos de Moreno" & cve_edo == 14
replace code_INEGI = 14054 if polygon_name == "El Lim-n" & cve_edo == 14
replace code_INEGI = 14055 if polygon_name == "Magdalena" & cve_edo == 14
replace code_INEGI = 14056 if polygon_name == "Santa Mar-a del Oro" & cve_edo == 14
replace code_INEGI = 14057 if polygon_name == "La Manzanilla de la Paz" & cve_edo == 14
replace code_INEGI = 14058 if polygon_name == "Mascota" & cve_edo == 14
replace code_INEGI = 14059 if polygon_name == "Mazamitla" & cve_edo == 14
replace code_INEGI = 14060 if polygon_name == "Mexticac-n" & cve_edo == 14
replace code_INEGI = 14061 if polygon_name == "Mezquitic" & cve_edo == 14
replace code_INEGI = 14062 if polygon_name == "Mixtl-n" & cve_edo == 14
replace code_INEGI = 14063 if polygon_name == "Ocotl-n" & cve_edo == 14
replace code_INEGI = 14064 if polygon_name == "Ojuelos de Jalisco" & cve_edo == 14
replace code_INEGI = 14065 if polygon_name == "Pihuamo" & cve_edo == 14
replace code_INEGI = 14066 if polygon_name == "Poncitl-n" & cve_edo == 14
replace code_INEGI = 14067 if polygon_name == "Puerto Vallarta" & cve_edo == 14
replace code_INEGI = 14068 if polygon_name == "Villa Purificaci-n" & cve_edo == 14
replace code_INEGI = 14069 if polygon_name == "Quitupan" & cve_edo == 14
replace code_INEGI = 14070 if polygon_name == "El Salto" & cve_edo == 14
replace code_INEGI = 14071 if polygon_name == "San Crist-bal de la Barranca" & cve_edo == 14
replace code_INEGI = 14072 if polygon_name == "San Diego de Alejandr-a" & cve_edo == 14
replace code_INEGI = 14073 if polygon_name == "San Juan de los Lagos" & cve_edo == 14
replace code_INEGI = 14074 if polygon_name == "San Juli-n" & cve_edo == 14
replace code_INEGI = 14075 if polygon_name == "San Marcos" & cve_edo == 14
replace code_INEGI = 14076 if polygon_name == "San Mart-n de Bola-os" & cve_edo == 14
replace code_INEGI = 14077 if polygon_name == "San Mart-n Hidalgo" & cve_edo == 14
replace code_INEGI = 14078 if polygon_name == "San Miguel el Alto" & cve_edo == 14
replace code_INEGI = 14079 if polygon_name == "G-mez Far-as" & cve_edo == 14
replace code_INEGI = 14080 if polygon_name == "San Sebasti-n del Oeste" & cve_edo == 14
replace code_INEGI = 14081 if polygon_name == "Santa Mar-a de los -ngeles" & cve_edo == 14 | polygon_name == "Santa Mar-a de los Angeles" & cve_edo == 14
replace code_INEGI = 14082 if polygon_name == "Sayula" & cve_edo == 14
replace code_INEGI = 14083 if polygon_name == "Tala" & cve_edo == 14
replace code_INEGI = 14084 if polygon_name == "Talpa de Allende" & cve_edo == 14
replace code_INEGI = 14085 if polygon_name == "Tamazula de Gordiano" & cve_edo == 14
replace code_INEGI = 14086 if polygon_name == "Tapalpa" & cve_edo == 14
replace code_INEGI = 14087 if polygon_name == "Tecalitl-n" & cve_edo == 14
replace code_INEGI = 14088 if polygon_name == "Tecolotl-n" & cve_edo == 14
replace code_INEGI = 14089 if polygon_name == "Techaluta de Montenegro" & cve_edo == 14
replace code_INEGI = 14090 if polygon_name == "Tenamaxtl-n" & cve_edo == 14
replace code_INEGI = 14091 if polygon_name == "Teocaltiche" & cve_edo == 14
replace code_INEGI = 14092 if polygon_name == "Teocuitatl-n de Corona" & cve_edo == 14
replace code_INEGI = 14093 if polygon_name == "Tepatitl-n de Morelos" & cve_edo == 14
replace code_INEGI = 14094 if polygon_name == "Tequila" & cve_edo == 14
replace code_INEGI = 14095 if polygon_name == "Teuchitl-n" & cve_edo == 14
replace code_INEGI = 14096 if polygon_name == "Tizap-n el Alto" & cve_edo == 14
replace code_INEGI = 14097 if polygon_name == "Tlajomulco de Z--iga" & cve_edo == 14
replace code_INEGI = 14098 if polygon_name == "San Pedro Tlaquepaque" & cve_edo == 14 | polygon_name == "Tlaquepaque" & cve_edo == 14
replace code_INEGI = 14099 if polygon_name == "Tolim-n" & cve_edo == 14
replace code_INEGI = 14100 if polygon_name == "Tomatl-n" & cve_edo == 14
replace code_INEGI = 14101 if polygon_name == "Tonal-" & cve_edo == 14
replace code_INEGI = 14102 if polygon_name == "Tonaya" & cve_edo == 14
replace code_INEGI = 14103 if polygon_name == "Tonila" & cve_edo == 14
replace code_INEGI = 14104 if polygon_name == "Totatiche" & cve_edo == 14
replace code_INEGI = 14105 if polygon_name == "Tototl-n" & cve_edo == 14
replace code_INEGI = 14106 if polygon_name == "Tuxcacuesco" & cve_edo == 14
replace code_INEGI = 14107 if polygon_name == "Tuxcueca" & cve_edo == 14
replace code_INEGI = 14108 if polygon_name == "Tuxpan" & cve_edo == 14
replace code_INEGI = 14109 if polygon_name == "Uni-n de San Antonio" & cve_edo == 14
replace code_INEGI = 14110 if polygon_name == "Uni-n de Tula" & cve_edo == 14
replace code_INEGI = 14111 if polygon_name == "Valle de Guadalupe" & cve_edo == 14
replace code_INEGI = 14112 if polygon_name == "Valle de Ju-rez" & cve_edo == 14
replace code_INEGI = 14113 if polygon_name == "San Gabriel" & cve_edo == 14
replace code_INEGI = 14114 if polygon_name == "Villa Corona" & cve_edo == 14
replace code_INEGI = 14115 if polygon_name == "Villa Guerrero" & cve_edo == 14
replace code_INEGI = 14116 if polygon_name == "Villa Hidalgo" & cve_edo == 14
replace code_INEGI = 14117 if polygon_name == "Ca-adas de Obreg-n" & cve_edo == 14
replace code_INEGI = 14118 if polygon_name == "Yahualica de Gonz-lez Gallo" & cve_edo == 14
replace code_INEGI = 14119 if polygon_name == "Zacoalco de Torres" & cve_edo == 14
replace code_INEGI = 14120 if polygon_name == "Zapopan" & cve_edo == 14
replace code_INEGI = 14121 if polygon_name == "Zapotiltic" & cve_edo == 14
replace code_INEGI = 14122 if polygon_name == "Zapotitl-n de Vadillo" & cve_edo == 14
replace code_INEGI = 14123 if polygon_name == "Zapotl-n del Rey" & cve_edo == 14
replace code_INEGI = 14124 if polygon_name == "Zapotlanejo" & cve_edo == 14
replace code_INEGI = 14125 if polygon_name == "San Ignacio Cerro Gordo" & cve_edo == 14

replace code_INEGI = 15001 if polygon_name == "Acambay de Ru-z Casta-eda" & cve_edo == 15
replace code_INEGI = 15002 if polygon_name == "Acolman" & cve_edo == 15
replace code_INEGI = 15003 if polygon_name == "Aculco" & cve_edo == 15
replace code_INEGI = 15004 if polygon_name == "Almoloya de Alquisiras" & cve_edo == 15
replace code_INEGI = 15005 if polygon_name == "Almoloya de Ju-rez" & cve_edo == 15
replace code_INEGI = 15006 if polygon_name == "Almoloya del R-o" & cve_edo == 15
replace code_INEGI = 15007 if polygon_name == "Amanalco" & cve_edo == 15
replace code_INEGI = 15008 if polygon_name == "Amatepec" & cve_edo == 15
replace code_INEGI = 15009 if polygon_name == "Amecameca" & cve_edo == 15
replace code_INEGI = 15010 if polygon_name == "Apaxco" & cve_edo == 15
replace code_INEGI = 15011 if polygon_name == "Atenco" & cve_edo == 15
replace code_INEGI = 15012 if polygon_name == "Atizap-n" & cve_edo == 15
replace code_INEGI = 15013 if polygon_name == "Atizap-n de Zaragoza" & cve_edo == 15
replace code_INEGI = 15014 if polygon_name == "Atlacomulco" & cve_edo == 15
replace code_INEGI = 15015 if polygon_name == "Atlautla" & cve_edo == 15
replace code_INEGI = 15016 if polygon_name == "Axapusco" & cve_edo == 15
replace code_INEGI = 15017 if polygon_name == "Ayapango" & cve_edo == 15
replace code_INEGI = 15018 if polygon_name == "Calimaya" & cve_edo == 15
replace code_INEGI = 15019 if polygon_name == "Capulhuac" & cve_edo == 15
replace code_INEGI = 15020 if polygon_name == "Coacalco de Berrioz-bal" & cve_edo == 15
replace code_INEGI = 15021 if polygon_name == "Coatepec Harinas" & cve_edo == 15
replace code_INEGI = 15022 if polygon_name == "Cocotitl-n" & cve_edo == 15
replace code_INEGI = 15023 if polygon_name == "Coyotepec" & cve_edo == 15
replace code_INEGI = 15024 if polygon_name == "Cuautitl-n" & cve_edo == 15
replace code_INEGI = 15025 if polygon_name == "Chalco" & cve_edo == 15
replace code_INEGI = 15026 if polygon_name == "Chapa de Mota" & cve_edo == 15
replace code_INEGI = 15027 if polygon_name == "Chapultepec" & cve_edo == 15
replace code_INEGI = 15028 if polygon_name == "Chiautla" & cve_edo == 15
replace code_INEGI = 15029 if polygon_name == "Chicoloapan" & cve_edo == 15
replace code_INEGI = 15030 if polygon_name == "Chiconcuac" & cve_edo == 15
replace code_INEGI = 15031 if polygon_name == "Chimalhuac-n" & cve_edo == 15
replace code_INEGI = 15032 if polygon_name == "Donato Guerra" & cve_edo == 15
replace code_INEGI = 15033 if polygon_name == "Ecatepec de Morelos" & cve_edo == 15
replace code_INEGI = 15034 if polygon_name == "Ecatzingo" & cve_edo == 15
replace code_INEGI = 15035 if polygon_name == "Huehuetoca" & cve_edo == 15
replace code_INEGI = 15036 if polygon_name == "Hueypoxtla" & cve_edo == 15
replace code_INEGI = 15037 if polygon_name == "Huixquilucan" & cve_edo == 15
replace code_INEGI = 15038 if polygon_name == "Isidro Fabela" & cve_edo == 15
replace code_INEGI = 15039 if polygon_name == "Ixtapaluca" & cve_edo == 15
replace code_INEGI = 15040 if polygon_name == "Ixtapan de la Sal" & cve_edo == 15
replace code_INEGI = 15041 if polygon_name == "Ixtapan del Oro" & cve_edo == 15
replace code_INEGI = 15042 if polygon_name == "Ixtlahuaca" & cve_edo == 15
replace code_INEGI = 15043 if polygon_name == "Xalatlaco" & cve_edo == 15
replace code_INEGI = 15044 if polygon_name == "Jaltenco" & cve_edo == 15
replace code_INEGI = 15045 if polygon_name == "Jilotepec" & cve_edo == 15
replace code_INEGI = 15046 if polygon_name == "Jilotzingo" & cve_edo == 15
replace code_INEGI = 15047 if polygon_name == "Jiquipilco" & cve_edo == 15
replace code_INEGI = 15048 if polygon_name == "Jocotitl-n" & cve_edo == 15
replace code_INEGI = 15049 if polygon_name == "Joquicingo" & cve_edo == 15
replace code_INEGI = 15050 if polygon_name == "Juchitepec" & cve_edo == 15
replace code_INEGI = 15051 if polygon_name == "Lerma" & cve_edo == 15
replace code_INEGI = 15052 if polygon_name == "Malinalco" & cve_edo == 15
replace code_INEGI = 15053 if polygon_name == "Melchor Ocampo" & cve_edo == 15
replace code_INEGI = 15054 if polygon_name == "Metepec" & cve_edo == 15
replace code_INEGI = 15055 if polygon_name == "Mexicaltzingo" & cve_edo == 15
replace code_INEGI = 15056 if polygon_name == "Morelos" & cve_edo == 15
replace code_INEGI = 15057 if polygon_name == "Naucalpan de Ju-rez" & cve_edo == 15
replace code_INEGI = 15058 if polygon_name == "Nezahualc-yotl" & cve_edo == 15
replace code_INEGI = 15059 if polygon_name == "Nextlalpan" & cve_edo == 15
replace code_INEGI = 15060 if polygon_name == "Nicol-s Romero" & cve_edo == 15
replace code_INEGI = 15061 if polygon_name == "Nopaltepec" & cve_edo == 15
replace code_INEGI = 15062 if polygon_name == "Ocoyoacac" & cve_edo == 15
replace code_INEGI = 15063 if polygon_name == "Ocuilan" & cve_edo == 15
replace code_INEGI = 15064 if polygon_name == "El Oro" & cve_edo == 15
replace code_INEGI = 15065 if polygon_name == "Otumba" & cve_edo == 15
replace code_INEGI = 15066 if polygon_name == "Otzoloapan" & cve_edo == 15
replace code_INEGI = 15067 if polygon_name == "Otzolotepec" & cve_edo == 15
replace code_INEGI = 15068 if polygon_name == "Ozumba" & cve_edo == 15
replace code_INEGI = 15069 if polygon_name == "Papalotla" & cve_edo == 15
replace code_INEGI = 15070 if polygon_name == "La Paz" & cve_edo == 15
replace code_INEGI = 15071 if polygon_name == "Polotitl-n" & cve_edo == 15
replace code_INEGI = 15072 if polygon_name == "Ray-n" & cve_edo == 15
replace code_INEGI = 15073 if polygon_name == "San Antonio la Isla" & cve_edo == 15
replace code_INEGI = 15074 if polygon_name == "San Felipe del Progreso" & cve_edo == 15
replace code_INEGI = 15075 if polygon_name == "San Mart-n de las Pir-mides" & cve_edo == 15 | polygon_name == "San Mart-n de las Pir--mides" & cve_edo == 15
replace code_INEGI = 15076 if polygon_name == "San Mateo Atenco" & cve_edo == 15
replace code_INEGI = 15077 if polygon_name == "San Sim-n de Guerrero" & cve_edo == 15
replace code_INEGI = 15078 if polygon_name == "Santo Tom-s" & cve_edo == 15
replace code_INEGI = 15079 if polygon_name == "Soyaniquilpan de Ju-rez" & cve_edo == 15
replace code_INEGI = 15080 if polygon_name == "Sultepec" & cve_edo == 15
replace code_INEGI = 15081 if polygon_name == "Tec-mac" & cve_edo == 15
replace code_INEGI = 15082 if polygon_name == "Tejupilco" & cve_edo == 15
replace code_INEGI = 15083 if polygon_name == "Temamatla" & cve_edo == 15
replace code_INEGI = 15084 if polygon_name == "Temascalapa" & cve_edo == 15
replace code_INEGI = 15085 if polygon_name == "Temascalcingo" & cve_edo == 15
replace code_INEGI = 15086 if polygon_name == "Temascaltepec" & cve_edo == 15
replace code_INEGI = 15087 if polygon_name == "Temoaya" & cve_edo == 15
replace code_INEGI = 15088 if polygon_name == "Tenancingo" & cve_edo == 15
replace code_INEGI = 15089 if polygon_name == "Tenango del Aire" & cve_edo == 15
replace code_INEGI = 15090 if polygon_name == "Tenango del Valle" & cve_edo == 15
replace code_INEGI = 15091 if polygon_name == "Teoloyucan" & cve_edo == 15 | polygon_name == "Teoloyuc-n" & cve_edo == 15
replace code_INEGI = 15092 if polygon_name == "Teotihuac-n" & cve_edo == 15
replace code_INEGI = 15093 if polygon_name == "Tepetlaoxtoc" & cve_edo == 15
replace code_INEGI = 15094 if polygon_name == "Tepetlixpa" & cve_edo == 15
replace code_INEGI = 15095 if polygon_name == "Tepotzotl-n" & cve_edo == 15
replace code_INEGI = 15096 if polygon_name == "Tequixquiac" & cve_edo == 15
replace code_INEGI = 15097 if polygon_name == "Texcaltitl-n" & cve_edo == 15
replace code_INEGI = 15098 if polygon_name == "Texcalyacac" & cve_edo == 15
replace code_INEGI = 15099 if polygon_name == "Texcoco" & cve_edo == 15
replace code_INEGI = 15100 if polygon_name == "Tezoyuca" & cve_edo == 15
replace code_INEGI = 15101 if polygon_name == "Tianguistenco" & cve_edo == 15
replace code_INEGI = 15102 if polygon_name == "Timilpan" & cve_edo == 15
replace code_INEGI = 15103 if polygon_name == "Tlalmanalco" & cve_edo == 15
replace code_INEGI = 15104 if polygon_name == "Tlalnepantla de Baz" & cve_edo == 15
replace code_INEGI = 15105 if polygon_name == "Tlatlaya" & cve_edo == 15
replace code_INEGI = 15106 if polygon_name == "Toluca" & cve_edo == 15
replace code_INEGI = 15107 if polygon_name == "Tonatico" & cve_edo == 15
replace code_INEGI = 15108 if polygon_name == "Tultepec" & cve_edo == 15
replace code_INEGI = 15109 if polygon_name == "Tultitl-n" & cve_edo == 15
replace code_INEGI = 15110 if polygon_name == "Valle de Bravo" & cve_edo == 15
replace code_INEGI = 15111 if polygon_name == "Villa de Allende" & cve_edo == 15
replace code_INEGI = 15112 if polygon_name == "Villa del Carb-n" & cve_edo == 15
replace code_INEGI = 15113 if polygon_name == "Villa Guerrero" & cve_edo == 15
replace code_INEGI = 15114 if polygon_name == "Villa Victoria" & cve_edo == 15
replace code_INEGI = 15115 if polygon_name == "Xonacatl-n" & cve_edo == 15
replace code_INEGI = 15116 if polygon_name == "Zacazonapan" & cve_edo == 15
replace code_INEGI = 15117 if polygon_name == "Zacualpan" & cve_edo == 15
replace code_INEGI = 15118 if polygon_name == "Zinacantepec" & cve_edo == 15
replace code_INEGI = 15119 if polygon_name == "Zumpahuac-n" & cve_edo == 15
replace code_INEGI = 15120 if polygon_name == "Zumpango" & cve_edo == 15
replace code_INEGI = 15121 if polygon_name == "Cuautitl-n Izcalli" & cve_edo == 15
replace code_INEGI = 15122 if polygon_name == "Valle de Chalco Solidaridad" & cve_edo == 15
replace code_INEGI = 15123 if polygon_name == "Luvianos" & cve_edo == 15
replace code_INEGI = 15124 if polygon_name == "San Jos- del Rinc-n" & cve_edo == 15
replace code_INEGI = 15125 if polygon_name == "Tonanitla" & cve_edo == 15

replace code_INEGI = 16001 if polygon_name == "Acuitzio" & cve_edo == 16
replace code_INEGI = 16002 if polygon_name == "Aguililla" & cve_edo == 16
replace code_INEGI = 16003 if polygon_name == "-lvaro Obreg-n" & cve_edo == 16
replace code_INEGI = 16004 if polygon_name == "Angamacutiro" & cve_edo == 16
replace code_INEGI = 16005 if polygon_name == "Angangueo" & cve_edo == 16
replace code_INEGI = 16006 if polygon_name == "Apatzing-n" & cve_edo == 16
replace code_INEGI = 16007 if polygon_name == "Aporo" & cve_edo == 16
replace code_INEGI = 16008 if polygon_name == "Aquila" & cve_edo == 16
replace code_INEGI = 16009 if polygon_name == "Ario" & cve_edo == 16
replace code_INEGI = 16010 if polygon_name == "Arteaga" & cve_edo == 16
replace code_INEGI = 16011 if polygon_name == "Brise-as" & cve_edo == 16
replace code_INEGI = 16012 if polygon_name == "Buenavista" & cve_edo == 16
replace code_INEGI = 16013 if polygon_name == "Car-cuaro" & cve_edo == 16
replace code_INEGI = 16014 if polygon_name == "Coahuayana" & cve_edo == 16
replace code_INEGI = 16015 if polygon_name == "Coalcom-n de V-zquez Pallares" & cve_edo == 16
replace code_INEGI = 16016 if polygon_name == "Coeneo" & cve_edo == 16
replace code_INEGI = 16017 if polygon_name == "Contepec" & cve_edo == 16
replace code_INEGI = 16018 if polygon_name == "Cop-ndaro" & cve_edo == 16
replace code_INEGI = 16019 if polygon_name == "Cotija" & cve_edo == 16
replace code_INEGI = 16020 if polygon_name == "Cuitzeo" & cve_edo == 16
replace code_INEGI = 16021 if polygon_name == "Charapan" & cve_edo == 16
replace code_INEGI = 16022 if polygon_name == "Charo" & cve_edo == 16
replace code_INEGI = 16023 if polygon_name == "Chavinda" & cve_edo == 16
replace code_INEGI = 16024 if polygon_name == "Cher-n" & cve_edo == 16
replace code_INEGI = 16025 if polygon_name == "Chilchota" & cve_edo == 16
replace code_INEGI = 16026 if polygon_name == "Chinicuila" & cve_edo == 16
replace code_INEGI = 16027 if polygon_name == "Chuc-ndiro" & cve_edo == 16
replace code_INEGI = 16028 if polygon_name == "Churintzio" & cve_edo == 16
replace code_INEGI = 16029 if polygon_name == "Churumuco" & cve_edo == 16
replace code_INEGI = 16030 if polygon_name == "Ecuandureo" & cve_edo == 16
replace code_INEGI = 16031 if polygon_name == "Epitacio Huerta" & cve_edo == 16
replace code_INEGI = 16032 if polygon_name == "Erongar-cuaro" & cve_edo == 16
replace code_INEGI = 16033 if polygon_name == "Gabriel Zamora" & cve_edo == 16
replace code_INEGI = 16034 if polygon_name == "Hidalgo" & cve_edo == 16
replace code_INEGI = 16035 if polygon_name == "La Huacana" & cve_edo == 16
replace code_INEGI = 16036 if polygon_name == "Huandacareo" & cve_edo == 16
replace code_INEGI = 16037 if polygon_name == "Huaniqueo" & cve_edo == 16
replace code_INEGI = 16038 if polygon_name == "Huetamo" & cve_edo == 16
replace code_INEGI = 16039 if polygon_name == "Huiramba" & cve_edo == 16
replace code_INEGI = 16040 if polygon_name == "Indaparapeo" & cve_edo == 16
replace code_INEGI = 16041 if polygon_name == "Irimbo" & cve_edo == 16
replace code_INEGI = 16042 if polygon_name == "Ixtl-n" & cve_edo == 16
replace code_INEGI = 16043 if polygon_name == "Jacona" & cve_edo == 16
replace code_INEGI = 16044 if polygon_name == "Jim-nez" & cve_edo == 16
replace code_INEGI = 16045 if polygon_name == "Jiquilpan" & cve_edo == 16
replace code_INEGI = 16046 if polygon_name == "Ju-rez" & cve_edo == 16
replace code_INEGI = 16047 if polygon_name == "Jungapeo" & cve_edo == 16
replace code_INEGI = 16048 if polygon_name == "Lagunillas" & cve_edo == 16
replace code_INEGI = 16049 if polygon_name == "Madero" & cve_edo == 16
replace code_INEGI = 16050 if polygon_name == "Maravat-o" & cve_edo == 16
replace code_INEGI = 16051 if polygon_name == "Marcos Castellanos" & cve_edo == 16
replace code_INEGI = 16052 if polygon_name == "L-zaro C-rdenas" & cve_edo == 16
replace code_INEGI = 16053 if polygon_name == "Morelia" & cve_edo == 16
replace code_INEGI = 16054 if polygon_name == "Morelos" & cve_edo == 16
replace code_INEGI = 16055 if polygon_name == "M-gica" & cve_edo == 16
replace code_INEGI = 16056 if polygon_name == "Nahuatzen" & cve_edo == 16
replace code_INEGI = 16057 if polygon_name == "Nocup-taro" & cve_edo == 16
replace code_INEGI = 16058 if polygon_name == "Nuevo Parangaricutiro" & cve_edo == 16 | polygon_name == "Nuevo Paranguricutiro" & cve_edo == 16
replace code_INEGI = 16059 if polygon_name == "Nuevo Urecho" & cve_edo == 16
replace code_INEGI = 16060 if polygon_name == "Numar-n" & cve_edo == 16
replace code_INEGI = 16061 if polygon_name == "Ocampo" & cve_edo == 16
replace code_INEGI = 16062 if polygon_name == "Pajacuar-n" & cve_edo == 16
replace code_INEGI = 16063 if polygon_name == "Panind-cuaro" & cve_edo == 16
replace code_INEGI = 16064 if polygon_name == "Par-cuaro" & cve_edo == 16
replace code_INEGI = 16065 if polygon_name == "Paracho" & cve_edo == 16
replace code_INEGI = 16066 if polygon_name == "P-tzcuaro" & cve_edo == 16
replace code_INEGI = 16067 if polygon_name == "Penjamillo" & cve_edo == 16
replace code_INEGI = 16068 if polygon_name == "Perib-n" & cve_edo == 16
replace code_INEGI = 16069 if polygon_name == "La Piedad" & cve_edo == 16
replace code_INEGI = 16070 if polygon_name == "Pur-pero" & cve_edo == 16
replace code_INEGI = 16071 if polygon_name == "Puru-ndiro" & cve_edo == 16
replace code_INEGI = 16072 if polygon_name == "Quer-ndaro" & cve_edo == 16
replace code_INEGI = 16073 if polygon_name == "Quiroga" & cve_edo == 16
replace code_INEGI = 16074 if polygon_name == "Cojumatl-n de R-gules" & cve_edo == 16
replace code_INEGI = 16075 if polygon_name == "Los Reyes" & cve_edo == 16
replace code_INEGI = 16076 if polygon_name == "Sahuayo" & cve_edo == 16
replace code_INEGI = 16077 if polygon_name == "San Lucas" & cve_edo == 16
replace code_INEGI = 16078 if polygon_name == "Santa Ana Maya" & cve_edo == 16
replace code_INEGI = 16079 if polygon_name == "Salvador Escalante" & cve_edo == 16
replace code_INEGI = 16080 if polygon_name == "Senguio" & cve_edo == 16
replace code_INEGI = 16081 if polygon_name == "Susupuato" & cve_edo == 16
replace code_INEGI = 16082 if polygon_name == "Tac-mbaro" & cve_edo == 16
replace code_INEGI = 16083 if polygon_name == "Tanc-taro" & cve_edo == 16
replace code_INEGI = 16084 if polygon_name == "Tangamandapio" & cve_edo == 16
replace code_INEGI = 16085 if polygon_name == "Tanganc-cuaro" & cve_edo == 16
replace code_INEGI = 16086 if polygon_name == "Tanhuato" & cve_edo == 16
replace code_INEGI = 16087 if polygon_name == "Taretan" & cve_edo == 16
replace code_INEGI = 16088 if polygon_name == "Tar-mbaro" & cve_edo == 16
replace code_INEGI = 16089 if polygon_name == "Tepalcatepec" & cve_edo == 16
replace code_INEGI = 16090 if polygon_name == "Tingambato" & cve_edo == 16
replace code_INEGI = 16091 if polygon_name == "Ting-ind-n" & cve_edo == 16
replace code_INEGI = 16092 if polygon_name == "Tiquicheo de Nicol-s Romero" & cve_edo == 16
replace code_INEGI = 16093 if polygon_name == "Tlalpujahua" & cve_edo == 16
replace code_INEGI = 16094 if polygon_name == "Tlazazalca" & cve_edo == 16
replace code_INEGI = 16095 if polygon_name == "Tocumbo" & cve_edo == 16
replace code_INEGI = 16096 if polygon_name == "Tumbiscat-o" & cve_edo == 16
replace code_INEGI = 16097 if polygon_name == "Turicato" & cve_edo == 16
replace code_INEGI = 16098 if polygon_name == "Tuxpan" & cve_edo == 16
replace code_INEGI = 16099 if polygon_name == "Tuzantla" & cve_edo == 16
replace code_INEGI = 16100 if polygon_name == "Tzintzuntzan" & cve_edo == 16
replace code_INEGI = 16101 if polygon_name == "Tzitzio" & cve_edo == 16
replace code_INEGI = 16102 if polygon_name == "Uruapan" & cve_edo == 16
replace code_INEGI = 16103 if polygon_name == "Venustiano Carranza" & cve_edo == 16
replace code_INEGI = 16104 if polygon_name == "Villamar" & cve_edo == 16
replace code_INEGI = 16105 if polygon_name == "Vista Hermosa" & cve_edo == 16
replace code_INEGI = 16106 if polygon_name == "Yur-cuaro" & cve_edo == 16
replace code_INEGI = 16107 if polygon_name == "Zacapu" & cve_edo == 16
replace code_INEGI = 16108 if polygon_name == "Zamora" & cve_edo == 16
replace code_INEGI = 16109 if polygon_name == "Zin-paro" & cve_edo == 16
replace code_INEGI = 16110 if polygon_name == "Zinap-cuaro" & cve_edo == 16
replace code_INEGI = 16111 if polygon_name == "Ziracuaretiro" & cve_edo == 16
replace code_INEGI = 16112 if polygon_name == "Zit-cuaro" & cve_edo == 16
replace code_INEGI = 16113 if polygon_name == "Jos- Sixto Verduzco" & cve_edo == 16

replace code_INEGI = 17001 if polygon_name == "Amacuzac" & cve_edo == 17
replace code_INEGI = 17002 if polygon_name == "Atlatlahucan" & cve_edo == 17
replace code_INEGI = 17003 if polygon_name == "Axochiapan" & cve_edo == 17
replace code_INEGI = 17004 if polygon_name == "Ayala" & cve_edo == 17
replace code_INEGI = 17005 if polygon_name == "Coatl-n del R-o" & cve_edo == 17
replace code_INEGI = 17006 if polygon_name == "Cuautla" & cve_edo == 17
replace code_INEGI = 17007 if polygon_name == "Cuernavaca" & cve_edo == 17
replace code_INEGI = 17008 if polygon_name == "Emiliano Zapata" & cve_edo == 17
replace code_INEGI = 17009 if polygon_name == "Huitzilac" & cve_edo == 17
replace code_INEGI = 17010 if polygon_name == "Jantetelco" & cve_edo == 17
replace code_INEGI = 17011 if polygon_name == "Jiutepec" & cve_edo == 17
replace code_INEGI = 17012 if polygon_name == "Jojutla" & cve_edo == 17
replace code_INEGI = 17013 if polygon_name == "Jonacatepec de Leandro Valle" & cve_edo == 17
replace code_INEGI = 17014 if polygon_name == "Mazatepec" & cve_edo == 17
replace code_INEGI = 17015 if polygon_name == "Miacatl-n" & cve_edo == 17
replace code_INEGI = 17016 if polygon_name == "Ocuituco" & cve_edo == 17
replace code_INEGI = 17017 if polygon_name == "Puente de Ixtla" & cve_edo == 17
replace code_INEGI = 17018 if polygon_name == "Temixco" & cve_edo == 17
replace code_INEGI = 17019 if polygon_name == "Tepalcingo" & cve_edo == 17
replace code_INEGI = 17020 if polygon_name == "Tepoztl-n" & cve_edo == 17
replace code_INEGI = 17021 if polygon_name == "Tetecala" & cve_edo == 17
replace code_INEGI = 17022 if polygon_name == "Tetela del Volc-n" & cve_edo == 17
replace code_INEGI = 17023 if polygon_name == "Tlalnepantla" & cve_edo == 17
replace code_INEGI = 17024 if polygon_name == "Tlaltizap-n de Zapata" & cve_edo == 17
replace code_INEGI = 17025 if polygon_name == "Tlaquiltenango" & cve_edo == 17
replace code_INEGI = 17026 if polygon_name == "Tlayacapan" & cve_edo == 17
replace code_INEGI = 17027 if polygon_name == "Totolapan" & cve_edo == 17
replace code_INEGI = 17028 if polygon_name == "Xochitepec" & cve_edo == 17
replace code_INEGI = 17029 if polygon_name == "Yautepec" & cve_edo == 17
replace code_INEGI = 17030 if polygon_name == "Yecapixtla" & cve_edo == 17
replace code_INEGI = 17031 if polygon_name == "Zacatepec" & cve_edo == 17
replace code_INEGI = 17032 if polygon_name == "Zacualpan de Amilpas" & cve_edo == 17
replace code_INEGI = 17033 if polygon_name == "Temoac" & cve_edo == 17
replace code_INEGI = 17034 if polygon_name == "Coatetelco" & cve_edo == 17
replace code_INEGI = 17035 if polygon_name == "Xoxocotla" & cve_edo == 17

replace code_INEGI = 18001 if polygon_name == "Acaponeta" & cve_edo == 18
replace code_INEGI = 18002 if polygon_name == "Ahuacatl-n" & cve_edo == 18
replace code_INEGI = 18003 if polygon_name == "Amatl-n de Ca-as" & cve_edo == 18
replace code_INEGI = 18004 if polygon_name == "Compostela" & cve_edo == 18
replace code_INEGI = 18005 if polygon_name == "Huajicori" & cve_edo == 18
replace code_INEGI = 18006 if polygon_name == "Ixtl-n del R-o" & cve_edo == 18
replace code_INEGI = 18007 if polygon_name == "Jala" & cve_edo == 18
replace code_INEGI = 18008 if polygon_name == "Xalisco" & cve_edo == 18
replace code_INEGI = 18009 if polygon_name == "Del Nayar" & cve_edo == 18
replace code_INEGI = 18010 if polygon_name == "Rosamorada" & cve_edo == 18
replace code_INEGI = 18011 if polygon_name == "Ru-z" & cve_edo == 18
replace code_INEGI = 18012 if polygon_name == "San Blas" & cve_edo == 18
replace code_INEGI = 18013 if polygon_name == "San Pedro Lagunillas" & cve_edo == 18
replace code_INEGI = 18014 if polygon_name == "Santa Mar-a del Oro" & cve_edo == 18
replace code_INEGI = 18015 if polygon_name == "Santiago Ixcuintla" & cve_edo == 18
replace code_INEGI = 18016 if polygon_name == "Tecuala" & cve_edo == 18
replace code_INEGI = 18017 if polygon_name == "Tepic" & cve_edo == 18
replace code_INEGI = 18018 if polygon_name == "Tuxpan" & cve_edo == 18
replace code_INEGI = 18019 if polygon_name == "La Yesca" & cve_edo == 18
replace code_INEGI = 18020 if polygon_name == "Bah-a de Banderas" & cve_edo == 18

replace code_INEGI = 19001 if polygon_name == "Abasolo" & cve_edo == 19
replace code_INEGI = 19002 if polygon_name == "Agualeguas" & cve_edo == 19
replace code_INEGI = 19003 if polygon_name == "Los Aldamas" & cve_edo == 19
replace code_INEGI = 19004 if polygon_name == "Allende" & cve_edo == 19
replace code_INEGI = 19005 if polygon_name == "An-huac" & cve_edo == 19
replace code_INEGI = 19006 if polygon_name == "Apodaca" & cve_edo == 19
replace code_INEGI = 19007 if polygon_name == "Aramberri" & cve_edo == 19
replace code_INEGI = 19008 if polygon_name == "Bustamante" & cve_edo == 19
replace code_INEGI = 19009 if polygon_name == "Cadereyta Jim-nez" & cve_edo == 19 | polygon_name == "Cadereyta" & cve_edo == 19
replace code_INEGI = 19010 if polygon_name == "El Carmen" & cve_edo == 19 | polygon_name == "Carmen" & cve_edo == 19
replace code_INEGI = 19011 if polygon_name == "Cerralvo" & cve_edo == 19
replace code_INEGI = 19012 if polygon_name == "Ci-nega de Flores" & cve_edo == 19
replace code_INEGI = 19013 if polygon_name == "China" & cve_edo == 19
replace code_INEGI = 19014 if polygon_name == "Doctor Arroyo" & cve_edo == 19
replace code_INEGI = 19015 if polygon_name == "Doctor Coss" & cve_edo == 19
replace code_INEGI = 19016 if polygon_name == "Doctor Gonz-lez" & cve_edo == 19
replace code_INEGI = 19017 if polygon_name == "Galeana" & cve_edo == 19
replace code_INEGI = 19018 if polygon_name == "Garc-a" & cve_edo == 19
replace code_INEGI = 19019 if polygon_name == "San Pedro Garza Garc-a" & cve_edo == 19
replace code_INEGI = 19020 if polygon_name == "General Bravo" & cve_edo == 19
replace code_INEGI = 19021 if polygon_name == "General Escobedo" & cve_edo == 19
replace code_INEGI = 19022 if polygon_name == "General Ter-n" & cve_edo == 19
replace code_INEGI = 19023 if polygon_name == "General Trevi-o" & cve_edo == 19
replace code_INEGI = 19024 if polygon_name == "General Zaragoza" & cve_edo == 19
replace code_INEGI = 19025 if polygon_name == "General Zuazua" & cve_edo == 19
replace code_INEGI = 19026 if polygon_name == "Guadalupe" & cve_edo == 19
replace code_INEGI = 19027 if polygon_name == "Los Herreras" & cve_edo == 19
replace code_INEGI = 19028 if polygon_name == "Higueras" & cve_edo == 19
replace code_INEGI = 19029 if polygon_name == "Hualahuises" & cve_edo == 19
replace code_INEGI = 19030 if polygon_name == "Iturbide" & cve_edo == 19
replace code_INEGI = 19031 if polygon_name == "Ju-rez" & cve_edo == 19
replace code_INEGI = 19032 if polygon_name == "Lampazos de Naranjo" & cve_edo == 19
replace code_INEGI = 19033 if polygon_name == "Linares" & cve_edo == 19
replace code_INEGI = 19034 if polygon_name == "Mar-n" & cve_edo == 19
replace code_INEGI = 19035 if polygon_name == "Melchor Ocampo" & cve_edo == 19
replace code_INEGI = 19036 if polygon_name == "Mier y Noriega" & cve_edo == 19
replace code_INEGI = 19037 if polygon_name == "Mina" & cve_edo == 19
replace code_INEGI = 19038 if polygon_name == "Montemorelos" & cve_edo == 19
replace code_INEGI = 19039 if polygon_name == "Monterrey" & cve_edo == 19
replace code_INEGI = 19040 if polygon_name == "Par-s" & cve_edo == 19
replace code_INEGI = 19041 if polygon_name == "Pesquer-a" & cve_edo == 19
replace code_INEGI = 19042 if polygon_name == "Los Ramones" & cve_edo == 19
replace code_INEGI = 19043 if polygon_name == "Rayones" & cve_edo == 19
replace code_INEGI = 19044 if polygon_name == "Sabinas Hidalgo" & cve_edo == 19
replace code_INEGI = 19045 if polygon_name == "Salinas Victoria" & cve_edo == 19
replace code_INEGI = 19046 if polygon_name == "San Nicol-s de los Garza" & cve_edo == 19
replace code_INEGI = 19047 if polygon_name == "Hidalgo" & cve_edo == 19
replace code_INEGI = 19048 if polygon_name == "Santa Catarina" & cve_edo == 19
replace code_INEGI = 19049 if polygon_name == "Santiago" & cve_edo == 19
replace code_INEGI = 19050 if polygon_name == "Vallecillo" & cve_edo == 19
replace code_INEGI = 19051 if polygon_name == "Villaldama" & cve_edo == 19
replace code_INEGI = 20001 if polygon_name == "Abejones" & cve_edo == 20
replace code_INEGI = 20002 if polygon_name == "Acatl-n de P-rez Figueroa" & cve_edo == 20
replace code_INEGI = 20003 if polygon_name == "Asunci-n Cacalotepec" & cve_edo == 20
replace code_INEGI = 20004 if polygon_name == "Asunci-n Cuyotepeji" & cve_edo == 20
replace code_INEGI = 20005 if polygon_name == "Asunci-n Ixtaltepec" & cve_edo == 20
replace code_INEGI = 20006 if polygon_name == "Asunci-n Nochixtl-n" & cve_edo == 20
replace code_INEGI = 20007 if polygon_name == "Asunci-n Ocotl-n" & cve_edo == 20
replace code_INEGI = 20008 if polygon_name == "Asunci-n Tlacolulita" & cve_edo == 20
replace code_INEGI = 20009 if polygon_name == "Ayotzintepec" & cve_edo == 20
replace code_INEGI = 20010 if polygon_name == "El Barrio de la Soledad" & cve_edo == 20
replace code_INEGI = 20011 if polygon_name == "Calihual-" & cve_edo == 20
replace code_INEGI = 20012 if polygon_name == "Candelaria Loxicha" & cve_edo == 20
replace code_INEGI = 20013 if polygon_name == "Ci-nega de Zimatl-n" & cve_edo == 20
replace code_INEGI = 20014 if polygon_name == "Ciudad Ixtepec" & cve_edo == 20
replace code_INEGI = 20015 if polygon_name == "Coatecas Altas" & cve_edo == 20
replace code_INEGI = 20016 if polygon_name == "Coicoy-n de las Flores" & cve_edo == 20
replace code_INEGI = 20017 if polygon_name == "La Compa--a" & cve_edo == 20
replace code_INEGI = 20018 if polygon_name == "Concepci-n Buenavista" & cve_edo == 20
replace code_INEGI = 20019 if polygon_name == "Concepci-n P-palo" & cve_edo == 20
replace code_INEGI = 20020 if polygon_name == "Constancia del Rosario" & cve_edo == 20
replace code_INEGI = 20021 if polygon_name == "Cosolapa" & cve_edo == 20
replace code_INEGI = 20022 if polygon_name == "Cosoltepec" & cve_edo == 20
replace code_INEGI = 20023 if polygon_name == "Cuil-pam de Guerrero" & cve_edo == 20
replace code_INEGI = 20024 if polygon_name == "Cuyamecalco Villa de Zaragoza" & cve_edo == 20
replace code_INEGI = 20025 if polygon_name == "Chahuites" & cve_edo == 20
replace code_INEGI = 20026 if polygon_name == "Chalcatongo de Hidalgo" & cve_edo == 20
replace code_INEGI = 20027 if polygon_name == "Chiquihuitl-n de Benito Ju-rez" & cve_edo == 20
replace code_INEGI = 20028 if polygon_name == "Heroica Ciudad de Ejutla de Crespo" & cve_edo == 20
replace code_INEGI = 20029 if polygon_name == "Eloxochitl-n de Flores Mag-n" & cve_edo == 20
replace code_INEGI = 20030 if polygon_name == "El Espinal" & cve_edo == 20
replace code_INEGI = 20031 if polygon_name == "Tamazul-pam del Esp-ritu Santo" & cve_edo == 20
replace code_INEGI = 20032 if polygon_name == "Fresnillo de Trujano" & cve_edo == 20
replace code_INEGI = 20033 if polygon_name == "Guadalupe Etla" & cve_edo == 20
replace code_INEGI = 20034 if polygon_name == "Guadalupe de Ram-rez" & cve_edo == 20
replace code_INEGI = 20035 if polygon_name == "Guelatao de Ju-rez" & cve_edo == 20
replace code_INEGI = 20036 if polygon_name == "Guevea de Humboldt" & cve_edo == 20
replace code_INEGI = 20037 if polygon_name == "Mesones Hidalgo" & cve_edo == 20
replace code_INEGI = 20038 if polygon_name == "Villa Hidalgo" & cve_edo == 20
replace code_INEGI = 20039 if polygon_name == "Heroica Ciudad de Huajuapan de Le-n" & cve_edo == 20
replace code_INEGI = 20040 if polygon_name == "Huautepec" & cve_edo == 20
replace code_INEGI = 20041 if polygon_name == "Huautla de Jim-nez" & cve_edo == 20
replace code_INEGI = 20042 if polygon_name == "Ixtl-n de Ju-rez" & cve_edo == 20
replace code_INEGI = 20043 if polygon_name == "Juchit-n de Zaragoza" & cve_edo == 20
replace code_INEGI = 20044 if polygon_name == "Loma Bonita" & cve_edo == 20
replace code_INEGI = 20045 if polygon_name == "Magdalena Apasco" & cve_edo == 20
replace code_INEGI = 20046 if polygon_name == "Magdalena Jaltepec" & cve_edo == 20
replace code_INEGI = 20047 if polygon_name == "Santa Magdalena Jicotl-n" & cve_edo == 20
replace code_INEGI = 20048 if polygon_name == "Magdalena Mixtepec" & cve_edo == 20
replace code_INEGI = 20049 if polygon_name == "Magdalena Ocotl-n" & cve_edo == 20
replace code_INEGI = 20050 if polygon_name == "Magdalena Pe-asco" & cve_edo == 20
replace code_INEGI = 20051 if polygon_name == "Magdalena Teitipac" & cve_edo == 20
replace code_INEGI = 20052 if polygon_name == "Magdalena Tequisistl-n" & cve_edo == 20
replace code_INEGI = 20053 if polygon_name == "Magdalena Tlacotepec" & cve_edo == 20
replace code_INEGI = 20054 if polygon_name == "Magdalena Zahuatl-n" & cve_edo == 20
replace code_INEGI = 20055 if polygon_name == "Mariscala de Ju-rez" & cve_edo == 20
replace code_INEGI = 20056 if polygon_name == "M-rtires de Tacubaya" & cve_edo == 20
replace code_INEGI = 20057 if polygon_name == "Mat-as Romero Avenda-o" & cve_edo == 20
replace code_INEGI = 20058 if polygon_name == "Mazatl-n Villa de Flores" & cve_edo == 20
replace code_INEGI = 20059 if polygon_name == "Miahuatl-n de Porfirio D-az" & cve_edo == 20
replace code_INEGI = 20060 if polygon_name == "Mixistl-n de la Reforma" & cve_edo == 20
replace code_INEGI = 20061 if polygon_name == "Monjas" & cve_edo == 20
replace code_INEGI = 20062 if polygon_name == "Natividad" & cve_edo == 20
replace code_INEGI = 20063 if polygon_name == "Nazareno Etla" & cve_edo == 20
replace code_INEGI = 20064 if polygon_name == "Nejapa de Madero" & cve_edo == 20
replace code_INEGI = 20065 if polygon_name == "Ixpantepec Nieves" & cve_edo == 20
replace code_INEGI = 20066 if polygon_name == "Santiago Niltepec" & cve_edo == 20
replace code_INEGI = 20067 if polygon_name == "Oaxaca de Ju-rez" & cve_edo == 20
replace code_INEGI = 20068 if polygon_name == "Ocotl-n de Morelos" & cve_edo == 20
replace code_INEGI = 20069 if polygon_name == "La Pe" & cve_edo == 20
replace code_INEGI = 20070 if polygon_name == "Pinotepa de Don Luis" & cve_edo == 20
replace code_INEGI = 20071 if polygon_name == "Pluma Hidalgo" & cve_edo == 20
replace code_INEGI = 20072 if polygon_name == "San Jos- del Progreso" & cve_edo == 20
replace code_INEGI = 20073 if polygon_name == "Putla Villa de Guerrero" & cve_edo == 20
replace code_INEGI = 20074 if polygon_name == "Santa Catarina Quioquitani" & cve_edo == 20
replace code_INEGI = 20075 if polygon_name == "Reforma de Pineda" & cve_edo == 20
replace code_INEGI = 20076 if polygon_name == "La Reforma" & cve_edo == 20
replace code_INEGI = 20077 if polygon_name == "Reyes Etla" & cve_edo == 20
replace code_INEGI = 20078 if polygon_name == "Rojas de Cuauht-moc" & cve_edo == 20
replace code_INEGI = 20079 if polygon_name == "Salina Cruz" & cve_edo == 20
replace code_INEGI = 20080 if polygon_name == "San Agust-n Amatengo" & cve_edo == 20
replace code_INEGI = 20081 if polygon_name == "San Agust-n Atenango" & cve_edo == 20
replace code_INEGI = 20082 if polygon_name == "San Agust-n Chayuco" & cve_edo == 20
replace code_INEGI = 20083 if polygon_name == "San Agust-n de las Juntas" & cve_edo == 20
replace code_INEGI = 20084 if polygon_name == "San Agust-n Etla" & cve_edo == 20
replace code_INEGI = 20085 if polygon_name == "San Agust-n Loxicha" & cve_edo == 20
replace code_INEGI = 20086 if polygon_name == "San Agust-n Tlacotepec" & cve_edo == 20
replace code_INEGI = 20087 if polygon_name == "San Agust-n Yatareni" & cve_edo == 20
replace code_INEGI = 20088 if polygon_name == "San Andr-s Cabecera Nueva" & cve_edo == 20
replace code_INEGI = 20089 if polygon_name == "San Andr-s Dinicuiti" & cve_edo == 20
replace code_INEGI = 20090 if polygon_name == "San Andr-s Huaxpaltepec" & cve_edo == 20
replace code_INEGI = 20091 if polygon_name == "San Andr-s Huay-pam" & cve_edo == 20
replace code_INEGI = 20092 if polygon_name == "San Andr-s Ixtlahuaca" & cve_edo == 20
replace code_INEGI = 20093 if polygon_name == "San Andr-s Lagunas" & cve_edo == 20
replace code_INEGI = 20094 if polygon_name == "San Andr-s Nuxi-o" & cve_edo == 20
replace code_INEGI = 20095 if polygon_name == "San Andr-s Paxtl-n" & cve_edo == 20
replace code_INEGI = 20096 if polygon_name == "San Andr-s Sinaxtla" & cve_edo == 20
replace code_INEGI = 20097 if polygon_name == "San Andr-s Solaga" & cve_edo == 20
replace code_INEGI = 20098 if polygon_name == "San Andr-s Teotil-lpam" & cve_edo == 20
replace code_INEGI = 20099 if polygon_name == "San Andr-s Tepetlapa" & cve_edo == 20
replace code_INEGI = 20100 if polygon_name == "San Andr-s Ya-" & cve_edo == 20
replace code_INEGI = 20101 if polygon_name == "San Andr-s Zabache" & cve_edo == 20
replace code_INEGI = 20102 if polygon_name == "San Andr-s Zautla" & cve_edo == 20
replace code_INEGI = 20103 if polygon_name == "San Antonino Castillo Velasco" & cve_edo == 20
replace code_INEGI = 20104 if polygon_name == "San Antonino el Alto" & cve_edo == 20
replace code_INEGI = 20105 if polygon_name == "San Antonino Monte Verde" & cve_edo == 20
replace code_INEGI = 20106 if polygon_name == "San Antonio Acutla" & cve_edo == 20
replace code_INEGI = 20107 if polygon_name == "San Antonio de la Cal" & cve_edo == 20
replace code_INEGI = 20108 if polygon_name == "San Antonio Huitepec" & cve_edo == 20
replace code_INEGI = 20109 if polygon_name == "San Antonio Nanahuat-pam" & cve_edo == 20
replace code_INEGI = 20110 if polygon_name == "San Antonio Sinicahua" & cve_edo == 20
replace code_INEGI = 20111 if polygon_name == "San Antonio Tepetlapa" & cve_edo == 20
replace code_INEGI = 20112 if polygon_name == "San Baltazar Chichic-pam" & cve_edo == 20
replace code_INEGI = 20113 if polygon_name == "San Baltazar Loxicha" & cve_edo == 20
replace code_INEGI = 20114 if polygon_name == "San Baltazar Yatzachi el Bajo" & cve_edo == 20
replace code_INEGI = 20115 if polygon_name == "San Bartolo Coyotepec" & cve_edo == 20
replace code_INEGI = 20116 if polygon_name == "San Bartolom- Ayautla" & cve_edo == 20
replace code_INEGI = 20117 if polygon_name == "San Bartolom- Loxicha" & cve_edo == 20
replace code_INEGI = 20118 if polygon_name == "San Bartolom- Quialana" & cve_edo == 20
replace code_INEGI = 20119 if polygon_name == "San Bartolom- Yucua-e" & cve_edo == 20
replace code_INEGI = 20120 if polygon_name == "San Bartolom- Zoogocho" & cve_edo == 20
replace code_INEGI = 20121 if polygon_name == "San Bartolo Soyaltepec" & cve_edo == 20
replace code_INEGI = 20122 if polygon_name == "San Bartolo Yautepec" & cve_edo == 20
replace code_INEGI = 20123 if polygon_name == "San Bernardo Mixtepec" & cve_edo == 20
replace code_INEGI = 20124 if polygon_name == "San Blas Atempa" & cve_edo == 20
replace code_INEGI = 20125 if polygon_name == "San Carlos Yautepec" & cve_edo == 20
replace code_INEGI = 20126 if polygon_name == "San Crist-bal Amatl-n" & cve_edo == 20
replace code_INEGI = 20127 if polygon_name == "San Crist-bal Amoltepec" & cve_edo == 20
replace code_INEGI = 20128 if polygon_name == "San Crist-bal Lachirioag" & cve_edo == 20
replace code_INEGI = 20129 if polygon_name == "San Crist-bal Suchixtlahuaca" & cve_edo == 20
replace code_INEGI = 20130 if polygon_name == "San Dionisio del Mar" & cve_edo == 20
replace code_INEGI = 20131 if polygon_name == "San Dionisio Ocotepec" & cve_edo == 20
replace code_INEGI = 20132 if polygon_name == "San Dionisio Ocotl-n" & cve_edo == 20
replace code_INEGI = 20133 if polygon_name == "San Esteban Atatlahuca" & cve_edo == 20
replace code_INEGI = 20134 if polygon_name == "San Felipe Jalapa de D-az" & cve_edo == 20
replace code_INEGI = 20135 if polygon_name == "San Felipe Tejal-pam" & cve_edo == 20
replace code_INEGI = 20136 if polygon_name == "San Felipe Usila" & cve_edo == 20
replace code_INEGI = 20137 if polygon_name == "San Francisco Cahuacu-" & cve_edo == 20
replace code_INEGI = 20138 if polygon_name == "San Francisco Cajonos" & cve_edo == 20
replace code_INEGI = 20139 if polygon_name == "San Francisco Chapulapa" & cve_edo == 20
replace code_INEGI = 20140 if polygon_name == "San Francisco Chind-a" & cve_edo == 20
replace code_INEGI = 20141 if polygon_name == "San Francisco del Mar" & cve_edo == 20
replace code_INEGI = 20142 if polygon_name == "San Francisco Huehuetl-n" & cve_edo == 20
replace code_INEGI = 20143 if polygon_name == "San Francisco Ixhuat-n" & cve_edo == 20
replace code_INEGI = 20144 if polygon_name == "San Francisco Jaltepetongo" & cve_edo == 20
replace code_INEGI = 20145 if polygon_name == "San Francisco Lachigol-" & cve_edo == 20
replace code_INEGI = 20146 if polygon_name == "San Francisco Logueche" & cve_edo == 20
replace code_INEGI = 20147 if polygon_name == "San Francisco Nuxa-o" & cve_edo == 20
replace code_INEGI = 20148 if polygon_name == "San Francisco Ozolotepec" & cve_edo == 20
replace code_INEGI = 20149 if polygon_name == "San Francisco Sola" & cve_edo == 20
replace code_INEGI = 20150 if polygon_name == "San Francisco Telixtlahuaca" & cve_edo == 20
replace code_INEGI = 20151 if polygon_name == "San Francisco Teopan" & cve_edo == 20
replace code_INEGI = 20152 if polygon_name == "San Francisco Tlapancingo" & cve_edo == 20
replace code_INEGI = 20153 if polygon_name == "San Gabriel Mixtepec" & cve_edo == 20
replace code_INEGI = 20154 if polygon_name == "San Ildefonso Amatl-n" & cve_edo == 20
replace code_INEGI = 20155 if polygon_name == "San Ildefonso Sola" & cve_edo == 20
replace code_INEGI = 20156 if polygon_name == "San Ildefonso Villa Alta" & cve_edo == 20
replace code_INEGI = 20157 if polygon_name == "San Jacinto Amilpas" & cve_edo == 20
replace code_INEGI = 20158 if polygon_name == "San Jacinto Tlacotepec" & cve_edo == 20
replace code_INEGI = 20159 if polygon_name == "San Jer-nimo Coatl-n" & cve_edo == 20
replace code_INEGI = 20160 if polygon_name == "San Jer-nimo Silacayoapilla" & cve_edo == 20
replace code_INEGI = 20161 if polygon_name == "San Jer-nimo Sosola" & cve_edo == 20
replace code_INEGI = 20162 if polygon_name == "San Jer-nimo Taviche" & cve_edo == 20
replace code_INEGI = 20163 if polygon_name == "San Jer-nimo Tec-atl" & cve_edo == 20
replace code_INEGI = 20164 if polygon_name == "San Jorge Nuchita" & cve_edo == 20
replace code_INEGI = 20165 if polygon_name == "San Jos- Ayuquila" & cve_edo == 20
replace code_INEGI = 20166 if polygon_name == "San Jos- Chiltepec" & cve_edo == 20
replace code_INEGI = 20167 if polygon_name == "San Jos- del Pe-asco" & cve_edo == 20
replace code_INEGI = 20168 if polygon_name == "San Jos- Estancia Grande" & cve_edo == 20
replace code_INEGI = 20169 if polygon_name == "San Jos- Independencia" & cve_edo == 20
replace code_INEGI = 20170 if polygon_name == "San Jos- Lachiguiri" & cve_edo == 20
replace code_INEGI = 20171 if polygon_name == "San Jos- Tenango" & cve_edo == 20
replace code_INEGI = 20172 if polygon_name == "San Juan Achiutla" & cve_edo == 20
replace code_INEGI = 20173 if polygon_name == "San Juan Atepec" & cve_edo == 20
replace code_INEGI = 20174 if polygon_name == "-nimas Trujano" & cve_edo == 20
replace code_INEGI = 20175 if polygon_name == "San Juan Bautista Atatlahuca" & cve_edo == 20
replace code_INEGI = 20176 if polygon_name == "San Juan Bautista Coixtlahuaca" & cve_edo == 20
replace code_INEGI = 20177 if polygon_name == "San Juan Bautista Cuicatl-n" & cve_edo == 20
replace code_INEGI = 20178 if polygon_name == "San Juan Bautista Guelache" & cve_edo == 20
replace code_INEGI = 20179 if polygon_name == "San Juan Bautista Jayacatl-n" & cve_edo == 20
replace code_INEGI = 20180 if polygon_name == "San Juan Bautista Lo de Soto" & cve_edo == 20
replace code_INEGI = 20181 if polygon_name == "San Juan Bautista Suchitepec" & cve_edo == 20
replace code_INEGI = 20182 if polygon_name == "San Juan Bautista Tlacoatzintepec" & cve_edo == 20
replace code_INEGI = 20183 if polygon_name == "San Juan Bautista Tlachichilco" & cve_edo == 20
replace code_INEGI = 20184 if polygon_name == "San Juan Bautista Tuxtepec" & cve_edo == 20
replace code_INEGI = 20185 if polygon_name == "San Juan Cacahuatepec" & cve_edo == 20
replace code_INEGI = 20186 if polygon_name == "San Juan Cieneguilla" & cve_edo == 20
replace code_INEGI = 20187 if polygon_name == "San Juan Coatz-spam" & cve_edo == 20
replace code_INEGI = 20188 if polygon_name == "San Juan Colorado" & cve_edo == 20
replace code_INEGI = 20189 if polygon_name == "San Juan Comaltepec" & cve_edo == 20
replace code_INEGI = 20190 if polygon_name == "San Juan Cotzoc-n" & cve_edo == 20
replace code_INEGI = 20191 if polygon_name == "San Juan Chicomez-chil" & cve_edo == 20
replace code_INEGI = 20192 if polygon_name == "San Juan Chilateca" & cve_edo == 20
replace code_INEGI = 20193 if polygon_name == "San Juan del Estado" & cve_edo == 20
replace code_INEGI = 20194 if polygon_name == "San Juan del R-o" & cve_edo == 20
replace code_INEGI = 20195 if polygon_name == "San Juan Diuxi" & cve_edo == 20
replace code_INEGI = 20196 if polygon_name == "San Juan Evangelista Analco" & cve_edo == 20
replace code_INEGI = 20197 if polygon_name == "San Juan Guelav-a" & cve_edo == 20
replace code_INEGI = 20198 if polygon_name == "San Juan Guichicovi" & cve_edo == 20
replace code_INEGI = 20199 if polygon_name == "San Juan Ihualtepec" & cve_edo == 20
replace code_INEGI = 20200 if polygon_name == "San Juan Juquila Mixes" & cve_edo == 20
replace code_INEGI = 20201 if polygon_name == "San Juan Juquila Vijanos" & cve_edo == 20
replace code_INEGI = 20202 if polygon_name == "San Juan Lachao" & cve_edo == 20
replace code_INEGI = 20203 if polygon_name == "San Juan Lachigalla" & cve_edo == 20
replace code_INEGI = 20204 if polygon_name == "San Juan Lajarcia" & cve_edo == 20
replace code_INEGI = 20205 if polygon_name == "San Juan Lalana" & cve_edo == 20
replace code_INEGI = 20206 if polygon_name == "San Juan de los Cu-s" & cve_edo == 20
replace code_INEGI = 20207 if polygon_name == "San Juan Mazatl-n" & cve_edo == 20
replace code_INEGI = 20208 if polygon_name == "San Juan Mixtepec Distrito 08" & cve_edo == 20
replace code_INEGI = 20209 if polygon_name == "San Juan Mixtepec Distrito 26" & cve_edo == 20
replace code_INEGI = 20210 if polygon_name == "San Juan -um-" & cve_edo == 20
replace code_INEGI = 20211 if polygon_name == "San Juan Ozolotepec" & cve_edo == 20
replace code_INEGI = 20212 if polygon_name == "San Juan Petlapa" & cve_edo == 20
replace code_INEGI = 20213 if polygon_name == "San Juan Quiahije" & cve_edo == 20
replace code_INEGI = 20214 if polygon_name == "San Juan Quiotepec" & cve_edo == 20
replace code_INEGI = 20215 if polygon_name == "San Juan Sayultepec" & cve_edo == 20
replace code_INEGI = 20216 if polygon_name == "San Juan Taba-" & cve_edo == 20
replace code_INEGI = 20217 if polygon_name == "San Juan Tamazola" & cve_edo == 20
replace code_INEGI = 20218 if polygon_name == "San Juan Teita" & cve_edo == 20
replace code_INEGI = 20219 if polygon_name == "San Juan Teitipac" & cve_edo == 20
replace code_INEGI = 20220 if polygon_name == "San Juan Tepeuxila" & cve_edo == 20
replace code_INEGI = 20221 if polygon_name == "San Juan Teposcolula" & cve_edo == 20
replace code_INEGI = 20222 if polygon_name == "San Juan Yae-" & cve_edo == 20
replace code_INEGI = 20223 if polygon_name == "San Juan Yatzona" & cve_edo == 20
replace code_INEGI = 20224 if polygon_name == "San Juan Yucuita" & cve_edo == 20
replace code_INEGI = 20225 if polygon_name == "San Lorenzo" & cve_edo == 20
replace code_INEGI = 20226 if polygon_name == "San Lorenzo Albarradas" & cve_edo == 20
replace code_INEGI = 20227 if polygon_name == "San Lorenzo Cacaotepec" & cve_edo == 20
replace code_INEGI = 20228 if polygon_name == "San Lorenzo Cuaunecuiltitla" & cve_edo == 20
replace code_INEGI = 20229 if polygon_name == "San Lorenzo Texmel-can" & cve_edo == 20
replace code_INEGI = 20230 if polygon_name == "San Lorenzo Victoria" & cve_edo == 20
replace code_INEGI = 20231 if polygon_name == "San Lucas Camotl-n" & cve_edo == 20
replace code_INEGI = 20232 if polygon_name == "San Lucas Ojitl-n" & cve_edo == 20
replace code_INEGI = 20233 if polygon_name == "San Lucas Quiavin-" & cve_edo == 20
replace code_INEGI = 20234 if polygon_name == "San Lucas Zoqui-pam" & cve_edo == 20
replace code_INEGI = 20235 if polygon_name == "San Luis Amatl-n" & cve_edo == 20
replace code_INEGI = 20236 if polygon_name == "San Marcial Ozolotepec" & cve_edo == 20
replace code_INEGI = 20237 if polygon_name == "San Marcos Arteaga" & cve_edo == 20
replace code_INEGI = 20238 if polygon_name == "San Mart-n de los Cansecos" & cve_edo == 20
replace code_INEGI = 20239 if polygon_name == "San Mart-n Huamel-lpam" & cve_edo == 20
replace code_INEGI = 20240 if polygon_name == "San Mart-n Itunyoso" & cve_edo == 20
replace code_INEGI = 20241 if polygon_name == "San Mart-n Lachil-" & cve_edo == 20
replace code_INEGI = 20242 if polygon_name == "San Mart-n Peras" & cve_edo == 20
replace code_INEGI = 20243 if polygon_name == "San Mart-n Tilcajete" & cve_edo == 20
replace code_INEGI = 20244 if polygon_name == "San Mart-n Toxpalan" & cve_edo == 20
replace code_INEGI = 20245 if polygon_name == "San Mart-n Zacatepec" & cve_edo == 20
replace code_INEGI = 20246 if polygon_name == "San Mateo Cajonos" & cve_edo == 20
replace code_INEGI = 20247 if polygon_name == "Capul-lpam de M-ndez" & cve_edo == 20
replace code_INEGI = 20248 if polygon_name == "San Mateo del Mar" & cve_edo == 20
replace code_INEGI = 20249 if polygon_name == "San Mateo Yoloxochitl-n" & cve_edo == 20
replace code_INEGI = 20250 if polygon_name == "San Mateo Etlatongo" & cve_edo == 20
replace code_INEGI = 20251 if polygon_name == "San Mateo Nej-pam" & cve_edo == 20
replace code_INEGI = 20252 if polygon_name == "San Mateo Pe-asco" & cve_edo == 20
replace code_INEGI = 20253 if polygon_name == "San Mateo Pi-as" & cve_edo == 20
replace code_INEGI = 20254 if polygon_name == "San Mateo R-o Hondo" & cve_edo == 20
replace code_INEGI = 20255 if polygon_name == "San Mateo Sindihui" & cve_edo == 20
replace code_INEGI = 20256 if polygon_name == "San Mateo Tlapiltepec" & cve_edo == 20
replace code_INEGI = 20257 if polygon_name == "San Melchor Betaza" & cve_edo == 20
replace code_INEGI = 20258 if polygon_name == "San Miguel Achiutla" & cve_edo == 20
replace code_INEGI = 20259 if polygon_name == "San Miguel Ahuehuetitl-n" & cve_edo == 20
replace code_INEGI = 20260 if polygon_name == "San Miguel Alo-pam" & cve_edo == 20
replace code_INEGI = 20261 if polygon_name == "San Miguel Amatitl-n" & cve_edo == 20
replace code_INEGI = 20262 if polygon_name == "San Miguel Amatl-n" & cve_edo == 20
replace code_INEGI = 20263 if polygon_name == "San Miguel Coatl-n" & cve_edo == 20
replace code_INEGI = 20264 if polygon_name == "San Miguel Chicahua" & cve_edo == 20
replace code_INEGI = 20265 if polygon_name == "San Miguel Chimalapa" & cve_edo == 20
replace code_INEGI = 20266 if polygon_name == "San Miguel del Puerto" & cve_edo == 20
replace code_INEGI = 20267 if polygon_name == "San Miguel del R-o" & cve_edo == 20
replace code_INEGI = 20268 if polygon_name == "San Miguel Ejutla" & cve_edo == 20
replace code_INEGI = 20269 if polygon_name == "San Miguel el Grande" & cve_edo == 20
replace code_INEGI = 20270 if polygon_name == "San Miguel Huautla" & cve_edo == 20
replace code_INEGI = 20271 if polygon_name == "San Miguel Mixtepec" & cve_edo == 20
replace code_INEGI = 20272 if polygon_name == "San Miguel Panixtlahuaca" & cve_edo == 20
replace code_INEGI = 20273 if polygon_name == "San Miguel Peras" & cve_edo == 20
replace code_INEGI = 20274 if polygon_name == "San Miguel Piedras" & cve_edo == 20
replace code_INEGI = 20275 if polygon_name == "San Miguel Quetzaltepec" & cve_edo == 20
replace code_INEGI = 20276 if polygon_name == "San Miguel Santa Flor" & cve_edo == 20
replace code_INEGI = 20277 if polygon_name == "Villa Sola de Vega" & cve_edo == 20
replace code_INEGI = 20278 if polygon_name == "San Miguel Soyaltepec" & cve_edo == 20
replace code_INEGI = 20279 if polygon_name == "San Miguel Suchixtepec" & cve_edo == 20
replace code_INEGI = 20280 if polygon_name == "Villa Talea de Castro" & cve_edo == 20
replace code_INEGI = 20281 if polygon_name == "San Miguel Tecomatl-n" & cve_edo == 20
replace code_INEGI = 20282 if polygon_name == "San Miguel Tenango" & cve_edo == 20
replace code_INEGI = 20283 if polygon_name == "San Miguel Tequixtepec" & cve_edo == 20
replace code_INEGI = 20284 if polygon_name == "San Miguel Tilqui-pam" & cve_edo == 20
replace code_INEGI = 20285 if polygon_name == "San Miguel Tlacamama" & cve_edo == 20
replace code_INEGI = 20286 if polygon_name == "San Miguel Tlacotepec" & cve_edo == 20
replace code_INEGI = 20287 if polygon_name == "San Miguel Tulancingo" & cve_edo == 20
replace code_INEGI = 20288 if polygon_name == "San Miguel Yotao" & cve_edo == 20
replace code_INEGI = 20289 if polygon_name == "San Nicol-s" & cve_edo == 20
replace code_INEGI = 20290 if polygon_name == "San Nicol-s Hidalgo" & cve_edo == 20
replace code_INEGI = 20291 if polygon_name == "San Pablo Coatl-n" & cve_edo == 20
replace code_INEGI = 20292 if polygon_name == "San Pablo Cuatro Venados" & cve_edo == 20
replace code_INEGI = 20293 if polygon_name == "San Pablo Etla" & cve_edo == 20
replace code_INEGI = 20294 if polygon_name == "San Pablo Huitzo" & cve_edo == 20
replace code_INEGI = 20295 if polygon_name == "San Pablo Huixtepec" & cve_edo == 20
replace code_INEGI = 20296 if polygon_name == "San Pablo Macuiltianguis" & cve_edo == 20
replace code_INEGI = 20297 if polygon_name == "San Pablo Tijaltepec" & cve_edo == 20
replace code_INEGI = 20298 if polygon_name == "San Pablo Villa de Mitla" & cve_edo == 20
replace code_INEGI = 20299 if polygon_name == "San Pablo Yaganiza" & cve_edo == 20
replace code_INEGI = 20300 if polygon_name == "San Pedro Amuzgos" & cve_edo == 20
replace code_INEGI = 20301 if polygon_name == "San Pedro Ap-stol" & cve_edo == 20
replace code_INEGI = 20302 if polygon_name == "San Pedro Atoyac" & cve_edo == 20
replace code_INEGI = 20303 if polygon_name == "San Pedro Cajonos" & cve_edo == 20
replace code_INEGI = 20304 if polygon_name == "San Pedro Coxcaltepec C-ntaros" & cve_edo == 20
replace code_INEGI = 20305 if polygon_name == "San Pedro Comitancillo" & cve_edo == 20
replace code_INEGI = 20306 if polygon_name == "San Pedro el Alto" & cve_edo == 20
replace code_INEGI = 20307 if polygon_name == "San Pedro Huamelula" & cve_edo == 20
replace code_INEGI = 20308 if polygon_name == "San Pedro Huilotepec" & cve_edo == 20
replace code_INEGI = 20309 if polygon_name == "San Pedro Ixcatl-n" & cve_edo == 20
replace code_INEGI = 20310 if polygon_name == "San Pedro Ixtlahuaca" & cve_edo == 20
replace code_INEGI = 20311 if polygon_name == "San Pedro Jaltepetongo" & cve_edo == 20
replace code_INEGI = 20312 if polygon_name == "San Pedro Jicay-n" & cve_edo == 20
replace code_INEGI = 20313 if polygon_name == "San Pedro Jocotipac" & cve_edo == 20
replace code_INEGI = 20314 if polygon_name == "San Pedro Juchatengo" & cve_edo == 20
replace code_INEGI = 20315 if polygon_name == "San Pedro M-rtir" & cve_edo == 20
replace code_INEGI = 20316 if polygon_name == "San Pedro M-rtir Quiechapa" & cve_edo == 20
replace code_INEGI = 20317 if polygon_name == "San Pedro M-rtir Yucuxaco" & cve_edo == 20
replace code_INEGI = 20318 if polygon_name == "San Pedro Mixtepec Distrito 22" & cve_edo == 20
replace code_INEGI = 20319 if polygon_name == "San Pedro Mixtepec Distrito 26" & cve_edo == 20
replace code_INEGI = 20320 if polygon_name == "San Pedro Molinos" & cve_edo == 20
replace code_INEGI = 20321 if polygon_name == "San Pedro Nopala" & cve_edo == 20
replace code_INEGI = 20322 if polygon_name == "San Pedro Ocopetatillo" & cve_edo == 20
replace code_INEGI = 20323 if polygon_name == "San Pedro Ocotepec" & cve_edo == 20
replace code_INEGI = 20324 if polygon_name == "San Pedro Pochutla" & cve_edo == 20
replace code_INEGI = 20325 if polygon_name == "San Pedro Quiatoni" & cve_edo == 20
replace code_INEGI = 20326 if polygon_name == "San Pedro Sochi-pam" & cve_edo == 20
replace code_INEGI = 20327 if polygon_name == "San Pedro Tapanatepec" & cve_edo == 20
replace code_INEGI = 20328 if polygon_name == "San Pedro Taviche" & cve_edo == 20
replace code_INEGI = 20329 if polygon_name == "San Pedro Teozacoalco" & cve_edo == 20
replace code_INEGI = 20330 if polygon_name == "San Pedro Teutila" & cve_edo == 20
replace code_INEGI = 20331 if polygon_name == "San Pedro Tida-" & cve_edo == 20
replace code_INEGI = 20332 if polygon_name == "San Pedro Topiltepec" & cve_edo == 20
replace code_INEGI = 20333 if polygon_name == "San Pedro Totol-pam" & cve_edo == 20
replace code_INEGI = 20334 if polygon_name == "Villa de Tututepec" & cve_edo == 20
replace code_INEGI = 20335 if polygon_name == "San Pedro Yaneri" & cve_edo == 20
replace code_INEGI = 20336 if polygon_name == "San Pedro Y-lox" & cve_edo == 20
replace code_INEGI = 20337 if polygon_name == "San Pedro y San Pablo Ayutla" & cve_edo == 20
replace code_INEGI = 20338 if polygon_name == "Villa de Etla" & cve_edo == 20
replace code_INEGI = 20339 if polygon_name == "San Pedro y San Pablo Teposcolula" & cve_edo == 20
replace code_INEGI = 20340 if polygon_name == "San Pedro y San Pablo Tequixtepec" & cve_edo == 20
replace code_INEGI = 20341 if polygon_name == "San Pedro Yucunama" & cve_edo == 20
replace code_INEGI = 20342 if polygon_name == "San Raymundo Jalpan" & cve_edo == 20
replace code_INEGI = 20343 if polygon_name == "San Sebasti-n Abasolo" & cve_edo == 20
replace code_INEGI = 20344 if polygon_name == "San Sebasti-n Coatl-n" & cve_edo == 20
replace code_INEGI = 20345 if polygon_name == "San Sebasti-n Ixcapa" & cve_edo == 20
replace code_INEGI = 20346 if polygon_name == "San Sebasti-n Nicananduta" & cve_edo == 20
replace code_INEGI = 20347 if polygon_name == "San Sebasti-n R-o Hondo" & cve_edo == 20
replace code_INEGI = 20348 if polygon_name == "San Sebasti-n Tecomaxtlahuaca" & cve_edo == 20
replace code_INEGI = 20349 if polygon_name == "San Sebasti-n Teitipac" & cve_edo == 20
replace code_INEGI = 20350 if polygon_name == "San Sebasti-n Tutla" & cve_edo == 20
replace code_INEGI = 20351 if polygon_name == "San Sim-n Almolongas" & cve_edo == 20
replace code_INEGI = 20352 if polygon_name == "San Sim-n Zahuatl-n" & cve_edo == 20
replace code_INEGI = 20353 if polygon_name == "Santa Ana" & cve_edo == 20
replace code_INEGI = 20354 if polygon_name == "Santa Ana Ateixtlahuaca" & cve_edo == 20
replace code_INEGI = 20355 if polygon_name == "Santa Ana Cuauht-moc" & cve_edo == 20
replace code_INEGI = 20356 if polygon_name == "Santa Ana del Valle" & cve_edo == 20
replace code_INEGI = 20357 if polygon_name == "Santa Ana Tavela" & cve_edo == 20
replace code_INEGI = 20358 if polygon_name == "Santa Ana Tlapacoyan" & cve_edo == 20
replace code_INEGI = 20359 if polygon_name == "Santa Ana Yareni" & cve_edo == 20
replace code_INEGI = 20360 if polygon_name == "Santa Ana Zegache" & cve_edo == 20
replace code_INEGI = 20361 if polygon_name == "Santa Catalina Quier-" & cve_edo == 20
replace code_INEGI = 20362 if polygon_name == "Santa Catarina Cuixtla" & cve_edo == 20
replace code_INEGI = 20363 if polygon_name == "Santa Catarina Ixtepeji" & cve_edo == 20
replace code_INEGI = 20364 if polygon_name == "Santa Catarina Juquila" & cve_edo == 20
replace code_INEGI = 20365 if polygon_name == "Santa Catarina Lachatao" & cve_edo == 20
replace code_INEGI = 20366 if polygon_name == "Santa Catarina Loxicha" & cve_edo == 20
replace code_INEGI = 20367 if polygon_name == "Santa Catarina Mechoac-n" & cve_edo == 20
replace code_INEGI = 20368 if polygon_name == "Santa Catarina Minas" & cve_edo == 20
replace code_INEGI = 20369 if polygon_name == "Santa Catarina Quian-" & cve_edo == 20
replace code_INEGI = 20370 if polygon_name == "Santa Catarina Tayata" & cve_edo == 20
replace code_INEGI = 20371 if polygon_name == "Santa Catarina Ticu-" & cve_edo == 20
replace code_INEGI = 20372 if polygon_name == "Santa Catarina Yosonot-" & cve_edo == 20
replace code_INEGI = 20373 if polygon_name == "Santa Catarina Zapoquila" & cve_edo == 20
replace code_INEGI = 20374 if polygon_name == "Santa Cruz Acatepec" & cve_edo == 20
replace code_INEGI = 20375 if polygon_name == "Santa Cruz Amilpas" & cve_edo == 20
replace code_INEGI = 20376 if polygon_name == "Santa Cruz de Bravo" & cve_edo == 20
replace code_INEGI = 20377 if polygon_name == "Santa Cruz Itundujia" & cve_edo == 20
replace code_INEGI = 20378 if polygon_name == "Santa Cruz Mixtepec" & cve_edo == 20
replace code_INEGI = 20379 if polygon_name == "Santa Cruz Nundaco" & cve_edo == 20
replace code_INEGI = 20380 if polygon_name == "Santa Cruz Papalutla" & cve_edo == 20
replace code_INEGI = 20381 if polygon_name == "Santa Cruz Tacache de Mina" & cve_edo == 20
replace code_INEGI = 20382 if polygon_name == "Santa Cruz Tacahua" & cve_edo == 20
replace code_INEGI = 20383 if polygon_name == "Santa Cruz Tayata" & cve_edo == 20
replace code_INEGI = 20384 if polygon_name == "Santa Cruz Xitla" & cve_edo == 20
replace code_INEGI = 20385 if polygon_name == "Santa Cruz Xoxocotl-n" & cve_edo == 20
replace code_INEGI = 20386 if polygon_name == "Santa Cruz Zenzontepec" & cve_edo == 20
replace code_INEGI = 20387 if polygon_name == "Santa Gertrudis" & cve_edo == 20
replace code_INEGI = 20388 if polygon_name == "Santa In-s del Monte" & cve_edo == 20
replace code_INEGI = 20389 if polygon_name == "Santa In-s Yatzeche" & cve_edo == 20
replace code_INEGI = 20390 if polygon_name == "Santa Luc-a del Camino" & cve_edo == 20
replace code_INEGI = 20391 if polygon_name == "Santa Luc-a Miahuatl-n" & cve_edo == 20
replace code_INEGI = 20392 if polygon_name == "Santa Luc-a Monteverde" & cve_edo == 20
replace code_INEGI = 20393 if polygon_name == "Santa Luc-a Ocotl-n" & cve_edo == 20
replace code_INEGI = 20394 if polygon_name == "Santa Mar-a Alotepec" & cve_edo == 20
replace code_INEGI = 20395 if polygon_name == "Santa Mar-a Apazco" & cve_edo == 20
replace code_INEGI = 20396 if polygon_name == "Santa Mar-a la Asunci-n" & cve_edo == 20
replace code_INEGI = 20397 if polygon_name == "Heroica Ciudad de Tlaxiaco" & cve_edo == 20
replace code_INEGI = 20398 if polygon_name == "Ayoquezco de Aldama" & cve_edo == 20
replace code_INEGI = 20399 if polygon_name == "Santa Mar-a Atzompa" & cve_edo == 20
replace code_INEGI = 20400 if polygon_name == "Santa Mar-a Camotl-n" & cve_edo == 20
replace code_INEGI = 20401 if polygon_name == "Santa Mar-a Colotepec" & cve_edo == 20
replace code_INEGI = 20402 if polygon_name == "Santa Mar-a Cortijo" & cve_edo == 20
replace code_INEGI = 20403 if polygon_name == "Santa Mar-a Coyotepec" & cve_edo == 20
replace code_INEGI = 20404 if polygon_name == "Santa Mar-a Chacho-pam" & cve_edo == 20
replace code_INEGI = 20405 if polygon_name == "Villa de Chilapa de D-az" & cve_edo == 20
replace code_INEGI = 20406 if polygon_name == "Santa Mar-a Chilchotla" & cve_edo == 20
replace code_INEGI = 20407 if polygon_name == "Santa Mar-a Chimalapa" & cve_edo == 20
replace code_INEGI = 20408 if polygon_name == "Santa Mar-a del Rosario" & cve_edo == 20
replace code_INEGI = 20409 if polygon_name == "Santa Mar-a del Tule" & cve_edo == 20
replace code_INEGI = 20410 if polygon_name == "Santa Mar-a Ecatepec" & cve_edo == 20
replace code_INEGI = 20411 if polygon_name == "Santa Mar-a Guelac-" & cve_edo == 20
replace code_INEGI = 20412 if polygon_name == "Santa Mar-a Guienagati" & cve_edo == 20
replace code_INEGI = 20413 if polygon_name == "Santa Mar-a Huatulco" & cve_edo == 20
replace code_INEGI = 20414 if polygon_name == "Santa Mar-a Huazolotitl-n" & cve_edo == 20
replace code_INEGI = 20415 if polygon_name == "Santa Mar-a Ipalapa" & cve_edo == 20
replace code_INEGI = 20416 if polygon_name == "Santa Mar-a Ixcatl-n" & cve_edo == 20
replace code_INEGI = 20417 if polygon_name == "Santa Mar-a Jacatepec" & cve_edo == 20
replace code_INEGI = 20418 if polygon_name == "Santa Mar-a Jalapa del Marqu-s" & cve_edo == 20
replace code_INEGI = 20419 if polygon_name == "Santa Mar-a Jaltianguis" & cve_edo == 20
replace code_INEGI = 20420 if polygon_name == "Santa Mar-a Lachix-o" & cve_edo == 20
replace code_INEGI = 20421 if polygon_name == "Santa Mar-a Mixtequilla" & cve_edo == 20
replace code_INEGI = 20422 if polygon_name == "Santa Mar-a Nativitas" & cve_edo == 20
replace code_INEGI = 20423 if polygon_name == "Santa Mar-a Nduayaco" & cve_edo == 20
replace code_INEGI = 20424 if polygon_name == "Santa Mar-a Ozolotepec" & cve_edo == 20
replace code_INEGI = 20425 if polygon_name == "Santa Mar-a P-palo" & cve_edo == 20
replace code_INEGI = 20426 if polygon_name == "Santa Mar-a Pe-oles" & cve_edo == 20
replace code_INEGI = 20427 if polygon_name == "Santa Mar-a Petapa" & cve_edo == 20
replace code_INEGI = 20428 if polygon_name == "Santa Mar-a Quiegolani" & cve_edo == 20
replace code_INEGI = 20429 if polygon_name == "Santa Mar-a Sola" & cve_edo == 20
replace code_INEGI = 20430 if polygon_name == "Santa Mar-a Tataltepec" & cve_edo == 20
replace code_INEGI = 20431 if polygon_name == "Santa Mar-a Tecomavaca" & cve_edo == 20
replace code_INEGI = 20432 if polygon_name == "Santa Mar-a Temaxcalapa" & cve_edo == 20
replace code_INEGI = 20433 if polygon_name == "Santa Mar-a Temaxcaltepec" & cve_edo == 20
replace code_INEGI = 20434 if polygon_name == "Santa Mar-a Teopoxco" & cve_edo == 20
replace code_INEGI = 20435 if polygon_name == "Santa Mar-a Tepantlali" & cve_edo == 20
replace code_INEGI = 20436 if polygon_name == "Santa Mar-a Texcatitl-n" & cve_edo == 20
replace code_INEGI = 20437 if polygon_name == "Santa Mar-a Tlahuitoltepec" & cve_edo == 20
replace code_INEGI = 20438 if polygon_name == "Santa Mar-a Tlalixtac" & cve_edo == 20
replace code_INEGI = 20439 if polygon_name == "Santa Mar-a Tonameca" & cve_edo == 20
replace code_INEGI = 20440 if polygon_name == "Santa Mar-a Totolapilla" & cve_edo == 20
replace code_INEGI = 20441 if polygon_name == "Santa Mar-a Xadani" & cve_edo == 20
replace code_INEGI = 20442 if polygon_name == "Santa Mar-a Yalina" & cve_edo == 20
replace code_INEGI = 20443 if polygon_name == "Santa Mar-a Yaves-a" & cve_edo == 20
replace code_INEGI = 20444 if polygon_name == "Santa Mar-a Yolotepec" & cve_edo == 20
replace code_INEGI = 20445 if polygon_name == "Santa Mar-a Yosoy-a" & cve_edo == 20
replace code_INEGI = 20446 if polygon_name == "Santa Mar-a Yucuhiti" & cve_edo == 20
replace code_INEGI = 20447 if polygon_name == "Santa Mar-a Zacatepec" & cve_edo == 20
replace code_INEGI = 20448 if polygon_name == "Santa Mar-a Zaniza" & cve_edo == 20
replace code_INEGI = 20449 if polygon_name == "Santa Mar-a Zoquitl-n" & cve_edo == 20
replace code_INEGI = 20450 if polygon_name == "Santiago Amoltepec" & cve_edo == 20
replace code_INEGI = 20451 if polygon_name == "Santiago Apoala" & cve_edo == 20
replace code_INEGI = 20452 if polygon_name == "Santiago Ap-stol" & cve_edo == 20
replace code_INEGI = 20453 if polygon_name == "Santiago Astata" & cve_edo == 20
replace code_INEGI = 20454 if polygon_name == "Santiago Atitl-n" & cve_edo == 20
replace code_INEGI = 20455 if polygon_name == "Santiago Ayuquililla" & cve_edo == 20
replace code_INEGI = 20456 if polygon_name == "Santiago Cacaloxtepec" & cve_edo == 20
replace code_INEGI = 20457 if polygon_name == "Santiago Camotl-n" & cve_edo == 20
replace code_INEGI = 20458 if polygon_name == "Santiago Comaltepec" & cve_edo == 20
replace code_INEGI = 20459 if polygon_name == "Villa de Santiago Chazumba" & cve_edo == 20
replace code_INEGI = 20460 if polygon_name == "Santiago Cho-pam" & cve_edo == 20
replace code_INEGI = 20461 if polygon_name == "Santiago del R-o" & cve_edo == 20
replace code_INEGI = 20462 if polygon_name == "Santiago Huajolotitl-n" & cve_edo == 20
replace code_INEGI = 20463 if polygon_name == "Santiago Huauclilla" & cve_edo == 20
replace code_INEGI = 20464 if polygon_name == "Santiago Ihuitl-n Plumas" & cve_edo == 20
replace code_INEGI = 20465 if polygon_name == "Santiago Ixcuintepec" & cve_edo == 20
replace code_INEGI = 20466 if polygon_name == "Santiago Ixtayutla" & cve_edo == 20
replace code_INEGI = 20467 if polygon_name == "Santiago Jamiltepec" & cve_edo == 20
replace code_INEGI = 20468 if polygon_name == "Santiago Jocotepec" & cve_edo == 20
replace code_INEGI = 20469 if polygon_name == "Santiago Juxtlahuaca" & cve_edo == 20
replace code_INEGI = 20470 if polygon_name == "Santiago Lachiguiri" & cve_edo == 20
replace code_INEGI = 20471 if polygon_name == "Santiago Lalopa" & cve_edo == 20
replace code_INEGI = 20472 if polygon_name == "Santiago Laollaga" & cve_edo == 20
replace code_INEGI = 20473 if polygon_name == "Santiago Laxopa" & cve_edo == 20
replace code_INEGI = 20474 if polygon_name == "Santiago Llano Grande" & cve_edo == 20
replace code_INEGI = 20475 if polygon_name == "Santiago Matatl-n" & cve_edo == 20
replace code_INEGI = 20476 if polygon_name == "Santiago Miltepec" & cve_edo == 20
replace code_INEGI = 20477 if polygon_name == "Santiago Minas" & cve_edo == 20
replace code_INEGI = 20478 if polygon_name == "Santiago Nacaltepec" & cve_edo == 20
replace code_INEGI = 20479 if polygon_name == "Santiago Nejapilla" & cve_edo == 20
replace code_INEGI = 20480 if polygon_name == "Santiago Nundiche" & cve_edo == 20
replace code_INEGI = 20481 if polygon_name == "Santiago Nuyo-" & cve_edo == 20
replace code_INEGI = 20482 if polygon_name == "Santiago Pinotepa Nacional" & cve_edo == 20
replace code_INEGI = 20483 if polygon_name == "Santiago Suchilquitongo" & cve_edo == 20
replace code_INEGI = 20484 if polygon_name == "Santiago Tamazola" & cve_edo == 20
replace code_INEGI = 20485 if polygon_name == "Santiago Tapextla" & cve_edo == 20
replace code_INEGI = 20486 if polygon_name == "Villa Tej-pam de la Uni-n" & cve_edo == 20
replace code_INEGI = 20487 if polygon_name == "Santiago Tenango" & cve_edo == 20
replace code_INEGI = 20488 if polygon_name == "Santiago Tepetlapa" & cve_edo == 20
replace code_INEGI = 20489 if polygon_name == "Santiago Tetepec" & cve_edo == 20
replace code_INEGI = 20490 if polygon_name == "Santiago Texcalcingo" & cve_edo == 20
replace code_INEGI = 20491 if polygon_name == "Santiago Textitl-n" & cve_edo == 20
replace code_INEGI = 20492 if polygon_name == "Santiago Tilantongo" & cve_edo == 20
replace code_INEGI = 20493 if polygon_name == "Santiago Tillo" & cve_edo == 20
replace code_INEGI = 20494 if polygon_name == "Santiago Tlazoyaltepec" & cve_edo == 20
replace code_INEGI = 20495 if polygon_name == "Santiago Xanica" & cve_edo == 20
replace code_INEGI = 20496 if polygon_name == "Santiago Xiacu-" & cve_edo == 20
replace code_INEGI = 20497 if polygon_name == "Santiago Yaitepec" & cve_edo == 20
replace code_INEGI = 20498 if polygon_name == "Santiago Yaveo" & cve_edo == 20
replace code_INEGI = 20499 if polygon_name == "Santiago Yolom-catl" & cve_edo == 20
replace code_INEGI = 20500 if polygon_name == "Santiago Yosond-a" & cve_edo == 20
replace code_INEGI = 20501 if polygon_name == "Santiago Yucuyachi" & cve_edo == 20
replace code_INEGI = 20502 if polygon_name == "Santiago Zacatepec" & cve_edo == 20
replace code_INEGI = 20503 if polygon_name == "Santiago Zoochila" & cve_edo == 20
replace code_INEGI = 20504 if polygon_name == "Nuevo Zoqui-pam" & cve_edo == 20
replace code_INEGI = 20505 if polygon_name == "Santo Domingo Ingenio" & cve_edo == 20
replace code_INEGI = 20506 if polygon_name == "Santo Domingo Albarradas" & cve_edo == 20
replace code_INEGI = 20507 if polygon_name == "Santo Domingo Armenta" & cve_edo == 20
replace code_INEGI = 20508 if polygon_name == "Santo Domingo Chihuit-n" & cve_edo == 20
replace code_INEGI = 20509 if polygon_name == "Santo Domingo de Morelos" & cve_edo == 20
replace code_INEGI = 20510 if polygon_name == "Santo Domingo Ixcatl-n" & cve_edo == 20
replace code_INEGI = 20511 if polygon_name == "Santo Domingo Nuxa-" & cve_edo == 20
replace code_INEGI = 20512 if polygon_name == "Santo Domingo Ozolotepec" & cve_edo == 20
replace code_INEGI = 20513 if polygon_name == "Santo Domingo Petapa" & cve_edo == 20
replace code_INEGI = 20514 if polygon_name == "Santo Domingo Roayaga" & cve_edo == 20
replace code_INEGI = 20515 if polygon_name == "Santo Domingo Tehuantepec" & cve_edo == 20
replace code_INEGI = 20516 if polygon_name == "Santo Domingo Teojomulco" & cve_edo == 20
replace code_INEGI = 20517 if polygon_name == "Santo Domingo Tepuxtepec" & cve_edo == 20
replace code_INEGI = 20518 if polygon_name == "Santo Domingo Tlatay-pam" & cve_edo == 20
replace code_INEGI = 20519 if polygon_name == "Santo Domingo Tomaltepec" & cve_edo == 20
replace code_INEGI = 20520 if polygon_name == "Santo Domingo Tonal-" & cve_edo == 20
replace code_INEGI = 20521 if polygon_name == "Santo Domingo Tonaltepec" & cve_edo == 20
replace code_INEGI = 20522 if polygon_name == "Santo Domingo Xagac-a" & cve_edo == 20
replace code_INEGI = 20523 if polygon_name == "Santo Domingo Yanhuitl-n" & cve_edo == 20
replace code_INEGI = 20524 if polygon_name == "Santo Domingo Yodohino" & cve_edo == 20
replace code_INEGI = 20525 if polygon_name == "Santo Domingo Zanatepec" & cve_edo == 20
replace code_INEGI = 20526 if polygon_name == "Santos Reyes Nopala" & cve_edo == 20
replace code_INEGI = 20527 if polygon_name == "Santos Reyes P-palo" & cve_edo == 20
replace code_INEGI = 20528 if polygon_name == "Santos Reyes Tepejillo" & cve_edo == 20
replace code_INEGI = 20529 if polygon_name == "Santos Reyes Yucun-" & cve_edo == 20
replace code_INEGI = 20530 if polygon_name == "Santo Tom-s Jalieza" & cve_edo == 20
replace code_INEGI = 20531 if polygon_name == "Santo Tom-s Mazaltepec" & cve_edo == 20
replace code_INEGI = 20532 if polygon_name == "Santo Tom-s Ocotepec" & cve_edo == 20
replace code_INEGI = 20533 if polygon_name == "Santo Tom-s Tamazulapan" & cve_edo == 20
replace code_INEGI = 20534 if polygon_name == "San Vicente Coatl-n" & cve_edo == 20
replace code_INEGI = 20535 if polygon_name == "San Vicente Lachix-o" & cve_edo == 20
replace code_INEGI = 20536 if polygon_name == "San Vicente Nu--" & cve_edo == 20
replace code_INEGI = 20537 if polygon_name == "Silacayo-pam" & cve_edo == 20
replace code_INEGI = 20538 if polygon_name == "Sitio de Xitlapehua" & cve_edo == 20
replace code_INEGI = 20539 if polygon_name == "Soledad Etla" & cve_edo == 20
replace code_INEGI = 20540 if polygon_name == "Villa de Tamazul-pam del Progreso" & cve_edo == 20
replace code_INEGI = 20541 if polygon_name == "Tanetze de Zaragoza" & cve_edo == 20
replace code_INEGI = 20542 if polygon_name == "Taniche" & cve_edo == 20
replace code_INEGI = 20543 if polygon_name == "Tataltepec de Vald-s" & cve_edo == 20
replace code_INEGI = 20544 if polygon_name == "Teococuilco de Marcos P-rez" & cve_edo == 20
replace code_INEGI = 20545 if polygon_name == "Teotitl-n de Flores Mag-n" & cve_edo == 20
replace code_INEGI = 20546 if polygon_name == "Teotitl-n del Valle" & cve_edo == 20
replace code_INEGI = 20547 if polygon_name == "Teotongo" & cve_edo == 20
replace code_INEGI = 20548 if polygon_name == "Tepelmeme Villa de Morelos" & cve_edo == 20
replace code_INEGI = 20549 if polygon_name == "Heroica Villa Tezoatl-n de Segura y Luna, Cuna de la Independencia de Oaxaca" & cve_edo == 20
replace code_INEGI = 20550 if polygon_name == "San Jer-nimo Tlacochahuaya" & cve_edo == 20
replace code_INEGI = 20551 if polygon_name == "Tlacolula de Matamoros" & cve_edo == 20
replace code_INEGI = 20552 if polygon_name == "Tlacotepec Plumas" & cve_edo == 20
replace code_INEGI = 20553 if polygon_name == "Tlalixtac de Cabrera" & cve_edo == 20
replace code_INEGI = 20554 if polygon_name == "Totontepec Villa de Morelos" & cve_edo == 20
replace code_INEGI = 20555 if polygon_name == "Trinidad Zaachila" & cve_edo == 20
replace code_INEGI = 20556 if polygon_name == "La Trinidad Vista Hermosa" & cve_edo == 20
replace code_INEGI = 20557 if polygon_name == "Uni-n Hidalgo" & cve_edo == 20
replace code_INEGI = 20558 if polygon_name == "Valerio Trujano" & cve_edo == 20
replace code_INEGI = 20559 if polygon_name == "San Juan Bautista Valle Nacional" & cve_edo == 20
replace code_INEGI = 20560 if polygon_name == "Villa D-az Ordaz" & cve_edo == 20
replace code_INEGI = 20561 if polygon_name == "Yaxe" & cve_edo == 20
replace code_INEGI = 20562 if polygon_name == "Magdalena Yodocono de Porfirio D-az" & cve_edo == 20
replace code_INEGI = 20563 if polygon_name == "Yogana" & cve_edo == 20
replace code_INEGI = 20564 if polygon_name == "Yutanduchi de Guerrero" & cve_edo == 20
replace code_INEGI = 20565 if polygon_name == "Villa de Zaachila" & cve_edo == 20
replace code_INEGI = 20566 if polygon_name == "San Mateo Yucutindoo" & cve_edo == 20
replace code_INEGI = 20567 if polygon_name == "Zapotitl-n Lagunas" & cve_edo == 20
replace code_INEGI = 20568 if polygon_name == "Zapotitl-n Palmas" & cve_edo == 20
replace code_INEGI = 20569 if polygon_name == "Santa In-s de Zaragoza" & cve_edo == 20
replace code_INEGI = 20570 if polygon_name == "Zimatl-n de -lvarez" & cve_edo == 20

replace code_INEGI = 21001 if polygon_name == "Acajete" & cve_edo == 21
replace code_INEGI = 21002 if polygon_name == "Acateno" & cve_edo == 21
replace code_INEGI = 21003 if polygon_name == "Acatl-n" & cve_edo == 21
replace code_INEGI = 21004 if polygon_name == "Acatzingo" & cve_edo == 21
replace code_INEGI = 21005 if polygon_name == "Acteopan" & cve_edo == 21
replace code_INEGI = 21006 if polygon_name == "Ahuacatl-n" & cve_edo == 21
replace code_INEGI = 21007 if polygon_name == "Ahuatl-n" & cve_edo == 21
replace code_INEGI = 21008 if polygon_name == "Ahuazotepec" & cve_edo == 21
replace code_INEGI = 21009 if polygon_name == "Ahuehuetitla" & cve_edo == 21
replace code_INEGI = 21010 if polygon_name == "Ajalpan" & cve_edo == 21
replace code_INEGI = 21011 if polygon_name == "Albino Zertuche" & cve_edo == 21
replace code_INEGI = 21012 if polygon_name == "Aljojuca" & cve_edo == 21
replace code_INEGI = 21013 if polygon_name == "Altepexi" & cve_edo == 21
replace code_INEGI = 21014 if polygon_name == "Amixtl-n" & cve_edo == 21
replace code_INEGI = 21015 if polygon_name == "Amozoc" & cve_edo == 21
replace code_INEGI = 21016 if polygon_name == "Aquixtla" & cve_edo == 21
replace code_INEGI = 21017 if polygon_name == "Atempan" & cve_edo == 21
replace code_INEGI = 21018 if polygon_name == "Atexcal" & cve_edo == 21
replace code_INEGI = 21019 if polygon_name == "Atlixco" & cve_edo == 21
replace code_INEGI = 21020 if polygon_name == "Atoyatempan" & cve_edo == 21
replace code_INEGI = 21021 if polygon_name == "Atzala" & cve_edo == 21
replace code_INEGI = 21022 if polygon_name == "Atzitzihuac-n" & cve_edo == 21
replace code_INEGI = 21023 if polygon_name == "Atzitzintla" & cve_edo == 21
replace code_INEGI = 21024 if polygon_name == "Axutla" & cve_edo == 21
replace code_INEGI = 21025 if polygon_name == "Ayotoxco de Guerrero" & cve_edo == 21
replace code_INEGI = 21026 if polygon_name == "Calpan" & cve_edo == 21
replace code_INEGI = 21027 if polygon_name == "Caltepec" & cve_edo == 21
replace code_INEGI = 21028 if polygon_name == "Camocuautla" & cve_edo == 21
replace code_INEGI = 21029 if polygon_name == "Caxhuacan" & cve_edo == 21
replace code_INEGI = 21030 if polygon_name == "Coatepec" & cve_edo == 21
replace code_INEGI = 21031 if polygon_name == "Coatzingo" & cve_edo == 21
replace code_INEGI = 21032 if polygon_name == "Cohetzala" & cve_edo == 21
replace code_INEGI = 21033 if polygon_name == "Cohuecan" & cve_edo == 21
replace code_INEGI = 21034 if polygon_name == "Coronango" & cve_edo == 21
replace code_INEGI = 21035 if polygon_name == "Coxcatl-n" & cve_edo == 21
replace code_INEGI = 21036 if polygon_name == "Coyomeapan" & cve_edo == 21
replace code_INEGI = 21037 if polygon_name == "Coyotepec" & cve_edo == 21
replace code_INEGI = 21038 if polygon_name == "Cuapiaxtla de Madero" & cve_edo == 21
replace code_INEGI = 21039 if polygon_name == "Cuautempan" & cve_edo == 21
replace code_INEGI = 21040 if polygon_name == "Cuautinch-n" & cve_edo == 21
replace code_INEGI = 21041 if polygon_name == "Cuautlancingo" & cve_edo == 21
replace code_INEGI = 21042 if polygon_name == "Cuayuca de Andrade" & cve_edo == 21
replace code_INEGI = 21043 if polygon_name == "Cuetzalan del Progreso" & cve_edo == 21
replace code_INEGI = 21044 if polygon_name == "Cuyoaco" & cve_edo == 21
replace code_INEGI = 21045 if polygon_name == "Chalchicomula de Sesma" & cve_edo == 21
replace code_INEGI = 21046 if polygon_name == "Chapulco" & cve_edo == 21
replace code_INEGI = 21047 if polygon_name == "Chiautla" & cve_edo == 21
replace code_INEGI = 21048 if polygon_name == "Chiautzingo" & cve_edo == 21
replace code_INEGI = 21049 if polygon_name == "Chiconcuautla" & cve_edo == 21
replace code_INEGI = 21050 if polygon_name == "Chichiquila" & cve_edo == 21
replace code_INEGI = 21051 if polygon_name == "Chietla" & cve_edo == 21
replace code_INEGI = 21052 if polygon_name == "Chigmecatitl-n" & cve_edo == 21
replace code_INEGI = 21053 if polygon_name == "Chignahuapan" & cve_edo == 21
replace code_INEGI = 21054 if polygon_name == "Chignautla" & cve_edo == 21
replace code_INEGI = 21055 if polygon_name == "Chila" & cve_edo == 21
replace code_INEGI = 21056 if polygon_name == "Chila de la Sal" & cve_edo == 21
replace code_INEGI = 21057 if polygon_name == "Honey" & cve_edo == 21
replace code_INEGI = 21058 if polygon_name == "Chilchotla" & cve_edo == 21
replace code_INEGI = 21059 if polygon_name == "Chinantla" & cve_edo == 21
replace code_INEGI = 21060 if polygon_name == "Domingo Arenas" & cve_edo == 21
replace code_INEGI = 21061 if polygon_name == "Eloxochitl-n" & cve_edo == 21
replace code_INEGI = 21062 if polygon_name == "Epatl-n" & cve_edo == 21
replace code_INEGI = 21063 if polygon_name == "Esperanza" & cve_edo == 21
replace code_INEGI = 21064 if polygon_name == "Francisco Z. Mena" & cve_edo == 21
replace code_INEGI = 21065 if polygon_name == "General Felipe -ngeles" & cve_edo == 21
replace code_INEGI = 21066 if polygon_name == "Guadalupe" & cve_edo == 21
replace code_INEGI = 21067 if polygon_name == "Guadalupe Victoria" & cve_edo == 21
replace code_INEGI = 21068 if polygon_name == "Hermenegildo Galeana" & cve_edo == 21
replace code_INEGI = 21069 if polygon_name == "Huaquechula" & cve_edo == 21
replace code_INEGI = 21070 if polygon_name == "Huatlatlauca" & cve_edo == 21
replace code_INEGI = 21071 if polygon_name == "Huauchinango" & cve_edo == 21
replace code_INEGI = 21072 if polygon_name == "Huehuetla" & cve_edo == 21
replace code_INEGI = 21073 if polygon_name == "Huehuetl-n el Chico" & cve_edo == 21
replace code_INEGI = 21074 if polygon_name == "Huejotzingo" & cve_edo == 21
replace code_INEGI = 21075 if polygon_name == "Hueyapan" & cve_edo == 21
replace code_INEGI = 21076 if polygon_name == "Hueytamalco" & cve_edo == 21
replace code_INEGI = 21077 if polygon_name == "Hueytlalpan" & cve_edo == 21
replace code_INEGI = 21078 if polygon_name == "Huitzilan de Serd-n" & cve_edo == 21
replace code_INEGI = 21079 if polygon_name == "Huitziltepec" & cve_edo == 21
replace code_INEGI = 21080 if polygon_name == "Atlequizayan" & cve_edo == 21
replace code_INEGI = 21081 if polygon_name == "Ixcamilpa de Guerrero" & cve_edo == 21
replace code_INEGI = 21082 if polygon_name == "Ixcaquixtla" & cve_edo == 21
replace code_INEGI = 21083 if polygon_name == "Ixtacamaxtitl-n" & cve_edo == 21
replace code_INEGI = 21084 if polygon_name == "Ixtepec" & cve_edo == 21
replace code_INEGI = 21085 if polygon_name == "Iz-car de Matamoros" & cve_edo == 21
replace code_INEGI = 21086 if polygon_name == "Jalpan" & cve_edo == 21
replace code_INEGI = 21087 if polygon_name == "Jolalpan" & cve_edo == 21
replace code_INEGI = 21088 if polygon_name == "Jonotla" & cve_edo == 21
replace code_INEGI = 21089 if polygon_name == "Jopala" & cve_edo == 21
replace code_INEGI = 21090 if polygon_name == "Juan C. Bonilla" & cve_edo == 21
replace code_INEGI = 21091 if polygon_name == "Juan Galindo" & cve_edo == 21
replace code_INEGI = 21092 if polygon_name == "Juan N. M-ndez" & cve_edo == 21
replace code_INEGI = 21093 if polygon_name == "Lafragua" & cve_edo == 21
replace code_INEGI = 21094 if polygon_name == "Libres" & cve_edo == 21
replace code_INEGI = 21095 if polygon_name == "La Magdalena Tlatlauquitepec" & cve_edo == 21
replace code_INEGI = 21096 if polygon_name == "Mazapiltepec de Ju-rez" & cve_edo == 21
replace code_INEGI = 21097 if polygon_name == "Mixtla" & cve_edo == 21
replace code_INEGI = 21098 if polygon_name == "Molcaxac" & cve_edo == 21
replace code_INEGI = 21099 if polygon_name == "Ca-ada Morelos" & cve_edo == 21
replace code_INEGI = 21100 if polygon_name == "Naupan" & cve_edo == 21
replace code_INEGI = 21101 if polygon_name == "Nauzontla" & cve_edo == 21
replace code_INEGI = 21102 if polygon_name == "Nealtican" & cve_edo == 21
replace code_INEGI = 21103 if polygon_name == "Nicol-s Bravo" & cve_edo == 21
replace code_INEGI = 21104 if polygon_name == "Nopalucan" & cve_edo == 21
replace code_INEGI = 21105 if polygon_name == "Ocotepec" & cve_edo == 21
replace code_INEGI = 21106 if polygon_name == "Ocoyucan" & cve_edo == 21
replace code_INEGI = 21107 if polygon_name == "Olintla" & cve_edo == 21
replace code_INEGI = 21108 if polygon_name == "Oriental" & cve_edo == 21
replace code_INEGI = 21109 if polygon_name == "Pahuatl-n" & cve_edo == 21
replace code_INEGI = 21110 if polygon_name == "Palmar de Bravo" & cve_edo == 21
replace code_INEGI = 21111 if polygon_name == "Pantepec" & cve_edo == 21
replace code_INEGI = 21112 if polygon_name == "Petlalcingo" & cve_edo == 21
replace code_INEGI = 21113 if polygon_name == "Piaxtla" & cve_edo == 21
replace code_INEGI = 21114 if polygon_name == "Puebla" & cve_edo == 21
replace code_INEGI = 21115 if polygon_name == "Quecholac" & cve_edo == 21
replace code_INEGI = 21116 if polygon_name == "Quimixtl-n" & cve_edo == 21
replace code_INEGI = 21117 if polygon_name == "Rafael Lara Grajales" & cve_edo == 21
replace code_INEGI = 21118 if polygon_name == "Los Reyes de Ju-rez" & cve_edo == 21
replace code_INEGI = 21119 if polygon_name == "San Andr-s Cholula" & cve_edo == 21
replace code_INEGI = 21120 if polygon_name == "San Antonio Ca-ada" & cve_edo == 21
replace code_INEGI = 21121 if polygon_name == "San Diego la Mesa Tochimiltzingo" & cve_edo == 21
replace code_INEGI = 21122 if polygon_name == "San Felipe Teotlalcingo" & cve_edo == 21
replace code_INEGI = 21123 if polygon_name == "San Felipe Tepatl-n" & cve_edo == 21
replace code_INEGI = 21124 if polygon_name == "San Gabriel Chilac" & cve_edo == 21
replace code_INEGI = 21125 if polygon_name == "San Gregorio Atzompa" & cve_edo == 21
replace code_INEGI = 21126 if polygon_name == "San Jer-nimo Tecuanipan" & cve_edo == 21
replace code_INEGI = 21127 if polygon_name == "San Jer-nimo Xayacatl-n" & cve_edo == 21
replace code_INEGI = 21128 if polygon_name == "San Jos- Chiapa" & cve_edo == 21
replace code_INEGI = 21129 if polygon_name == "San Jos- Miahuatl-n" & cve_edo == 21
replace code_INEGI = 21130 if polygon_name == "San Juan Atenco" & cve_edo == 21
replace code_INEGI = 21131 if polygon_name == "San Juan Atzompa" & cve_edo == 21
replace code_INEGI = 21132 if polygon_name == "San Mart-n Texmelucan" & cve_edo == 21
replace code_INEGI = 21133 if polygon_name == "San Mart-n Totoltepec" & cve_edo == 21
replace code_INEGI = 21134 if polygon_name == "San Mat-as Tlalancaleca" & cve_edo == 21
replace code_INEGI = 21135 if polygon_name == "San Miguel Ixitl-n" & cve_edo == 21
replace code_INEGI = 21136 if polygon_name == "San Miguel Xoxtla" & cve_edo == 21
replace code_INEGI = 21137 if polygon_name == "San Nicol-s Buenos Aires" & cve_edo == 21
replace code_INEGI = 21138 if polygon_name == "San Nicol-s de los Ranchos" & cve_edo == 21
replace code_INEGI = 21139 if polygon_name == "San Pablo Anicano" & cve_edo == 21
replace code_INEGI = 21140 if polygon_name == "San Pedro Cholula" & cve_edo == 21
replace code_INEGI = 21141 if polygon_name == "San Pedro Yeloixtlahuaca" & cve_edo == 21
replace code_INEGI = 21142 if polygon_name == "San Salvador el Seco" & cve_edo == 21
replace code_INEGI = 21143 if polygon_name == "San Salvador el Verde" & cve_edo == 21
replace code_INEGI = 21144 if polygon_name == "San Salvador Huixcolotla" & cve_edo == 21
replace code_INEGI = 21145 if polygon_name == "San Sebasti-n Tlacotepec" & cve_edo == 21
replace code_INEGI = 21146 if polygon_name == "Santa Catarina Tlaltempan" & cve_edo == 21
replace code_INEGI = 21147 if polygon_name == "Santa In-s Ahuatempan" & cve_edo == 21
replace code_INEGI = 21148 if polygon_name == "Santa Isabel Cholula" & cve_edo == 21
replace code_INEGI = 21149 if polygon_name == "Santiago Miahuatl-n" & cve_edo == 21
replace code_INEGI = 21150 if polygon_name == "Huehuetl-n el Grande" & cve_edo == 21
replace code_INEGI = 21151 if polygon_name == "Santo Tom-s Hueyotlipan" & cve_edo == 21
replace code_INEGI = 21152 if polygon_name == "Soltepec" & cve_edo == 21
replace code_INEGI = 21153 if polygon_name == "Tecali de Herrera" & cve_edo == 21
replace code_INEGI = 21154 if polygon_name == "Tecamachalco" & cve_edo == 21
replace code_INEGI = 21155 if polygon_name == "Tecomatl-n" & cve_edo == 21
replace code_INEGI = 21156 if polygon_name == "Tehuac-n" & cve_edo == 21
replace code_INEGI = 21157 if polygon_name == "Tehuitzingo" & cve_edo == 21
replace code_INEGI = 21158 if polygon_name == "Tenampulco" & cve_edo == 21
replace code_INEGI = 21159 if polygon_name == "Teopantl-n" & cve_edo == 21
replace code_INEGI = 21160 if polygon_name == "Teotlalco" & cve_edo == 21
replace code_INEGI = 21161 if polygon_name == "Tepanco de L-pez" & cve_edo == 21
replace code_INEGI = 21162 if polygon_name == "Tepango de Rodr-guez" & cve_edo == 21
replace code_INEGI = 21163 if polygon_name == "Tepatlaxco de Hidalgo" & cve_edo == 21
replace code_INEGI = 21164 if polygon_name == "Tepeaca" & cve_edo == 21
replace code_INEGI = 21165 if polygon_name == "Tepemaxalco" & cve_edo == 21
replace code_INEGI = 21166 if polygon_name == "Tepeojuma" & cve_edo == 21
replace code_INEGI = 21167 if polygon_name == "Tepetzintla" & cve_edo == 21
replace code_INEGI = 21168 if polygon_name == "Tepexco" & cve_edo == 21
replace code_INEGI = 21169 if polygon_name == "Tepexi de Rodr-guez" & cve_edo == 21
replace code_INEGI = 21170 if polygon_name == "Tepeyahualco" & cve_edo == 21
replace code_INEGI = 21171 if polygon_name == "Tepeyahualco de Cuauht-moc" & cve_edo == 21
replace code_INEGI = 21172 if polygon_name == "Tetela de Ocampo" & cve_edo == 21
replace code_INEGI = 21173 if polygon_name == "Teteles de Avila Castillo" & cve_edo == 21
replace code_INEGI = 21174 if polygon_name == "Teziutl-n" & cve_edo == 21
replace code_INEGI = 21175 if polygon_name == "Tianguismanalco" & cve_edo == 21
replace code_INEGI = 21176 if polygon_name == "Tilapa" & cve_edo == 21
replace code_INEGI = 21177 if polygon_name == "Tlacotepec de Benito Ju-rez" & cve_edo == 21
replace code_INEGI = 21178 if polygon_name == "Tlacuilotepec" & cve_edo == 21
replace code_INEGI = 21179 if polygon_name == "Tlachichuca" & cve_edo == 21
replace code_INEGI = 21180 if polygon_name == "Tlahuapan" & cve_edo == 21
replace code_INEGI = 21181 if polygon_name == "Tlaltenango" & cve_edo == 21
replace code_INEGI = 21182 if polygon_name == "Tlanepantla" & cve_edo == 21
replace code_INEGI = 21183 if polygon_name == "Tlaola" & cve_edo == 21
replace code_INEGI = 21184 if polygon_name == "Tlapacoya" & cve_edo == 21
replace code_INEGI = 21185 if polygon_name == "Tlapanal-" & cve_edo == 21
replace code_INEGI = 21186 if polygon_name == "Tlatlauquitepec" & cve_edo == 21
replace code_INEGI = 21187 if polygon_name == "Tlaxco" & cve_edo == 21
replace code_INEGI = 21188 if polygon_name == "Tochimilco" & cve_edo == 21
replace code_INEGI = 21189 if polygon_name == "Tochtepec" & cve_edo == 21
replace code_INEGI = 21190 if polygon_name == "Totoltepec de Guerrero" & cve_edo == 21
replace code_INEGI = 21191 if polygon_name == "Tulcingo" & cve_edo == 21
replace code_INEGI = 21192 if polygon_name == "Tuzamapan de Galeana" & cve_edo == 21
replace code_INEGI = 21193 if polygon_name == "Tzicatlacoyan" & cve_edo == 21
replace code_INEGI = 21194 if polygon_name == "Venustiano Carranza" & cve_edo == 21
replace code_INEGI = 21195 if polygon_name == "Vicente Guerrero" & cve_edo == 21
replace code_INEGI = 21196 if polygon_name == "Xayacatl-n de Bravo" & cve_edo == 21
replace code_INEGI = 21197 if polygon_name == "Xicotepec" & cve_edo == 21
replace code_INEGI = 21198 if polygon_name == "Xicotl-n" & cve_edo == 21
replace code_INEGI = 21199 if polygon_name == "Xiutetelco" & cve_edo == 21
replace code_INEGI = 21200 if polygon_name == "Xochiapulco" & cve_edo == 21
replace code_INEGI = 21201 if polygon_name == "Xochiltepec" & cve_edo == 21
replace code_INEGI = 21202 if polygon_name == "Xochitl-n de Vicente Su-rez" & cve_edo == 21
replace code_INEGI = 21203 if polygon_name == "Xochitl-n Todos Santos" & cve_edo == 21
replace code_INEGI = 21204 if polygon_name == "Yaon-huac" & cve_edo == 21
replace code_INEGI = 21205 if polygon_name == "Yehualtepec" & cve_edo == 21
replace code_INEGI = 21206 if polygon_name == "Zacapala" & cve_edo == 21
replace code_INEGI = 21207 if polygon_name == "Zacapoaxtla" & cve_edo == 21
replace code_INEGI = 21208 if polygon_name == "Zacatl-n" & cve_edo == 21
replace code_INEGI = 21209 if polygon_name == "Zapotitl-n" & cve_edo == 21
replace code_INEGI = 21210 if polygon_name == "Zapotitl-n de M-ndez" & cve_edo == 21
replace code_INEGI = 21211 if polygon_name == "Zaragoza" & cve_edo == 21
replace code_INEGI = 21212 if polygon_name == "Zautla" & cve_edo == 21
replace code_INEGI = 21213 if polygon_name == "Zihuateutla" & cve_edo == 21
replace code_INEGI = 21214 if polygon_name == "Zinacatepec" & cve_edo == 21
replace code_INEGI = 21215 if polygon_name == "Zongozotla" & cve_edo == 21
replace code_INEGI = 21216 if polygon_name == "Zoquiapan" & cve_edo == 21
replace code_INEGI = 21217 if polygon_name == "Zoquitl-n" & cve_edo == 21

replace code_INEGI = 22001 if polygon_name == "Amealco de Bonfil" & cve_edo == 22
replace code_INEGI = 22002 if polygon_name == "Pinal de Amoles" & cve_edo == 22
replace code_INEGI = 22003 if polygon_name == "Arroyo Seco" & cve_edo == 22
replace code_INEGI = 22004 if polygon_name == "Cadereyta de Montes" & cve_edo == 22
replace code_INEGI = 22005 if polygon_name == "Col-n" & cve_edo == 22
replace code_INEGI = 22006 if polygon_name == "Corregidora" & cve_edo == 22
replace code_INEGI = 22007 if polygon_name == "Ezequiel Montes" & cve_edo == 22
replace code_INEGI = 22008 if polygon_name == "Huimilpan" & cve_edo == 22
replace code_INEGI = 22009 if polygon_name == "Jalpan de Serra" & cve_edo == 22
replace code_INEGI = 22010 if polygon_name == "Landa de Matamoros" & cve_edo == 22
replace code_INEGI = 22011 if polygon_name == "El Marqu-s" & cve_edo == 22
replace code_INEGI = 22012 if polygon_name == "Pedro Escobedo" & cve_edo == 22
replace code_INEGI = 22013 if polygon_name == "Pe-amiller" & cve_edo == 22
replace code_INEGI = 22014 if polygon_name == "Quer-taro" & cve_edo == 22
replace code_INEGI = 22015 if polygon_name == "San Joaqu-n" & cve_edo == 22
replace code_INEGI = 22016 if polygon_name == "San Juan del R-o" & cve_edo == 22
replace code_INEGI = 22017 if polygon_name == "Tequisquiapan" & cve_edo == 22
replace code_INEGI = 22018 if polygon_name == "Tolim-n" & cve_edo == 22

replace code_INEGI = 23001 if polygon_name == "Cozumel" & cve_edo == 23
replace code_INEGI = 23002 if polygon_name == "Felipe Carrillo Puerto" & cve_edo == 23
replace code_INEGI = 23003 if polygon_name == "Isla Mujeres" & cve_edo == 23
replace code_INEGI = 23004 if polygon_name == "Oth-n P. Blanco" & cve_edo == 23
replace code_INEGI = 23005 if polygon_name == "Benito Ju-rez" & cve_edo == 23
replace code_INEGI = 23006 if polygon_name == "Jos- Mar-a Morelos" & cve_edo == 23
replace code_INEGI = 23007 if polygon_name == "L-zaro C-rdenas" & cve_edo == 23
replace code_INEGI = 23008 if polygon_name == "Solidaridad" & cve_edo == 23
replace code_INEGI = 23009 if polygon_name == "Tulum" & cve_edo == 23
replace code_INEGI = 23010 if polygon_name == "Bacalar" & cve_edo == 23
replace code_INEGI = 23011 if polygon_name == "Puerto Morelos" & cve_edo == 23

replace code_INEGI = 24001 if polygon_name == "Ahualulco" & cve_edo == 24
replace code_INEGI = 24002 if polygon_name == "Alaquines" & cve_edo == 24
replace code_INEGI = 24003 if polygon_name == "Aquism-n" & cve_edo == 24
replace code_INEGI = 24004 if polygon_name == "Armadillo de los Infante" & cve_edo == 24
replace code_INEGI = 24005 if polygon_name == "C-rdenas" & cve_edo == 24
replace code_INEGI = 24006 if polygon_name == "Catorce" & cve_edo == 24
replace code_INEGI = 24007 if polygon_name == "Cedral" & cve_edo == 24
replace code_INEGI = 24008 if polygon_name == "Cerritos" & cve_edo == 24
replace code_INEGI = 24009 if polygon_name == "Cerro de San Pedro" & cve_edo == 24
replace code_INEGI = 24010 if polygon_name == "Ciudad del Ma-z" & cve_edo == 24
replace code_INEGI = 24011 if polygon_name == "Ciudad Fern-ndez" & cve_edo == 24
replace code_INEGI = 24012 if polygon_name == "Tancanhuitz" & cve_edo == 24
replace code_INEGI = 24013 if polygon_name == "Ciudad Valles" & cve_edo == 24
replace code_INEGI = 24014 if polygon_name == "Coxcatl-n" & cve_edo == 24
replace code_INEGI = 24015 if polygon_name == "Charcas" & cve_edo == 24
replace code_INEGI = 24016 if polygon_name == "Ebano" & cve_edo == 24
replace code_INEGI = 24017 if polygon_name == "Guadalc-zar" & cve_edo == 24
replace code_INEGI = 24018 if polygon_name == "Huehuetl-n" & cve_edo == 24
replace code_INEGI = 24019 if polygon_name == "Lagunillas" & cve_edo == 24
replace code_INEGI = 24020 if polygon_name == "Matehuala" & cve_edo == 24
replace code_INEGI = 24021 if polygon_name == "Mexquitic de Carmona" & cve_edo == 24
replace code_INEGI = 24022 if polygon_name == "Moctezuma" & cve_edo == 24
replace code_INEGI = 24023 if polygon_name == "Ray-n" & cve_edo == 24
replace code_INEGI = 24024 if polygon_name == "Rioverde" & cve_edo == 24
replace code_INEGI = 24025 if polygon_name == "Salinas" & cve_edo == 24
replace code_INEGI = 24026 if polygon_name == "San Antonio" & cve_edo == 24
replace code_INEGI = 24027 if polygon_name == "San Ciro de Acosta" & cve_edo == 24
replace code_INEGI = 24028 if polygon_name == "San Luis Potos-" & cve_edo == 24
replace code_INEGI = 24029 if polygon_name == "San Mart-n Chalchicuautla" & cve_edo == 24
replace code_INEGI = 24030 if polygon_name == "San Nicol-s Tolentino" & cve_edo == 24
replace code_INEGI = 24031 if polygon_name == "Santa Catarina" & cve_edo == 24
replace code_INEGI = 24032 if polygon_name == "Santa Mar-a del R-o" & cve_edo == 24
replace code_INEGI = 24033 if polygon_name == "Santo Domingo" & cve_edo == 24
replace code_INEGI = 24034 if polygon_name == "San Vicente Tancuayalab" & cve_edo == 24
replace code_INEGI = 24035 if polygon_name == "Soledad de Graciano S-nchez" & cve_edo == 24
replace code_INEGI = 24036 if polygon_name == "Tamasopo" & cve_edo == 24
replace code_INEGI = 24037 if polygon_name == "Tamazunchale" & cve_edo == 24
replace code_INEGI = 24038 if polygon_name == "Tampac-n" & cve_edo == 24
replace code_INEGI = 24039 if polygon_name == "Tampamol-n Corona" & cve_edo == 24
replace code_INEGI = 24040 if polygon_name == "Tamu-n" & cve_edo == 24
replace code_INEGI = 24041 if polygon_name == "Tanlaj-s" & cve_edo == 24
replace code_INEGI = 24042 if polygon_name == "Tanqui-n de Escobedo" & cve_edo == 24
replace code_INEGI = 24043 if polygon_name == "Tierra Nueva" & cve_edo == 24
replace code_INEGI = 24044 if polygon_name == "Vanegas" & cve_edo == 24
replace code_INEGI = 24045 if polygon_name == "Venado" & cve_edo == 24
replace code_INEGI = 24046 if polygon_name == "Villa de Arriaga" & cve_edo == 24
replace code_INEGI = 24047 if polygon_name == "Villa de Guadalupe" & cve_edo == 24
replace code_INEGI = 24048 if polygon_name == "Villa de la Paz" & cve_edo == 24
replace code_INEGI = 24049 if polygon_name == "Villa de Ramos" & cve_edo == 24
replace code_INEGI = 24050 if polygon_name == "Villa de Reyes" & cve_edo == 24
replace code_INEGI = 24051 if polygon_name == "Villa Hidalgo" & cve_edo == 24
replace code_INEGI = 24052 if polygon_name == "Villa Ju-rez" & cve_edo == 24
replace code_INEGI = 24053 if polygon_name == "Axtla de Terrazas" & cve_edo == 24
replace code_INEGI = 24054 if polygon_name == "Xilitla" & cve_edo == 24
replace code_INEGI = 24055 if polygon_name == "Zaragoza" & cve_edo == 24
replace code_INEGI = 24056 if polygon_name == "Villa de Arista" & cve_edo == 24
replace code_INEGI = 24057 if polygon_name == "Matlapa" & cve_edo == 24
replace code_INEGI = 24058 if polygon_name == "El Naranjo" & cve_edo == 24

replace code_INEGI = 25001 if polygon_name == "Ahome" & cve_edo == 25
replace code_INEGI = 25002 if polygon_name == "Angostura" & cve_edo == 25
replace code_INEGI = 25003 if polygon_name == "Badiraguato" & cve_edo == 25
replace code_INEGI = 25004 if polygon_name == "Concordia" & cve_edo == 25
replace code_INEGI = 25005 if polygon_name == "Cosal-" & cve_edo == 25
replace code_INEGI = 25006 if polygon_name == "Culiac-n" & cve_edo == 25
replace code_INEGI = 25007 if polygon_name == "Choix" & cve_edo == 25
replace code_INEGI = 25008 if polygon_name == "Elota" & cve_edo == 25
replace code_INEGI = 25009 if polygon_name == "Escuinapa" & cve_edo == 25
replace code_INEGI = 25010 if polygon_name == "El Fuerte" & cve_edo == 25
replace code_INEGI = 25011 if polygon_name == "Guasave" & cve_edo == 25
replace code_INEGI = 25012 if polygon_name == "Mazatl-n" & cve_edo == 25
replace code_INEGI = 25013 if polygon_name == "Mocorito" & cve_edo == 25
replace code_INEGI = 25014 if polygon_name == "Rosario" & cve_edo == 25 | polygon_name == "El Rosario" & cve_edo == 25
replace code_INEGI = 25015 if polygon_name == "Salvador Alvarado" & cve_edo == 25
replace code_INEGI = 25016 if polygon_name == "San Ignacio" & cve_edo == 25
replace code_INEGI = 25017 if polygon_name == "Sinaloa" & cve_edo == 25
replace code_INEGI = 25018 if polygon_name == "Navolato" & cve_edo == 25

replace code_INEGI = 26001 if polygon_name == "Aconchi" & cve_edo == 26
replace code_INEGI = 26002 if polygon_name == "Agua Prieta" & cve_edo == 26
replace code_INEGI = 26003 if polygon_name == "-lamos" & cve_edo == 26
replace code_INEGI = 26004 if polygon_name == "Altar" & cve_edo == 26
replace code_INEGI = 26005 if polygon_name == "Arivechi" & cve_edo == 26
replace code_INEGI = 26006 if polygon_name == "Arizpe" & cve_edo == 26
replace code_INEGI = 26007 if polygon_name == "Atil" & cve_edo == 26
replace code_INEGI = 26008 if polygon_name == "Bacad-huachi" & cve_edo == 26
replace code_INEGI = 26009 if polygon_name == "Bacanora" & cve_edo == 26
replace code_INEGI = 26010 if polygon_name == "Bacerac" & cve_edo == 26
replace code_INEGI = 26011 if polygon_name == "Bacoachi" & cve_edo == 26
replace code_INEGI = 26012 if polygon_name == "B-cum" & cve_edo == 26
replace code_INEGI = 26013 if polygon_name == "Ban-michi" & cve_edo == 26
replace code_INEGI = 26014 if polygon_name == "Bavi-cora" & cve_edo == 26
replace code_INEGI = 26015 if polygon_name == "Bavispe" & cve_edo == 26
replace code_INEGI = 26016 if polygon_name == "Benjam-n Hill" & cve_edo == 26
replace code_INEGI = 26017 if polygon_name == "Caborca" & cve_edo == 26
replace code_INEGI = 26018 if polygon_name == "Cajeme" & cve_edo == 26
replace code_INEGI = 26019 if polygon_name == "Cananea" & cve_edo == 26
replace code_INEGI = 26020 if polygon_name == "Carb-" & cve_edo == 26
replace code_INEGI = 26021 if polygon_name == "La Colorada" & cve_edo == 26
replace code_INEGI = 26022 if polygon_name == "Cucurpe" & cve_edo == 26
replace code_INEGI = 26023 if polygon_name == "Cumpas" & cve_edo == 26
replace code_INEGI = 26024 if polygon_name == "Divisaderos" & cve_edo == 26
replace code_INEGI = 26025 if polygon_name == "Empalme" & cve_edo == 26
replace code_INEGI = 26026 if polygon_name == "Etchojoa" & cve_edo == 26
replace code_INEGI = 26027 if polygon_name == "Fronteras" & cve_edo == 26
replace code_INEGI = 26028 if polygon_name == "Granados" & cve_edo == 26
replace code_INEGI = 26029 if polygon_name == "Guaymas" & cve_edo == 26
replace code_INEGI = 26030 if polygon_name == "Hermosillo" & cve_edo == 26
replace code_INEGI = 26031 if polygon_name == "Huachinera" & cve_edo == 26
replace code_INEGI = 26032 if polygon_name == "Hu-sabas" & cve_edo == 26
replace code_INEGI = 26033 if polygon_name == "Huatabampo" & cve_edo == 26
replace code_INEGI = 26034 if polygon_name == "Hu-pac" & cve_edo == 26
replace code_INEGI = 26035 if polygon_name == "Imuris" & cve_edo == 26
replace code_INEGI = 26036 if polygon_name == "Magdalena" & cve_edo == 26
replace code_INEGI = 26037 if polygon_name == "Mazat-n" & cve_edo == 26
replace code_INEGI = 26038 if polygon_name == "Moctezuma" & cve_edo == 26
replace code_INEGI = 26039 if polygon_name == "Naco" & cve_edo == 26
replace code_INEGI = 26040 if polygon_name == "N-cori Chico" & cve_edo == 26
replace code_INEGI = 26041 if polygon_name == "Nacozari de Garc-a" & cve_edo == 26
replace code_INEGI = 26042 if polygon_name == "Navojoa" & cve_edo == 26
replace code_INEGI = 26043 if polygon_name == "Nogales" & cve_edo == 26
replace code_INEGI = 26044 if polygon_name == "Onavas" & cve_edo == 26
replace code_INEGI = 26045 if polygon_name == "Opodepe" & cve_edo == 26
replace code_INEGI = 26046 if polygon_name == "Oquitoa" & cve_edo == 26
replace code_INEGI = 26047 if polygon_name == "Pitiquito" & cve_edo == 26
replace code_INEGI = 26048 if polygon_name == "Puerto Pe-asco" & cve_edo == 26
replace code_INEGI = 26049 if polygon_name == "Quiriego" & cve_edo == 26
replace code_INEGI = 26050 if polygon_name == "Ray-n" & cve_edo == 26
replace code_INEGI = 26051 if polygon_name == "Rosario" & cve_edo == 26
replace code_INEGI = 26052 if polygon_name == "Sahuaripa" & cve_edo == 26
replace code_INEGI = 26053 if polygon_name == "San Felipe de Jes-s" & cve_edo == 26
replace code_INEGI = 26054 if polygon_name == "San Javier" & cve_edo == 26
replace code_INEGI = 26055 if polygon_name == "San Luis R-o Colorado" & cve_edo == 26
replace code_INEGI = 26056 if polygon_name == "San Miguel de Horcasitas" & cve_edo == 26
replace code_INEGI = 26057 if polygon_name == "San Pedro de la Cueva" & cve_edo == 26
replace code_INEGI = 26058 if polygon_name == "Santa Ana" & cve_edo == 26
replace code_INEGI = 26059 if polygon_name == "Santa Cruz" & cve_edo == 26
replace code_INEGI = 26060 if polygon_name == "S-ric" & cve_edo == 26
replace code_INEGI = 26061 if polygon_name == "Soyopa" & cve_edo == 26
replace code_INEGI = 26062 if polygon_name == "Suaqui Grande" & cve_edo == 26
replace code_INEGI = 26063 if polygon_name == "Tepache" & cve_edo == 26
replace code_INEGI = 26064 if polygon_name == "Trincheras" & cve_edo == 26
replace code_INEGI = 26065 if polygon_name == "Tubutama" & cve_edo == 26
replace code_INEGI = 26066 if polygon_name == "Ures" & cve_edo == 26
replace code_INEGI = 26067 if polygon_name == "Villa Hidalgo" & cve_edo == 26
replace code_INEGI = 26068 if polygon_name == "Villa Pesqueira" & cve_edo == 26
replace code_INEGI = 26069 if polygon_name == "Y-cora" & cve_edo == 26
replace code_INEGI = 26070 if polygon_name == "General Plutarco El-as Calles" & cve_edo == 26
replace code_INEGI = 26071 if polygon_name == "Benito Ju-rez" & cve_edo == 26
replace code_INEGI = 26072 if polygon_name == "San Ignacio R-o Muerto" & cve_edo == 26

replace code_INEGI = 27001 if polygon_name == "Balanc-n" & cve_edo == 27
replace code_INEGI = 27002 if polygon_name == "C-rdenas" & cve_edo == 27
replace code_INEGI = 27003 if polygon_name == "Centla" & cve_edo == 27
replace code_INEGI = 27004 if polygon_name == "Centro" & cve_edo == 27
replace code_INEGI = 27005 if polygon_name == "Comalcalco" & cve_edo == 27
replace code_INEGI = 27006 if polygon_name == "Cunduac-n" & cve_edo == 27
replace code_INEGI = 27007 if polygon_name == "Emiliano Zapata" & cve_edo == 27
replace code_INEGI = 27008 if polygon_name == "Huimanguillo" & cve_edo == 27
replace code_INEGI = 27009 if polygon_name == "Jalapa" & cve_edo == 27
replace code_INEGI = 27010 if polygon_name == "Jalpa de M-ndez" & cve_edo == 27
replace code_INEGI = 27011 if polygon_name == "Jonuta" & cve_edo == 27
replace code_INEGI = 27012 if polygon_name == "Macuspana" & cve_edo == 27
replace code_INEGI = 27013 if polygon_name == "Nacajuca" & cve_edo == 27
replace code_INEGI = 27014 if polygon_name == "Para-so" & cve_edo == 27
replace code_INEGI = 27015 if polygon_name == "Tacotalpa" & cve_edo == 27
replace code_INEGI = 27016 if polygon_name == "Teapa" & cve_edo == 27
replace code_INEGI = 27017 if polygon_name == "Tenosique" & cve_edo == 27
replace code_INEGI = 28001 if polygon_name == "Abasolo" & cve_edo == 28
replace code_INEGI = 28002 if polygon_name == "Aldama" & cve_edo == 28
replace code_INEGI = 28003 if polygon_name == "Altamira" & cve_edo == 28
replace code_INEGI = 28004 if polygon_name == "Antiguo Morelos" & cve_edo == 28
replace code_INEGI = 28005 if polygon_name == "Burgos" & cve_edo == 28
replace code_INEGI = 28006 if polygon_name == "Bustamante" & cve_edo == 28
replace code_INEGI = 28007 if polygon_name == "Camargo" & cve_edo == 28
replace code_INEGI = 28008 if polygon_name == "Casas" & cve_edo == 28
replace code_INEGI = 28009 if polygon_name == "Ciudad Madero" & cve_edo == 28
replace code_INEGI = 28010 if polygon_name == "Cruillas" & cve_edo == 28
replace code_INEGI = 28011 if polygon_name == "G-mez Far-as" & cve_edo == 28
replace code_INEGI = 28012 if polygon_name == "Gonz-lez" & cve_edo == 28
replace code_INEGI = 28013 if polygon_name == "G--mez" & cve_edo == 28
replace code_INEGI = 28014 if polygon_name == "Guerrero" & cve_edo == 28
replace code_INEGI = 28015 if polygon_name == "Gustavo D-az Ordaz" & cve_edo == 28 | polygon_name == "Gustavo D-az Ord-z" & cve_edo == 28
replace code_INEGI = 28016 if polygon_name == "Hidalgo" & cve_edo == 28
replace code_INEGI = 28017 if polygon_name == "Jaumave" & cve_edo == 28
replace code_INEGI = 28018 if polygon_name == "Jim-nez" & cve_edo == 28
replace code_INEGI = 28019 if polygon_name == "Llera" & cve_edo == 28
replace code_INEGI = 28020 if polygon_name == "Mainero" & cve_edo == 28
replace code_INEGI = 28021 if polygon_name == "El Mante" & cve_edo == 28
replace code_INEGI = 28022 if polygon_name == "Matamoros" & cve_edo == 28
replace code_INEGI = 28023 if polygon_name == "M-ndez" & cve_edo == 28
replace code_INEGI = 28024 if polygon_name == "Mier" & cve_edo == 28
replace code_INEGI = 28025 if polygon_name == "Miguel Alem-n" & cve_edo == 28
replace code_INEGI = 28026 if polygon_name == "Miquihuana" & cve_edo == 28
replace code_INEGI = 28027 if polygon_name == "Nuevo Laredo" & cve_edo == 28
replace code_INEGI = 28028 if polygon_name == "Nuevo Morelos" & cve_edo == 28
replace code_INEGI = 28029 if polygon_name == "Ocampo" & cve_edo == 28
replace code_INEGI = 28030 if polygon_name == "Padilla" & cve_edo == 28
replace code_INEGI = 28031 if polygon_name == "Palmillas" & cve_edo == 28
replace code_INEGI = 28032 if polygon_name == "Reynosa" & cve_edo == 28
replace code_INEGI = 28033 if polygon_name == "R-o Bravo" & cve_edo == 28
replace code_INEGI = 28034 if polygon_name == "San Carlos" & cve_edo == 28
replace code_INEGI = 28035 if polygon_name == "San Fernando" & cve_edo == 28
replace code_INEGI = 28036 if polygon_name == "San Nicol-s" & cve_edo == 28
replace code_INEGI = 28037 if polygon_name == "Soto la Marina" & cve_edo == 28
replace code_INEGI = 28038 if polygon_name == "Tampico" & cve_edo == 28
replace code_INEGI = 28039 if polygon_name == "Tula" & cve_edo == 28
replace code_INEGI = 28040 if polygon_name == "Valle Hermoso" & cve_edo == 28
replace code_INEGI = 28041 if polygon_name == "Victoria" & cve_edo == 28
replace code_INEGI = 28042 if polygon_name == "Villagr-n" & cve_edo == 28
replace code_INEGI = 28043 if polygon_name == "Xicot-ncatl" & cve_edo == 28

replace code_INEGI = 29001 if polygon_name == "Amaxac de Guerrero" & cve_edo == 29
replace code_INEGI = 29002 if polygon_name == "Apetatitl-n de Antonio Carvajal" & cve_edo == 29
replace code_INEGI = 29003 if polygon_name == "Atlangatepec" & cve_edo == 29
replace code_INEGI = 29004 if polygon_name == "Atltzayanca" & cve_edo == 29 | polygon_name == "Altzayanca" & cve_edo == 29
replace code_INEGI = 29005 if polygon_name == "Apizaco" & cve_edo == 29
replace code_INEGI = 29006 if polygon_name == "Calpulalpan" & cve_edo == 29
replace code_INEGI = 29007 if polygon_name == "El Carmen Tequexquitla" & cve_edo == 29
replace code_INEGI = 29008 if polygon_name == "Cuapiaxtla" & cve_edo == 29
replace code_INEGI = 29009 if polygon_name == "Cuaxomulco" & cve_edo == 29
replace code_INEGI = 29010 if polygon_name == "Chiautempan" & cve_edo == 29
replace code_INEGI = 29011 if polygon_name == "Mu-oz de Domingo Arenas" & cve_edo == 29
replace code_INEGI = 29012 if polygon_name == "Espa-ita" & cve_edo == 29
replace code_INEGI = 29013 if polygon_name == "Huamantla" & cve_edo == 29
replace code_INEGI = 29014 if polygon_name == "Hueyotlipan" & cve_edo == 29
replace code_INEGI = 29015 if polygon_name == "Ixtacuixtla de Mariano Matamoros" & cve_edo == 29
replace code_INEGI = 29016 if polygon_name == "Ixtenco" & cve_edo == 29
replace code_INEGI = 29017 if polygon_name == "Mazatecochco de Jos- Mar-a Morelos" & cve_edo == 29
replace code_INEGI = 29018 if polygon_name == "Contla de Juan Cuamatzi" & cve_edo == 29
replace code_INEGI = 29019 if polygon_name == "Tepetitla de Lardiz-bal" & cve_edo == 29
replace code_INEGI = 29020 if polygon_name == "Sanct-rum de L-zaro C-rdenas" & cve_edo == 29
replace code_INEGI = 29021 if polygon_name == "Nanacamilpa de Mariano Arista" & cve_edo == 29
replace code_INEGI = 29022 if polygon_name == "Acuamanala de Miguel Hidalgo" & cve_edo == 29
replace code_INEGI = 29023 if polygon_name == "Nat-vitas" & cve_edo == 29
replace code_INEGI = 29024 if polygon_name == "Panotla" & cve_edo == 29
replace code_INEGI = 29025 if polygon_name == "San Pablo del Monte" & cve_edo == 29
replace code_INEGI = 29026 if polygon_name == "Santa Cruz Tlaxcala" & cve_edo == 29
replace code_INEGI = 29027 if polygon_name == "Tenancingo" & cve_edo == 29
replace code_INEGI = 29028 if polygon_name == "Teolocholco" & cve_edo == 29
replace code_INEGI = 29029 if polygon_name == "Tepeyanco" & cve_edo == 29
replace code_INEGI = 29030 if polygon_name == "Terrenate" & cve_edo == 29
replace code_INEGI = 29031 if polygon_name == "Tetla de la Solidaridad" & cve_edo == 29
replace code_INEGI = 29032 if polygon_name == "Tetlatlahuca" & cve_edo == 29
replace code_INEGI = 29033 if polygon_name == "Tlaxcala" & cve_edo == 29
replace code_INEGI = 29034 if polygon_name == "Tlaxco" & cve_edo == 29
replace code_INEGI = 29035 if polygon_name == "Tocatl-n" & cve_edo == 29
replace code_INEGI = 29036 if polygon_name == "Totolac" & cve_edo == 29
replace code_INEGI = 29037 if polygon_name == "Ziltlalt-pec de Trinidad S-nchez Santos" & cve_edo == 29
replace code_INEGI = 29038 if polygon_name == "Tzompantepec" & cve_edo == 29
replace code_INEGI = 29039 if polygon_name == "Xaloztoc" & cve_edo == 29
replace code_INEGI = 29040 if polygon_name == "Xaltocan" & cve_edo == 29
replace code_INEGI = 29041 if polygon_name == "Papalotla de Xicoht-ncatl" & cve_edo == 29
replace code_INEGI = 29042 if polygon_name == "Xicohtzinco" & cve_edo == 29
replace code_INEGI = 29043 if polygon_name == "Yauhquemehcan" & cve_edo == 29
replace code_INEGI = 29044 if polygon_name == "Zacatelco" & cve_edo == 29
replace code_INEGI = 29045 if polygon_name == "Benito Ju-rez" & cve_edo == 29
replace code_INEGI = 29046 if polygon_name == "Emiliano Zapata" & cve_edo == 29
replace code_INEGI = 29047 if polygon_name == "L-zaro C-rdenas" & cve_edo == 29
replace code_INEGI = 29048 if polygon_name == "La Magdalena Tlaltelulco" & cve_edo == 29
replace code_INEGI = 29049 if polygon_name == "San Dami-n Tex-loc" & cve_edo == 29
replace code_INEGI = 29050 if polygon_name == "San Francisco Tetlanohcan" & cve_edo == 29
replace code_INEGI = 29051 if polygon_name == "San Jer-nimo Zacualpan" & cve_edo == 29
replace code_INEGI = 29052 if polygon_name == "San Jos- Teacalco" & cve_edo == 29
replace code_INEGI = 29053 if polygon_name == "San Juan Huactzinco" & cve_edo == 29
replace code_INEGI = 29054 if polygon_name == "San Lorenzo Axocomanitla" & cve_edo == 29
replace code_INEGI = 29055 if polygon_name == "San Lucas Tecopilco" & cve_edo == 29
replace code_INEGI = 29056 if polygon_name == "Santa Ana Nopalucan" & cve_edo == 29
replace code_INEGI = 29057 if polygon_name == "Santa Apolonia Teacalco" & cve_edo == 29
replace code_INEGI = 29058 if polygon_name == "Santa Catarina Ayometla" & cve_edo == 29
replace code_INEGI = 29059 if polygon_name == "Santa Cruz Quilehtla" & cve_edo == 29
replace code_INEGI = 29060 if polygon_name == "Santa Isabel Xiloxoxtla" & cve_edo == 29

replace code_INEGI = 30001 if polygon_name == "Acajete" & cve_edo == 30
replace code_INEGI = 30002 if polygon_name == "Acatl-n" & cve_edo == 30
replace code_INEGI = 30003 if polygon_name == "Acayucan" & cve_edo == 30
replace code_INEGI = 30004 if polygon_name == "Actopan" & cve_edo == 30
replace code_INEGI = 30005 if polygon_name == "Acula" & cve_edo == 30
replace code_INEGI = 30006 if polygon_name == "Acultzingo" & cve_edo == 30
replace code_INEGI = 30007 if polygon_name == "Camar-n de Tejeda" & cve_edo == 30
replace code_INEGI = 30008 if polygon_name == "Alpatl-huac" & cve_edo == 30
replace code_INEGI = 30009 if polygon_name == "Alto Lucero de Guti-rrez Barrios" & cve_edo == 30
replace code_INEGI = 30010 if polygon_name == "Altotonga" & cve_edo == 30
replace code_INEGI = 30011 if polygon_name == "Alvarado" & cve_edo == 30
replace code_INEGI = 30012 if polygon_name == "Amatitl-n" & cve_edo == 30
replace code_INEGI = 30013 if polygon_name == "Naranjos Amatl-n" & cve_edo == 30
replace code_INEGI = 30014 if polygon_name == "Amatl-n de los Reyes" & cve_edo == 30
replace code_INEGI = 30015 if polygon_name == "-ngel R. Cabada" & cve_edo == 30
replace code_INEGI = 30016 if polygon_name == "La Antigua" & cve_edo == 30
replace code_INEGI = 30017 if polygon_name == "Apazapan" & cve_edo == 30
replace code_INEGI = 30018 if polygon_name == "Aquila" & cve_edo == 30
replace code_INEGI = 30019 if polygon_name == "Astacinga" & cve_edo == 30
replace code_INEGI = 30020 if polygon_name == "Atlahuilco" & cve_edo == 30
replace code_INEGI = 30021 if polygon_name == "Atoyac" & cve_edo == 30
replace code_INEGI = 30022 if polygon_name == "Atzacan" & cve_edo == 30
replace code_INEGI = 30023 if polygon_name == "Atzalan" & cve_edo == 30
replace code_INEGI = 30024 if polygon_name == "Tlaltetela" & cve_edo == 30
replace code_INEGI = 30025 if polygon_name == "Ayahualulco" & cve_edo == 30
replace code_INEGI = 30026 if polygon_name == "Banderilla" & cve_edo == 30
replace code_INEGI = 30027 if polygon_name == "Benito Ju-rez" & cve_edo == 30
replace code_INEGI = 30028 if polygon_name == "Boca del R-o" & cve_edo == 30
replace code_INEGI = 30029 if polygon_name == "Calcahualco" & cve_edo == 30
replace code_INEGI = 30030 if polygon_name == "Camerino Z. Mendoza" & cve_edo == 30
replace code_INEGI = 30031 if polygon_name == "Carrillo Puerto" & cve_edo == 30
replace code_INEGI = 30032 if polygon_name == "Catemaco" & cve_edo == 30
replace code_INEGI = 30033 if polygon_name == "Cazones de Herrera" & cve_edo == 30
replace code_INEGI = 30034 if polygon_name == "Cerro Azul" & cve_edo == 30
replace code_INEGI = 30035 if polygon_name == "Citlalt-petl" & cve_edo == 30
replace code_INEGI = 30036 if polygon_name == "Coacoatzintla" & cve_edo == 30
replace code_INEGI = 30037 if polygon_name == "Coahuitl-n" & cve_edo == 30
replace code_INEGI = 30038 if polygon_name == "Coatepec" & cve_edo == 30
replace code_INEGI = 30039 if polygon_name == "Coatzacoalcos" & cve_edo == 30
replace code_INEGI = 30040 if polygon_name == "Coatzintla" & cve_edo == 30
replace code_INEGI = 30041 if polygon_name == "Coetzala" & cve_edo == 30
replace code_INEGI = 30042 if polygon_name == "Colipa" & cve_edo == 30
replace code_INEGI = 30043 if polygon_name == "Comapa" & cve_edo == 30
replace code_INEGI = 30044 if polygon_name == "C-rdoba" & cve_edo == 30
replace code_INEGI = 30045 if polygon_name == "Cosamaloapan de Carpio" & cve_edo == 30
replace code_INEGI = 30046 if polygon_name == "Cosautl-n de Carvajal" & cve_edo == 30
replace code_INEGI = 30047 if polygon_name == "Coscomatepec" & cve_edo == 30
replace code_INEGI = 30048 if polygon_name == "Cosoleacaque" & cve_edo == 30
replace code_INEGI = 30049 if polygon_name == "Cotaxtla" & cve_edo == 30
replace code_INEGI = 30050 if polygon_name == "Coxquihui" & cve_edo == 30
replace code_INEGI = 30051 if polygon_name == "Coyutla" & cve_edo == 30
replace code_INEGI = 30052 if polygon_name == "Cuichapa" & cve_edo == 30
replace code_INEGI = 30053 if polygon_name == "Cuitl-huac" & cve_edo == 30
replace code_INEGI = 30054 if polygon_name == "Chacaltianguis" & cve_edo == 30
replace code_INEGI = 30055 if polygon_name == "Chalma" & cve_edo == 30
replace code_INEGI = 30056 if polygon_name == "Chiconamel" & cve_edo == 30
replace code_INEGI = 30057 if polygon_name == "Chiconquiaco" & cve_edo == 30
replace code_INEGI = 30058 if polygon_name == "Chicontepec" & cve_edo == 30
replace code_INEGI = 30059 if polygon_name == "Chinameca" & cve_edo == 30
replace code_INEGI = 30060 if polygon_name == "Chinampa de Gorostiza" & cve_edo == 30
replace code_INEGI = 30061 if polygon_name == "Las Choapas" & cve_edo == 30
replace code_INEGI = 30062 if polygon_name == "Chocam-n" & cve_edo == 30
replace code_INEGI = 30063 if polygon_name == "Chontla" & cve_edo == 30
replace code_INEGI = 30064 if polygon_name == "Chumatl-n" & cve_edo == 30
replace code_INEGI = 30065 if polygon_name == "Emiliano Zapata" & cve_edo == 30
replace code_INEGI = 30066 if polygon_name == "Espinal" & cve_edo == 30
replace code_INEGI = 30067 if polygon_name == "Filomeno Mata" & cve_edo == 30
replace code_INEGI = 30068 if polygon_name == "Fort-n" & cve_edo == 30
replace code_INEGI = 30069 if polygon_name == "Guti-rrez Zamora" & cve_edo == 30
replace code_INEGI = 30070 if polygon_name == "Hidalgotitl-n" & cve_edo == 30
replace code_INEGI = 30071 if polygon_name == "Huatusco" & cve_edo == 30
replace code_INEGI = 30072 if polygon_name == "Huayacocotla" & cve_edo == 30
replace code_INEGI = 30073 if polygon_name == "Hueyapan de Ocampo" & cve_edo == 30
replace code_INEGI = 30074 if polygon_name == "Huiloapan de Cuauht-moc" & cve_edo == 30
replace code_INEGI = 30075 if polygon_name == "Ignacio de la Llave" & cve_edo == 30
replace code_INEGI = 30076 if polygon_name == "Ilamatl-n" & cve_edo == 30
replace code_INEGI = 30077 if polygon_name == "Isla" & cve_edo == 30
replace code_INEGI = 30078 if polygon_name == "Ixcatepec" & cve_edo == 30
replace code_INEGI = 30079 if polygon_name == "Ixhuac-n de los Reyes" & cve_edo == 30
replace code_INEGI = 30080 if polygon_name == "Ixhuatl-n del Caf-" & cve_edo == 30
replace code_INEGI = 30081 if polygon_name == "Ixhuatlancillo" & cve_edo == 30
replace code_INEGI = 30082 if polygon_name == "Ixhuatl-n del Sureste" & cve_edo == 30
replace code_INEGI = 30083 if polygon_name == "Ixhuatl-n de Madero" & cve_edo == 30
replace code_INEGI = 30084 if polygon_name == "Ixmatlahuacan" & cve_edo == 30
replace code_INEGI = 30085 if polygon_name == "Ixtaczoquitl-n" & cve_edo == 30
replace code_INEGI = 30086 if polygon_name == "Jalacingo" & cve_edo == 30 | polygon_name == "Jalancingo" & cve_edo == 30
replace code_INEGI = 30087 if polygon_name == "Xalapa" & cve_edo == 30
replace code_INEGI = 30088 if polygon_name == "Jalcomulco" & cve_edo == 30
replace code_INEGI = 30089 if polygon_name == "J-ltipan" & cve_edo == 30
replace code_INEGI = 30090 if polygon_name == "Jamapa" & cve_edo == 30
replace code_INEGI = 30091 if polygon_name == "Jes-s Carranza" & cve_edo == 30
replace code_INEGI = 30092 if polygon_name == "Xico" & cve_edo == 30
replace code_INEGI = 30093 if polygon_name == "Jilotepec" & cve_edo == 30
replace code_INEGI = 30094 if polygon_name == "Juan Rodr-guez Clara" & cve_edo == 30
replace code_INEGI = 30095 if polygon_name == "Juchique de Ferrer" & cve_edo == 30
replace code_INEGI = 30096 if polygon_name == "Landero y Coss" & cve_edo == 30
replace code_INEGI = 30097 if polygon_name == "Lerdo de Tejada" & cve_edo == 30
replace code_INEGI = 30098 if polygon_name == "Magdalena" & cve_edo == 30
replace code_INEGI = 30099 if polygon_name == "Maltrata" & cve_edo == 30
replace code_INEGI = 30100 if polygon_name == "Manlio Fabio Altamirano" & cve_edo == 30
replace code_INEGI = 30101 if polygon_name == "Mariano Escobedo" & cve_edo == 30
replace code_INEGI = 30102 if polygon_name == "Mart-nez de la Torre" & cve_edo == 30
replace code_INEGI = 30103 if polygon_name == "Mecatl-n" & cve_edo == 30
replace code_INEGI = 30104 if polygon_name == "Mecayapan" & cve_edo == 30
replace code_INEGI = 30105 if polygon_name == "Medell-n de Bravo" & cve_edo == 30
replace code_INEGI = 30106 if polygon_name == "Miahuatl-n" & cve_edo == 30
replace code_INEGI = 30107 if polygon_name == "Las Minas" & cve_edo == 30
replace code_INEGI = 30108 if polygon_name == "Minatitl-n" & cve_edo == 30
replace code_INEGI = 30109 if polygon_name == "Misantla" & cve_edo == 30
replace code_INEGI = 30110 if polygon_name == "Mixtla de Altamirano" & cve_edo == 30
replace code_INEGI = 30111 if polygon_name == "Moloac-n" & cve_edo == 30
replace code_INEGI = 30112 if polygon_name == "Naolinco" & cve_edo == 30
replace code_INEGI = 30113 if polygon_name == "Naranjal" & cve_edo == 30
replace code_INEGI = 30114 if polygon_name == "Nautla" & cve_edo == 30
replace code_INEGI = 30115 if polygon_name == "Nogales" & cve_edo == 30
replace code_INEGI = 30116 if polygon_name == "Oluta" & cve_edo == 30
replace code_INEGI = 30117 if polygon_name == "Omealca" & cve_edo == 30
replace code_INEGI = 30118 if polygon_name == "Orizaba" & cve_edo == 30
replace code_INEGI = 30119 if polygon_name == "Otatitl-n" & cve_edo == 30
replace code_INEGI = 30120 if polygon_name == "Oteapan" & cve_edo == 30
replace code_INEGI = 30121 if polygon_name == "Ozuluama de Mascare-as" & cve_edo == 30
replace code_INEGI = 30122 if polygon_name == "Pajapan" & cve_edo == 30
replace code_INEGI = 30123 if polygon_name == "P-nuco" & cve_edo == 30
replace code_INEGI = 30124 if polygon_name == "Papantla" & cve_edo == 30
replace code_INEGI = 30125 if polygon_name == "Paso del Macho" & cve_edo == 30
replace code_INEGI = 30126 if polygon_name == "Paso de Ovejas" & cve_edo == 30
replace code_INEGI = 30127 if polygon_name == "La Perla" & cve_edo == 30
replace code_INEGI = 30128 if polygon_name == "Perote" & cve_edo == 30
replace code_INEGI = 30129 if polygon_name == "Plat-n S-nchez" & cve_edo == 30
replace code_INEGI = 30130 if polygon_name == "Playa Vicente" & cve_edo == 30
replace code_INEGI = 30131 if polygon_name == "Poza Rica de Hidalgo" & cve_edo == 30
replace code_INEGI = 30132 if polygon_name == "Las Vigas de Ram-rez" & cve_edo == 30
replace code_INEGI = 30133 if polygon_name == "Pueblo Viejo" & cve_edo == 30
replace code_INEGI = 30134 if polygon_name == "Puente Nacional" & cve_edo == 30
replace code_INEGI = 30135 if polygon_name == "Rafael Delgado" & cve_edo == 30
replace code_INEGI = 30136 if polygon_name == "Rafael Lucio" & cve_edo == 30
replace code_INEGI = 30137 if polygon_name == "Los Reyes" & cve_edo == 30
replace code_INEGI = 30138 if polygon_name == "R-o Blanco" & cve_edo == 30
replace code_INEGI = 30139 if polygon_name == "Saltabarranca" & cve_edo == 30
replace code_INEGI = 30140 if polygon_name == "San Andr-s Tenejapan" & cve_edo == 30
replace code_INEGI = 30141 if polygon_name == "San Andr-s Tuxtla" & cve_edo == 30
replace code_INEGI = 30142 if polygon_name == "San Juan Evangelista" & cve_edo == 30
replace code_INEGI = 30143 if polygon_name == "Santiago Tuxtla" & cve_edo == 30
replace code_INEGI = 30144 if polygon_name == "Sayula de Alem-n" & cve_edo == 30
replace code_INEGI = 30145 if polygon_name == "Soconusco" & cve_edo == 30
replace code_INEGI = 30146 if polygon_name == "Sochiapa" & cve_edo == 30
replace code_INEGI = 30147 if polygon_name == "Soledad Atzompa" & cve_edo == 30
replace code_INEGI = 30148 if polygon_name == "Soledad de Doblado" & cve_edo == 30
replace code_INEGI = 30149 if polygon_name == "Soteapan" & cve_edo == 30
replace code_INEGI = 30150 if polygon_name == "Tamal-n" & cve_edo == 30
replace code_INEGI = 30151 if polygon_name == "Tamiahua" & cve_edo == 30
replace code_INEGI = 30152 if polygon_name == "Tampico Alto" & cve_edo == 30
replace code_INEGI = 30153 if polygon_name == "Tancoco" & cve_edo == 30
replace code_INEGI = 30154 if polygon_name == "Tantima" & cve_edo == 30
replace code_INEGI = 30155 if polygon_name == "Tantoyuca" & cve_edo == 30
replace code_INEGI = 30156 if polygon_name == "Tatatila" & cve_edo == 30
replace code_INEGI = 30157 if polygon_name == "Castillo de Teayo" & cve_edo == 30
replace code_INEGI = 30158 if polygon_name == "Tecolutla" & cve_edo == 30
replace code_INEGI = 30159 if polygon_name == "Tehuipango" & cve_edo == 30
replace code_INEGI = 30160 if polygon_name == "-lamo Temapache" & cve_edo == 30 | polygon_name == "Temapache" & cve_edo == 30
replace code_INEGI = 30161 if polygon_name == "Tempoal" & cve_edo == 30
replace code_INEGI = 30162 if polygon_name == "Tenampa" & cve_edo == 30
replace code_INEGI = 30163 if polygon_name == "Tenochtitl-n" & cve_edo == 30
replace code_INEGI = 30164 if polygon_name == "Teocelo" & cve_edo == 30
replace code_INEGI = 30165 if polygon_name == "Tepatlaxco" & cve_edo == 30
replace code_INEGI = 30166 if polygon_name == "Tepetl-n" & cve_edo == 30
replace code_INEGI = 30167 if polygon_name == "Tepetzintla" & cve_edo == 30
replace code_INEGI = 30168 if polygon_name == "Tequila" & cve_edo == 30
replace code_INEGI = 30169 if polygon_name == "Jos- Azueta" & cve_edo == 30
replace code_INEGI = 30170 if polygon_name == "Texcatepec" & cve_edo == 30
replace code_INEGI = 30171 if polygon_name == "Texhuac-n" & cve_edo == 30
replace code_INEGI = 30172 if polygon_name == "Texistepec" & cve_edo == 30
replace code_INEGI = 30173 if polygon_name == "Tezonapa" & cve_edo == 30
replace code_INEGI = 30174 if polygon_name == "Tierra Blanca" & cve_edo == 30
replace code_INEGI = 30175 if polygon_name == "Tihuatl-n" & cve_edo == 30
replace code_INEGI = 30176 if polygon_name == "Tlacojalpan" & cve_edo == 30
replace code_INEGI = 30177 if polygon_name == "Tlacolulan" & cve_edo == 30
replace code_INEGI = 30178 if polygon_name == "Tlacotalpan" & cve_edo == 30
replace code_INEGI = 30179 if polygon_name == "Tlacotepec de Mej-a" & cve_edo == 30
replace code_INEGI = 30180 if polygon_name == "Tlachichilco" & cve_edo == 30
replace code_INEGI = 30181 if polygon_name == "Tlalixcoyan" & cve_edo == 30
replace code_INEGI = 30182 if polygon_name == "Tlalnelhuayocan" & cve_edo == 30
replace code_INEGI = 30183 if polygon_name == "Tlapacoyan" & cve_edo == 30
replace code_INEGI = 30184 if polygon_name == "Tlaquilpa" & cve_edo == 30
replace code_INEGI = 30185 if polygon_name == "Tlilapan" & cve_edo == 30
replace code_INEGI = 30186 if polygon_name == "Tomatl-n" & cve_edo == 30
replace code_INEGI = 30187 if polygon_name == "Tonay-n" & cve_edo == 30
replace code_INEGI = 30188 if polygon_name == "Totutla" & cve_edo == 30
replace code_INEGI = 30189 if polygon_name == "Tuxpan" & cve_edo == 30
replace code_INEGI = 30190 if polygon_name == "Tuxtilla" & cve_edo == 30
replace code_INEGI = 30191 if polygon_name == "-rsulo Galv-n" & cve_edo == 30
replace code_INEGI = 30192 if polygon_name == "Vega de Alatorre" & cve_edo == 30
replace code_INEGI = 30193 if polygon_name == "Veracruz" & cve_edo == 30
replace code_INEGI = 30194 if polygon_name == "Villa Aldama" & cve_edo == 30
replace code_INEGI = 30195 if polygon_name == "Xoxocotla" & cve_edo == 30
replace code_INEGI = 30196 if polygon_name == "Yanga" & cve_edo == 30
replace code_INEGI = 30197 if polygon_name == "Yecuatla" & cve_edo == 30
replace code_INEGI = 30198 if polygon_name == "Zacualpan" & cve_edo == 30
replace code_INEGI = 30199 if polygon_name == "Zaragoza" & cve_edo == 30
replace code_INEGI = 30200 if polygon_name == "Zentla" & cve_edo == 30
replace code_INEGI = 30201 if polygon_name == "Zongolica" & cve_edo == 30
replace code_INEGI = 30202 if polygon_name == "Zontecomatl-n de L-pez y Fuentes" & cve_edo == 30
replace code_INEGI = 30203 if polygon_name == "Zozocolco de Hidalgo" & cve_edo == 30
replace code_INEGI = 30204 if polygon_name == "Agua Dulce" & cve_edo == 30
replace code_INEGI = 30205 if polygon_name == "El Higo" & cve_edo == 30
replace code_INEGI = 30206 if polygon_name == "Nanchital de L-zaro C-rdenas del R-o" & cve_edo == 30
replace code_INEGI = 30207 if polygon_name == "Tres Valles" & cve_edo == 30
replace code_INEGI = 30208 if polygon_name == "Carlos A. Carrillo" & cve_edo == 30
replace code_INEGI = 30209 if polygon_name == "Tatahuicapan de Ju-rez" & cve_edo == 30
replace code_INEGI = 30210 if polygon_name == "Uxpanapa" & cve_edo == 30
replace code_INEGI = 30211 if polygon_name == "San Rafael" & cve_edo == 30
replace code_INEGI = 30212 if polygon_name == "Santiago Sochiapan" & cve_edo == 30

replace code_INEGI = 31001 if polygon_name == "Abal-" & cve_edo == 31
replace code_INEGI = 31002 if polygon_name == "Acanceh" & cve_edo == 31
replace code_INEGI = 31003 if polygon_name == "Akil" & cve_edo == 31
replace code_INEGI = 31004 if polygon_name == "Baca" & cve_edo == 31
replace code_INEGI = 31005 if polygon_name == "Bokob-" & cve_edo == 31
replace code_INEGI = 31006 if polygon_name == "Buctzotz" & cve_edo == 31
replace code_INEGI = 31007 if polygon_name == "Cacalch-n" & cve_edo == 31
replace code_INEGI = 31008 if polygon_name == "Calotmul" & cve_edo == 31
replace code_INEGI = 31009 if polygon_name == "Cansahcab" & cve_edo == 31
replace code_INEGI = 31010 if polygon_name == "Cantamayec" & cve_edo == 31
replace code_INEGI = 31011 if polygon_name == "Celest-n" & cve_edo == 31
replace code_INEGI = 31012 if polygon_name == "Cenotillo" & cve_edo == 31
replace code_INEGI = 31013 if polygon_name == "Conkal" & cve_edo == 31
replace code_INEGI = 31014 if polygon_name == "Cuncunul" & cve_edo == 31
replace code_INEGI = 31015 if polygon_name == "Cuzam-" & cve_edo == 31
replace code_INEGI = 31016 if polygon_name == "Chacsink-n" & cve_edo == 31
replace code_INEGI = 31017 if polygon_name == "Chankom" & cve_edo == 31
replace code_INEGI = 31018 if polygon_name == "Chapab" & cve_edo == 31
replace code_INEGI = 31019 if polygon_name == "Chemax" & cve_edo == 31
replace code_INEGI = 31020 if polygon_name == "Chicxulub Pueblo" & cve_edo == 31
replace code_INEGI = 31021 if polygon_name == "Chichimil-" & cve_edo == 31
replace code_INEGI = 31022 if polygon_name == "Chikindzonot" & cve_edo == 31
replace code_INEGI = 31023 if polygon_name == "Chochol-" & cve_edo == 31
replace code_INEGI = 31024 if polygon_name == "Chumayel" & cve_edo == 31
replace code_INEGI = 31025 if polygon_name == "Dz-n" & cve_edo == 31
replace code_INEGI = 31026 if polygon_name == "Dzemul" & cve_edo == 31
replace code_INEGI = 31027 if polygon_name == "Dzidzant-n" & cve_edo == 31
replace code_INEGI = 31028 if polygon_name == "Dzilam de Bravo" & cve_edo == 31
replace code_INEGI = 31029 if polygon_name == "Dzilam Gonz-lez" & cve_edo == 31
replace code_INEGI = 31030 if polygon_name == "Dzit-s" & cve_edo == 31
replace code_INEGI = 31031 if polygon_name == "Dzoncauich" & cve_edo == 31
replace code_INEGI = 31032 if polygon_name == "Espita" & cve_edo == 31
replace code_INEGI = 31033 if polygon_name == "Halach-" & cve_edo == 31
replace code_INEGI = 31034 if polygon_name == "Hocab-" & cve_edo == 31
replace code_INEGI = 31035 if polygon_name == "Hoct-n" & cve_edo == 31
replace code_INEGI = 31036 if polygon_name == "Hom-n" & cve_edo == 31
replace code_INEGI = 31037 if polygon_name == "Huh-" & cve_edo == 31
replace code_INEGI = 31038 if polygon_name == "Hunucm-" & cve_edo == 31
replace code_INEGI = 31039 if polygon_name == "Ixil" & cve_edo == 31
replace code_INEGI = 31040 if polygon_name == "Izamal" & cve_edo == 31
replace code_INEGI = 31041 if polygon_name == "Kanas-n" & cve_edo == 31
replace code_INEGI = 31042 if polygon_name == "Kantunil" & cve_edo == 31
replace code_INEGI = 31043 if polygon_name == "Kaua" & cve_edo == 31
replace code_INEGI = 31044 if polygon_name == "Kinchil" & cve_edo == 31
replace code_INEGI = 31045 if polygon_name == "Kopom-" & cve_edo == 31
replace code_INEGI = 31046 if polygon_name == "Mama" & cve_edo == 31
replace code_INEGI = 31047 if polygon_name == "Man-" & cve_edo == 31
replace code_INEGI = 31048 if polygon_name == "Maxcan-" & cve_edo == 31
replace code_INEGI = 31049 if polygon_name == "Mayap-n" & cve_edo == 31
replace code_INEGI = 31050 if polygon_name == "M-rida" & cve_edo == 31
replace code_INEGI = 31051 if polygon_name == "Mococh-" & cve_edo == 31
replace code_INEGI = 31052 if polygon_name == "Motul" & cve_edo == 31
replace code_INEGI = 31053 if polygon_name == "Muna" & cve_edo == 31
replace code_INEGI = 31054 if polygon_name == "Muxupip" & cve_edo == 31
replace code_INEGI = 31055 if polygon_name == "Opich-n" & cve_edo == 31
replace code_INEGI = 31056 if polygon_name == "Oxkutzcab" & cve_edo == 31
replace code_INEGI = 31057 if polygon_name == "Panab-" & cve_edo == 31
replace code_INEGI = 31058 if polygon_name == "Peto" & cve_edo == 31
replace code_INEGI = 31059 if polygon_name == "Progreso" & cve_edo == 31
replace code_INEGI = 31060 if polygon_name == "Quintana Roo" & cve_edo == 31
replace code_INEGI = 31061 if polygon_name == "R-o Lagartos" & cve_edo == 31
replace code_INEGI = 31062 if polygon_name == "Sacalum" & cve_edo == 31
replace code_INEGI = 31063 if polygon_name == "Samahil" & cve_edo == 31
replace code_INEGI = 31064 if polygon_name == "Sanahcat" & cve_edo == 31
replace code_INEGI = 31065 if polygon_name == "San Felipe" & cve_edo == 31
replace code_INEGI = 31066 if polygon_name == "Santa Elena" & cve_edo == 31
replace code_INEGI = 31067 if polygon_name == "Sey-" & cve_edo == 31
replace code_INEGI = 31068 if polygon_name == "Sinanch-" & cve_edo == 31
replace code_INEGI = 31069 if polygon_name == "Sotuta" & cve_edo == 31
replace code_INEGI = 31070 if polygon_name == "Sucil-" & cve_edo == 31
replace code_INEGI = 31071 if polygon_name == "Sudzal" & cve_edo == 31
replace code_INEGI = 31072 if polygon_name == "Suma" & cve_edo == 31
replace code_INEGI = 31073 if polygon_name == "Tahdzi-" & cve_edo == 31
replace code_INEGI = 31074 if polygon_name == "Tahmek" & cve_edo == 31
replace code_INEGI = 31075 if polygon_name == "Teabo" & cve_edo == 31
replace code_INEGI = 31076 if polygon_name == "Tecoh" & cve_edo == 31
replace code_INEGI = 31077 if polygon_name == "Tekal de Venegas" & cve_edo == 31
replace code_INEGI = 31078 if polygon_name == "Tekant-" & cve_edo == 31
replace code_INEGI = 31079 if polygon_name == "Tekax" & cve_edo == 31
replace code_INEGI = 31080 if polygon_name == "Tekit" & cve_edo == 31
replace code_INEGI = 31081 if polygon_name == "Tekom" & cve_edo == 31
replace code_INEGI = 31082 if polygon_name == "Telchac Pueblo" & cve_edo == 31
replace code_INEGI = 31083 if polygon_name == "Telchac Puerto" & cve_edo == 31
replace code_INEGI = 31084 if polygon_name == "Temax" & cve_edo == 31
replace code_INEGI = 31085 if polygon_name == "Temoz-n" & cve_edo == 31
replace code_INEGI = 31086 if polygon_name == "Tepak-n" & cve_edo == 31
replace code_INEGI = 31087 if polygon_name == "Tetiz" & cve_edo == 31
replace code_INEGI = 31088 if polygon_name == "Teya" & cve_edo == 31
replace code_INEGI = 31089 if polygon_name == "Ticul" & cve_edo == 31
replace code_INEGI = 31090 if polygon_name == "Timucuy" & cve_edo == 31
replace code_INEGI = 31091 if polygon_name == "Tinum" & cve_edo == 31
replace code_INEGI = 31092 if polygon_name == "Tixcacalcupul" & cve_edo == 31
replace code_INEGI = 31093 if polygon_name == "Tixkokob" & cve_edo == 31
replace code_INEGI = 31094 if polygon_name == "Tixmehuac" & cve_edo == 31
replace code_INEGI = 31095 if polygon_name == "Tixp-hual" & cve_edo == 31
replace code_INEGI = 31096 if polygon_name == "Tizim-n" & cve_edo == 31
replace code_INEGI = 31097 if polygon_name == "Tunk-s" & cve_edo == 31
replace code_INEGI = 31098 if polygon_name == "Tzucacab" & cve_edo == 31
replace code_INEGI = 31099 if polygon_name == "Uayma" & cve_edo == 31
replace code_INEGI = 31100 if polygon_name == "Uc-" & cve_edo == 31
replace code_INEGI = 31101 if polygon_name == "Um-n" & cve_edo == 31
replace code_INEGI = 31102 if polygon_name == "Valladolid" & cve_edo == 31
replace code_INEGI = 31103 if polygon_name == "Xocchel" & cve_edo == 31
replace code_INEGI = 31104 if polygon_name == "Yaxcab-" & cve_edo == 31
replace code_INEGI = 31105 if polygon_name == "Yaxkukul" & cve_edo == 31
replace code_INEGI = 31106 if polygon_name == "Yoba-n" & cve_edo == 31

replace code_INEGI = 32001 if polygon_name == "Apozol" & cve_edo == 32
replace code_INEGI = 32002 if polygon_name == "Apulco" & cve_edo == 32
replace code_INEGI = 32003 if polygon_name == "Atolinga" & cve_edo == 32
replace code_INEGI = 32004 if polygon_name == "Benito Ju-rez" & cve_edo == 32
replace code_INEGI = 32005 if polygon_name == "Calera" & cve_edo == 32
replace code_INEGI = 32006 if polygon_name == "Ca-itas de Felipe Pescador" & cve_edo == 32
replace code_INEGI = 32007 if polygon_name == "Concepci-n del Oro" & cve_edo == 32
replace code_INEGI = 32008 if polygon_name == "Cuauht-moc" & cve_edo == 32
replace code_INEGI = 32009 if polygon_name == "Chalchihuites" & cve_edo == 32
replace code_INEGI = 32010 if polygon_name == "Fresnillo" & cve_edo == 32
replace code_INEGI = 32011 if polygon_name == "Trinidad Garc-a de la Cadena" & cve_edo == 32
replace code_INEGI = 32012 if polygon_name == "Genaro Codina" & cve_edo == 32
replace code_INEGI = 32013 if polygon_name == "General Enrique Estrada" & cve_edo == 32
replace code_INEGI = 32014 if polygon_name == "General Francisco R. Murgu-a" & cve_edo == 32
replace code_INEGI = 32015 if polygon_name == "El Plateado de Joaqu-n Amaro" & cve_edo == 32
replace code_INEGI = 32016 if polygon_name == "General P-nfilo Natera" & cve_edo == 32
replace code_INEGI = 32017 if polygon_name == "Guadalupe" & cve_edo == 32
replace code_INEGI = 32018 if polygon_name == "Huanusco" & cve_edo == 32
replace code_INEGI = 32019 if polygon_name == "Jalpa" & cve_edo == 32
replace code_INEGI = 32020 if polygon_name == "Jerez" & cve_edo == 32
replace code_INEGI = 32021 if polygon_name == "Jim-nez del Teul" & cve_edo == 32
replace code_INEGI = 32022 if polygon_name == "Juan Aldama" & cve_edo == 32
replace code_INEGI = 32023 if polygon_name == "Juchipila" & cve_edo == 32
replace code_INEGI = 32024 if polygon_name == "Loreto" & cve_edo == 32
replace code_INEGI = 32025 if polygon_name == "Luis Moya" & cve_edo == 32
replace code_INEGI = 32026 if polygon_name == "Mazapil" & cve_edo == 32
replace code_INEGI = 32027 if polygon_name == "Melchor Ocampo" & cve_edo == 32
replace code_INEGI = 32028 if polygon_name == "Mezquital del Oro" & cve_edo == 32
replace code_INEGI = 32029 if polygon_name == "Miguel Auza" & cve_edo == 32
replace code_INEGI = 32030 if polygon_name == "Momax" & cve_edo == 32
replace code_INEGI = 32031 if polygon_name == "Monte Escobedo" & cve_edo == 32
replace code_INEGI = 32032 if polygon_name == "Morelos" & cve_edo == 32
replace code_INEGI = 32033 if polygon_name == "Moyahua de Estrada" & cve_edo == 32
replace code_INEGI = 32034 if polygon_name == "Nochistl-n de Mej-a" & cve_edo == 32
replace code_INEGI = 32035 if polygon_name == "Noria de -ngeles" & cve_edo == 32
replace code_INEGI = 32036 if polygon_name == "Ojocaliente" & cve_edo == 32
replace code_INEGI = 32037 if polygon_name == "P-nuco" & cve_edo == 32
replace code_INEGI = 32038 if polygon_name == "Pinos" & cve_edo == 32
replace code_INEGI = 32039 if polygon_name == "R-o Grande" & cve_edo == 32
replace code_INEGI = 32040 if polygon_name == "Sain Alto" & cve_edo == 32
replace code_INEGI = 32041 if polygon_name == "El Salvador" & cve_edo == 32
replace code_INEGI = 32042 if polygon_name == "Sombrerete" & cve_edo == 32
replace code_INEGI = 32043 if polygon_name == "Susticac-n" & cve_edo == 32
replace code_INEGI = 32044 if polygon_name == "Tabasco" & cve_edo == 32
replace code_INEGI = 32045 if polygon_name == "Tepechitl-n" & cve_edo == 32
replace code_INEGI = 32046 if polygon_name == "Tepetongo" & cve_edo == 32
replace code_INEGI = 32047 if polygon_name == "Te-l de Gonz-lez Ortega" & cve_edo == 32
replace code_INEGI = 32048 if polygon_name == "Tlaltenango de S-nchez Rom-n" & cve_edo == 32
replace code_INEGI = 32049 if polygon_name == "Valpara-so" & cve_edo == 32
replace code_INEGI = 32050 if polygon_name == "Vetagrande" & cve_edo == 32
replace code_INEGI = 32051 if polygon_name == "Villa de Cos" & cve_edo == 32
replace code_INEGI = 32052 if polygon_name == "Villa Garc-a" & cve_edo == 32
replace code_INEGI = 32053 if polygon_name == "Villa Gonz-lez Ortega" & cve_edo == 32
replace code_INEGI = 32054 if polygon_name == "Villa Hidalgo" & cve_edo == 32
replace code_INEGI = 32055 if polygon_name == "Villanueva" & cve_edo == 32
replace code_INEGI = 32056 if polygon_name == "Zacatecas" & cve_edo == 32
replace code_INEGI = 32057 if polygon_name == "Trancoso" & cve_edo == 32
replace code_INEGI = 32058 if polygon_name == "Santa Mar-a de la Paz" & cve_edo == 32
}

replace polygon_name = subinstr(polygon_name,"Dist. ","",.)

export delimited using "Dataset/Facebook/PB Mexico Admin L3 (polygon).csv", replace


forvalues m = 5/6 {
forvalues d = 1/31 {

cap erase "Dataset/Facebook/Movement Range/aux`m'`d'.dta"

}
}
