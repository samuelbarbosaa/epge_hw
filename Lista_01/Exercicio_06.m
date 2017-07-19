diary 'Exercicio_06.txt' % salva o output deste script em arquivo texto
disp('EXERCÍCIO 06')

disp('Itens 1 a 3 -------------------------------------------------------')
[X, Y] = meshgrid(linspace(0,2.5,10), linspace(0,2.5,10));
Y(Y > 2.5 - X) = 0;
X(X > 2.5 - Y) = 0;
f = X .* Y

k = find(f >= max(max(f)));
x_opt = X(k)
y_opt = X(k)
f_opt = max(max(f))

disp('Itens 4 e 5 -------------------------------------------------------')
for t = [50, 100, 200, 500, 1000]
    tic
    [X, Y] = meshgrid(linspace(0,2.5,t),linspace(0,2.5,t));
    Y(Y > 2.5 - X) = 0;
    X(X > 2.5 - Y) = 0;
    f = X .* Y;

    k = find(f >= max(max(f)));
    fprintf('t=%d .....................................................',t)
    x_opt = X(k)
    y_opt = X(k)
    f_opt = max(max(f))
    time = toc
    
    % Item 5
    f_star = 25/16;
    ef = 1 / ((f_star - f_opt) * time)
end
diary off