# usage: ret = computeError(p, x)

function ret = computeError(p, x)

    ret = [];
	
    if(nargin != 2)
        print_usage();
	endif
	
	if(isscalar(p) && isscalar(x))
		ret = 1 - p;
		if(x < 0.5)
			ret = p;
		endif
	elseif(isvector(p) && isscalar(x))
		ret = 1 .- p;
		if(x < 0.5)
			ret = p;
		endif
	elseif(isscalar(p) && isvector(x))
		ret = repmat(1 - p, 1, length(x));
		ret(x < 0.5) = p;
	else
		error("@probabilisticAL/computeError: requires either two scalars or one scalar and one vector");
	endif

endfunction