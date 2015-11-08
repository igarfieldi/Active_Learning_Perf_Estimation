# usage: [RSAL, oracle, aquFeat, aquLab] = selectInstance(RSAL, classifier, oracle)

function [RSAL, oracle, aquFeat, aquLab] = selectInstance(RSAL, classifier, oracle)
    
    aquFeat = [];
    aquLab = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!isa(RSAL, "randomSamplingAL") || !isa(classifier, "classifier")
            || !isa(oracle, "oracle"))
        error("@randomSamplingAL/selectInstance: requires randomSamplingAL, \
classifier, oracle");
    endif
    
    unlabeledSize = getNumOfUnlabeledInstances(oracle);
    
    # if unlabeled instances remain
    if(unlabeledSize > 0)
        # select a random one
        nextLabelIndex = floor(rand(1) * unlabeledSize) + 1;
        [oracle, aquFeat, aquLab] = queryInstance(oracle, nextLabelIndex);
        
        # add it to the active learner
        RSAL = addLabeledInstances(RSAL, aquFeat, aquLab);
    endif
    
endfunction