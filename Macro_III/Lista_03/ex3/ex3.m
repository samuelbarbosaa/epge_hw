clc, close all
% clear all

% Parâmetros dos cenários
cen(1).pi_ll = 0.2;
cen(1).pi_hh = 0.6;
cen(1).delta = 0.04;
cen(2).pi_ll = 0.5;
cen(2).pi_hh = 0.4;
cen(2).delta = 0.04;
cen(3).pi_ll = 0.2;
cen(3).pi_hh = 0.6;
cen(3).delta = 0.2;

result.r = [];
result.K = [];
result.w = [];

for cen_ptr = 1:3 % Cada cenário é um item da questão
    
    % Parâmetros do modelo
    beta = 0.96;
    alpha = 0.36;
    eta_l = 0.1;
    eta_h = 1;
    pi_ll = cen(cen_ptr).pi_ll;
    pi_hh = cen(cen_ptr).pi_hh;
    PI = [pi_ll 1-pi_ll; 1-pi_hh pi_hh];
    PI_invar = invdist_numeric(PI);
    delta = cen(cen_ptr).delta;
    K_l = 1;
    K_h = 10;

    % Funções do modelo
    u = @(c)(10*sqrt(c));
    f = @(K,L)(K.^alpha.*L.^(1-alpha));
    df_K = @(K,L)(alpha.*(L./K).^(1-alpha));
    df_L = @(K,L)((1-alpha).*(K./L).^alpha);

    % Grids
    k_l = 0;
    k_h = 50;
    n_k = 300;
    k = linspace(k_l,k_h,n_k)';
    kl = k;
    n_eta = 2;
    eta = linspace(eta_l,eta_h,n_eta)';

    % Cálculo de L
    L = eta'*PI_invar;

    % Ajuste dos grids para formato matricial
    [eta,k] = meshgrid(eta,k);
    
    % Parâmetros da iteração
    tol_K = 1e-2;
    tol_V = 1e-2;
    maxit_K = 100;
    maxit_V = 1000;
    desv_K = tol_K+1;
    it_K = 0;
    gamma = 0.9;
    
    while abs(desv_K)>tol_K && it_K<maxit_K
        K = (K_h+K_l)/2;
        r = df_K(K,L);
        w = df_L(K,L);
        
        C = (1+r-delta)*repmat(k(:),1,n_k) + w*repmat(eta(:),1,n_k) - repmat(kl',n_k*n_eta,1);
        U = u(C);
        U = ((U.^2)==abs(U.^2)).*U + log(1*((U.^2)==abs(U.^2))); % Ajuste para jogar utilidade para -inf os pontos com consumo negativo
        V = zeros(n_eta*n_k,1);
        TV = V;
        
        Prob = kron(PI,ones(n_k,1));
        
        desv_V = tol_V+1;
        it_V = 0;
        while desv_V>tol_V && it_V<maxit_V
            Vaux = U + beta*Prob*reshape(V,[n_k,n_eta])';
            [TV,pos] = max(Vaux,[],2);
            G = k(pos);
            desv_V = max(max(abs(TV-V)));
            V = TV;
            it_V = it_V+1;
        end
        if it_V>=maxit_V, warning(['função valor não convergiu. Desvio foi de ' num2str(desv_V) ' para o cenario ' num2str(cen_ptr)]); end
        
        % Encontra a matriz M
        M = zeros(n_eta*n_k);
        for i = 1:n_eta*n_k
            for j = 1:n_eta
                M(i,pos(i)+(j-1)*n_k) = PI(ceil(i/n_k),j);
            end
        end
        
        % Encontra a distribuição invariante de M
        lambda = invdist_numeric(M);
        
        Kl = lambda'*G;
        desv_K = K-Kl;
%         disp([num2str(K_l) ' ' num2str(K) ' ' num2str(K_h) ' | ' num2str(desv_K)]);
        if desv_K > 0;
            K_h = K;
            K = gamma*K_h + (1-gamma)*K_l;
        else
            K_l = K;
            K = gamma*K_l + (1-gamma)*K_h;
        end
        it_K = it_K + 1;
        
    end
    
    result.r = [result.r; r];
    result.K = [result.K; K];
    result.w = [result.w; w];
    
end

figure;
subplot(3,1,1); bar(result.r,0.2); grid on; ylabel('r');
subplot(3,1,2); bar(result.K,0.2); grid on; ylabel('K');
subplot(3,1,3); bar(result.w,0.2); grid on; ylabel('w');
xlabel('Cenário');

disp('Valores de r, K e w para os cenários a, b e c:');
disp(' ');
disp('r:');
disp(result.r');
disp(' ');
disp('K:');
disp(result.K');
disp(' ');
disp('w:');
disp(result.w');
disp(' ');
