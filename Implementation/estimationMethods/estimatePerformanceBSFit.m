# usage: [mu, var, MCSamples, funcs] = estimatePerformanceRegFit(estAccs,
#                                               functionParams, wis,
#                                               combs, samples)

function [mu, averages, func, accs] = estimatePerformanceBSFit(classifier,
                                                oracle, functionParams,
                                                totalSamples, prevAcc)

    mu = [];
    averages = [];
    func = [];
    accs = [];
    
    if((nargin != 4) && (nargin != 5))
        print_usage();
    endif
    
    if(nargin == 5)
        accs = estimateLOOBootstrap(classifier, oracle, totalSamples, prevAcc);
    else
        accs = estimateLOOBootstrap(classifier, oracle, totalSamples);
    endif
    
    for i = 2:length(accs)
        averages = [averages, sum(accs{i}) / length(accs{i})];
    endfor
    
    if(length(averages) > 1)
        func = fitFunctions(1:length(averages), averages, functionParams);
        mu = functionParams.template(length(averages) + 2, func);
    else
        mu = averages(1);
    endif

endfunction