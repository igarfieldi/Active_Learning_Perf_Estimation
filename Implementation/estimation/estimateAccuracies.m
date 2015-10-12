# usage: [accs, accumAccs] = estimateAccuracies(classifier, oracle)

function [accs, accumAccs] = estimateAccuracies(classifier, oracle)

	global debug;
	
	accs = [];
	accumAccs = [];
	
	if(nargin != 2)
		print_usage();
	elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle"))
		error("@estimator/estimateAccuracies: requires classifier, oracle");
	endif
	
	# set the bounds
	low = 3;
	high = size(getQueriedInstances(oracle), 1);
	
	# get the labeled instances
	[features, labels] = getQueriedInstances(oracle);
	# list for the accuracy values
	accs = cell(high-low+1, 1);
	accumAccs = cell(high-low+1, 1);
	
	for iter = low:high
		if(debug)
			disp(sprintf("Estimation iteration: %d", iter));
		endif
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