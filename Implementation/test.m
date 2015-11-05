1;
clc;

k = 2;
n = 1:4;

totalSize = length(n) ^ k;

mat = [];

for i = 1:k
    mat = [repmat(repelems(n, [1:length(n); ones(1, length(n)) * length(n)^(i-1)])',...
            totalSize/(length(n)^i), 1), mat];
endfor

mat