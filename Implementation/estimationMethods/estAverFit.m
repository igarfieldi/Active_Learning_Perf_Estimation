# usage: [mu, func, averages] = estAverFit(accs, sizes, functionParams,
#                                       weighted, niRate)


function [mu, func, averages] = estAverFit(accs, sizes, functionParams,
                                        weighted, niRate)

    mu = [];
	averages = [];
	func = [];
    
    if((nargin < 3) || (nargin > 5))
        print_usage();
    elseif(!isvector(accs))
        error("estimationMethods/estAverFit: accuracies have to be provided as vector");
    elseif(!isvector(sizes))
        error("estimationMethods/estAverFit: amount of accuracies per iteration \
(sizes) have to be provided as vector");
    elseif(!isstruct(functionParams))
        error("estimationMethods/estAverFit: function parameters have to be \
provided as struct");
    endif
    
    iter = length(sizes);
    fitX = 1:iter;
    
    # average the accuracies for every cell
    oldPos = 0;
    for k = 1:length(sizes)
        currAverage = accs((oldPos+1):(oldPos+sizes(k)));
        oldPos += sizes(k);
        
        averages = [averages, sum(currAverage) / prod(size(currAverage))];
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
            error("estAverFit: niRate has to be scalar");
        endif
        
        averages = [niRate, averages];
        weights = [1, weights];
        fitX = [0, fitX];
    endif
    
    # fit functions
    if(length(averages) == 1)
        mu = averages(end);
    else
        func = fitFunctions(fitX, averages, functionParams, weights);
		mu = functionParams.template(iter + 1, func);
	endif

endfunction