# usage: [mu, var, MCSamples, funcs] = estimatePerformanceRegNIFit(estAccs,
#                                               functionParams, wis,
#                                               combs, samples)

function [mu, var, MCSamples, funcs] = estimatePerformanceRegNIFit(estAccs,
                                                functionParams, wis,
                                                combs, samples, classifier, oracle)

    mu = [];
	var = [];
	MCSamples = [];
	funcs = [];
    
    if(nargin != 7)
        print_usage();
    elseif(!iscell(estAccs) || !isstruct(functionParams)
			 || !iscell(wis) || !iscell(combs) || !isscalar(samples))
        error("estimatePerformanceRegFit: requires cell, struct, cell, cell, scalar");
    endif
    
    # get no-information rate
    [feat, lab] = getQueriedInstances(oracle);
    classifier = setTrainingData(classifier, feat, lab, getNumberOfLabels(oracle));
    [~, predictions] = max(classifyInstances(classifier, feat));
    frequTrain = histc(lab, unique(lab));
    frequPred = histc(predictions, unique(predictions));
    # make sure that we have one column vector
    if(rows(frequTrain) == 1)
        frequTrain = frequTrain';
    endif
    gammaHat = (sum(sum(frequTrain * frequPred)) .- sum(frequTrain' .* frequPred))...
                / (length(lab) ^ 2);
    
    # use Monte-Carlo sampling to reduce the amount of functions to be fitted
    MCSamples = getMonteCarloSamplesSuper(estAccs, wis, combs, samples);
    MCSamples = [(1-gammaHat) .* ones(size(MCSamples, 1), 1), MCSamples];
    funcs = fitFunctions(0:length(estAccs), MCSamples, functionParams);
    
    [mu, var] = evaluateEstimatedFunctions(length(estAccs)+1, funcs,
                                                functionParams.template);

    
endfunction