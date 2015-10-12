# usage: [mu, var] = getMuVarFromBeta(p, q)

function [mu, var] = getMuVarFromBeta(p, q)

    mu = [];
	var = [];
    
    if(nargin != 2)
        print_usage();
    elseif(!isvector(p) || !isvector(q))
        error("@estimator/getMuVarFromBeta: requires scalar, scalar");
    elseif(length(p) != length(q))
        error("@estimtor/getMuVarFromBeta: length of mu and var do not match");
    endif
	
	mu = p ./ (p .+ q);
	var = p .* q ./ ((p .+ q) .^ 2 .* (p .+ q .+ 1));

endfunction