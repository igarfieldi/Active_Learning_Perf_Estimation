# usage: [mu, var, betas, fVals] = predictAccuracyDistribution(regFuncParams, functionTemplate)

function [mu, var, betas, fVals] = predictAccuracyDistribution(x, regFuncParams, functionTemplate)
    
    mu = [];
    var = [];
	betas = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!isscalar(x) || !ismatrix(regFuncParams) || !is_function_handle(functionTemplate))
        error("@estimator/estimatePerformanceLevel: requires scalar, matrix, functionHandle");
    endif
    
    mu = 0;
    var = 0;
    fVals = [];
    
    for j = 1:size(regFuncParams, 1)
        # bias due to the cutoff???
        val = max(0, min(functionTemplate(x, regFuncParams(j, :)), 1));
        fVals = [fVals, val];
        mu += val;
    endfor
    
    mu /= size(regFuncParams, 1);
    
    var = sum((fVals .- mu).^2) ./ (length(fVals) - 1);
    
    betas = [betas; getBetaFromMuVar(mu, var)];

endfunction