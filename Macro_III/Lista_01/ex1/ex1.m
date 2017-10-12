%% Ambiente/Parametros
f = @(w, alpha_1, alpha_2) alpha_1 + alpha_2 * w;
u = @(c, gamma) c .^ gamma;

beta = 0.98;
pi = 0.1;
b = 0;
wmin = 0;
wmax = 20;
gamma = 1/2;

%% (i)
alpha_1 = 1/15;
alpha_2 = -1/600;

n = 1000;
w = linspace(wmin, wmax, n)';
V = ones(n, 1); % chute inicial para a função valor
G = ones(n, 1); % chute inicial para a função política

% inicia variaveis do algoritmo de iteracao
err = 1;
tol = 10^-5;
itmax = 2000;
iter = 1;
h = w(2) - w(1);

% algoritmo de iteracao
while err > tol && iter < itmax
    F = V .* f(w, alpha_1, alpha_2);
    E = h/2 * (F(1) + F(n) + 2 * sum(F(2:n-1)));
    N = u(b, gamma) + beta * E;
    N = repmat(N, n, 1);
    A = u(w, gamma) + beta * ((1-pi) * V + pi * N);
    [TV, G] = max([N A], [], 2);
    err = abs(max(TV - V));
    V = TV;
    iter = iter + 1;
end

G = G-1;
R = min(w(G == 1));
R

subplot(2,1,1);
plot(w, V);
title('Funcao valor');
ylabel('v(w)');
xlabel('w');

subplot(2,1,2);
plot(w, G);
title('Funcao politica');
ylabel('g(w)');
xlabel('w');
saveas(gcf, 'ex1_1.png');


%% (ii)

alpha_1 = 1/30;
alpha_2 = 1/600;

tol = 10^-5;
itmax = 3000;
iter = 1;
err = 1;
h = w(2) - w(1);

% algoritmo de iteracao
while err > tol && iter < itmax
    F = V .* f(w, alpha_1, alpha_2);
    E = h/2 * (F(1) + F(n) + 2 * sum(F(2:n-1)));    
    N = u(b, gamma) + beta * E;
    N = repmat(N, n, 1);
    A = u(w, gamma) + beta * ((1-pi) * V + pi * N);
    [TV, G] = max([N A], [], 2);
    err = abs(max(TV - V));
    V = TV;
    iter = iter + 1;
end

G = G-1;
R = min(w(G == 1));
R

subplot(2,1,1);
plot(w, V);
title('Funcao valor');
ylabel('v(w)');
xlabel('w');

subplot(2,1,2);
plot(w, G);
title('Funcao politica');
ylabel('g(w)');
xlabel('w');

saveas(gcf, 'ex1_2.png');