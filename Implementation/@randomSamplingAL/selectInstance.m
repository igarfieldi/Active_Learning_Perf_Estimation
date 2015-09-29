# usage: [randomSamplingAL, oracle, aquFeat, aquLab] = selectInstance(randomSamplingAL, classifier, oracle)

function [randomSamplingAL, oracle, aquFeat, aquLab] = selectInstance(randomSamplingAL, classifier, oracle)
    
    aquFeat = [];
    aquLab = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!isa(randomSamplingAL, "randomSamplingAL") || !isa(classifier, "classifier")
            || !isa(oracle, "oracle"))
        error("selectInstance@randomSamplingAL: requires randomSamplingAL, classifier, oracle");
    endif
    
    unlabeledSize = getNumOfUnlabeledInstances(oracle);
    
    # if unlabeled instances remain
    if(unlabeledSize > 0)
        # select a random one
        nextLabelIndex = floor(rand(1) * unlabeledSize) + 1;
        [oracle, aquFeat, aquLab] = queryInstance(oracle, nextLabelIndex);
        
        # add it to the active learner
        randomSamplingAL = addLabeledInstances(randomSamplingAL, aquFeat, aquLab);
    endif
    
endfunction