clc, close all
% clear all

beta = 0.995;
sigma = 1.5;
theta = 1/4;
y = 1;
chi = [0.9565 0.0435; 0.5 0.5];

m = 0:0.027:0.027*300;
s = [y theta*y];
nm = length(m);
ns = length(s);
ml = m';
[s,m] = meshgrid(s,m);
u = @(c)((c.^(1-sigma)-1)/(1-sigma));

alpha = 0.8;
maxit_V = 10000;
maxit_excesso = 10000;
tol_V = 1e-2;
tol_excesso = 1e-2;

avg_real_cash_balances = [];
sd_real_cash_balances = [];
avg_consumption = [];
sd_consumption = [];
avg_income = [];
sd_income = [];
avg_utility = [];

PI = [0.0125 0.0062 0];

for pi = PI
    fprintf('pi = %5.4f ------------------------------------ \n', pi);
    excesso = tol_excesso+1;
    it_excesso = 0;
    
    Mh = 20;
    Ml = 0;
    M = mean([Mh Ml]);
    
    while  abs(excesso)>tol_excesso && it_excesso<maxit_excesso
        C = 1/(1+pi)*repmat(m(:),1,nm) + repmat(s(:),1,nm) + pi/(1-pi)*M - repmat(ml',ns*nm,1);
        U = u(max(0,C));
        V = zeros(ns*nm,1);
        TV = V;
        
        Prob = kron(chi,ones(nm,1));
        
        it_V = 0;
        desv = tol_V+1;
        while desv>tol_V && it_V<maxit_V
            Vaux = U + beta*Prob*reshape(V,[nm,ns])';
            [TV,pos] = max(Vaux,[],2);
            G = m(pos);
            desv = max(max(abs(TV-V)));
            V = TV;
            it_V = it_V+1;
        end
        if it_V>=maxit_V, warning(['função valor não convergiu. Desvio foi de ' num2str(desv) ' para pi = ' num2str(pi)]); end

        % Encontra a matriz M
        MT = zeros(ns*nm);
        for i = 1:ns*nm
            for j = 1:ns
                MT(i,pos(i)+(j-1)*nm) = chi(ceil(i/nm),j);
            end
        end        

        % Encontra a distribuição invariante de M
        lambda = invdist_numeric(MT);

        excesso = lambda'*G-M;
        if excesso > 0
            Ml = M;
            M = (1-alpha)*Mh + alpha*Ml;
        else
            Mh = M;
            M = (1-alpha)*Ml + alpha*Mh;
        end
        it_excesso = it_excesso + 1;
        
    end
    
    c = 1/(1+pi)*m(:) + s(:) + pi/(1-pi)*M - G;
        
        avg_real_cash_balances = [lambda'*G];
        sd_real_cash_balances = [sqrt(lambda'*(G-avg_real_cash_balances(end)).^2)];
        avg_consumption = [lambda'*c];
        sd_consumption = [sqrt(lambda'*(c-avg_consumption(end)).^2)];
        avg_income = [lambda'*s(:)];
        sd_income = [sqrt(lambda'*(s(:)-avg_income(end)).^2)];
        avg_utility = [lambda'*u(c)];
        
        fprintf('real cash bal: %5.4f (%5.4f) \n', avg_real_cash_balances, sd_real_cash_balances);
        fprintf('consumption: %5.4f (%5.4f) \n', avg_consumption, sd_consumption);
        fprintf('income: %5.4f (%5.4f) \n', avg_income, sd_income);
        fprintf('avg utility: %5.4f \n', avg_utility);
        

end