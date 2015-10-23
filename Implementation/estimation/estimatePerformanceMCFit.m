# usage: [mu, var, beta] = estimatePerformanceMCFit(classifier, oracle, samples,
#                                                    functionTemplate,
#                                                    fittingFunction)


function [mu, var, beta, MCSamples, funcs] = estimatePerformanceMCFit(
													classifier, oracle, samples,
                                                    functionTemplate,
                                                    bounds, inits)

    mu = [];
	var = [];
	beta = [];
	MCSamples = [];
	funcs = [];
    
    if(nargin != 6)
        print_usage();
    elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle")
            || !isscalar(samples) || !is_function_handle(functionTemplate)
            || !ismatrix(bounds) || !ismatrix(inits))
        error("estimatePerformanceFitting: requires classifier, oracle, scalar,\
                function handle, function handle");
    endif
    
    # estimate the accuracies for all combinations of training/test set
    # with the queried instances
    [~, accumEstAccs] = estimateAccuraciesIter(classifier, oracle);
    # use Monte-Carlo sampling to reduce the amount of functions to be fitted
    MCSamples = getMonteCarloSamplesIter(accumEstAccs, samples);
    funcs = fitFunctionsIter(MCSamples, functionTemplate, bounds, inits);
    
    [mu, var, beta, ~] = estimateAccuracyDistribution(length(accumEstAccs)+2, funcs, functionTemplate);

endfunction