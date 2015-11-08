# usage: accs = estimateAccuracies(classifier, oracle, samples)

function accs = estimateAccuracies(classifier, oracle, samples)

	accs = [];
	
    if(nargin != 3)
        print_usage();
    elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle")
            || (!isvector(samples) && !isempty(samples)))
        error("estimation/estimateAccuracies: requires classifier, oracle, vector");
    
    endif
	# get the labeled instances
	[features, labels] = getQueriedInstances(oracle);
	# list for the accuracy values
	#accs = cell(length(labels)-1, 1);
	
	accumAccs = cell(length(labels)-1, 1);
	for i = 1:length(accumAccs)
		accumAccs{i} = zeros(1, length(labels) - i + 1);
	endfor
	
    # compute all possible two-set splits of the labeled instances by
    # computing the powerset of the instance indices
	elemVec = 1:length(labels);
    
    #{
    for i = 1:(2^length(labels)-2)
        s = elemVec(logical(bitget(i, elemVec)));
        counter(length(s))++;
        
        if(ismember(counter(length(s)), samples{length(s)}))
            classifier = setTrainingData(classifier, features(s, :),
                                labels(s), getNumberOfLabels(oracle));
            
            #diff = setdiff(elemVec, s(j, :));
            diff = setdiff(elemVec, s);
            currAcc = computeAccuracy(classifier, features(diff, :),
                                labels(diff));
            accs{length(s)} = [length(s), currAcc];
        endif
    endfor
    #}
    
    for i = 1:length(samples)
        bits = logical(bitget(samples(i), elemVec));
        s = elemVec(bits);
        
        
        classifier = setTrainingData(classifier, features(s, :),
                                labels(s), getNumberOfLabels(oracle));
        
        diff = elemVec(!bits);
        currAcc = computeAccuracy(classifier, features(diff, :),
                            labels(diff));
        accs = [accs, currAcc];
    endfor
    
    #{
    for i = 1:length(labels)-1
        currSets = samples{i};
        
        for j = 1:size(currSets, 1)
            classifier = setTrainingData(classifier, features(currSets(j, :), :),
                                labels(currSets(j, :)), getNumberOfLabels(oracle));
            
            #diff = setdiff(elemVec, s(j, :));
            diff = setdiff(elemVec, currSets(j, :));
            currAcc = computeAccuracy(classifier, features(diff, :),
                                labels(diff));
            accs{i} = [accs{i}, currAcc];
        endfor
	endfor
    #}

endfunction