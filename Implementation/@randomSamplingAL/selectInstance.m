function [ret, aquFeat, aquLab] = selectInstance(randomSamplingAL, classifier, labelNum)
    
    ret = randomSamplingAL;
    
    if(nargin != 3)
        print_usage();
    elseif(!isa(randomSamplingAL, "randomSamplingAL") || !isa(classifier, "classifier") || !isscalar(labelNum))
        error("selectInstance@randomSamplingAL: requires randomSamplingAL, classifier, scalar");
    endif
    
    labFeat = getLabeledFeatures(ret);
    unlabFeat = getUnlabeledFeatures(ret);
    labLab = getLabeledLabels(ret);
    unlabLab = getUnlabeledLabels(ret);
    
    unlabeledSize = length(getUnlabeledLabels(ret));
    if(unlabeledSize > 0)
        nextLabelIndex = floor(rand(1) * unlabeledSize) + 1;
        
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