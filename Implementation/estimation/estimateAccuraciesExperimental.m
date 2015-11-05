# usage: accs = estimateAccuraciesExperimental(classifier, oracle)

function accs = estimateAccuraciesExperimental(classifier, oracle)

	accs = [];
	
	# get the labeled instances
	[features, labels] = getQueriedInstances(oracle);
	# list for the accuracy values
	accs = cell(length(labels)-1, 1);
	
	accumAccs = cell(length(labels)-1, 1);
	for i = 1:length(accumAccs)
		accumAccs{i} = zeros(1, length(labels) - i + 1);
	endfor
	
    # compute all possible two-set splits of the labeled instances by
    # computing the powerset of the instance indices
	elemVec = 1:length(labels);
	
	tot = [];
	
	for i = 1:(2^length(labels)-2)
		s = logical(bitget(i, elemVec));
		tot = [tot; s];
	endfor
	
	#for i = 1:length(labels)-1
		d = find(sum(tot, 2) == 1);
		find(sum(tot, 2) == 3);
		z = d + d'
		z = z(1:end-1, 2:end);
		z = triu(z);
		z = reshape(z, prod(size(z)), 1);
		z(z == 0) = [];
	#endfor
    
	#{
    for comb = 1:length(pwr)
        # train the classifier with the selected instances
        classifier = setTrainingData(classifier, features(pwr{comb}, :),
                                labels(pwr{comb}), getNumberOfLabels(oracle));
        
        # test using the remaining instances
        currAcc = computeAccuracy(classifier, features(revPwr{comb}, :),
                                labels(revPwr{comb}));
        # add estimated accuracy to list
        accs{length(pwr{comb})} = [accs{length(pwr{comb})}, currAcc];
    endfor
	#}
	

endfunction