# usage: [mu, averages, func] = est632Fit(accs, sizes, functionParams)

function [mu, averages, func] = est632Fit(accs, sizes, functionParams,
                                        weighted, niRate)

    mu = [];
    averages = [];
    func = [];
    
    if((nargin < 3) || (nargin > 5))
        print_usage();
    elseif(!isvector(accs))
        error("estimationMethods/est632Fit: accuracies have to be provided as vector");
    elseif(!isvector(sizes))
        error("estimationMethods/est632Fit: amount of accuracies per iteration \
(sizes) have to be provided as vector");
    elseif(!isstruct(functionParams))
        error("estimationMethods/est632Fit: function parameters have to be \
provided as struct");
    endif
    
    iter = length(sizes)+1;
    fitX = 2:iter;
    
    # average the accuracies for each iteration
    pos = 0;
    for i = 1:length(sizes)
        currAver = sum(accs(pos+1:(pos+sizes(i)))) / sizes(i);
        pos += sizes(i);
        
        averages = [averages, currAver];
    endfor
    
    # default weights
    weights = ones(1, length(fitX));
    
    if((nargin >= 4) && !isempty(weighted) && weighted)
        # use n choose k as relative weights
        weights = bincoeff(ones(1, length(fitX)) .* (iter + 1), fitX);
    endif
    
    # use no-information rate as 0th fitting point
    if((nargin == 5) && !isempty(niRate))
        if(!isscalar(niRate))
            error("est632Fit: niRate has to be scalar");
        endif
        
        averages = [niRate, averages];
        weights = [1, weights];
        fitX = [0, fitX];
    endif
    
    if(length(averages) > 1)
        func = fitFunctions(fitX, averages, functionParams, weights);
        mu = functionParams.template(iter + 1, func);
    else
        mu = averages(end);
    endif

endfunction