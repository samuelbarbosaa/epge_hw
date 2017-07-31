clear all

% Item 1
M = [1/2 1/2;
     1/3 2/3]

% Itens 2 e 3 (ver definicao das funcoes no fim do arquivo
invar(M)
invar_num(M)   

% Itens 4 e 5
P = scale(randn(5), 2) % funcao auxiliar definida na última seção deste arquivo
invar(P)
invar_num(P)

% Item 5
% T = [20, 50, 100, 500, 1000];
% 
% for t = T
%     P = scale(randn(t), 2);
%     fprintf('\nMATRIZ %4d x %4d: ----------------------------\n', t, t)
%     tic; invar(P); fprintf('invar: '); toc
%     tic; invar_num(P); fprintf('invar_num: '); toc
% end



%% Funcoes

% Calcula distribuição invariante por autovetores/autovalores
function A = invar(M)
    [V, D] = eig(M');
    [row, col] = find(abs(D-1) < eps(1e3), 1);
    A = V(:, col);
    A = A / sum(A);
end

% Calculo por aproximacao numerica
function D = invar_num(M)
    A = M + eps;
    v = randn(size(A, 2), 1);
    tol = eps(1e9);  
    n_iter = 1e6;
    iter = 1;
    while all(abs(A'*v - v) > tol) && iter < n_iter
        v = A' * v;
        iter = iter + 1;
    end
    
    D = v / sum(v);
end

% Função auxiliar para o item 4
% Transforma qualquer matriz em uma matriz de transição/markov
function P = scale(M, dim)
    scaledM = M - min(M, [], dim);
    P = scaledM ./ sum(scaledM, dim);
end