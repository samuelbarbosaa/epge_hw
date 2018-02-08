library(tidyverse)

tbl = haven::read_dta("data_raw/pnad/pnad2015.dta")

tbl = tbl %>% 
  rename(renda = v4718,
         anos_estudo = v4803,
         idade = v8005,
         mulher = v0302,
         cond_fam = v0402,
         peso = v4729,
         estrato = v4617,
         psu = v4618)

tbl = tbl %>% 
  mutate(renda = ifelse(renda == 999999999999, ., renda),
         ind_renda = ifelse(renda > 0, 1, 0))

tbl = tbl %>% filter(!is.na(renda))

tbl = tbl %>% 
  mutate(idade2 = idade^2,
         log_renda = log(renda))

tbl = tbl %>% 
  mutate(anos_estudo = replace(anos_estudo, anos_estudo==17, NA)) %>% 
  mutate(anos_estudo = anos_estudo - 1)

tbl = tbl %>% 
  mutate(id_fam = paste0(v0101, v0102, v0103, v0403))

tbl = tbl %>% 
  group_by(id_fam) %>% 
  mutate(n_filhos = sum(cond_fam == 3 & idade < 18)) %>% 
  mutate(n_filhos = ifelse(cond_fam >= 3, 0, n_filhos)) %>% 
  ungroup()

tbl = tbl %>% 
  mutate(pia = ifelse(idade >= 18 & idade <= 65, 1, 0),
         casal = ifelse(v4111==1, 1, 0),
         mulher = ifelse(mulher == 4, 1, 0),
         mulher_casal = mulher * casal,
         n_filhos_mulher = n_filhos * mulher)
  
tbl = tbl %>% 
  select(v0101, v0102, v0103, 
         mulher, idade, idade2, cond_fam, casal, anos_estudo,
         pia, mulher_casal, n_filhos, n_filhos_mulher, ind_renda, log_renda,
         peso, estrato, psu)

haven::write_dta(tbl, "data/pnad/pnad2015_ex2.dta", version = 13)

