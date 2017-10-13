library(forecast)

data("AirPassengers")
class(AirPassengers)
start(AirPassengers)
end(AirPassengers)

frequency(AirPassengers)
time(AirPassengers)
cycle(AirPassengers)

plot(AirPassengers)
abline(lm(AirPassengers ~ time(AirPassengers)))
plot(diff(AirPassengers, lag = 1))

plot(aggregate(AirPassengers, nfrequency = 1, FUN = mean))
boxplot(AirPassengers ~ cycle(AirPassengers))

acf(AirPassengers)
pacf(AirPassengers)
plot(forecast(ar(AirPassengers, order.max = 13), h = 24))

plot(forecast(ma(AirPassengers, order = 3)))
plot(decompose(AirPassengers))

# Dickey-Fuller Test
sAirPassengers = diff(log(AirPassengers), lag = 1)
plot(AirPassengers)
plot(sAirPassengers)

urca::ur.df(AirPassengers, lags = 0)
urca::ur.df(sAirPassengers, lags = 0)

acf(sAirPassengers)
pacf(sAirPassengers)

fit = arima(log(AirPassengers), 
            order = c(0, 1, 1),
            seasonal = c(0, 1, 1))

plot(forecast(fit, h = 60))

plot(forecast(ets(log(AirPassengers), "MAM"), h = 60))
plot(forecast(ets(log(AirPassengers)), h = 60))
