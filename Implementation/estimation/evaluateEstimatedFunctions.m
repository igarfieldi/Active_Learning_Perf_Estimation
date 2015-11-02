# usage: [mu, var, fVals] = evaluateEstimatedFunctions(x, regFuncParams, functionTemplate)

function [mu, variance, fVals] = evaluateEstimatedFunctions(x, regFuncParams, functionTemplate)
    
    mu = [];
    variance = [];
	betas = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!isscalar(x) || !ismatrix(regFuncParams) || !is_function_handle(functionTemplate))
        error("@estimator/estimatePerformanceLevel: requires scalar, matrix, functionHandle");
    endif
    
    mu = 0;
    variance = 0;
    fVals = [];
    
    for j = 1:size(regFuncParams, 1)
        # bias due to the cutoff???
        val = max(0, min(functionTemplate(x, regFuncParams(j, :)), 1));
        fVals = [fVals, val];
    endfor
    
    mu = mean(fVals);
    
    variance = var(fVals);

endfunction