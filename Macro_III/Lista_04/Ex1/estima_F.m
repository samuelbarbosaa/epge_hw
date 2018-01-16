%% MACRO III - LISTA 4


function [lambda, F] = estima_F(A, p, delta, R, N)
%Esta funcao estima lambda (multiplicador de lagrange associado a IC) e
%a matriz F

lambda = 1; % chute inicial para lambda

%Parâmetros auxiliares
erro = 10e-7;
diff = erro + 1;
max_iter = 500;
iter = 1;
max_lambda = 10e5;


while (diff >= erro) && (iter <= max_iter) && (lambda <= max_lambda)
     
    gamma = abs(  ( (1 + lambda/(1-p)) / (A - lambda/p) )^(1/delta) );
 
    % Obs. Aqui, L = tamanho do vetor omega + 1
    L = N + 1;

    F = zeros(L,L); % F vai guardar os termos f(j,i) - j e i variando de 0 a N
    F(1:L,L) = [0:L-1]'*gamma*R^( (1-delta)/delta ); % ultima coluna


    for k = 1:L-1 % loop para as demais colunas
        i = L-k;
        for j = 1:L-k
            F(j,i) = ( p*( (F(j,i+1) + 1)^delta ) + (1-p)*( F(j+1,i+1)^delta ) )^(1/delta);
        end    
    end
    
    G = zeros(L,L); % G vai guardar os termos g(j,i) - j e i variando de 0 a N
    G(1:L,L) = ([0:L-1].^delta)'*(p/(1-p))*R^(1-delta); % ultima coluna
    for k = 1:L-1 % loop para as demais colunas
        i = L-k;
        for j = 1:L-k
            aux = G(j,i+1)*(F(j,i+1)^(1-delta));
            if isnan(aux) == 1
                aux = 0;
            end    
            G(j,i) = p*( aux -1 )*(1+F(j,i+1)^(delta-1)) + (1-p)*(G(j+1,i+1));
        end    
    end
    
    new_lambda = exp(G(1,1))*lambda;
    diff = abs(new_lambda - lambda);
    lambda = new_lambda;
    iter = iter + 1;
end

end