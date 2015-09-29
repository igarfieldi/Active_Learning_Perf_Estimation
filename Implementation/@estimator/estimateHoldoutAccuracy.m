# usage: holdoutAccs = estimateHoldoutAccuracy(classifier, oracle, holdoutSize)

function holdoutAccs = estimateHoldoutAccuracy(classifier, oracle, holdoutSize)

    holdoutAccs = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle") || !isscalar(holdoutSize))
        error("@estimator/estimateHoldoutAccuracy: requires classifier, oracle, scalar");
    endif
    
    unlabeled = getNumOfUnlabeledInstances(oracle);
    
    # size < 0 will be interpreted as using only one holdout set
    if(holdoutSize < 0)
        holdoutSize = unlabeled;
    endif
    holdoutSize = min(holdoutSize, unlabeled);
    
    [holdoutFeat, holdoutLab] = getHoldoutSets(oracle, holdoutSize, -1);
    
    # compute the accuracies for each holdout set separately
    for i = 1:length(holdoutLab)
        holdoutAccs = [holdoutAccs, computeAccuracy(classifier, holdoutFeat{i}, holdoutLab{i})];
    endfor

endfunction