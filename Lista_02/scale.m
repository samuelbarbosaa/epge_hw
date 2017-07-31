% Função auxiliar para o item 4
% Transforma qualquer matriz em uma matriz de transição/markov
function P = scale(M, dim)
    min_dim = min(M, [], dim);
    min_matrix = repmat(min_dim, 1, size(M,2));
    scaledM = M - min_matrix;
    P = scaledM ./ repmat(sum(scaledM, dim), 1, size(M,2));
end