# usage: [mu, var, funcs] = estimatePerformanceRegFitExp(accs, functionParams)

function [mu, var, funcs] = estimatePerformanceRegFitExp(accs, functionParams)

    mu = [];
	var = [];
	funcs = [];
    
    funcs = fitFunctions(1:length(estAccs), MCSamples, functionParams);
    
    [mu, var] = evaluateEstimatedFunctions(length(estAccs)+1, funcs,
                                                functionParams.template);

    
endfunction