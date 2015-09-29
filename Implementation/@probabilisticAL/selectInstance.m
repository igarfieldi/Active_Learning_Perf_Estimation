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
        
    
    unlabeledSize = getNumOfUnlabeledInstances(oracle);
    
    # if unlabeled instances remain
    if(unlabeledSize > 0)
        # if no instances have been labeled yet, choose randomly
        if(size(getQueriedInstances(oracle), 1) < 1)
            nextLabelIndex = floor(rand(1) * unlabeledSize) + 1;
        else
            # perform kernel frequency estimation for each instance
            kernel = @(x, n) exp(-sum(x .^ 2, 2) ./ (2*getStandardDeviation(pwClassifier)^2);
            # get labeled instances and sort them using the classifier's setTrainingData
            [labFeat, labLab] = getLabeledInstances(probabilisticAL);
            pwClassifier = setTrainingData(pwClassifier, labFeat, labLab, getNumberOfLabels(oracle));
            [labFeat, ~, labLabInd] = getTrainingInstances(pwClassifier);
            # get unlabeled instances
            [unlabFeat, unlabLab] = getUnlabeledInstances(oracle);
            
            
            nx = estimateKernelFrequencies(unlabFeat, labFeat, kernel);
            p = [];
            old = 1;
            for i = 1:getNumberOfLabels(oracle)
                p = [p, estimateKernelFrequencies(unlabFeat, labFeat(old:labLabInd(i)), kernel);
                old = labLabInd(i) + 1;
            endfor
            
            pmax = max(p) ./ nx;
            
            if(nargin != 4)
                dx = estimateKernelFrequencies(unlabFeat, [labFeat; unlabFeat], kernel);
            endif
            
            # TODO: compute pgain
        endif
        
        # query the wanted instance
        [oracle, aquFeat, aquLab] = queryInstance(oracle, nextLabelIndex);
        
        # add it to the active learner
        probabilisticAL = addLabeledInstances(probabilisticAL, aquFeat, aquLab);
    endif
    
endfunction