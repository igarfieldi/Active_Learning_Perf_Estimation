# usage: [mu, var, beta] = estimatePerformanceMCFit(classifier, oracle, samples,
#                                                    functionTemplate,
#                                                    fittingFunction)


function [mu, var, beta, MCSamples, funcs] = estimatePerformanceMCFit(
													classifier, oracle, samples,
                                                    functionTemplate,
                                                    fittingFunction)

    mu = [];
	var = [];
	beta = [];
	MCSamples = [];
	funcs = [];
    
    if(nargin != 5)
        print_usage();
    elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle")
            || !isscalar(samples) || !is_function_handle(functionTemplate)
            || !is_function_handle(fittingFunction))
        error("estimatePerformanceFitting: requires classifier, oracle, scalar,\
                function handle, function handle");
    endif
    
    # estimate the accuracies for all combinations of training/test set
    # with the queried instances
    [~, accumEstAccs] = estimateAccuraciesIter(classifier, oracle);
    # use Monte-Carlo sampling to reduce the amount of functions to be fitted
    MCSamples = getMonteCarloSamplesIter(accumEstAccs, samples);
    funcs = fitFunctionsIter(MCSamples, fittingFunction);
    
    [mu, var, beta, ~] = predictAccuracyDistribution(funcs, functionTemplate);

endfunction