# usage: [mu, var, MCSamples, funcs] = estimatePerformanceRegFit(estAccs,
#                                               functionParams, wis,
#                                               combs, samples)

function [mu, averages, func] = estimatePerformance632Fit(classifier,
                                                oracle, functionParams,
                                                totalSamples)

    mu = [];
    averages = [];
    func = [];
    accs = [];
    
    if(nargin != 4)
        print_usage();
    endif
    
    accs = estimate632Bootstrap(classifier, oracle, totalSamples);
    mu = 0;
    #{
    for i = 2:length(accs)
        averages = [averages, sum(accs{i}) / length(accs{i})];
    endfor
    
    if(length(averages) > 1)
        func = fitFunctions(1:length(averages), averages, functionParams);
        mu = functionParams.template(length(averages) + 2, func);
    else
        mu = averages(1);
    endif
    #}

endfunction