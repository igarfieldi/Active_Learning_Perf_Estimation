# usage: [probabilisticAL, oracle, aquFeat, aquLab] = selectInstance(
#                                                       probabilisticAL, classifier, oracle)

function [probabilisticAL, oracle, aquFeat, aquLab] = selectInstance(
                                                            probabilisticAL,
                                                            pwClassifier, oracle,
                                                            dx)
    
    aquFeat = [];
    aquLab = [];
    
    if(nargin == 3)
        if(!isa(randomSamplingAL, "randomSamplingAL")
            || !isa(pwClassifier, "parzenWindowClassifier") || !isa(oracle, "oracle"))
            error("selectInstance@randomSamplingAL(3): requires randomSamplingAL, parzenWindowClassifier, oracle");
        endif
    elseif(nargin == 4)
        if(!isa(randomSamplingAL, "randomSamplingAL")
            || !isa(pwClassifier, "parzenWindowClassifier") || !isa(oracle, "oracle")
            || !ismatrix(dx))
            error("selectInstance@randomSamplingAL(4): requires randomSamplingAL, parzenWindowClassifier, oracle, matrix");
        endif
    else
        print_usage();
    endif
    
	# only defined for 2-class problem?
	if(getNumberOfLabels(oracle) != 2)
		error("selectInstance@randomSamplingAL: only works for binary class problem");
	endif
    
    unlabeledSize = getNumOfUnlabeledInstances(oracle);
    
    # if unlabeled instances remain
    if(unlabeledSize > 0)
        # if no instances have been labeled yet, choose randomly
        if(size(getQueriedInstances(oracle), 1) < 1)
            nextLabelIndex = floor(rand(1) * unlabeledSize) + 1;
        else
            # perform kernel frequency estimation for each instance
            kernel = @(x) exp(-sum(x .^ 2 ./ (2*getSigma(pwClassifier).^2), 2));
            # get labeled instances and sort them using the classifier's setTrainingData
            [labFeat, labLab] = getLabeledInstances(probabilisticAL);
            pwClassifier = setTrainingData(pwClassifier, labFeat, labLab, getNumberOfLabels(oracle));
            [labFeat, ~, labLabInd] = getTrainingInstances(pwClassifier);
            # get unlabeled instances
            [unlabFeat, unlabLab] = getUnlabeledInstances(oracle);
			
			# integration resolution
			X = linspace(0.0001, 0.9999, 10000);
            
            # calculate label statistics
            nx = estimateKernelFrequencies(unlabFeat, labFeat);
            py = [];
            old = 1;
            for i = 1:getNumberOfLabels(oracle)
                py = [py; estimateKernelFrequencies(unlabFeat, labFeat(old:labLabInd(i), :))];
                old = labLabInd(i) + 1;
            endfor
            
            pmax = max(py) ./ nx;
            
            if(nargin != 4)
                dx = estimateKernelFrequencies(unlabFeat, [labFeat; unlabFeat]);
            endif
            
            # compute pgain
			# TODO: find vectorized version without NaN errors
			betaP = nx .* pmax .+ 1;
			betaQ = nx .* (1 .- pmax) .+ 1;
			gainFunc = @(p, y) computeError(p, pmax) .- computeError(p, (nx .* pmax .+ y) ./ (nx .+ 1));
			pgainFunc = @(p) betapdf(repmat(p, 1, length(betaP)), repmat(betaP, length(p), 1),...
										repmat(betaQ, length(p), 1))...
								.* ((1 .- p) .* gainFunc(p, 0) .+ p .* gainFunc(p, 1));
			
			
			#pgain = quadVec(pgainFunc, 0, 1) .* dx;
			#pgain = quadv(pgainFunc, 0, 1) .* dx;
			pgain = trapz(X, pgainFunc(X')) .* dx;
			
			
			# find instances that maximize the pgain (if multiple maxima, select random)
			maxPgain = max(pgain);
            maxIndices = find(pgain == maxPgain);
            nextLabelIndex = maxIndices(floor(rand(1) * length(maxIndices)) + 1);
        endif
        
        # query the wanted instance
        [oracle, aquFeat, aquLab] = queryInstance(oracle, nextLabelIndex);
        
        # add it to the active learner
        probabilisticAL = addLabeledInstances(probabilisticAL, aquFeat, aquLab);
    endif
    
endfunction