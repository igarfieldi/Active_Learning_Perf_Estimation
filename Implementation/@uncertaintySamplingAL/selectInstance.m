function [ret, aquFeat, aquLab] = selectInstance(uncertaintySamplingAL)
    
    ret = uncertaintySamplingAL;
    
    if(nargin != 1)
        print_usage();
    elseif(!isa(uncertaintySamplingAL, "uncertaintySamplingAL"))
        error("selectInstance@uncertaintySamplingAL: requires uncertaintySamplingAL");
    endif
    
    labFeat = getLabeledFeatures(ret);
    unlabFeat = getUnlabeledFeatures(ret);
    labLab = getLabeledLabels(ret);
    unlabLab = getUnlabeledLabels(ret);
    
    unlabeledSize = size(getUnlabeledLabels(ret), 2);
    if(unlabeledSize > 0)
        # if no instances have been labeled yet, choose randomly
        if(length(labLab) < 1)
            nextLabelIndex = floor(rand(1) * unlabeledSize) + 1;
        else
            # Determine estimated posteriors with kernel density estimation
            pwC = parzenWindowClassifier(labFeat, labLab, 0.1);
            
            posteriors = classifyInstances(pwC, unlabFeat);
            
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