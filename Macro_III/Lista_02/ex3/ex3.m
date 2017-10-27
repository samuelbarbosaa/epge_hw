clear all;clc

%%%% EXERCICIO 03

%% Item (a)

%% Exemplo A

% Funcoes
u = v = @(c) sqrt(c);
f = @(c) sqrt(c) ./ 2;
f_inv = @(c) (2.*c.*(-(c)+ sqrt((c.^2)+1)));

% Parametros
w = 1;
beta = lambda = 0;
Delta = 0.05;
I = J = 1:2';
K = -1:1;

% Probabilidades
pi = ones(size(I)) / max(I);
theta = ones(size(J)) / max(J);
joint_pmf = theta .* pi';

% Variaveis
N = [exp(beta + Delta .* I)];
x = [exp(lambda + Delta .* J)];
z = [exp(lambda - beta + Delta .* K)];
z_mat = x ./ N';

% PMF de z
for i = 1:length(z)
  index = find(abs(z(i) - x ./ N') < 10^-5);
  phi_k(i) = sum(joint_pmf(index));
end

% PMF de N condicional a z
for i = I
  for k = 1:length(z)
    index = find(abs(z(k) - z_mat(i,:)) < 10^-5);
    if size(index, 2) != 0
      phi_ik(k,i) = pi(i) * joint_pmf(i,index) / phi_k(k);
      else
      phi_ik(k,i) = 0;
    end
  end
end
phi_ik = phi_ik ./ sum(phi_ik, 2);
             
% Chute inicial e algoritmo de iteracao            
y0 = [1 1 1]';
it = 1;
itmax = 1000;
err = 1;

while err > eps && it < itmax
  x = y0 ./ (z' * N);
  y = f_inv(phi_ik * (phi_k * f(x))');
  err = norm(y - y0, 1);
  y0 = y;
  it = it + 1;
end

y

%% Exemplo B
clear all;clc

% Funcoes
u = v = @(c) sqrt(c);
f = @(c) sqrt(c) ./ 2;
f_inv = @(c) (2.*c.*(-(c)+ sqrt((c.^2)+1)));

% Parametros
w = 1;
beta = lambda = 0;
Delta = 0.05;
I = 1:2';
J = 1:4';
K = -1:3;

% Probabilidades
pi = ones(size(I)) / max(I);
theta = ones(size(J)) / max(J);
joint_pmf = theta .* pi';

% Variaveis
N = [exp(beta + Delta .* I)];
x = [exp(lambda + Delta .* J)];
z = [exp(lambda - beta + Delta .* K)];
z_mat = x ./ N';

% PMF de z
for i = 1:length(z)
  index = find(abs(z(i) - z_mat) < 10^-5);
  phi_k(i) = sum(joint_pmf(index));
end

% PMF de N condicional a z
for i = I
  for k = 1:length(z)
    index = find(abs(z(k) - z_mat(i,:)) < 10^-5);
    if size(index, 2) != 0
      phi_ik(k,i) = pi(i) * joint_pmf(i,index) / phi_k(k);
      else
      phi_ik(k,i) = 0;
    end
  end
end
phi_ik = phi_ik ./ sum(phi_ik, 2);

% Chute inicial e algoritmo de iteracao           
y0 = [1 1 1 1 1]';
it = 1;
itmax = 1000;
err = 1;

while err > eps && it < itmax
  x = y0 ./ (z' * N);
  y = f_inv(phi_ik * (phi_k * f(x))');
  err = norm(y - y0, 1);
  y0 = y;
  it = it + 1;
end

y
