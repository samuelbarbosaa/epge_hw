%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXERCICIO 01 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Item (i) - Método da bisseção

F = @(x) x.^3 .* exp(-x.^2);
f = @(x) 3 * x.^2 .* exp(-x.^2) - 2 * x.^4 .* exp(-x.^2);

% Parâmetros
a = -10;
b = 10;

x = linspace(a, b, 500);
y = F(x);
plot(x, y);

% Loop
it = 1;
itmax = 1000;
delta = 1;
tol = 10^-5;

while delta > tol && it < itmax
  c = (a + b)/2;
  if f(c) < 0
      b = c;
  else
      a = c;
  end
 
  c_prime = (a + b)/2;
  delta_x = abs(c_prime - c);
  delta_f = abs(f(c_prime));
  delta = max(delta_x, delta_f);
  it = it + 1;
end

disp("Solucao:");
disp(c);

line([c c], [0.5 * F(c) 1.5 * F(c)]);

%% Item (ii) - Newton-Raphson

F  = @(x) x.^3 .* exp(-x.^2);
f  = @(x) 3 * x.^2 .* exp(-x.^2) - 2 * x.^4 .* exp(-x.^2);
df = @(x)(2*x*exp(-(x^2))*(3-7*(x^2)+2*(x^4)));

x0 = .9;  %Chute inicial

it = 1;
itmax = 1000;
delta = 1;
tol = 10^-5;

while delta > tol && it < itmax
   x1 = x0 - f(x0)/df(x0);
   delta_x = abs(x1 - x0);
   delta_f = abs(f(x1));
   delta = max(delta_x, delta_f);
   it = it + 1;
   x0 = x1;
end

disp("Solucao:");
disp(x1);
   