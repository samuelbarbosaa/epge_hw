% EXERCICIO 06

% Itens 1 a 3
[X, Y] = meshgrid(linspace(0,2.5,10), linspace(0,2.5,10));
Y(Y > 2.5 - X) = 0;
X(X > 2.5 - Y) = 0;
f = X .* Y

k = find(f >= max(max(f)));
x_opt = X(k)
y_opt = X(k)
f_opt = max(max(f))

% Item 4
for t = [50, 100, 200, 500, 1000]
    tic
    [X, Y] = meshgrid(linspace(0,2.5,t),linspace(0,2.5,t));
    Y(Y > 2.5 - X) = 0;
    X(X > 2.5 - Y) = 0;
    f = X .* Y;

    k = find(f >= max(max(f)));
    x_opt = X(k)
    y_opt = X(k)
    f_opt = max(max(f))
    toc
end