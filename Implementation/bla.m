1;

pkg load optim;

addpath("functionFitting");

X = [1,2,3,4];
Y = [10, 6, 4, 3];

[p, f] = fitExponentialSimple(X, Y);

figure(1);
clf;
hold on;

plot(X, Y, "*-");
fplot(f, [min(X), max(X)]);