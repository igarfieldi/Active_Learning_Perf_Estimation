#{
f = @(n) sum((n .- (1:n-1)) .* (factorial(n) ./ (factorial(1:n-1) .* factorial(n .- (1:n-1)))));

for i = 3:10
	s = 0;
	
	for k = 1:i-1
		s += (i-k)*nchoosek(i, k) - (i-k-1)*nchoosek(i-1, k);
	endfor
	
	disp(sprintf("%d %d %d %d %d %d", i, 2^i-2, f(i), i*(2^(i-1)-1), s, (i+1)*2^(i-2)-1));
endfor

Cv = [];
v = 2;
R = quadcc(@(x) (exp(-x .^2 ./ 2) ./ sqrt(2*pi)) .^ 2, -Inf, Inf)
for q = 1:20
	Cv = [Cv, (pi^(q/2)*2^(q+v-1)*factorial(v)^2*R^q/...
		(v*1*(doubleFactorial(2*v-1)+(q-1)*doubleFactorial(v-1)^2)))^(1/(2*v+q))];
endfor
#}

clc;

pwc = parzenWindowClassifier();
pwc = setSigma(pwc, [0.1, 0.1]);
feat = [0, 0;
		0, 0.5;
		0, 1;
		0.5, 0;
		0.5, 0.5;
		0.5, 1;
		1, 0;
		1, 0.5;
		1, 1];
lab = [1, 0, 0, 0, 1, 1, 0, 1, 0];
pwc = setTrainingData(pwc, feat, lab, 2);

r = linspace(0, 1, 100);
[X, Y] = meshgrid(r, r);
instances = [reshape(X, 1, rows(X)*columns(X)); reshape(Y, 1, rows(Y)*columns(Y))]';


res = classifyInstances(pwc, instances);
class = max(res) == res(1, :);

figure(1);
hold on;

z = linspace(0, 1, 256)';
cm = [z, zeros(256, 1), 1 .- z];
cmap = colormap(cm);
image([0, 1], [0, 1], reshape(ceil(res(1, :) * 256), length(r), length(r)));

#{
axis([-1, 2, -1, 2]);
for i = 1:size(instances, 1)
	plot(instances(i, 1), instances(i, 2), ".", "color", [res(1, i), 0, res(2, i)]);
	#plot(instances(i, 1), instances(i, 2), ".", "color", [class(i), 0, 1 - class(i)]);
endfor
#}