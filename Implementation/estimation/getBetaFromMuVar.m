# usage: [p, q] = getBetaFromMuVar(mu, var)

function dist = getBetaFromMuVar(mu, var)

    dist = [];
    
    if(nargin != 2)
        print_usage();
    elseif(!isvector(mu) || !isvector(var))
        error("@estimator/getBetaFromMuVar: requires scalar, scalar");
    elseif(length(mu) != length(var))
        error("@estimtor/getBetaFromMuVar: length of mu and var do not match");
    endif
	
	p = -mu .* (var .+ mu .^ 2 .- mu) ./ var;
	q = (var .+ mu .^ 2 .- mu) .* (mu .- 1) ./ var;
	
	dist = [p, q];

endfunction