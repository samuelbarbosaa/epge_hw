library(tidyverse)
library(data.table)
library(forecast)
options(scipen = 99)

readxl::read_excel("data_raw/champagne-sales.xlsx") %>% 
  data.table() -> tbl

y = ts(tbl$`Champagne Sales`[-c(91:96)], start = c(1,1), frequency = 12)
trend = na.omit(decompose(y)$trend)
season = na.omit(decompose(y)$season)

plot(y)
plot(decompose(y))
plot(diff(y, lag = 12)) 
# Diferenciacao sazonal é suficiente para tornar a série estacionária,
# logo temos d = 0, D = 1.


acf(diff(y, lag = 12)) # correlacao positiva no primeiro lag
pacf(diff(y, lag = 12)) # correlacao positiva no 13º lag
# vamos tomar p = 1, P = 1

# model
fc = forecast(arima(y, c(1, 0, 0), c(1, 1, 0)), h = 6)
plot(fc)

residuals = tbl$`Champagne Sales`[91:96] - fc$mean
plot(residuals)
acf(residuals)


