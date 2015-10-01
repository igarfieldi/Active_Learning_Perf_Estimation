# usage: accs = estimateAccuracies(classifier, oracle, low, high)

function [accs, accumAccs] = estimateAccuracies(classifier, oracle, low, high)

	accs = [];
	accumAccs = [];
	
	if(nargin != 4)
		print_usage();
	elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle") || !isscalar(low) || !isscalar(high))
		error("@estimator/estimateAccuracies: requires classifier, oracle, scalar, scalar");
	endif
	
	# check for accidental switcheroo
	if(low > high)
		t = high;
		high = low;
		low = t;
	endif
	# negative upper limit means no limit
	if(high < 0)
		high = size(getQueriedInstances(oracle), 1);
	endif
	# check for correct bounds
	low = max(2, low);
	high = min(size(getQueriedInstances(oracle), 1), high);
	
	# get the labeled instances
	[features, labels] = getQueriedInstances(oracle);
	# list for the accuracy values
	accs = cell(high-low+1, 1);
	accumAccs = cell(high-low+1, 1);
	
	for iter = low:high
		# add a new cell dimension for the currrent iteration
		accs{iter-low + 1} = cell(iter-1, 1);
		
		# compute all possible two-set splits of the labeled instances by
		# computing the powerset of the instance indices
		pwr = powerset([1:iter])(2:end-1);
		revPwr = fliplr(pwr);
		
		for comb = 1:length(pwr)
			# train the classifier with the selected instances
			classifier = setTrainingData(classifier, features(pwr{comb}, :), labels(pwr{comb}), getNumberOfLabels(oracle));
			
			# test using the remaining instances
			currAcc = computeAccuracy(classifier, features(revPwr{comb}, :), labels(revPwr{comb}));
			# add estimated accuracy to list
			accs{iter-low + 1}{length(pwr{comb})} = [accs{iter-low + 1}{length(pwr{comb})}, currAcc];
		endfor
		
		# if accumulated (kind of sparse) accuracy list is wanted
		if(isargout(2))
			accumAccs{iter-low + 1} = cell(iter - 1, 1);
			
			for l = 1:iter-1
				# uniquify the accuracy vectors
				[u, ~, j] = unique(accs{iter-low + 1}{l});
				accumAccs{iter-low + 1}{l} = [u; accumarray(j', 1)'];
			endfor
		endif
	endfor

endfunction