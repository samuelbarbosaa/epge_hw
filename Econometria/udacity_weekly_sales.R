library(tidyverse)
library(data.table)
library(forecast)
options(scipen = 99)

readxl::read_excel("data_raw/weekly-sales-differencing.xlsx") %>% 
  data.table() -> tbl

tbl[, `First Difference` := as.numeric(`First Difference`)]
tbl[, `Second Difference` := as.numeric(`Second Difference`)]

tbl[, `First Difference` := c(NA, diff(`Weekly Sales of a Cutting Tool`))]
tbl[, `Second Difference` := c(NA, diff(`First Difference`))]

tbl[, `First Difference` := `Weekly Sales of a Cutting Tool` - lag(`Weekly Sales of a Cutting Tool`)]

y = ts(tbl$`Weekly Sales of a Cutting Tool`, start = c(1, 1), frequency = 52)
acf(y)
pacf(y)
acf(diff(y))

# AR 1
# I 1
# MA 0
plot(y, type = "o")
plot(diff(y))

plot(forecast(arima(y, order = c(1,1,0)), 12))
auto.arima(y)


