function ret = getClassifier(pwClassifier)
    
    ret = [];
    
    if(nargin != 1)
        print_usage();
    elseif(!isa(pwClassifier, "parzenWindowClassifier"))
        error("getClassifier@parzenWindowClassifier: requires parzenWindowClassifier");   
    else
        ret = pwClassifier.classifier;
    endif        

endfunction