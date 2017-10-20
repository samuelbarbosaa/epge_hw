clc;clear all;
pkg load io; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ALTERAR NO MATLAB
pkg load signal; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ALTERAR NO MATLAB

dados = xlsread('dados.xlsx');
% dados = dados(2:end,:); % 1994-2013
dados = dados(4:end,:); % 1996-2013

var_cons_real_pc = dados(:,7);
plot(var_cons_real_pc)

retorno_ibov = dados(:,11);
plot(retorno_ibov)

retorno_selic = dados(:,12);
plot(retorno_selic)


%% Calibracao
mu = mean(var_cons_real_pc)
delta = std(var_cons_real_pc)
% ac = 0.042; % acf todas as observacoes %%%%%%%%%%%%%%% ALTERAR NO MATLAB
ac = 0.175; % acf 1995-2013
phi = 0.5 * (1 + ac)

x = [1 + mu + delta, 1 + mu - delta]

premio_risco = retorno_ibov - retorno_selic;
premio_risco_medio = mean(premio_risco);

%% Matriz de Markov e distribuicao invariante
D = [   phi    ,  1 - phi ; 
      1 - phi  ,   phi    ]; 

[eigvec, eigval] = eig(D);
[row, col] = find(eigval == 1);
P = eigvec(:, col) / sum(eigvec(:, col));

% Grid
n = 1000;
beta = linspace(0.7, 0.99, n)';
sigma = linspace(0, 10, n);

beta_m = repmat(beta, 1, n);
sigma_m = repmat(sigma, n, 1);

lambda_1 = x(1) .^ (-sigma);
lambda_2 = x(2) .^ (-sigma);

% Retornos do modelo para o ativo livre de risco
p1f = (D(1,1) .* lambda_1 + D(1,2) * lambda_2) .* beta;
R1f = 1 ./ p1f - 1;
p2f = (D(2,1) .* lambda_1 + D(2,2) * lambda_2) .* beta;
R2f = 1./ p2f - 1;

Rf = P(1) * R1f + P(2) * R2f;

Re = zeros(size(Rf));
A = zeros(length(x), length(x));
b = zeros(length(x), 1);
R = zeros(size(A));

% Retornos do ativo de risco no modelo
for k = 1:n
    for m = 1:n
        for i = 1:length(x)
            for j = 1:length(x)
                A(i,j) = beta(k) * (x(j) ^ (1 - sigma(m)) * D(i,j));
            end
            b(i) = beta(k)*sum(A(i,:));
        end
        q = (eye(size(A)) - A)\b;
        Re11 = (q(1) + 1)*x(1)/q(1) - 1;
        Re12 = (q(2) + 1)*x(2)/q(1) - 1;
        Re21 = (q(1) + 1)*x(1)/q(2) - 1;
        Re22 = (q(2) + 1)*x(2)/q(2) - 1;
        R = [Re11 Re12; 
             Re21 Re22];
        Re1 = D(1,:)*R(1,:)';
        Re2 = D(2,:)*R(2,:)';
     
        Re(k,m) = P(1) * Re1 + P(2) * Re2;
    end
end

%% Premio de risco no modelo
premio_risco_modelo = Re - Rf;

%% Comparando premio de risco obtido do modelo e o observado nos dados.
dist = abs(premio_risco_modelo - premio_risco_medio * ones(size(Re)));
[a,b] = find(dist == min(min(dist)));
beta_otimo = beta(a)
sigma_otimo = sigma(b)