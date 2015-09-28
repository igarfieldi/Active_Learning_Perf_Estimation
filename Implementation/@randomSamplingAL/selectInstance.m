# usage: [ret, orac, aquFeat, aquLab] = selectInstance(randomSamplingAL, classifier, oracle, labelNum)

function [ret, orac, aquFeat, aquLab] = selectInstance(randomSamplingAL, classifier, oracle, labelNum)
    
    ret = [];
    orac = [];
    aquFeat = [];
    aquLab = [];
    
    if(nargin != 4)
        print_usage();
    elseif(!isa(randomSamplingAL, "randomSamplingAL") || !isa(classifier, "classifier")
            || !isa(oracle, "oracle") || !isscalar(labelNum))
        error("selectInstance@randomSamplingAL: requires randomSamplingAL, classifier, oracle, scalar");
    endif
    
    ret = randomSamplingAL;
    orac = oracle;
    
    unlabeledSize = getNumOfUnlabeledInstances(oracle);
    
    # if unlabeled instances remain
    if(unlabeledSize > 0)
        # select a random one
        nextLabelIndex = floor(rand(1) * unlabeledSize) + 1;
        [orac, aquFeat, aquLab] = queryInstance(orac, nextLabelIndex);
        
        # add it to the active learner
        ret = addLabeledInstances(ret, aquFeat, aquLab);
    endif
    
endfunction