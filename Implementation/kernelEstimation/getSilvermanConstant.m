# usage: Cv = getSilvermanConstant(kernel, dims)

function Cv = getSilvermanConstant(kernel, dims)

	Cv = [];
	
	if(nargin != 2)
		print_usage();
	elseif(!is_function_handle(kernel) || !isscalar(dims) || (floor(dims) != dims)
			|| (dims < 1))
		error("getSilvermanConstant: requires function_handle, scalar integer >= 1");
	endif
	
	R = quadcc(@(x) kernel(x) .^ 2, -Inf, Inf);			# function roughness
	
	v = 0;
	kv = 0;
	while(abs(kv) < 10^(-14))							# compute first non-zero moment
		v++;
		kv = quadcc(@(x) x .^ v .* kernel(x), -Inf, Inf);
	endwhile
	
	# compute Silverman constant
	Cv = (pi^(dims/2)*2^(dims+v-1)*factorial(v)^2*R^dims/...
			(v*kv^2*(doubleFactorial(2*v-1)+(dims-1)*doubleFactorial(v-1)^2)))^(1/(2*v+dims));

endfunction