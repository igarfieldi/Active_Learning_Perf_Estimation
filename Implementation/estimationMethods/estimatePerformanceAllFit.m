# usage: [mu, func] = estimatePerformanceAllFit(estAccs, functionParams


function [mu, func] = estimatePerformanceAllFit(estAccs, functionParams)

    mu = [];
	func = [];
    
    if(nargin != 2)
        print_usage();
    elseif(!iscell(estAccs) || !isstruct(functionParams))
        error("estimatePerformanceAllFit: requires cell, struct");
    endif
    
    # average the accuracies for every cell
	accs = [];
	iters = [];
	for i = 1:length(estAccs)
		accs = [accs, estAccs{i}];
		iters = [iters, ones(1, length(estAccs{i})) .* i];
	endfor
    func = fitFunctionsExperimental(iters, accs, functionParams);
	
	mu = functionParams.template(length(estAccs) + 2, func);

endfunction