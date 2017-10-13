% Parametros
alpha = 0.70;
beta = 0.98;
gamma = 2.00;
delta = 0.10;

k_ss = ((1 + beta * (delta - 1))/ alpha * beta )^(1 / (alpha - 1));

% Funcoes
f = @(k) k .^ alpha;
c = @(k, k_linha) max(f(k) + (1 - delta) * k - k_linha, 0);
u = @(c) (c .^ (1 - gamma)) ./ (1 - gamma);

% Grid
n = 1000;
k = linspace(0.01 * k_ss, 1.25 * k_ss, n)';
K = repmat(k,1,n);
K_linha = K;

% Chutes iniciais:
V = ones(n, 1);
g = ones(n, 1);

% Variaveis iteracao
err = 1;
tol = 10^-5;
it = 1;
itmax = 1000;

% Possibilidades de consumo e utilidade
C = c(K, K_linha);
U = u(C);

% Algoritmo de iteracao
while err > tol && it < itmax
    H = U + beta * repmat(V', n, 1);
    [TV, I] = max(H, [], 2);
    err = max(abs(TV - V));
    fprintf('Iteração: %d, Desvio: %1.7f \n', it, err)
    V = TV;
    it = it+1;
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
