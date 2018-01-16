%% MACRO III - LISTA 4


function [Wc1, Wc0] = bem_estar_pato(A, p, delta, R, N, Y)

%Função utilidade
u = @(delta,c)((c.^(1-delta))/(1-delta));

%Vetor para armazenar todas as possibilidades de omega
omega = zeros(1,N);

%Estimação do lambda e F
[lambda, F] = estima_F (A, p, delta, R, N);

Wc0 = 0; %Inicializando a variável com bem-estar médio de mentir
Wc1 = 0; %Inicializando a variável com bem-estar médio de falar a verdade

for k = 1:N
    for i = 1:N
        omega(1,N-i+1) = floor(mod(2^(k-1)/(2^(i-1)),2));
    end
    Wc1 = Wc1 + omega*u(delta, consumo_otimo(A, p, delta, R, omega, Y, lambda, F))';
    Wc0 = Wc0 + omega*u(delta, consumo_otimo(A, p, delta, R, zeros (1,N), Y, lambda, F))';
end

Wc0 = Wc0 / N; %bem-estar médio de mentir
Wc1 = Wc1 / N; %bem-estar médio de falar a verdade

end