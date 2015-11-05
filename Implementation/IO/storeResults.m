# usage: storeResults(path, mus, vars)

function storeResults(path, mus, vars)

	if(nargin != 3)
		print_usage();
	elseif(!ischar(path))
		error("storeResults: requires chars, ..., ...");
	endif
	
	save(path, "mus", "vars");

endfunction