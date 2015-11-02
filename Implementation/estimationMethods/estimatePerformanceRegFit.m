# usage: [mu, var, MCSamples, funcs] = estimatePerformanceRegFit(estAccs,
#                                               functionParams, wis,
#                                               combs, samples)

function [mu, var, MCSamples, funcs] = estimatePerformanceRegFit(estAccs,
                                                functionParams, wis,
                                                combs, samples)

    mu = [];
	var = [];
	MCSamples = [];
	funcs = [];
    
    if(nargin != 5)
        print_usage();
    elseif(!iscell(estAccs) || !isstruct(functionParams)
			 || !iscell(wis) || !iscell(combs) || !isscalar(samples))
        error("estimatePerformanceRegFit: requires cell, struct, cell, cell, scalar");
    endif
    
    # use Monte-Carlo sampling to reduce the amount of functions to be fitted
    MCSamples = getMonteCarloSamplesSuper(estAccs, wis, combs, samples);
    funcs = fitFunctions(1:length(estAccs), MCSamples, functionParams);
    
    [mu, var] = evaluateEstimatedFunctions(length(estAccs)+1, funcs,
                                                functionParams.template);

    
endfunction