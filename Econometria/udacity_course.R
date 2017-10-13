library(tidyverse)
library(data.table)
library(forecast)
options(scipen = 99)

readxl::read_excel("data_raw/single-family-home-sales.xlsx") %>% 
  data.table() -> tbl

# Simple exponential smoothing
y = ts(tbl[!is.na(`Home Sales`), `Home Sales`], 
       start = c(1990,01), frequency = 12)

s1 = sum(y * 0.8 * 0.2 ^ (rev(seq_along(y)) - 1))
s2 = sum(y * 0.6 * 0.4 ^ (rev(seq_along(y)) - 1))
s3 = sum(y * 0.2 * 0.8 ^ (rev(seq_along(y)) - 1))

ynew = c(y, s1)
sum(ynew * 0.8 * 0.2 ^ (rev(seq_along(ynew)) - 1))

plot(y)

par(mfrow = c(1,2))
plot(forecast(ets(y, model = "AAA"), 120))
plot(hw(y, h = 120, seasonal = "additive", damped = FALSE, exponential = FALSE))

par(mfrow = c(1,1))
plot(decompose(y))

seasonplot(y, col = brewer.pal(6, "Dark2"), year.labels = TRUE, lwd = 2)
