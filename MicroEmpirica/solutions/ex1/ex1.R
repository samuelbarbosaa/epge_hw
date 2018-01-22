# library(lodown)
# pnad_cat = get_catalog("pnad", output_dir = "data_raw/pnad/")
# pnad_cat = subset( pnad_cat , year == 2015)
# lodown("pnad", pnad_cat)

library(tidyverse);library(srvyr);library(survey)
options(scipen = 10)

load("data/pnad/pnad2015_ex1.Rdata")

pnad_df = rename(pnad_df,
             renda = v4718, anos_estudo = v4803, idade = v8005,
             sexo = v0302, cor_raca = v0404,
             migrou = v0504,
             peso = v4729, estrato = v4617, psu = v4618, proj_pop = v4609)

pnad_df = 
  mutate(pnad_df, anos_estudo = as.integer(anos_estudo)) %>% 
  mutate(anos_estudo = ifelse(anos_estudo == 17, NA, anos_estudo)) %>% 
  mutate(anos_estudo = anos_estudo - 1)

pnad_df = 
  mutate_at(pnad_df, vars(uf, sexo, cor_raca, migrou), as.factor)

levels(pnad_df$sexo) = c("Masc", "Fem")
levels(pnad_df$cor_raca)  = c("Indigena", "Branca", "Preta", "Amarela", "Parda", "SemDecl")
levels(pnad_df$migrou) = c("Sim", "Nao")

pnad_df = mutate(pnad_df, 
             idade2 = idade^2, 
             log_renda = log(renda)) 

pnad_df = filter(pnad_df, renda > 0)

# Desenho da amostra
pnad_design = as_survey_design(pnad_df, 
                              ids = psu, 
                              strata = estrato, 
                              weights = peso,
                              nest = TRUE)

rm(pnad_df);gc()

options(survey.lonely.psu="remove")

svymean(~renda, pnad_design, na.rm = TRUE)            # renda média

pnad_design %>% 
  group_by(anos_estudo) %>% 
  summarise(renda_media = survey_mean(renda, na.rm = TRUE))

short_fit = svyglm(log_renda ~ anos_estudo + idade + idade2, pnad_design)
summary(short_fit) # um ano adicional de estudo parece aumentar a renda em aproximadamente 17,6%

long_fit = svyglm(log_renda ~ anos_estudo + idade + idade2 + sexo + cor_raca, pnad_design)
summary(long_fit) # inclusão das variáveis demográficas pouco altera o resultado

# Apenas migrantes
sub_pnad_design <- subset(pnad_design, migrou == "Sim")

short_fit_mig = svyglm(log_renda ~ anos_estudo + idade + idade2, sub_pnad_design)
summary(short_fit_mig) # um ano adicional de estudo parece aumentar a renda em aproximadamente 12,6%
