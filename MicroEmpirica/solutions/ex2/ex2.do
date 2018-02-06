* Micro Empírica
* Trabalho 02
* Samuel Barbosa

/* Neste exercício vamos estimar a equação de salários (Mincer, 1974) com a
correção do viés de seleção das informações dos salários através do procedimento
de Heckman (1979). Vamos utilizar os dados da PNAD 2015, considerando somente a
subpopulação de indivíduos de 18 a 65 anos de idade. */

global root  "E:\Projetos\EPGE_github\MicroEmpirica\" 
global data_raw "${root}\data_raw\pnad"
global data "${root}\data\pnad"
cd "${data_raw}"

clear all

use pnad2015.dta

* Cria, altera e renomeia variáveis 
rename (v4718 v4803 v8005 v0404 v0302) (renda anos_estudo idade cor_raca mulher)
rename (v4729 v4617 v4618) (peso estrato psu)

gen idade2 = idade^2
gen log_renda = ln(renda) // renda = 0 é descartado.

recode anos_estudo (17 = .)
recode renda (999999999999 = .)

replace anos_estudo = anos_estudo - 1

keep v0101 v0102 v0103 mulher idade idade2 v0401 v4111 cor_raca anos_estudo ///
     renda log_renda peso estrato psu

drop if renda == .
gen ind_renda = 0
replace ind_renda = 1 if renda > 0


egen id_dom = concat(v0101 v0102 v0103)
bysort id_dom: egen n_filhos = total(v0401==3 & idade<18)
replace n_filhos = 0 if v0401>2	

gen pia = 0
replace pia = 1 if idade >= 18 & idade <= 65

gen casal = 0
replace casal = 1 if v4111 == 1

replace mulher = 1 if mulher == 4
replace mulher = 0 if mulher == 2

gen mulher_casal = mulher * casal
gen n_filhos_mulher = n_filhos * mulher

* Labels
label define mulher_labels 0 "Não" 1 "Sim"
label define casal 0 "Não" 1 "Sim"	  
label define cor_raca_labels 0 /// 
	  "Indigena" 2 "Branca" 4 "Preta" 6 "Amarela" 8 "Parda" 9 "SemDecl"

label value mulher mulher_labels
label value cor_raca cor_raca_labels

/* EXERCÍCIO EMPÍRICO */

* log using "${root}\solutions\ex2\ex2_log.smcl", replace

* Define o Desenho Amostral
svyset psu [pw = peso], strata(estrato)

* Identifica os estratos com psu unico 
quietly svydes, gen(single2)
drop if single2==1

* (a) Regressão OLS - Retornos a educação
svy, subpop(pia): reg log_renda anos_estudo mulher idade idade2

esttab using "${root}\solutions\ex2\tabela_1.tex", ///
		title("Equação de Mincer desconsiderando viés de seleção") ///
		booktabs ///
		replace

* (b) Regressão OLS - Retornos a educação
svy, subpop(pia): probit ind_renda anos_estudo mulher casal mulher_casal n_filhos n_filhos_mulher
esttab using "${root}\solutions\ex2\tabela_2.tex", ///
		title("Equação de seleçao - Modelo Probit") ///
		booktabs ///
		replace

* (c) Heckman Correction
svy, subpop(pia): heckman log_renda anos_estudo mulher idade idade2, select(ind_renda = anos_estudo mulher casal mulher_casal n_filhos n_filhos_mulher)
esttab using "${root}\solutions\ex2\tabela_3.tex", ///
		title("Equação de Mincer (com correção de Heckman)") ///
		booktabs ///
		nostar ///
		replace
		
* log close




	
	