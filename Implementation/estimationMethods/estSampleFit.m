# usage: [mu, var, funcs] = estSampleFit(accs, functionParams, weighted, niRate)

function [mu, var, funcs] = estSampleFit(accs, functionParams, weighted, niRate)

    mu = [];
	var = [];
	funcs = [];
    
    if((nargin < 2) || (nargin > 4))
        print_usage();
    elseif(!ismatrix(accs))
        error("estimationMethods/estSampleFit: accuracies have to be of matrix form");
    elseif(!isstruct(functionParams))
        error("estimationMethods/estSampleFit: function parameters have to be \
provided as a struct");
    endif
    
    iter = size(accs, 2);
    fitX = 1:iter;
    
    # default weights
    weights = ones(1, length(fitX));
    
    if((nargin >= 3) && !isempty(weighted) && weighted)
        # use n choose k as relative weights
        weights = bincoeff(ones(1, length(fitX)) .* (iter + 1), fitX);
    endif
    
    # use no-information rate as 0th fitting point
    if((nargin == 4) && !isempty(niRate))
        if(!isscalar(niRate))
            error("estSampleFit: niRate has to be scalar");
        endif
        accs = [ones(size(accs, 1), 1) .* niRate, accs];
        weights = [1, weights];
        fitX = [0, fitX];
    endif
    
    funcs = fitFunctions(fitX, accs, functionParams, weights);
    
    [mu, var] = evaluateEstimatedFunctions(iter + 1, funcs,
                                            functionParams.template);

endfunction