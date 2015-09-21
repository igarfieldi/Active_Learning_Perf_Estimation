function ret = setLabeledFeatures(activeLearner, features)

    activeLearner.labeledFeatures = features;
    
    ret = activeLearner;
endfunction