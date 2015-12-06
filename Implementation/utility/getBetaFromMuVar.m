# usage: [p, q] = getBetaFromMuVar(mu, var)

function [p, q] = getBetaFromMuVar(mu, var)

    dist = [];
    
    if(nargin != 2)
        print_usage();
    elseif(!ismatrix(mu) || !ismatrix(var))
        error("utility/getBetaFromMuVar: requires matrix, matrix");
    elseif(size(mu) != size(var))
        error("utility/getBetaFromMuVar: length of mu and var do not match");
    endif
	
	p = -mu .* (var .+ mu .^ 2 .- mu) ./ var;
	q = (var .+ mu .^ 2 .- mu) .* (mu .- 1) ./ var;

endfunction