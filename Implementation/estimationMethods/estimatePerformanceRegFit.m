# usage: [mu, var, MCSamples, funcs] = estimatePerformanceRegFit(classifier,
#                                            oracle, samples, functionParams,
#											estAccs, wis, combs)

function [mu, var, MCSamples, funcs] = estimatePerformanceRegFit(classifier,
                                            oracle, samples, functionParams,
											estAccs, wis, combs)

    mu = [];
	var = [];
	MCSamples = [];
	funcs = [];
    
    if(nargin != 7)
        print_usage();
    elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle")
             || !isscalar(samples) || !isstruct(functionParams),
			 || !iscell(estAccs) || !iscell(wis) || !iscell(combs))
        error("estimatePerformanceRegFit: requires classifier, oracle, scalar,\
					struct, cell, cell, cell");
    endif
    
    # use Monte-Carlo sampling to reduce the amount of functions to be fitted
    MCSamples = getMonteCarloSamplesSuper(estAccs, wis, combs, samples);
    funcs = fitFunctions(1:length(estAccs), MCSamples, functionParams);
    
    [mu, var] = evaluateEstimatedFunctions(length(estAccs)+2, funcs,
                                                functionParams.template);

    
endfunction