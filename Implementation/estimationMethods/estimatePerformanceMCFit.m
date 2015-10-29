# usage: [mu, var, beta] = estimatePerformanceMCFit(classifier, oracle, samples,
#                                                    functionTemplate,
#                                                    fittingFunction)


function [mu, var, MCSamples, funcs] = estimatePerformanceMCFit(classifier,
                                                    oracle, samples, functionParams)

    mu = [];
	var = [];
	beta = [];
	MCSamples = [];
	funcs = [];
    
    if(nargin != 4)
        print_usage();
    elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle")
            || !isscalar(samples) || !isstruct(functionParams))
        error("estimatePerformanceFitting: requires classifier, oracle, scalar,\
                function handle, function handle");
    endif
    
    # estimate the accuracies for all combinations of training/test set
    # with the queried instances
    [~, accumEstAccs] = estimateAccuracies(classifier, oracle);
    # use Monte-Carlo sampling to reduce the amount of functions to be fitted
    MCSamples = getMonteCarloSamples(accumEstAccs, samples);
    funcs = fitFunctions(MCSamples, functionParams);
    
    [mu, var] = evaluateEstimatedFunctions(length(accumEstAccs)+2, funcs,
                                            functionParams.template);

endfunction