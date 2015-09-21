function ret = setUnlabeledFeatures(activeLearner, features)

    activeLearner.unlabeledFeatures = features;

    ret = activeLearner;
    
endfunction