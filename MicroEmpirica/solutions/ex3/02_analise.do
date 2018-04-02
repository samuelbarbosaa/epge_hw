* Configuração do ambiente de trabalho
global root  "E:\Projetos\EPGE_github\MicroEmpirica" 
global data_raw "${root}\data_raw\pnad"
global data "${root}\data\pnad"
cd "${data_raw}"

clear all

set dp comma

* Seleciona variáveis de interesse
use "${data}\ex3.dta", clear

svyset psu [pweight=weights], strata(strata)

quietly { 
	svydescribe, gen(A)
	drop if A==1
}


* TABELA 1

tabulate age_cat if sp==1 										  // subpopulation observations
svy, subpop(sp): tabulate employer age_cat, count format(%14.3gc) // Expanded Subpop Size
svy, subpop(sp): tabulate employer age_cat, column 				  // Fractions

tabulate age_cat if rj==1 										  // subpopulation observations
svy, subpop(rj): tabulate employer age_cat, count format(%14.3gc) // Expanded Subpop Size
svy, subpop(rj): tabulate employer age_cat, column 				  // Fractions

svy: tabulate employer  // number of observations, population represented

* TABELAS 2 E 3
quietly tabulate age_cat, generate(age)

foreach uf in sp rj {
	foreach var of varlist age1-age7 {
		gen `uf'_`var' = `uf' * `var'
	}
}

* SP
global splist = ""
foreach var of varlist arthritis-tuberculosis {
 	foreach spg of varlist sp_age1-sp_age7 {
			quietly svy, subpop(`spg'): regress `var' ind_dummy emp_dummy
			estimates store model_`var'_`spg'
			global splist = "${splist} model_`var'_`spg'"
	}
	esttab ${splist} using "${root}\solutions\ex3\sp.tex", plain star append ///
		label noobs nonotes nonumbers not nogaps title("`: var label `var''") ///
		mtitles("0-17" "18-29" "30-39" "40-49" "50-59" "60-69" ">= 70") ///
		fragment b(%8.2f) transform(@*100)
	global splist = ""

}

* RJ
global splist = ""
foreach var of varlist arthritis-tuberculosis {
 	foreach spg of varlist rj_age1-rj_age7 {
			quietly svy, subpop(`spg'): regress `var' ind_dummy emp_dummy
			estimates store model_`var'_`spg'
			global splist = "${splist} model_`var'_`spg'"
	}
	esttab ${splist} using "${root}\solutions\ex3\rj.tex", plain star append ///
		label noobs nonotes nonumbers not nogaps title("`: var label `var''") ///
		mtitles("0-17" "18-29" "30-39" "40-49" "50-59" "60-69" ">= 70") ///
		fragment b(%8.2f) transform(@*100)
	global splist = ""

}
