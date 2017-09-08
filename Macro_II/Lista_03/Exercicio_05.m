% EXERCÍCIO 06

% Parametros do modelo:
alpha = 0.75;
beta = 0.98;
delta = 0.05;
gamma = 1.2;
A = [1.2 0.4]';

M = [0.85 0.15;
     0.35 0.65];
 
P = invar_num(M);
 
% Capital de estado estacionário:
kss = ((1/beta + delta - 1) ./ (alpha * A)) .^ (1/(alpha-1));

% Grid para k e k_linha.
grid_size = 2000;
a = [linspace(kss(1) * 0.7, kss(1) * 1.3, grid_size)]';
b = [linspace(kss(2) * 0.7, kss(2) * 1.3, grid_size)]';
k = [a b];
k_linha = k;

% Chutes iniciais:
V = zeros(grid_size, 2);
TV = zeros(grid_size, 2);

% Parametros de iteracao:
tol = 1e-5;
n_iter = 1000;

% Problema
K = repmat(k, 1, 1, grid_size);
K_linha = repmat(k_linha, 1, 1, grid_size);
PTF = repmat(A', grid_size, 1, grid_size);
y = f(K,PTF,alpha);
C = max(y + (1-delta)*K - K_linha, 0);
U = u(C, gamma);

% Define variaveis para iniciar loop
desvio_max = tol+1;
iter = 1;

while desvio_max > tol && iter < n_iter
    EV = repmat(V * M', 1, 1, grid_size);
    H = U + beta * EV;
    [TV, I] = max(H, [], 3);
    desvio_max = max(max(abs(TV - V)));
    fprintf('Iteração: %d, Desvio: %1.7f \n', iter, desvio_max)
    V = TV;
    iter = iter+1;
end

% Função política
g = k(I);

% Gráfico das funções valor e política
subplot(2,1,1);
plot(TV);
ylabel('Função valor V(k)');

subplot(2,1,2); hold on;
plot(g);
ylabel('Função política g(k)');

%% Item b

P = repmat([0; 1], 1, 1000);
At = repmat(1.2, 1000, 1);

for i = 1:999
    P(:,i+1) = M' * P(:,i);
    if rand <= P(1,i)
        At(i+1) = A(1);
    else
        At(i+1) = A(2);
    end
end






















