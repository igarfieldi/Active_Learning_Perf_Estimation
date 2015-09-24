function [ret, aquFeat, aquLab] = selectInstance(uncertaintySamplingAL, classifier, labelNum)
    
    ret = [];
    aquFeat = [];
    aquLab = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!isa(uncertaintySamplingAL, "uncertaintySamplingAL") || !isa(classifier, "classifier") || !isscalar(labelNum))
        error("selectInstance@uncertaintySamplingAL: requires uncertaintySamplingAL, classifier, scalar");
    endif
    
    ret = uncertaintySamplingAL;
    
    labFeat = getLabeledFeatures(ret);
    unlabFeat = getUnlabeledFeatures(ret);
    labLab = getLabeledLabels(ret);
    unlabLab = getUnlabeledLabels(ret);
    
    unlabeledSize = length(getUnlabeledLabels(ret));
    
    if(unlabeledSize > 0)
        # if no instances have been labeled yet, choose randomly
        if(length(labLab) < 1)
            nextLabelIndex = floor(rand(1) * unlabeledSize) + 1;
        else
            # Determine estimated posteriors with kernel density estimation
            classifier = setTrainingData(classifier, labFeat, labLab, labelNum);
            
            posteriors = classifyInstances(classifier, unlabFeat);
            
            posteriors(posteriors(:) == 0) = 1;
            
            entropies = -sum(posteriors .* log2(posteriors), 1);
            
            maxEntr = max(entropies);
            
            maxIndices = find(entropies == maxEntr);
            
            nextLabelIndex = maxIndices(floor(rand(1) * length(maxIndices)) + 1);
        endif
        
        aquFeat = unlabFeat(nextLabelIndex, :);
        aquLab = unlabLab(nextLabelIndex);
        
        labFeat = [labFeat; aquFeat];
        labLab = [labLab; aquLab];
        
        unlabFeat(nextLabelIndex, :) = [];
        unlabLab(nextLabelIndex) = [];
        
        ret = setLabeledFeatures(ret, labFeat);
        ret = setUnlabeledFeatures(ret, unlabFeat);
        ret = setLabeledLabels(ret, labLab);
        ret = setUnlabeledLabels(ret, unlabLab);
    endif
    
    
endfunction