# usage: [mu, var, MCSamples, funcs] = estimatePerformance632MCFit(accumEstAccs,
#                                                   functionParams, samples


function [mu, var, MCSamples, funcs] = estimatePerformance632MCFit(classifier,
                                                    oracle, functionParams, samples)

    mu = [];
	var = [];
	beta = [];
	MCSamples = [];
	funcs = [];
    
    if(nargin != 4)
        print_usage();
    endif
    
    [feat, lab] = getQueriedInstances(oracle);
    
    probs = ones(1, (2^length(lab)-2));
    MCSamples = discrete_rnd(1:(2^length(lab)-2), probs, samples, 1);
    
    accs = estimate632Bootstrap(classifier, oracle, 50, MCSamples);
    serAccs = [];
    iters = [];
    for i = 1:length(accs)
        serAccs = [serAccs, accs{i}];
        iters = [iters, ones(1, length(accs{i})) .* (i+1)];
    endfor
    
	if(var(iters) != 0)
		funcs = fitFunctions(iters, serAccs, functionParams);
		mu = functionParams.template(length(lab)+1, funcs);
	else
		mu = mean(serAccs);
	endif

endfunction