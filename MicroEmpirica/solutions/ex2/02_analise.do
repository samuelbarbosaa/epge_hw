* Micro Empírica
* Trabalho 02
* Samuel Barbosa

/* Neste exercício vamos estimar a equação de salários (Mincer, 1974) com a
correção do viés de seleção das informações dos salários através do procedimento
de Heckman (1979). Vamos utilizar os dados da PNAD 2015, considerando somente a
subpopulação de indivíduos de 18 a 65 anos de idade. */

* Configuração do ambiente de trabalho
global root  "E:\Projetos\EPGE_github\MicroEmpirica\" 
global data_raw "${root}\data_raw\pnad"
global data "${root}\data\pnad"
cd "${data_raw}"

clear all

log using "${root}\solutions\ex2\ex2_log.smcl", replace

/* EXERCÍCIO EMPÍRICO */
use "${data}/pnad2015_ex2.dta", clear

* Define o Desenho Amostral
svyset psu [pw = peso], strata(estrato)

* Identifica os estratos com psu unico 
quietly svydes, gen(single2)
drop if single2==1

* (a) Regressão OLS - Retornos a educação
svy, subpop(pia): reg log_renda anos_estudo i.mulher idade idade2

esttab using "${root}\solutions\ex2\tabela_1.tex", ///
		title("Equação de Mincer desconsiderando viés de seleção") ///
		booktabs ///
		replace

* (b) Regressão OLS - Retornos a educação
svy, subpop(pia): probit ind_renda anos_estudo casal##mulher c.n_filhos##mulher
esttab using "${root}\solutions\ex2\tabela_2.tex", ///
		title("Equação de seleçao - Modelo Probit") ///
		booktabs ///
		replace

* (c) Heckman Correction
svy, subpop(pia): heckman log_renda anos_estudo i.mulher idade idade2, select(ind_renda = anos_estudo casal##mulher c.n_filhos##mulher)
esttab using "${root}\solutions\ex2\tabela_3.tex", ///
		title("Equação de Mincer (com correção de Heckman)") ///
		booktabs ///
		nostar ///
		replace
		
* (d) Two step Correction

log close




	
	