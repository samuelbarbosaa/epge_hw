%% Funcoes

% Calcula distribuição invariante por autovetores/autovalores
function A = invar(M)
    [V, D] = eig(M');
    [row, col] = find(abs(D-1) < eps(1e3), 1);
    A = V(:, col);
    A = A / sum(A);
end
