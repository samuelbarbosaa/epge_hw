*********************************************************
*           Guia para o Trabalho 1 - Micro Empírica		*
*					Laísa Rachter 						*
*********************************************************

  * Esse do-file lê os Microdados da PNAD 2014, trata algumas variáveis de interesse e estima equação Mineceriana
  * INPUT: Dados Brutos - Microdados PNAD PES.TXT
  * OUTPUT: Dados Tratados - Pnad.dta e tabelas Resultados.xls

	clear all

	 log using "C:\Users\Trabalho1_Nome.smcl", replace // log file: salva todo o output da tela de resultados


	/* Globals */

		global root  "C:\Users\Monitoria" 
		global RawData "${root}\Dados Brutos"
		global TreatedData "${root}\Dados Tratados"
	
		chdir "${RawData}" //Define o Diretório
		
		
	/* LEITURA E TRATAMENTO DOS DADOS */

	  * Infile: a partir do dicionário de variáveis, o comando infile faz a leitura dos dados em .txt 

	   * Pessoas

		infile using "pnadpes.dct", using(PES2014.TXT)	
		sort uf v0102 v0103
		save pnadPes.dta, replace	
		clear

	  * Domicílios

		infile using "pnaddom.dct", using(DOM2014.TXT)	
		 sort uf v0102 v0103
		save pnadDom.dta, replace	
		clear

	/* Merge:

	Combina o banco de dados de pessoas e domicílios. O "Master Data" usado foi o banco de dados de pessoas e o "Using" o banco de dados de domicílios 
	merge correto deve ser o "many to 1" - a partir do identificador de domicílio, que combina uf, número de série e número de controle, estamos identificando pessoas e seus respectivos domicílios. 
	Quando dropamos _merge==2, estamos eliminando da base de dados as observações que apareciam somente no banco de dados "using" (não teve match nos dados "master".  
	*/

		use pnadpes.dta, clear
		 merge m:1 uf v0102 v0103 using pnadDom
		 drop if _merge==2
		 drop _merge
		save pesdom, replace	
						

	foreach i in Pes Dom{
	erase pnad`i'_2014.dta					
	}
						
						
	/* TRATAMENTO */ 

	recode v8005 (999=.), g(idade)  //Pnads mais recentes já vem sem o 999

	gen idade2 = idade^2

	gen female=1 if sexo==0
	replace female=0 if sexo==1
	
	//continuar....
	
	
	* Variáveis para Definir Amostra Complexa

	rename (v4729 v4617 v4618) (peso estrato psu)
		
   /* KEEPING */

	*Ordeno e mantenho no banco de daos as variáveis de interesse

	order v0101 uf idade idade2 female etc...
			
	keep v0101 uf v0104 v0105 v0106 idade idade2 sexo female urbana metropol cor anoest trabalhou_semana ///
	horas_trab_sem renda_mensal_din estrato psu peso
		
	  save "${TreatedData}/Pnad.dta", replace


	/* EXERCÍCIO EMPÍRICO */


  use "${TreatedData}/Pnad.dta", clear

	* Define o Desenho Amostral

    	svyset psu [pw = peso], strata(estrato) 
	
	* Identifica os estratos com psu unico 
		
		svydes, gen(single2)
		drop if single2==1
	
	* A. Tabela Descritiva  
		chdir ${Tables}

		svy: mean Y X Z   //Outras estatísticas possíveis: mediana, desvio padrão, min, max, etc... 

	* B. Regressão OLS - Retornos a educação

	svy: reg Y X 
	outreg2 using "Tabela1", excel nocons  aster(se) dec(3) replace 
	 //para acrescentar informações de outras regressões usar como opção "append". Lembre que tudo o que vai depois da vírgula é opção, você pode retirar ou incluir outras  

	* Exercício com uma subpopulação

	svy, subpop(var): command X 	

close log 
