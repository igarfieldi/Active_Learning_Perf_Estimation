# usage: [ret, orac, aquFeat, aquLab] = selectInstance(uncertaintySamplingAL, classifier, oracle, labelNum)

function [ret, orac, aquFeat, aquLab] = selectInstance(uncertaintySamplingAL, classifier, oracle, labelNum)
    
    ret = [];
    aquFeat = [];
    aquLab = [];
    orac = [];
    
    if(nargin != 4)
        print_usage();
    elseif(!isa(uncertaintySamplingAL, "uncertaintySamplingAL") || !isa(classifier, "classifier")
            || !isa(oracle, "oracle") || !isscalar(labelNum))
        error("selectInstance@uncertaintySamplingAL: requires uncertaintySamplingAL, classifier, oracle, scalar");
    endif
    
    ret = uncertaintySamplingAL;
    orac = oracle;
    
    unlabeledSize = getNumOfUnlabeledInstances(oracle);
    
    if(unlabeledSize > 0)
        # if no instances have been labeled yet, choose randomly
        if(size(getQueriedInstances(oracle), 1) < 1)
            nextLabelIndex = floor(rand(1) * unlabeledSize) + 1;
        else
            # Determine estimated posteriors with kernel density estimation
            
            [features, labels] = getLabeledInstances(ret);
            classifier = setTrainingData(classifier, features, labels, labelNum);
            
            # compute estimated class probabilities
            posteriors = classifyInstances(classifier, getUnlabeledInstances(oracle));
            posteriors(posteriors(:) == 0) = 1;
            
            # compute and select the instance with the maximal prob. entropy
            entropies = -sum(posteriors .* log2(posteriors), 1);
            maxEntr = max(entropies);
            maxIndices = find(entropies == maxEntr);
            
            # if multiple instances have the same entropy (max.), select one at random
            nextLabelIndex = maxIndices(floor(rand(1) * length(maxIndices)) + 1);
        endif
        [orac, aquFeat, aquLab] = queryInstance(orac, nextLabelIndex);
        
        ret = addLabeledInstances(ret, aquFeat, aquLab);
    endif
    
endfunction