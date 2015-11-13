# usage: [newMus, newVars, newTimes] = addResults(path, mus, vars, times)

function [newMus, newVars, newTimes] = addResults(path, mus, vars, times)

	newMus = [];
	newVars = [];
	newTimes = [];
	
	if(nargin != 4)
		print_usage();
	elseif(!ischar(path))
		error("IO/storeResults: requires chars, ..., ...");
	endif
	
    oldMus = [];
    oldVars = [];
	oldTimes = [];
    
    if(exist(path, "file") == 2)
        [oldMus, oldVars, oldTimes] = loadResults(path);
    endif
	
	newMus = cat(1, oldMus, mus);
	newVars = cat(1, oldVars, vars);
	newTimes = cat(1, oldTimes, times);
	
	storeResults(path, newMus, newVars, newTimes);

endfunction