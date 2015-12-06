# usage: storeResults(path, mus, vars, times)

function storeResults(path, mus, vars, times)

	if(nargin != 4)
		print_usage();
	elseif(!ischar(path))
		error("IO/storeResults: requires chars, ..., ...");
	endif
	
	save(path, "mus", "vars", "times");

endfunction