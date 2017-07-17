% EXERCICIO 05
t = 10;
u = normrnd(zeros(t, 1), ones(t, 1));
x = zeros(t+1, 1);

for i = 1:t
    x(i+1) = 0.8 * x(i) + u(i);
end

plot(x)
ylim([-6 6]);

% Item 4
for t = [20, 50, 100, 500, 1000, 2000]
    tic
    u = normrnd(zeros(t, 1), ones(t, 1));
    x = zeros(t+1, 1);
    for i = 1:t
        x(i+1) = 0.8 * x(i) + u(i);
    end
    figure(t);
    plot(x)
    ylim([-6 6]);
    toc
end

