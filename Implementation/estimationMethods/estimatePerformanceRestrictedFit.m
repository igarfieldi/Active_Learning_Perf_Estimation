# usage: [mu, var, MCSamples, funcs] = estimatePerformanceRestrictedFit(
#													classifier, oracle, samples,
#                                                   functionParams)


function [mu, var, MCSamples, funcs] = estimatePerformanceRestrictedFit(
													classifier, oracle, samples,
                                                    functionParams)

    mu = [];
	var = [];
	MCSamples = [];
	funcs = [];
    
    if(nargin != 4)
        print_usage();
    elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle")
             || !isscalar(samples) || !isstruct(functionParams))
        error("estimatePerformanceFitting: requires classifier, oracle, scalar, struct");
    endif
    
    # estimate the accuracies for all combinations of training/test set
    # with the queried instances
    [~, accumEstAccs] = estimateAccuracies(classifier, oracle);
    # use Monte-Carlo sampling to reduce the amount of functions to be fitted
    MCSamples = getMonteCarloSamplesInc(accumEstAccs, samples);
    funcs = fitFunctions(MCSamples, functionParams);
    
    [mu, var] = evaluateEstimatedFunctions(length(accumEstAccs)+2, funcs,
                                            functionParams.template);

endfunction