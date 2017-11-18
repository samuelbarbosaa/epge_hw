% M: matriz quadrada
% P: matriz cujas colunas são as distribuições invariantes associadas à
% matriz M'
% invdist_analytic obtém as distribuições invariantes analiticamente, isto
% é, calculando autovetores associados aos autovalores iguais a 1

function P = invdist_analytic(M)

eps = 1e-10; % epsilon que defino como tolerância para encontrar o autovalor igual a 1
n = size(M,1);
[V,D] = eig(M'); 
P = [];

for i=1:n % varro a matriz inteira atrás dos autovalores iguais a 1
    if abs(D(i,i)-1)<eps % se autovalor "é" 1, obtenho o autovetor associado e normalizo de forma que a soma dos componentes do vetar seja 1
        P = [P V(:,i)/sum(V(:,i))]; % concateno o vetor obtido com eventuais vetores obtidos anteriormente
        break
    end
end