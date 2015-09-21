function [ret, aquFeat, aquLab] = selectInstance(randomSamplingAL)
    
    ret = randomSamplingAL;
    
    if(nargin != 1)
        print_usage();
    elseif(!isa(randomSamplingAL, "randomSamplingAL"))
        error("selectInstance@randomSamplingAL: requires randomSamplingAL");
    endif
    
    labFeat = getLabeledFeatures(ret);
    unlabFeat = getUnlabeledFeatures(ret);
    labLab = getLabeledLabels(ret);
    unlabLab = getUnlabeledLabels(ret);
    
    unlabeledSize = size(getUnlabeledLabels(ret), 2);
    if(unlabeledSize > 0)
        nextLabelIndex = floor(rand(1) * unlabeledSize) + 1
        
        aquFeat = unlabFeat(nextLabelIndex, :)
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