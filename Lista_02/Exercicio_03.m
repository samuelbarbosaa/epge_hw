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

% Item 6
T = [20, 50, 100, 500, 1000];

for t = T
    P = scale(randn(t), 2);
    fprintf('\nMATRIZ %4d x %4d: ----------------------------\n', t, t)
    tic; invar(P); fprintf('invar: '); toc
    tic; invar_num(P); fprintf('invar_num: '); toc
end
