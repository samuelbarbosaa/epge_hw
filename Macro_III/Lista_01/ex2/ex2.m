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
k = linspace(1, 1.25 * k_ss, n);
k_linha = k';
K = repmat(k, n, 1);
K_linha = repmat(k_linha, 1, n);

% Possibilidades de consumo e utilidade
C = c(K, K_linha);
U = u(C);

% Chutes iniciais:
V = zeros(1, n);
g = zeros(1, n);

% Variaveis iteracao
err = 1;
tol = 10^-5;
it = 1;
itmax = 1000;

%% Algoritmo de iteracao
while err > tol && it < itmax
    [TV, I] = max(U + beta * repmat(V',1, n));
    err = max(abs((TV - V)));
    V = TV;
    it = it + 1;
end

G = k(I);

% Gráfico das funções valor e política
figure(1);
subplot(2,1,1);
plot(k, TV);
ylabel('Função valor V(k)');

subplot(2,1,2); hold on;
plot(k, G);
ylabel('Função política g(k)');

saveas(figure(1), 'ex2_1.png');

%% item (v)
kt = 2;
err = 1;
tol = 10^-5;
it = 1;
itmax = 1000;

while err > tol && it < itmax
    [x, i] = min(abs(k - kt));
    kt = k(i);
    kt1 = G(i);
    err = abs(kt1 - kt);
    
    T(it) = kt;
    
    kt = kt1;
    it = it + 1;
end

figure(2);
plot(T);
xlabel('t');
ylabel('k''');
saveas(figure(2), 'ex2_2.png');

% nivel de capital de SS
kt

% produto e consumo de SS
[x, i] = min(abs(k - kt));
y_ss = f(k(i));
c_ss = c(k(i), k_linha(i));

%% item (vi)
k_ss_b = @(beta) ((1 + beta .* (delta - 1)) ./ (alpha .* beta) ).^(1 / (alpha - 1));
beta_v = linspace(0.7, .99, 1000);
figure(3);
plot(beta_v, k_ss_b(beta_v));
ylabel('k_{ss}');
xlabel('\beta');
saveas(figure(3), 'ex2_3.png');