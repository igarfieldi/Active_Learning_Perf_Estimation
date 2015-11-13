# usage: [mu, func, averages] = estimatePerformanceAverNIFit(accumEstAccs,
#                                                    functionParams, classifier,
#                                                    oracle)


function [mu, func, averages] = estimatePerformanceAverNIFit(accumEstAccs,
                                                    functionParams, classifier,
                                                    oracle)

    mu = [];
	averages = [];
	func = [];
    
    if(nargin != 4)
        print_usage();
    elseif(!iscell(accumEstAccs) || !isstruct(functionParams))
        error("estimatePerformanceAverFit: requires cell, struct");
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
    
    # average the accuracies for every cell
	averages = [1 - gammaHat];
	for i = 1:length(accumEstAccs)
		averages = [averages, sum(accumEstAccs{i}(1, :) .* accumEstAccs{i}(2, :), 2)...
									/ sum(accumEstAccs{i}(2, :), 2)];
	endfor
    func = fitFunctions(1:length(averages), averages, functionParams);
	
	if(isempty(func))
		mu = averages(end);
	else
		mu = functionParams.template(length(averages) + 1, func);
	endif

endfunction