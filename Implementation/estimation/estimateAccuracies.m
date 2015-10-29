# usage: [accs, accumAccs, wis, combs] = estimateAccuracies(classifier, oracle)

function [accs, accumAccs, wis, combs] = estimateAccuracies(classifier, oracle)

	accs = [];
	accumAccs = [];
	
	if(nargin != 2)
		print_usage();
	elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle"))
		error("@perfEstimation/estimateAccuraciesIter: requires classifier, oracle");
	endif
	
	# get the labeled instances
	[features, labels] = getQueriedInstances(oracle);
	# list for the accuracy values
	accs = cell(length(labels)-1, 1);
		
    # compute all possible two-set splits of the labeled instances by
    # computing the powerset of the instance indices
    pwr = powerset([1:length(labels)])(2:end-1);
    revPwr = fliplr(pwr);
    
    # set up list storing which set contains which training instances
    if(isargout(3))
        wis = cell(length(labels)-1, 1);
        for i = 1:length(labels)-1
            wis{i} = zeros(length(labels), i);
        endfor
        wisCounter = ones(length(labels)-1, 1);
    endif
    if(isargout(4))
        combs = cell(length(labels)-1, 1);
    endif
    
    for comb = 1:length(pwr)
        # train the classifier with the selected instances
        classifier = setTrainingData(classifier, features(pwr{comb}, :), labels(pwr{comb}), getNumberOfLabels(oracle));
        
        # test using the remaining instances
        currAcc = computeAccuracy(classifier, features(revPwr{comb}, :), labels(revPwr{comb}));
        # add estimated accuracy to list
        accs{length(pwr{comb})} = [accs{length(pwr{comb})}, currAcc];
        
        if(isargout(3))
            # write current counter in the storage list
            wis{length(pwr{comb})}(pwr{comb}, wisCounter(length(pwr{comb}))) = ...
                                        wisCounter(length(pwr{comb}));
            wisCounter(length(pwr{comb}))++;
        endif
        
        if(isargout(4))
            combs{length(pwr{comb})} = [combs{length(pwr{comb})}; pwr{comb}];
        endif
    endfor
    
    # remove the (inevitable) zeros in the storage list
    if(isargout(3))
        for i = 1:length(labels)-1
            wis{i} = wis{i}';
            wis{i}(wis{i} == 0) = [];
            wis{i} = reshape(wis{i}, length(wis{i}) / length(labels), length(labels))';
        endfor
    endif
    
    # if accumulated (kind of sparse) accuracy list is wanted
    if(isargout(2))
        accumAccs = cell(length(labels)-1, 1);
    
        for l = 1:length(accumAccs)
            # uniquify the accuracy vectors
            [u, ~, j] = unique(accs{l});
            accumAccs{l} = [u; accumarray(j', 1)'];
        endfor
    endif

endfunction