function M = top_right(N,n)
[h, p] = size(N);
M = N(1:n, (p-n+1):p);