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
		r = ret;
	elseif(isvector(p) && isvector(x))
		ret = repmat(reshape((1 .- p), length(p), 1), 1, length(x));
		x = repmat(reshape(x, 1, length(x)), length(p), 1);
		indices = find(x < 0.5);
		ret(indices) = 1 .- ret(indices);
	else
		error("@probabilisticAL/computeError: requires either scalars or vectors");
	endif

endfunction