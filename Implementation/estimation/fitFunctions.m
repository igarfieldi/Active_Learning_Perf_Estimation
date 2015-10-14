# usage: 

function funcReg = fitFunctions(accSamples, funcHandle)

	global debug;
	
	funcReg = [];
	
	if(nargin != 2)
		print_usage();
	elseif(!iscell(accSamples) || !is_function_handle(funcHandle))
		error("@estimator/fitFunctions: requires cell, funcHandle");
	endif
	
	funcReg = cell(length(accSamples), 1);
	
	for i = 1:length(accSamples)
        funcReg{i} = [];
		if(debug)
			disp(sprintf("Fitting iteration: %d", i+2));
        endif
		
		# iterate over all samples and fit a curve for each one
		for j = 1:size(accSamples{i}, 1)
            
			fittedParams = funcHandle((1:length(accSamples{i}(j, :))), accSamples{i}(j, :));
			
			funcReg{i} = [funcReg{i}; fittedParams];
		endfor
		
	endfor

endfunction