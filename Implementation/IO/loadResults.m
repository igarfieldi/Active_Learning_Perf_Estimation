# usage: [mus, vars] = loadResults(path)

function [mus, vars] = loadResults(path)

	if(nargin != 1)
		print_usage();
	elseif(!ischar(path))
		error("IO/storeResults: requires chars");
	endif
	
	load(path, "mus", "vars");

endfunction