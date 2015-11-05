# usage: [newMus, newVars] = addResults(path, mus, vars)

function [newMus, newVars] = addResults(path, mus, vars)

	newMus = [];
	newVars = [];
	
	if(nargin != 3)
		print_usage();
	elseif(!ischar(path))
		error("storeResults: requires chars, ..., ...");
	endif
	
	[oldMus, oldVars] = loadResults(path);
	
	newMus = cat(1, oldMus, mus);
	newVars = cat(1, oldVars, vars);
	
	storeResults(path, newMus, newVars);

endfunction