f = @(n) sum((n .- (1:n-1)) .* (factorial(n) ./ (factorial(1:n-1) .* factorial(n .- (1:n-1)))));

for i = 3:10
	s = 0;
	
	for k = 1:i-1
		s += (i-k)*nchoosek(i, k) - (i-k-1)*nchoosek(i-1, k);
	endfor
	
	disp(sprintf("%d %d %d %d %d %d", i, 2^i-2, f(i), i*(2^(i-1)-1), s, (i+1)*2^(i-2)-1));
endfor