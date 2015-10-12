# usage: [aver, stdDev, betas] = estimatePerformanceLevel(regFuncParams, functionTemplate)

function [mu, var, betas] = estimatePerformanceLevel(regFuncParams, functionTemplate)
    
    mu = [];
    var = [];
	betas = [];
    
    if(nargin != 2)
        print_usage();
    elseif(!iscell(regFuncParams) || !is_function_handle(functionTemplate))
        error("@estimator/estimatePerformanceLevel: requires cell, functionHandle");
    endif
    
	for i = 1:length(regFuncParams)
		currMu = 0;
		fVals = [];
		
		for j = 1:size(regFuncParams{i}, 1)
			# bias due to the cutoff???
			val = max(0, min(functionTemplate(j, regFuncParams{i}(j, :)), 1));
			fVals = [fVals, val];
			currMu += val;
		endfor
		
		currMu /= size(regFuncParams{i}, 1);
		mu = [mu, currMu];
		
		currVar = sum((fVals .- currMu).^2) ./ (length(fVals) - 1);
		var = [var, currVar];
		
		betas = [betas; getBetaFromMuVar(currMu, currVar)];
	endfor
	
    
endfunction