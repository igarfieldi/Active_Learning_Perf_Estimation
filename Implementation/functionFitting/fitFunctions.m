# usage: funcReg = fitFunctions(accSamples, funcHandle)

function funcReg = fitFunctions(accSamples, functionParams)

	global notConverged;
	funcReg = [];
	
	if(nargin != 2)
		print_usage();
	elseif(!ismatrix(accSamples) || !isstruct(functionParams))
		error("@perfEstimation/fitFunctionsIter: requires matrix, struct");
	endif
	
	funcReg = [];
	
	options.bounds = functionParams.bounds;
    
    # iterate over all samples and fit a curve for each one
    for j = 1:size(accSamples, 1)
		X = 1:length(accSamples(j, :));
		Y = accSamples(j, :);
        #[~, mi] = min(Y);
        #X(mi) = [];
        #Y(mi) = [];
		
		squErr = 1;
		counter = 0;
		
		while((squErr > 10^(-3)) && (counter < 10))
			init = (rand(1, 3) .- functionParams.inits(1, :)) .* functionParams.inits(2, :);
			[values, fittedParams, cvg] = leasqr(X', Y', init,
                                        functionParams.template, 0.0001,
										200, [], [], [], options);
			
			squErr = sum((functionParams.template(X, fittedParams) .- Y) .^ 2);
			counter++;
		endwhile
		
		if(counter >= 10)
			notConverged = [notConverged; accSamples(j, :)];
			#fittedParams = [sum(Y) / length(Y); 0; 0];
		endif
        
        funcReg = [funcReg; fittedParams'];
    endfor

endfunction