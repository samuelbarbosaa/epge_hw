# Ambiente/Parametros
f = function(w) alpha_1 + alpha_2 * w
u = function(c) c ^ gamma

beta = 0.98
pi = 0.1
b = 0
wmin = 0L
wmax = 20L
gamma = 1/2

# Item (i)
alpha_1 = 1/15
alpha_2 = -1/600

n = 1000
w = seq(wmin, wmax, along.with = rep(0, n))
V = rep(0, n)
G = rep(0, n)

# variaveis do algoritmo de iteracao
err = 1
tol = 10^-5
itmax = 2000
iter = 1
h = (wmax - wmin) / n

# algoritmo de iteracao
while (err > tol && iter < itmax) {
  vfw = V * f(w)
  E = h/2 * (vfw[1] + vfw[n] + 2 * sum(vfw[2:n-1]))
  N = u(b) + beta * E
  N = rep(N, n)
  A = u(w) + beta * ((1-pi) * V + pi * N)
  H = cbind(N, A)
  TV = apply(H, 1, max)
  G = which(H == apply(H, 1, max), arr.ind = TRUE)
  err = abs(max(TV - V))
  V = TV
  iter = iter + 1
}

G = G[,2] - 1
R = min(w[G == 1])
R

# plotting
library(ggplot2)
theme_set(theme_light())

ggplot(tbl, aes(y = V, x = w)) +
 geom_line() + ylab("V(w)")

ggplot(tbl, aes(y = G, x = w)) +
  geom_point(size = 0.5) + ylab("G(w)")

