# usage: [mu, var, funcs] = estSampleSupSetFit(accs, functionParams)

function [mu, var, funcs] = estSampleSupSetFit(accs, functionParams)

    mu = [];
	var = [];
	funcs = [];
    
    
    funcs = fitFunctions(1:size(accs, 2), accs, functionParams);
    
    [mu, var] = evaluateEstimatedFunctions(size(accs, 2) + 2, funcs,
                                            functionParams.template);

endfunction