F  = @(x) x.^3 .* exp(-x.^2);
f  = @(x) 3 * x.^2 .* exp(-x.^2) - 2 * x.^4 .* exp(-x.^2);
df = @(x)(2*x*exp(-(x^2))*(3-7*(x^2)+2*(x^4)));

a = 0.1;
b = 5;

for j = 1:10000
  x0 = a + (b-a)*rand;  %Chute inicial

  it = 1;
  it2 = 1;
  itmax = 5000;
  delta = 1;
  tol = eps;

  tic
  while delta > tol && it < itmax
     x1 = x0 - f(x0)/df(x0);
     if x1 < a || x1 > b
        x1 = a + (b-a)*rand;
        it2 = it2 + 1;
     endif
     delta_x = abs(x1 - x0);
     delta_f = abs(f(x1));
     delta = max(delta_x, delta_f);
     it = it + 1;
     x0 = x1;
  end
  tempo(j) = toc;
  iter(j) = it; 
end

mean(iter)
mean(tempo)