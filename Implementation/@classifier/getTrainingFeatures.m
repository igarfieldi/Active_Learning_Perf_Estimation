function ret = getTrainingFeatures(classifier)
    
    ret = [];
    
    if(nargin != 1)
        print_usage();
    elseif(!isa(classifier, "classifier"))
        error("getTrainingFeatures: requires classifier");
    else
        ret = classifier.trainingFeatures;
    endif

endfunction