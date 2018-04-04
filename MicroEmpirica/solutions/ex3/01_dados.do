* Configuração do ambiente de trabalho
global root  "E:\Projetos\EPGE_github\MicroEmpirica" 
global data_raw "${root}\data_raw\pnad"
global data "${root}\data\pnad"
cd "${data_raw}"

clear all

* Obtém dados de domicilios e pessoas da PNAD 2003.
* datazoom_pnad, years(2003) original("${data_raw}\PES2003.txt", "${data_raw}\DOM2003.txt") saving("${data}") both ncomp

* Seleciona variáveis de interesse
use "${data}\pnad2003.dta", clear

keep uf v1309 v1310 v1311 v1312 v1313 v1314 v1315 v1316 v1317 ///
	 v1321 v1332 v1324 v1318 v1319 v1320 v8005 v4727 v4618 v4617 v4729 ///
	 v4721

rename v1310 arthritis
rename v1313 bronchitis
rename v1311 cancer
rename v1316 chronic_renal
rename v1320 cirrhosis
rename v1317 depression
rename v1312 diabetes
rename v1315 heart_disease
rename v1314 hypertension
rename v1309 lumbar_pain
rename v1319 tendinitis
rename v1318 tuberculosis
rename v1321 insured
rename v1332 payment
rename v8005 age
rename v4727 area_cens
rename v4618 psu
rename v4617 strata
rename v4729 weights
rename v4721 renda_dom

label var arthritis			"Arthritis or Rheumatism"
label var bronchitis		"Bronchitis or Asthma"
label var cancer			"Cancer"
label var chronic_renal		"Chronic Renal Disease"
label var cirrhosis			"Cirrhosis"
label var depression		"Depression"
label var diabetes			"Diabetes"
label var heart_disease		"Heart Disease"
label var hypertension		"Hypertension"
label var lumbar_pain		"Lumbar Pain"
label var tendinitis		"Tendonitis"
label var tuberculosis		"Tuberculosis"

recode arthritis 		(2=1) (4=0) (9=.)
recode bronchitis 		  	  (3=0) (9=.)
recode cancer 				  (3=0) (9=.)
recode chronic_renal	(2=1) (4=0) (9=.)
recode cirrhosis		(2=1) (4=0) (9=.)
recode depression			  (3=0) (9=.)
recode diabetes			(2=1) (4=0) (9=.) 
recode heart_disease		  (3=0) (9=.)
recode hypertension		(2=1) (4=0) (9=.) 
recode lumbar_pain			  (3=0) (9=.)
recode tendinitis			  (3=0) (9=.) 
recode tuberculosis		(2=1) (4=0) (9=.) 

recode renda_dom (999999999999=.)

order arthritis bronchitis cancer chronic_renal cirrhosis depression ///
	  diabetes heart_disease hypertension lumbar_pain tendinitis tuberculosis 

* Plano de saude
recode insured (5=0) (9=.) (3=1)

gen employer = 4 if insured == 1 
replace employer = 2 if payment >= 4 & payment <= 6
recode employer (.=6)

label define insurance_type 2 "Individual Coverage" 4 "Employer-Contracted Plan" 6 "Not Insured"
label values employer insurance_type

gen emp_dummy = 0
replace emp_dummy = 1 if employer == 4
label var emp_dummy "Employer-Contracted Plan"

gen ind_dummy = 0
replace ind_dummy = 1 if employer == 2
label var ind_dummy "Individual Coverage"

* Categorias de idade
gen age_cat = 7 if age >= 70
replace age_cat = 6 if age < 70
replace age_cat = 5 if age < 60
replace age_cat = 4 if age < 50
replace age_cat = 3 if age < 40
replace age_cat = 2 if age < 30
replace age_cat = 1 if age < 18

label define age_categories 1 "0-17" 2 "18-29" 3 "30-39" 4 "40-49" 5 "50-59" 6 "60-69" 7 ">=70"
label values age_cat age_categories

* Area metropolitana de Sao Paulo
gen sp = 0
replace sp = 1 if area_cens==1 & uf=="35"

* Area metropolitana do RJ
gen rj = 0
replace rj = 1 if area_cens==1 & uf=="33"

save "${data}\ex3.dta", replace
