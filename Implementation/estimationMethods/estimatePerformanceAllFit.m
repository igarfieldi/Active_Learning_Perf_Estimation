# usage: [mu, func] = estimatePerformanceAllFit(classifier, oracle, functionParams
#												estAccs)


function [mu, func] = estimatePerformanceAllFit(classifier, oracle, functionParams,
												estAccs)

    mu = [];
	func = [];
    
    if(nargin != 4)
        print_usage();
    elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle")
             || !isstruct(functionParams) || !iscell(estAccs))
        error("estimatePerformanceAllFit: requires classifier, oracle, struct, cell");
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