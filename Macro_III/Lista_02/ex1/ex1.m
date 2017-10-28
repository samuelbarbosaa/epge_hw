%% EXERCICIO 01 

%% Item (i) - Método da bisseção

F = @(x) x.^3 .* exp(-x.^2);
f = @(x) 3 * x.^2 .* exp(-x.^2) - 2 * x.^4 .* exp(-x.^2);
df = @(x) 2 * exp(-x.^2) .* x .* (3 - 7 .* x.^2 + 2 .* x.^4);

% Parâmetros
a = -10;
b = 10;

% Grafico
x = linspace(a, b, 500);
y = F(x);
plot(x, y);
saveas(gcf, "ex1_1.png");

% Delimitando intervalo inicial graficamente
a = 0.1;
b = 5;

% Loop
it = 1;
itmax = 1000;
delta = 1;
tol = eps;

tic
while delta > tol && it < itmax
  c = (a + b)/2;
  if f(a) * f(c) < 0
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
toc
fprintf("%i iteracoes\n", it);


if !df(c) < 0 disp("Ponto de maximo nao encontrado")
  else fprintf("Solucao:\nx = %d \n", c);;
end

%% Item (ii) - Newton-Raphson

F  = @(x) x.^3 .* exp(-x.^2);
f  = @(x) 3 * x.^2 .* exp(-x.^2) - 2 * x.^4 .* exp(-x.^2);
df = @(x)(2*x*exp(-(x^2))*(3-7*(x^2)+2*(x^4)));

a = 0.1;
b = 5;
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
      %fprintf("%iº valor inicial: %d \n", it2, x1);
      it2 = it2 + 1;
   endif
   delta_x = abs(x1 - x0);
   delta_f = abs(f(x1));
   delta = max(delta_x, delta_f);
   it = it + 1;
   x0 = x1;
end
toc
fprintf('%i iteracoes\n', it);
fprintf("Solucao:\nx = %d \n", x1);
