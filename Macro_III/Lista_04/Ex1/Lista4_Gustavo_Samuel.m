%% MACRO III - LISTA 4


clear all
close all
clc

%Parâmetros Iniciais
A = 1; p = .5; delta = 2; R = 1.05; N = 2; e = 10;


%% Questão 1 - Item a
%  Estimação do lambda e cálculo da matriz de coeficientes f(j,i)
%  Obs. Estimação do lambda e F é feito na função estima_F

%Lambda estimado e matriz de coeficientes f (j,i)
[lambda, F] = estima_F (A, p, delta, R, N);


%% Item b
%  Mecanismo ótimo está implementado na função consumo_otimo

%Exemplo de consumo ótimo para o vetor omega abaixo
omega = [0 1];
xfinal = consumo_otimo(A, p, delta, R, omega, e*N, lambda, F);

%% Item c
%  Cada impaciente que resolva sacar receberá 1/N da riqueza Y
%  Cada paciente receberá 1/N de R*Y

%% Itens d, e
%  Cálculo do bem-estar está implementado na funcao bem_estar

%Bem-estar em autarquia, ótimo e em corrida
[Wa, Wo, Wc] = bem_estar(A, p, delta, R, N, e*N);

%% Item f
% Comparação dos 3 tipos de bem-estar para diferentes N

%Parâmetros Iniciais
A = 1; p = .5; delta = 2; R = 1.05; N = 2; e = 10; N_max = 10;

Waoc = zeros (N_max,3);
for n = 1:N_max
    [Waoc(n,1), Waoc(n,2), Waoc(n,3)] = bem_estar(A, p, delta, R, n, e*n);
end

figure(1)
Waoc
plot (Waoc(:,1:2));
xlabel ('N');
ylabel ('bem-estar');
title ('Comparativo de Bem-Estar');
legend ('autarquia', 'otimo');


%% Questão 2 - Item a
% Comparação do bem-estar entre falar a verdade ou correr como os demais
clc
clear all

%Parâmetros Iniciais
A = 1; p = .5; delta = 2; R = 1.05; N = 2; e = 10; 

% Wc1 = bem estar de falar a verdade sobre ser tipo paciente
% Wc0 = bem estar de mentir sobre ser tipo paciente, anunciado ser
% impaciente
[Wc1, Wc0] = bem_estar_pato(A, p, delta, R, N, e*N);


%% Item b
% Comparação do bem-estar entre falar a verdade ou correr como os demais
% (para diferentes valores de A)

a = 1.0;
iter = 0; Wc0 = 0; Wc1 = 1;
while (Wc0 < Wc1) && (iter < 100)
    a = a + .1;
    iter = iter + 1;
    [Wc1, Wc0] = bem_estar_pato(a, p, delta, R, N, e*N);
end
Wc1;
Wc0;
a;


%% Item c
% Comparação do bem-estar entre falar a verdade ou correr como os demais
% (para diferentes valores de N)

n = 2;
iter = 0; Wc0 = 0; Wc1 = 1;
while (Wc0 < Wc1) && (iter < 100)
    n = n + 1;
    iter = iter + 1;
    [Wc1, Wc0] = bem_estar_pato(A, p, delta, R, n, e*n);
end
Wc1;
Wc0;
n;


%% Simulações 

%Simulando para probabilidade
pp = 1.0;
iter = 0; Wc0 = 0; Wc1 = 1;
while (Wc0 < Wc1) && (iter < 100)
    pp = pp - .01;
    iter = iter + 1;
    [Wc1, Wc0] = bem_estar_pato(A, pp, delta, R, N, e*N);
end
Wc1;
Wc0;
pp; %Probabilidade de corte

%Simulando para tx de juros
r = 2.00;
iter = 0; Wc0 = 0; Wc1 = 1;
while (Wc0 < Wc1) && (iter < 150)
    r = r - .01;
    iter = iter + 1;
    [Wc1, Wc0] = bem_estar_pato(A, p, delta, r, N, e*N);
end
Wc1;
Wc0;
r; % Tx de juros de corte


%Simulando para A com N = 3
a = 1.00;
iter = 0; Wc0 = 0; Wc1 = 1;
while (Wc0 < Wc1) && (iter < 100)
    a = a + .1;
    iter = iter + 1;
    [Wc1, Wc0] = bem_estar_pato(a, p, delta, R, 3, e*N);
end
Wc1;
Wc0;
a;

%Simulando para A com N = 5
a = 1.00;
iter = 0; Wc0 = 0; Wc1 = 1;
while (Wc0 < Wc1) && (iter < 100)
    a = a + .1;
    iter = iter + 1;
    [Wc1, Wc0] = bem_estar_pato(a, p, delta, R, 5, 5*e);
end
Wc1;
Wc0;
a;

%Simulando para N com A = 1.1
n = 2;
iter = 0; Wc0 = 0; Wc1 = 1;
while (Wc0 < Wc1) && (iter < 100)
    n = n + 1;
    iter = iter + 1;
    [Wc1, Wc0] = bem_estar_pato(1.1, p, delta, R, n, e*n);
end
Wc1;
Wc0;
n;

%Simulando para N com A = 1.2
n = 2;
iter = 0; Wc0 = 0; Wc1 = 1;
while (Wc0 < Wc1) && (iter < 100)
    n = n + 1;
    iter = iter + 1;
    [Wc1, Wc0] = bem_estar_pato(1.2, p, delta, R, n, e*n);
end
Wc1;
Wc0;
n;


%Simulando para delta
dd = 0.55;
iter = 0; Wc0 = 0; Wc1 = 1;
while (Wc0 < Wc1) && (iter < 100)
    dd = dd + .1;
    iter = iter + 1;
    [Wc1, Wc0] = bem_estar_pato(A, p, dd, R, N, e*N);
end
Wc1;
Wc0;
dd;

%% Gráficos adicionais com outros parâmetros iniciais

%Caso Base
A = 1; p = .5; delta = 2; R = 1.05; N = 2; e = 10; N_max = 10;

Waoc1 = zeros (N_max,3);
for n = 1:N_max
    [Waoc1(n,1), Waoc1(n,2), Waoc1(n,3)] = bem_estar(A, p, delta, R, n, e*n);
end

%Novos Parâmetros
A = 1; p = .2; delta = 2; R = 1.05; e = 10; N_max = 10;

Waoc2 = zeros (N_max,3);
for n = 1:N_max
    [Waoc2(n,1), Waoc2(n,2), Waoc2(n,3)] = bem_estar(A, p, delta, R, n, e*n);
end
Waoc1;
Waoc2;

figure(2)
aux = [Waoc1(:,1:2)' ; Waoc2(:,1:2)']; 
plot (aux');
xlabel ('N');
ylabel ('bem-estar');
title ('Comparativo de Bem-Estar alterando-se a proporção de impacientes para .2');
legend ('autarquia original', 'otimo original', 'autarquia', 'otimo');

figure(3)
aux = [Waoc1(:,2:3)' ; Waoc2(:,2:3)']; 
plot (aux');
xlabel ('N');
ylabel ('bem-estar');
title ('Comparativo de Bem-Estar alterando-se a proporção de impacientes para .2');
legend ('otimo original', 'corrida original', 'otimo', 'corrida');

