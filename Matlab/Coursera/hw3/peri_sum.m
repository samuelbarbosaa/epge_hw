function y = peri_sum(A)
y = sum(sum(A([1 end], :))) + sum(sum(A(2:(end-1), [1 end])));