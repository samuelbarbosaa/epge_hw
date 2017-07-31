% Função utilidade
function U = u(c, gamma)
    U = (c .^ (1 - gamma) - 1) / (1 - gamma);
end