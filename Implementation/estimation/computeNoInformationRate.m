# usage: niRate = computeNoInformationRate(classifier, oracle)

function niRate = computeNoInformationRate(classifier, oracle)

    niRate = [];
    
    if(nargin != 2)
        print_usage();
    elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle"))
        error("estimation/computeNoInformationRate: requires classifier, oracle");
    endif
    
    [feat, lab] = getQueriedInstances(oracle);
    
    classifier = setTrainingData(classifier, feat, lab, getNumberOfLabels(oracle));
    
    # compute the first correction factor (no-information rate)
    # count the proportions of unequal labels (see the paper for better
    # description)
    [~, predictions] = max(classifyInstances(classifier, feat));
    
    frequTrain = histc(lab, unique(lab));
    frequPred = histc(predictions, unique(predictions));
    # make sure that we have one column vector
    if(rows(frequTrain) == 1)
        frequTrain = frequTrain';
    endif
    
    niRate = (sum(sum(frequTrain * frequPred)) .- sum(frequTrain' .* frequPred))...
                / (length(lab) ^ 2);

endfunction