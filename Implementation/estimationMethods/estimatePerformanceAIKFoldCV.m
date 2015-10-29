# usage: 

function perf = estimatePerformanceAIKFoldCV(classifier, oracle, k, iter)

	perf = [];
	
	if(nargin == 3)
		if(!isa(classifier, "classifier") || !isa(oracle, "oracle") || !isscalar(k))
			error("estimation/estimatePerformanceAIKFoldCV(3): requires classifier, oracle, scalar");
		endif
		iter = size(getQueriedInstances(oracle), 1);
	elseif(nargin == 4)
		if(!isa(classifier, "classifier") || !isa(oracle, "oracle") || !isscalar(k) || !isscalar(iter))
			error("estimation/estimatePerformanceAIKFoldCV(4): requires classifier, oracle, scalar, scalar");
		endif
	else
		print_usage();
	endif
	
	# get the queried instances up to the wanted iteration (or max)
	[feat, lab] = getQueriedInstances(oracle);
	feat = feat(1:iter, :);
	lab = lab(1:iter);
	indices = randperm(length(lab));
	
	# we can only have as many subsets as instances already queried
	if(k > length(lab))
		k = length(lab);
	endif
	setSize = length(lab) / k;
	
	currIndex = 0;
	perf = 0;
	
	for i = 1:k
		testIndices = [round(currIndex)+1:round(currIndex + setSize)];
		trainIndices = setdiff(indices, testIndices);
		currIndex += setSize;
		
		classifier = setTrainingData(classifier, feat(trainIndices, :),
								lab(trainIndices), getNumberOfLabels(oracle));
		perf += computeAccuracy(classifier, feat(testIndices, :), lab(testIndices));
	endfor
	
	perf /= k;

endfunction