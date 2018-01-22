#-------------------------------------------------------------------------------
# DOMICILIOS

dic_dom = read_csv2("data_raw/dic_dom_2015.csv")
domicilios = read_fwf(file = "data_raw/DOM2015.txt",
                      col_positions = fwf_widths(dic_dom$tamanho, dic_dom$cod), 
                      col_types = paste0(dic_dom$tipo, collapse = ""))
domicilios$UF = as.numeric(substr(domicilios$V0102, 1, 2))
save(domicilios, file = "data/domicilios_2015.Rdata")

#-------------------------------------------------------------------------------
# PESSOAS
dic_pes = read_csv2("data_raw/dic_pes_2015.csv")
pessoas = read_fwf(file = "data_raw/PES2015.txt",
                   col_positions = fwf_widths(widths = dic_pes$tamanho, col_names = dic_pes$cod),
                   col_types = paste0(dic_pes$tipo, collapse = ""))
save(pessoas, file = "data/pessoas_2015.Rdata")
