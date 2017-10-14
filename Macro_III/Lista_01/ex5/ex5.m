clc, clear all

% Exercício 5

% Dados do problema
A = [5 -2 3;
    -3 9 1;
    2 -1 -7];

b = [-1 2 3]';

%% Metodo de Jacobi
x0 = zeros(size(b,1), 1); % Chute inicial

n = size(b,1);
err = 1;
tol = 10^-5;
it = 1;
itmax = 1000;

while err > tol && it < itmax
    for i = 1:n
      x(i) = (1/A(i,i))*(b(i) - A(i,[1:i-1, i+1:n]) * x0([1:i-1, i+1:n]));
    end
x1 = x';
err = norm(x1 - x0, 1);
it = it +1;
end   
disp('x1 =');
disp(x1);

% Eliminacao Gaussiana
