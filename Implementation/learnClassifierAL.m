# usage: [activeLearner, classifier, oracle] = learnClassifierAL(activeLearner,
#                                classifier, oracle, labelNum, limit)

function [activeLearner, classifier, oracle] = learnClassifierAL(activeLearner,
                                classifier, oracle, limit)
    
    if(nargin != 4)
        print_usage();
    elseif(!isa(activeLearner, "activeLearner") || !isa(classifier, "classifier")
            || !isa(oracle, "oracle") || !isscalar(limit))
        error("learnClassifierAL: requires activeLearner, classifier, oracle, scalar");
    endif
    
    
    # amount of unlabeled data that can be labeled
    instances = getNumOfUnlabeledInstances(oracle);
    # user provided upper limit of iterations; values < 0 mean no limit
    limit = min(limit, instances);
    if(limit < 0)
        limit = instances;
    endif
    
    # add as many instances as specified by limit
    for iteration = 1:limit
        # select the next instance by using the provided active learner and
        # add it to the active learner
        [activeLearner, oracle, aquFeat, aquLab] = selectInstance(
            activeLearner, classifier, oracle);
    endfor
    
    [labeledFeatures, labeledLabels] = getLabeledInstances(activeLearner);
    
    if(isargout(2))
        classifier = setTrainingData(classifier, labeledFeatures, labeledLabels, labelNum);
    endif

endfunction