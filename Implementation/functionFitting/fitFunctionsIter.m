# usage: funcReg = fitFunctionsIter(accSamples, funcHandle)

function funcReg = fitFunctionsIter(accSamples, functionTemplate, bounds, inits)

	global notConverged;
	funcReg = [];
	
	if(nargin != 4)
		print_usage();
	elseif(!ismatrix(accSamples) || !is_function_handle(functionTemplate)
			|| !ismatrix(bounds) || !ismatrix(inits))
		error("@perfEstimation/fitFunctionsIter: requires matrix, function_handle, matrix, matrix");
	endif
	
	funcReg = [];
	
	options.bounds = bounds;
    
    # iterate over all samples and fit a curve for each one
    for j = 1:size(accSamples, 1)
		X = 1:length(accSamples(j, :));
		Y = accSamples(j, :);
		
		squErr = 1;
		counter = 0;
		
		while((squErr > 10^(-3)) && (counter < 10))
			init = (rand(1, 3) .- inits(1, :)) .* inits(2, :);
			[values, fittedParams, cvg] = leasqr(X', Y', init, functionTemplate, 0.0001,
										200, [], [], [], options);
			
			squErr = sum((functionTemplate(X, fittedParams) .- Y) .^ 2);
			counter++;
		endwhile
		
		if(counter >= 10)
			notConverged++;
			#fittedParams = [sum(Y) / length(Y); 0; 0];
		endif
        
        funcReg = [funcReg; fittedParams'];
    endfor

endfunction