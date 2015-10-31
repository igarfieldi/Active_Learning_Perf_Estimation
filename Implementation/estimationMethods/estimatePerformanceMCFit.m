# usage: [mu, var, MCSamples, funcs] = estimatePerformanceMCFit(accumEstAccs,
#                                                   functionParams, samples


function [mu, var, MCSamples, funcs] = estimatePerformanceMCFit(accumEstAccs,
                                                    functionParams, samples)

    mu = [];
	var = [];
	beta = [];
	MCSamples = [];
	funcs = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!iscell(accumEstAccs) || !isstruct(functionParams) || !isscalar(samples))
        error("estimatePerformanceMCFit: requires cell, struct, scalar");
    endif
    
    # use Monte-Carlo sampling to reduce the amount of functions to be fitted
    MCSamples = getMonteCarloSamples(accumEstAccs, samples);
    funcs = fitFunctions(1:length(accumEstAccs), MCSamples, functionParams);
    
    [mu, var] = evaluateEstimatedFunctions(length(accumEstAccs)+2, funcs,
                                            functionParams.template);

endfunction