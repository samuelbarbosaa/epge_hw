clear
% 
%    EXERCICIO 01
% 

a_inf = input('Insira o limite inferior de crédito {-12, -10, -8, -6 ,-4 ou -2}: ');

%% Parametros e funcoes
beta = 0.99332; sigma = 1.5; 
u = @(c) (c .^ (1-sigma))/(1-sigma);

n_a = 150; step = 0.1; a_sup = a_inf + (n_a-1)*step; A = a_inf:step:a_sup;
eh = 1; el = 0.1; q = 1; q_inf = 0; q_sup = 2; qp = 2;

phh = 0.925; phl = 1 - phh;
plh = 0.5; pll = 1 - plh;

z = 1; k = 1; kmax = 1000;
while abs(z)> 10^-5 && abs(q - qp) > 10^-6 && k < kmax

%% Funcoes valor e politica (item a)
Ch = max(eh + A - A' * q, 10^-5);
Cl = max(el + A - A' * q, 10^-5);
Vh = zeros(n_a, 1); Vl = Vh;

it = 1; itmax = 1000; err = 1;
while err > 10^-5 && it < itmax
[TVh, gh] = max(u(Ch) + beta * (phh .* Vh + phl .* Vl));
[TVl, gl] = max(u(Cl) + beta * (plh .* Vh + pll .* Vl));

err = max(max(abs(TVh - Vh')), max(abs(TVl - Vl')));
Vh = TVh'; Vl = TVl';
it = it+1;
end

%% Matriz M (item b)
ih = zeros(size(Cl)); il = zeros(size(Cl));
for j = 1:n_a
    ih(gh(j), j) = 1;
    il(gl(j), j) = 1;
end
        
M = [phh*ih plh*il; 
     phl*ih pll*il]';
lambda = 1/n_a * ones(1, 2*n_a);

%% Distribuicao invariante como autovetor de M (item c)
[eigvec, eigval] = eig(M');
[row, col] = find(round(real(diag(eigval)))==1);
lambda_eig = eigvec(:, col) / sum(eigvec(:, col));

%% Distribuicao invariante como "ponto fixo" do operador linear M (item d)
it = 1; err = 1; itmax = 1000;
while err > 10^-5 && it < itmax
lambda_prime = lambda * M;
err = max(abs(lambda - lambda_prime));
lambda = lambda_prime;
it = it+1;
end
lambda = lambda/sum(lambda);

%% Excesso de oferta de credito (item e)
gh = A(gh); gl = A(gl);
z = lambda * [gl gh]';

if z > 10^-5
    q_inf = q;
elseif z < -10^-5
    q_sup = q;
end

fprintf("z = %.8f, q = %.8f \n", z, q);
qp = q;
q = (q_inf + q_sup) / 2;
k = k+1;
end

subplot(2,1,1); plot(A, TVh, A, TVl);
legend('V(e_H, a)', 'V(e_L, a)', 'location', 'bestoutside');
title('Funções valor nos estados e_H & e_L');

subplot(2,1,2); plot(A, gh, A, gl);
legend('g(e_H, a)', 'g(e_L, a)', 'location', 'bestoutside');
title('Funções política nos estados e_H & e_L');


