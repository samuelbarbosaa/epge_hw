%% MACRO III - LISTA 4


function [Wa, Wo, Wc] = bem_estar(A, p, delta, R, N, Y)

%Função utilidade
u = @(delta,c)((c.^(1-delta))/(1-delta));

%Matrizes que armazenarão o consumo e utilidade
XF = zeros (2^N,N);
UT  = zeros (2^N,1);

%Vetor para armazenar todas as possibilidades de omega
omega = zeros(1,N);

%Estimação do lambda e F
[lambda, F] = estima_F (A, p, delta, R, N);

Wo = 0; %Inicializando a variável com bem-estar médio pelo mecanismo ótimo

for k = 1:2^N
    for i = 1:N
        omega(1,N-i+1) = floor(mod(k/(2^(i-1)),2));
    end
    XF(k,:) = consumo_otimo(A, p, delta, R, omega, Y, lambda, F);
    UT(k,1) = (ones(1,N) - omega)*A*u(delta,XF(k,:))' + (omega)*u(delta,XF(k,:))';
    Wo = Wo + p^(N-sum(omega)) * (1-p)^(sum(omega)) * UT(k,1)/N;
end


% bem-estar médio em autarquia
Wa_tipo1 = A*u(delta,   Y/N);
Wa_tipo2 =   u(delta, R*Y/N);
Wa = p*Wa_tipo1 + (1-p)*Wa_tipo2;

% bem-estar médio em corrida
Wc = UT(2^N,1) / N;


end