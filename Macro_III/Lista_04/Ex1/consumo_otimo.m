%% MACRO III - LISTA 4

function xfinal = consumo_otimo(A, p, delta, R, omega, Y, lambda, T)

N = length(omega);

%F vai guardar as taxas de poupança f's, mas apenas os termos necessários
F = zeros(N,N); 
F = T(1:N, 2:N+1);
 
% Calculando a taxa de popupança do banco para o omega dado
s = ones(1,N);
 
% contando o numero de pacientes antecedente
counter(1:N) = zeros(1,N); for i = 1:N-1, counter(i+1) = sum(omega(1:i)); end

 % localizando os impacientes
imp = find(omega == 0);

% loop para calculo das taxas de poupança
for i = imp
    s(i) = F( counter(i) + 1, i);
    s(i) = s(i)/(1+s(i));
end

pi=1; % variável para acúmulo da taxa de poupança
z = Y*ones(1,N); %consumo

for i=1:N
    pi=pi*s(i);
    z(i)=pi*Y;

end

x1=(1-s).*[Y,z(1:N-1)];

%pagamento dos pacientes
x2 = zeros (1,N);
if sum(omega) > 0
    y=z(N)*R/sum(omega);
    x2 = omega.*y;
end
    
xfinal = x1 + x2;

end