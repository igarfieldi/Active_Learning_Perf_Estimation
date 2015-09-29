# usage: sigma = getStandardDeviation(pwClassifier)

function sigma = getStandardDeviation(pwClassifier)

    sigma = [];
    
    if(nargin != 1)
        print_usage();
    elseif(!isa(pwClassifier, "parzenWindowClassifier"))
        error("@parzenWindowClassifier/getStandardDeviation: requires parzenWindowClassifier");
    endif
    
    sigma = pwClassifier.sigma;

endfunction