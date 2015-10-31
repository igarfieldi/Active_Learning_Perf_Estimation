# usage: [mu, var, MCSamples, funcs] = estimatePerformanceRestrictedFit(
#   												accumEstAccs, functionParams,
#                                                   samples)


function [mu, var, MCSamples, funcs] = estimatePerformanceRestrictedFit(
													accumEstAccs, functionParams,
                                                    samples)

    mu = [];
	var = [];
	MCSamples = [];
	funcs = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!isscalar(samples) || !isstruct(functionParams)
			 || !isscell(accumEstAccs))
        error("estimatePerformanceRestrictedFit: requires cell, struct, scalar");
    endif
    
    # use Monte-Carlo sampling to reduce the amount of functions to be fitted
    MCSamples = getMonteCarloSamplesInc(accumEstAccs, samples);
    funcs = fitFunctions(1:length(accumEstAccs), MCSamples, functionParams);
    
    [mu, var] = evaluateEstimatedFunctions(length(accumEstAccs)+2, funcs,
                                            functionParams.template);

endfunction