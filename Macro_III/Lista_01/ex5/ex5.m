clc, clear all


A = [5 -2 3;
    -3 9 1;
    2 -1 -7];

b = [-1 2 3]';

%Metodo de Jacobi

x0 = zeros (size(b,1), 1);

function y = J(A, x, n)
   d = diag(A);
   r = A(n,:);
   r = r([1:n-1 n+1:end]);
   y = (1/d(n)) * (b(n) - 
