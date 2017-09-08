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