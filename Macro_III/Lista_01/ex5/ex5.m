clc, clear all

% Exercício 5

% Dados do problema
A = [5 -2 3;
    -3 9 1;
    2 -1 -7];

b = [-1 2 3]';

%%%%%%%%%%%%%%%%%%%%%%%%
%% Metodo de Jacobi %%%%
%%%%%%%%%%%%%%%%%%%%%%%%

x0 = zeros(length(b), 1); % Chute inicial

m = length(b);
err = 1;
tol = 10^-4;
it = 1;
itmax = 1000;

while err > tol && it < itmax
    for i = 1:m
      x(i) = (1/A(i,i))*(b(i) - A(i,[1:i-1, i+1:m]) * x0([1:i-1, i+1:m]));
    end
    disp(x)
    err = norm(x' - x0, 1);
    x0 = x';
    it = it + 1;
end   

disp('Solucao:"x =');
disp(x0);

%%%%%%%%%%%%%%%%%%%%%%%%
% Eliminacao Gaussiana % 
%%%%%%%%%%%%%%%%%%%%%%%%
E = [A b];
[m, n] = size(E);

% Transforma matriz A em triangular superior
for i = 2:m
  for j = 1:i-1
      E(i,:) = E(i,:) - E(i,j) / E(j,j) * E(j,:);
  end
end

x = zeros(m, 1);
A = E(1:m, 1:n-1);
b = E(1:m, n);

x(m) = b(m) / A(m,m);

for i = m-1:-1:1
  u = E(i,i+1:n-1);
  v = x(i+1:m);
  x(i) = (b(i) - u * v) / A(i,i);
end

disp('x =');
disp(x);

% Forma alternativa de escrever o mesmo algoritmo (usar matriz já triangularizada)
for i = m:-1:1
  E(i,:) = (E(i,:) - (E(i,i+1:m) * E(i+1:m,:))) / E(i,i)
end

x = E(:,n);
disp('x=')
x
