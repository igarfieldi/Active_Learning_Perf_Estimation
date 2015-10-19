# usage: [params, func] = fitExponential(X, Y)

function [params, func] = fitExponential(X, Y)

	global verbose;
	
    params = [];
    
    if(nargin != 2)
        print_usage();
    elseif(!isvector(X) || !isvector(Y))
        error("fitExponential: requires vector, vector");
    elseif(length(X) != length(Y))
        error("fitExponential: vector lengths do not match");
    endif
    
	f = @(x, p) p(1) .+ p(2) .* exp(p(3) .* x);
	#dfdp = @(x, f, p, dp, func) [ones(length(x), 1), exp(x * p(3)), p(2) * x .* exp(x * p(3))];
    
	cvg = 0;
	
	wt1 = sqrt (X');
	
	options.bounds = [0, 1; -Inf, 0; -Inf, 0];
	
	squErr = 1;
	c = 0;
	
	while((squErr > 10^(-3)) && (c < 10))
		init = (rand(1, 3) .- [0, 1, 1]) .* [1, 10, 10];
		[values, params, cvg] = leasqr(X', Y', init, f, 0.0001,
									200, [], [], [], options);
		
		squErr = sum((f(X, params) .- Y) .^ 2);
		c++;
	endwhile
	
	
	params = params';
    
	if(c >= 20)
		func = [];
	else
		func = @(x) f(x, params);
	endif

endfunction