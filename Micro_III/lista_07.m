X = csvread("data.txt", 1, 0);

s0 = 1 - X(:,3) - X(:,4); % Market share da outside option

%Identificando variaveis
p1 = X(:,1);
p2 = X(:,2);
s1 = X(:,3);
s2 = X(:,4);
x1 = X(:,5);
x2 = X(:,6);
z1 = X(:,7);
z2 = X(:,8);

% Empilhando dados
y1 = log(s1./s0);
y2 = log(s2./s0);
Y = [y1;y2];
A = [ones(500,1) zeros(500,1) x1 p1 ; zeros(500,1) ones(500,1) x2 p2];

% Item 3
regress(Y,A)

% 2SLS
P = [p1 ; p2];
Z = [ones(500,1) zeros(500,1) x1 z1 ; zeros(500,1) ones(500,1) x2 z2];
b1 = regress(P,Z);
Pchapeu = Z*b1;
D = [ones(500,1) zeros(500,1) x1 Pchapeu(1:500,:) ; zeros(500,1) ones(500,1) x2 Pchapeu(501:1000,:)];
b2sls = regress(Y,D);

% Recuperando custos marginais
c1 = mean(p1) + (1/((mean(s1)-1)*(-b2sls(4))));
c2 = mean(p2) + (1/((mean(s2)-1)*(-b2sls(4))));

% Item 8
err = 1;
tol = 10^-5;
iter = 0;
maxit = 2000;
p_old = [c1 ; c2];
x = [mean(x1) ; mean(x2)];
c = [c1 ; c2]
while err>tol && iter<maxit
  iter = iter + 1;
  s = MarketShare(x,p_old,zeros(2,1),b2sls)';
  Sigma = [ -b2sls(4)*s(1)*(s(1) - 1) -b2sls(4)*s(1)*s(2) ; -b2sls(4)*s(1)*s(2) -b2sls(4)*s(2)*(s(2) - 1)];
  p_new = -(Sigma\s) + c;
  err = max(abs(p_new - p_old));
  p_old = p_new;
end

% Reducao de 15% nos custos marginais
err = 1;
tol = 10^-5;
iter = 0;
maxit = 2000;
p_old_r = 0.85*[c1 ; c2];
x = [mean(x1) ; mean(x2)];
c = [c1 ; c2]
while err>tol && iter<maxit
  iter = iter + 1;
  s = MarketShare(x,p_old_r,zeros(2,1),b2sls)';
  Sigma = [ -b2sls(4)*s(1)*(s(1) - 1) -b2sls(4)*s(1)*s(2) ; -b2sls(4)*s(1)*s(2) -b2sls(4)*s(2)*(s(2) - 1)];
  p_new = -(Sigma\s) + 0.85*c;
  err = max(abs(p_new - p_old_r));
  p_old_r = p_new;
end












