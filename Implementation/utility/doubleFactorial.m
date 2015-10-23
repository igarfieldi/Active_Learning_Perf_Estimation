# usage: res = doubleFactorial(n)

function res = doubleFactorial(n)

	res = [];
	
	if(nargin != 1)
		print_usage();
	elseif(!isscalar(n))
		error("doubleFactorial: requires scalar");
	endif
	
	res = 1;
	
	while(n >= 2)
		res *= n;
		n -= 2;
	endwhile

endfunction