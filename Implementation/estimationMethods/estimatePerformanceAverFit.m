# usage: [mu, func, averages] = estimatePerformanceAverFit(classifier, oracle,
#                                                    functionParams, accumEstAccs)


function [mu, func, averages] = estimatePerformanceAverFit(classifier, oracle,
                                                    functionParams, accumEstAccs)

    mu = [];
	averages = [];
	func = [];
    
    if(nargin != 4)
        print_usage();
    elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle")
             || !isstruct(functionParams) || !iscell(accumEstAccs))
        error("estimatePerformanceAverFit: requires classifier, oracle, struct, cell");
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