library(data.table)

tbl = fread("data.txt") 

# Item 3
tbl[, s0 := 1 - s1 - s2]
tbl[, y1 := log(s1) - log(s0)]
tbl[, y2 := log(s2) - log(s0)]
tbl[, s0 := NULL]

tbl = melt(data = tbl, 
           measure.vars = list(c("p1", "p2"), 
                               c("s1", "s2"), 
                               c("x1", "x2"), 
                               c("z1", "z2"), 
                               c("y1", "y2")), 
           variable.name = "empresa", 
           variable.factor = TRUE, 
           value.name = c("p", "s", "x", "z", "y"))

model = lm(y ~ x + p + empresa + 0, data = tbl)
summary(model)

# Item 6
ivmodel = AER::ivreg(y ~ x + p + empresa + 0 | x + z + empresa + 0, data = tbl)
summary(ivmodel)

# Item 7
beta = -coefficients(ivmodel)["p"]
avgs = tbl[, list(s = mean(s), p = mean(p)), by = empresa]
avgs[, c := p + 1 / (beta * (s - 1))]

# Item 8
coefs = coef(ivmodel)
market_share = function(p, coefs, x, xi) {
  alpha = c(coefs["empresa1"], coefs["empresa2"])
  gamma = rep(coefs["x"], 2)
  beta = rep(-coefs["p"], 2)
  sigma = exp(alpha + gamma * x - beta * p + xi)
  s = sigma / (1 + sum(sigma))
  return(s)
}

avgs2 = tbl[, list(x = mean(x), p = mean(p)), by = empresa]
market_share(avgs2$p, coef(ivmodel), avgs2$x, 0)

# while loop
err = 1
tol = 10^-5
iter = 0
maxit = 2000
p_old = avgs$c
beta = coef(ivmodel)["p"]

while(err > tol && iter < maxit) {
  iter = iter + 1
  s = market_share(p_old, coef(ivmodel), avgs2$x, 0)
  Sigma = matrix(c(-beta * (s[1] - s[1]^2), beta * s[1] * s[2],
                   beta * s[1] * s[2], -beta * (s[2] - s[2]^2)), ncol = 2)
  p_new = s %*% solve(Sigma) + avgs$c
  err = max(abs(p_new - p_old))
  p_old = p_new
}

p_old

# reducao de 15% no custo marginal

# while loop
err = 1
tol = 10^-5
iter = 0
maxit = 2000
p_old = avgs$c * 0.85
beta = coef(ivmodel)["p"]

while(err > tol && iter < maxit) {
  iter = iter + 1
  s = market_share(p_old, coef(ivmodel), avgs2$x, 0)
  Sigma = matrix(c(-beta * (s[1] - s[1]^2), beta * s[1] * s[2],
                   beta * s[1] * s[2], -beta * (s[2] - s[2]^2)), ncol = 2)
  p_new = s %*% solve(Sigma) + avgs$c * 0.85
  err = max(abs(p_new - p_old))
  p_old = p_new
}

p_old

