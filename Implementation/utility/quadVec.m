# usage: res = quadVec(func, low, high)

function res = quadVec(func, low, high)

	res = [];
	
	if(nargin != 3)
		print_usage();
	elseif(!is_function_handle(func) || !isscalar(low) || !isscalar(high))
		error("quadVec: requires function_handle, scalar, scalar");
	endif
	
	dims = length(func(1));
	
	for i = 1:dims
		res = [res, quadgk(@(x) func(x)(i), low, high)];
	endfor

endfunction