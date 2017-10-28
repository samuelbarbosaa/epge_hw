F = @(x, y) 4 ./ ((x-1).^2 + 4.*y.^2 + 1);
f = @(x, y) [-4 * 2.*(x-1) / ((x-1).^2 + 4.*y.^2 + 1).^2,
             -4 * 8.*y / ((x-1).^2 + 4.*y.^2 + 1).^2];
J = @(x, y) [32.*(x-1).^2/((x-1).^2 + 4.*y.^2 + 1).^3 - 8/((x-1).^2 + 4.*y.^2 + 1).^2, 128.*(x-1).*y/((x-1).^2 + 4.*y.^2 + 1).^3;
    128.*(x-1).*y/((x-1).^2 + 4.*y.^2 + 1).^3, 512.*y.^2/((x-1).^2 + 4.*y.^2 + 1).^3 - 32/((x-1).^2 + 4.*y.^2 + 1).^2];

% Graf
u = linspace(-10, 10, 100);
v = linspace(-10, 10, 100);
[U, V] = meshgrid(u,v);
surf(F(U,V), U, V);

% Newton-Rhapson
a = [-5 -5];
b = [5 5];
x = 0;
y = 0;
k = 1;
kmax = 2000;
err = 1;

tic
while err > 10^-5 && k < kmax
    A = J(x(k), y(k));
    s = linsolve(A, -f(x(k), y(k)));
    x(k+1) = s(1) + x(k);
    y(k+1) = s(2) + y(k);
    if x(k+1) < a(1) || x(k+1) > b(1)
      x(k+1) = a(1) + (b(1)-a(1)) *rand;
    endif
    if y(k+1) < a(2) || y(k+1) > b(2)
      y(k+1) = a(2) + (b(2)-a(2)) *rand;
    endif
    z = [x(k) y(k)]';
    zprime = [x(k+1) y(k+1)]';
    err = norm(z-zprime);
    k = k + 1;
end
toc

fprintf('%i iteracoes\n', k);
fprintf("Solucao:\nx = %d \n", round(x(k) * 100 / 100));
fprintf("y = %d \n", round(y(k) * 100 / 100));
