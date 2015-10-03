# usage: [aver, stdDev] = estimatePerformanceLevel(regFuncParams, functionTemplate)

function [aver, stdDev] = estimatePerformanceLevel(regFuncParams, functionTemplate)
    
    aver = 0;
    stdDev = 0;
    
    if(nargin != 2)
        print_usage();
    elseif(!ismatrix(regFuncParams) || !is_function_handle(functionTemplate))
        error("@estimator/estimatePerformanceLevel: requires matrix, functionHandle");
    endif
    
    fVals = [];
	
    for j = 1:size(regFuncParams, 1)
        val = max(0, min(functionTemplate(j, regFuncParams(j, 1:end-1)), 1));
        # bias due to the cutoff?
        fVals = [fVals, val];
        aver += val*regFuncParams(j, end);
    endfor
    aver /= sum(regFuncParams(:, end));
    
    stdDev = sqrt(sum((fVals .- aver).^2 .* regFuncParams(:, end)') / (length(fVals)*sum(regFuncParams(:, end)) - 1));
    
endfunction