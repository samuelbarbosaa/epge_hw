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

*-------------------------------------------------------------------------------
* 25% mais ricos e 25% mais pobres
pctile dec1 = renda_dom [pweight=weights], nq(4)
list dec1 in 1/4

gen fq = 0 if renda_dom != .
replace fq = 1 if renda_dom <= 400

gen lq = 0 if renda_dom != .
replace lq = 1 if renda_dom > 1425

gen spf = 0
replace spf = 1 if sp==1 & fq ==1

gen spl = 0
replace spl = 1 if sp==1 & lq ==1

gen rjf = 0
replace rjf = 1 if rj==1 & fq ==1

gen rjl = 0
replace rjl = 1 if rj==1 & lq ==1

*-------------------------------------------------------------------------------
* Observacoes e subpopulacao

* SP 25% mais pobres
tabulate age_cat if spf==1 										  // subpopulation observations
svy, subpop(spf): tabulate employer age_cat, count format(%14.3gc) // Expanded Subpop Size

* SP 25% mais ricos
tabulate age_cat if spl==1 										  // subpopulation observations
svy, subpop(spl): tabulate employer age_cat, count format(%14.3gc) // Expanded Subpop Size

* RJ 25% mais pobres
tabulate age_cat if rjf==1 										  // subpopulation observations
svy, subpop(rjf): tabulate employer age_cat, count format(%14.3gc) // Expanded Subpop Size

* RJ 25% mais ricos
tabulate age_cat if rjl==1 										  // subpopulation observations
svy, subpop(rjl): tabulate employer age_cat, count format(%14.3gc) // Expanded Subpop Size

*-------------------------------------------------------------------------------
* TABELAS 
*-------------------------------------------------------------------------------
quietly tabulate age_cat, generate(age)

* SP ---------------------------------------------------------------------------
foreach uf in spf spl rjf rjl {
	foreach var of varlist age1-age7 {
		gen `uf'_`var' = `uf' * `var'
	}
}

* SP 10% mais pobres
global splist = ""
foreach var of varlist arthritis-tuberculosis {
 	foreach spg of varlist spf_age1-spf_age7 {
			quietly svy, subpop(`spg'): regress `var' ind_dummy emp_dummy
			estimates store `var'_`spg'
			global splist = "${splist} `var'_`spg'"
	}
	esttab ${splist} using "${root}\solutions\ex3\spf.tex", plain star append ///
		label noobs nonotes nonumbers not nogaps title("`: var label `var''") ///
		mtitles("0-17" "18-29" "30-39" "40-49" "50-59" "60-69" ">= 70") ///
		fragment b(%8.2f) transform(@*100)
	global splist = ""
}

* SP 10% mais ricos
global splist = ""
foreach var of varlist arthritis-tuberculosis {
 	foreach spg of varlist spl_age1-spl_age7 {
			quietly svy, subpop(`spg'): regress `var' ind_dummy emp_dummy
			estimates store `var'_`spg'
			global splist = "${splist} `var'_`spg'"
	}
	esttab ${splist} using "${root}\solutions\ex3\spl.tex", plain star append ///
		label noobs nonotes nonumbers not nogaps title("`: var label `var''") ///
		mtitles("0-17" "18-29" "30-39" "40-49" "50-59" "60-69" ">= 70") ///
		fragment b(%8.2f) transform(@*100)
	global splist = ""
}


* RJ ---------------------------------------------------------------------------

* RJ 10% mais pobres
global splist = ""
foreach var of varlist arthritis-tuberculosis {
 	foreach spg of varlist rjf_age1-rjf_age7 {
			quietly svy, subpop(`spg'): regress `var' ind_dummy emp_dummy
			estimates store `var'_`spg'
			global splist = "${splist} `var'_`spg'"
	}
	esttab ${splist} using "${root}\solutions\ex3\rjf.tex", plain star append ///
		label noobs nonotes nonumbers not nogaps title("`: var label `var''") ///
		mtitles("0-17" "18-29" "30-39" "40-49" "50-59" "60-69" ">= 70") ///
		fragment b(%8.2f) transform(@*100)
	global splist = ""
}

* RJ 10% mais ricos
global splist = ""
foreach var of varlist arthritis-tuberculosis {
 	foreach spg of varlist rjl_age1-rjl_age7 {
			quietly svy, subpop(`spg'): regress `var' ind_dummy emp_dummy
			estimates store `var'_`spg'
			global splist = "${splist} `var'_`spg'"
	}
	esttab ${splist} using "${root}\solutions\ex3\rjl.tex", plain star append ///
		label noobs nonotes nonumbers not nogaps title("`: var label `var''") ///
		mtitles("0-17" "18-29" "30-39" "40-49" "50-59" "60-69" ">= 70") ///
		fragment b(%8.2f) transform(@*100)
	global splist = ""
}


* SP e RJ -----------------------------------------------------------------------
foreach subpop in fq lq {
	foreach var of varlist age1-age7 {
		gen `subpop'_`var' = `subpop' * `var'
		replace `subpop'_`var' = 0 if rj == 0 & sp == 0
	}
}

global splist = ""
foreach var of varlist arthritis-tuberculosis {
 	foreach spg of varlist fq_age1-fq_age7 {
			quietly svy, subpop(`spg'): regress `var' ind_dummy emp_dummy
			estimates store `var'_`spg'
			global splist = "${splist} `var'_`spg'"
	}
	esttab ${splist} using "${root}\solutions\ex3\sp_rj_fq.tex", plain star append ///
		label noobs nonotes nonumbers not nogaps title("`: var label `var''") ///
		mtitles("0-17" "18-29" "30-39" "40-49" "50-59" "60-69" ">= 70") ///
		fragment b(%8.2f) transform(@*100)
	global splist = ""
}


global splist = ""
foreach var of varlist arthritis-tuberculosis {
 	foreach spg of varlist lq_age1-lq_age7 {
			quietly svy, subpop(`spg'): regress `var' ind_dummy emp_dummy
			estimates store `var'_`spg'
			global splist = "${splist} `var'_`spg'"
	}
	esttab ${splist} using "${root}\solutions\ex3\sp_rj_lq.tex", plain star append ///
		label noobs nonotes nonumbers not nogaps title("`: var label `var''") ///
		mtitles("0-17" "18-29" "30-39" "40-49" "50-59" "60-69" ">= 70") ///
		fragment b(%8.2f) transform(@*100)
	global splist = ""
}
