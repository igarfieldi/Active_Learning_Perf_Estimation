# usage: holdoutAccs = estimateHoldoutAccuracy(classifier, oracle, holdoutSize)

function [holdoutAccs, iterAccs] = estimateHoldoutAccuracy(classifier, oracle, holdoutSize)

    holdoutAccs = [];
    iterAccs = [];
    
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
    
	if(isargout(1))
		# compute the accuracies for each holdout set separately
		for i = 1:length(holdoutLab)
			holdoutAccs = [holdoutAccs, computeAccuracy(classifier, holdoutFeat{i}, holdoutLab{i})];
		endfor
	endif
	
	# if wanted, compute the holdout accuracies for every iteration stored in oracle
	if(isargout(2))
		iterAccs = [];
		[feat, lab] = getQueriedInstances(oracle);
		
		for i = 3:length(lab)
			classifier = setTrainingData(classifier, feat(1:i, :), lab(1:i), getNumberOfLabels(oracle));
			
			currAccs = [];
			for i = 1:length(holdoutLab)
				currAccs = [currAccs, computeAccuracy(classifier, holdoutFeat{i}, holdoutLab{i})];
			endfor
			
			iterAccs = [iterAccs; currAccs];
		endfor
	endif

endfunction