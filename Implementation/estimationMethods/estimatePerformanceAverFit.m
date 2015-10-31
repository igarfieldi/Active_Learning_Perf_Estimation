# usage: [mu, func, averages] = estimatePerformanceAverFit(accumEstAccs, functionParams)


function [mu, func, averages] = estimatePerformanceAverFit(accumEstAccs, functionParams)

    mu = [];
	averages = [];
	func = [];
    
    if(nargin != 2)
        print_usage();
    elseif(!iscell(accumEstAccs) || !isstruct(functionParams))
        error("estimatePerformanceAverFit: cell, struct");
    endif
    
    # average the accuracies for every cell
	averages = [];
	for i = 1:length(accumEstAccs)
		averages = [averages, sum(accumEstAccs{i}(1, :) .* accumEstAccs{i}(2, :), 2)...
									/ sum(accumEstAccs{i}(2, :), 2)];
	endfor
    func = fitFunctions(1:length(accumEstAccs), averages, functionParams);
	
	if(isempty(func))
		mu = accumEstAccs(end);
	else
		mu = functionParams.template(length(accumEstAccs) + 2, func);
	endif

endfunction