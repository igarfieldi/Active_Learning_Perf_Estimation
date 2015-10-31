# usage: [mu, var, MCSamples, funcs] = estimatePerformanceRestrictedFit(
#													classifier, oracle, samples,
#                                                   functionParams, accumEstAccs)


function [mu, var, MCSamples, funcs] = estimatePerformanceRestrictedFit(
													classifier, oracle, samples,
                                                    functionParams, accumEstAccs)

    mu = [];
	var = [];
	MCSamples = [];
	funcs = [];
    
    if(nargin != 5)
        print_usage();
    elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle")
             || !isscalar(samples) || !isstruct(functionParams)
			 || !isscell(accumEstAccs))
        error("estimatePerformanceRestrictedFit: requires classifier, oracle, scalar,\
					struct, cell");
    endif
    
    # use Monte-Carlo sampling to reduce the amount of functions to be fitted
    MCSamples = getMonteCarloSamplesInc(accumEstAccs, samples);
    funcs = fitFunctions(1:length(accumEstAccs), MCSamples, functionParams);
    
    [mu, var] = evaluateEstimatedFunctions(length(accumEstAccs)+2, funcs,
                                            functionParams.template);

endfunction