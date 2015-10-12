# usage: accs = estimateAccuraciesInc(classifier, oracle)

function accs = estimateAccuraciesInc(classifier, oracle)
	
	accs = [];
	
	# set the bounds
	low = 3;
	high = size(getQueriedInstances(oracle), 1);
	
	# get the labeled instances
	[features, labels] = getQueriedInstances(oracle);
	# list for the accuracy values
	accs = cell(high-low+1, 1);
	
	if(low > high)
		return ;
	endif
	
	for iter = low:high
		accs{iter-low + 1} = cell(iter-1, 1);
		
		if(low == 3)
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
		else
			#{
			estAccs = estAccs
			nextAcc = [];
			[feat, lab] = getQueriedInstances(orac);

			for i = 1:length(lab)-1
				pwC = setTrainingData(pwC, feat(i, :), lab(i), getNumberOfLabels(orac));
				currAcc = computeAccuracy(pwC, feat(end, :), lab(end));
				nextAcc = [nextAcc, (estAccs{end-1}{1}(i)*2+currAcc)/3];
			endfor

			nextAcc = nextAcc
			#}
		endif
	endfor

endfunction