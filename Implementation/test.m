1;
clc;

f = @(x, p) p(1) .+ p(2) .* x;

tp = [1, 0.2];

X = [0, 0, 0, 1, 1, 1, 2, 2, 2]';
Y = f(X, tp) .+ normrnd(0, 0.1, 1, length(X))'

[val, params, ~, ~, ~, ~, ~, stdresid] = leasqr(X, Y, [0,1], f)

e = sum((val .- f(X, tp)) .^ 2)