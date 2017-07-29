disp('EXERCÍCIO 06')

disp('Itens 1 a 3 -------------------------------------------------------')
disp('Como f é estritamente crescente em x e y, a restição será ativa.')
disp('Logo a solução se dará sobre a reta y = 2.5 - x.')

x = linspace(0,2.5,10);
y = 2.5 - x;
f = x .* y;

k = find(f >= max(f));
x_opt = x(k)
y_opt = y(k)
f_opt = max(f)

disp('Itens 4 e 5 -------------------------------------------------------')
for t = [50, 100, 200, 500, 1000]
    tic
    x = linspace(0,2.5,t);
    y = 2.5 - x;
    f = x .* y;

    k = find(f >= max(f));
    fprintf('t=%d .....................................................',t)
    x_opt = x(k)
    y_opt = y(k)
    f_opt = max(f)
    time = toc
    
    % Item 5
    f_star = 25/16;
    ef = ((f_star - f_opt) * time) ^ (-1)
end