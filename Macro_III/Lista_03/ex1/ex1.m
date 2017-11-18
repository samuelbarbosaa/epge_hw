clc, close all
% clear all

al = -2;
  
eh = 1;
el = 0.1;
pi_hh = 0.925;
pi_lh = 0.5;
beta = 0.99322;
sigma = 1.5;
ah = 20;
ql = 0.5;
qh = 1.5;
nA = 300;
nE = 2;
alpha = 0.9;
Y = [];

PI = [pi_hh (1-pi_hh); pi_lh (1-pi_lh)];
A = linspace(al,ah,nA)';
E = linspace(eh,el,nE);
Al = A;
[E A] = meshgrid(E,A);
X = [E(:) A(:)];

q = mean([ql, qh]);

u = @(c)(c.^(1-sigma)/(1-sigma));

tol = 1e-2;
maxit = 1000;
max_it_excesso = 100;
tol_excesso = 1e-2;

it_excesso = 0;
excesso = tol_excesso+1;
while abs(excesso)>tol_excesso && it_excesso<max_it_excesso && abs(qh-ql)>1e-6

    C = repmat(A(:),1,nA) + repmat(E(:),1,nA) - repmat(Al',nE*nA,1)*q;
    U = u(max(0,C));
    V = zeros(nE*nA,1);
    TV = V;

    Prob = kron(PI,ones(nA,1));

    it = 0;
    desv = tol+1;
    while desv>tol && it<maxit
        Vaux = U + beta*Prob*reshape(V,[nA,nE])';
        [TV pos] = max(Vaux,[],2);
        G = A(pos);
        desv = max(max(abs(TV-V)));
        V = TV;
        it = it+1;
    end
    if it>=maxit, warning(['função valor não convergiu. Desvio foi de ' num2str(desv) ' para al = ' num2str(al)]); end

    % Encontra a matriz M
    M = zeros(nE*nA);
    for i = 1:nE*nA
        for j = 1:nE
            M(i,pos(i)+(j-1)*nA) = PI(ceil(i/nA),j);
        end
    end

    % Encontra a distribuição invariante de M
    P_invar = invdist_numeric(M);

    excesso = P_invar'*G;
    disp([num2str(ql) ' ' num2str(q) ' ' num2str(qh) ' | ' num2str(excesso)]);
    if excesso > 0;
        ql = q;
        q = (1-alpha)*qh + alpha*ql;
    else
        qh = q;
        q = (1-alpha)*ql + alpha*qh;
    end
    it_excesso = it_excesso + 1;
end
Q = [Q q];

if al == -2
    X1 = reshape(V,[nA,nE]);
    X2 = reshape(G,[nA,nE]);
    figure; hold on;
    plot(A(:,1),X1(:,1)); plot(A(:,1),X1(:,2)); grid on;
    figure; hold on;
    plot(A(:,1),X2(:,1)); plot(A(:,1),X2(:,2)); grid on;
end

P_numeric = invdist_numeric(M);
P_analytic = invdist_analytic(M);
disp(['A diferença máxima entre a dist. invariante obtida iterativamente '...
    'e a obtida através de autovetor associado ao autovalor unitário é de: ']);
disp(num2str(max(abs(P_analytic-P_numeric))));

figure; plot(AL,Q); grid on;