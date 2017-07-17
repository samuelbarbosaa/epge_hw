% EXERCICIO 04 

% 4.1
A = 10 * rand(3);
B = 10 * rand(3);
I = eye(3);

(A + I) * (A - I) - A*A
abs(det(A*B) - det(A) * det(B))
inv(inv(A)) - A

% 4.2
alpha = 0.3;
beta = 0.4;
delta = 0.055;
A = 10;
k = 1:0.1:3;

A*k .^ (alpha + beta) - delta * k

% 4.3
x = 0:1:5
y = x'
M = repmat(x,6,1)

a1 = M(:, 1)
a2 = M(:, 2)
a3 = M(:, 3)
a4 = M(:, 4)
a5 = M(:, 5)
a6 = M(:, 6)
