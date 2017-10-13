library(tidyverse)
library(data.table)
library(forecast)
options(scipen = 99)

readxl::read_excel("data_raw/champagne-sales.xlsx") %>% 
  data.table() -> tbl

y = ts(tbl$`Champagne Sales`, start = c(1, 1), frequency = 12)
plot(decompose(y))

y_train = window(y, end = c(8, 06))
y_test = window(y, start = c(8, 06))

plot(decompose(y_train))
forecast(ets(y_train, "MAA"), h = 6)
plot(forecast(ets(y_train, "MNM"), h = 6))
lines(y_test, col = "red")

plot(log(y_train))
acf(log(y_train))
pacf(log(y_train))

plot(forecast(arima(log(y_train), order = c(1, 0, 0), seasonal = c(0, 1, 1)), h = 6))
lines(log(y_test), col = "red")

acf(na.omit(decompose(y)$trend))
pacf(na.omit(decompose(y)$trend))

acf(na.omit(decompose(y)$seasonal))
pacf(na.omit(decompose(y)$seasonal))
plot(na.omit(decompose(y)$seasonal))

accuracy(forecast(ets(y, "MNM"), h = 6), test = 90:96)
accuracy(forecast(arima(y, order = c(1, 0, 0), seasonal = c(0, 1, 1)), h = 6), test = 90:96)

