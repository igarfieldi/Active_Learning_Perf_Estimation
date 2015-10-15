# usage: funcReg = fitFunctionsIter(accSamples, funcHandle)

function funcReg = fitFunctionsIter(accSamples, funcHandle)

	funcReg = [];
	
	if(nargin != 2)
		print_usage();
	elseif(!ismatrix(accSamples) || !is_function_handle(funcHandle))
		error("@perfEstimation/fitFunctionsIter: requires matrix, funcHandle");
	endif
	
	funcReg = [];
    
    # iterate over all samples and fit a curve for each one
    for j = 1:size(accSamples, 1)
        fittedParams = funcHandle((1:length(accSamples(j, :))), accSamples(j, :));
        
        funcReg = [funcReg; fittedParams];
    endfor

endfunction