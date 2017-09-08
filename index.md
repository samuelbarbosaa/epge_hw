Exercise 08
-----------

> In this problem we will do a simple econometric exercise using Mroz (1987) data on the wages of 428 working, married women. Use ~~Stata~~ **R** to answer the following items. Please attach your code to the answer.
>
> (a)  Run the regression lwage = *β*<sub>0</sub> + *β*<sub>1</sub>kidslt6 + *β*<sub>2</sub>kidsge6 + *u*, where lwage is the logarithm of the wage, the number of children less than six and the number of children at least six years of age. Test the hypothesis *H*<sub>0</sub> : *β*<sub>1</sub> = 0, *β*<sub>2</sub> = 0.

``` r
mroz = haven::read_dta("mroz.dta")
short = lm(lwage ~ kidslt6 + kidsge6, data = mroz)
summary(short)
```

    ## 
    ## Call:
    ## lm(formula = lwage ~ kidslt6 + kidsge6, data = mroz)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -3.1896 -0.3797  0.0254  0.4145  2.1490 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  1.28069    0.05072  25.248   <2e-16 ***
    ## kidslt6     -0.01419    0.08923  -0.159    0.874    
    ## kidsge6     -0.06555    0.02657  -2.467    0.014 *  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.7196 on 425 degrees of freedom
    ##   (325 observations deleted due to missingness)
    ## Multiple R-squared:  0.01445,    Adjusted R-squared:  0.009816 
    ## F-statistic: 3.117 on 2 and 425 DF,  p-value: 0.04532

Observe que `F = 3.117`, com `p-valor = 0.04532`. Rejeitamos a hipótese nula ao nível de confiança de 95%.

> (b)  Comment on the exogeneity of the regressors from the last item.

(...)

> (c)  Now run the regression lwage = *β*<sub>0</sub> + *β*<sub>1</sub>kidslt6 + *β*<sub>2</sub>kidsge6 + *β*<sub>3</sub>age + *β*<sub>4</sub>educ + *β*<sub>5</sub>exper + *β*<sub>6</sub>expersq + *u*

``` r
long = lm(lwage ~ kidslt6 + kidsge6 + age + educ + exper + expersq, data = mroz)

rhs = c(0, 0)
row1 = c(0, 1, 0, 0, 0, 0, 0)
row2 = c(0, 0, 1, 0, 0, 0, 0)
H = matrix(data = c(row1, row2), nrow = 2, byrow = TRUE)
car::linearHypothesis(long, H, rhs)
```

    ## Linear hypothesis test
    ## 
    ## Hypothesis:
    ## kidslt6 = 0
    ## kidsge6 = 0
    ## 
    ## Model 1: restricted model
    ## Model 2: lwage ~ kidslt6 + kidsge6 + age + educ + exper + expersq
    ## 
    ##   Res.Df    RSS Df Sum of Sq      F Pr(>F)
    ## 1    423 188.30                           
    ## 2    421 187.99  2   0.31599 0.3538 0.7022

Agora temos `F = 0.3538`, com `p-valor = 0.7022`. Não podemos, portanto, rejeitar a hipótese nula.
