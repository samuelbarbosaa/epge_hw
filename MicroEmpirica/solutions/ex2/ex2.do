* Micro Empírica
* Trabalho 02
* Samuel Barbosa

/* Neste exercício vamos estimar a equação de salários (Mincer, 1974) com a
correção do viés de seleção das informações dos salários através do procedimento
de Heckman (1979). Vamos utilizar os dados da PNAD 2015, considerando somente a
subpopulação de indivíduos de 18 a 65 anos de idade. */

* Configuração do ambiente de trabalho
global root  "E:\Projetos\EPGE_github\MicroEmpirica" 
global data "${root}/data/pnad"
cd "${data}"
clear all

log using "${root}\solutions\ex2\ex2_log.smcl", replace

/* EXERCÍCIO EMPÍRICO */
use "${data}/pnad2015_ex2.dta", clear

* Define o Desenho Amostral
svyset psu [pw = peso], strata(estrato)

* Identifica os estratos com psu unico 
svydes, gen(single2)
drop if single2==1

* (a) Regressão OLS - Retornos a educação
svy: reg log_renda anos_estudo i.sexo idade idade2

* (b) Regressão OLS - Retornos a educação
svy: probit ind_renda anos_estudo casado##sexo c.n_filhos##sexo

log close
