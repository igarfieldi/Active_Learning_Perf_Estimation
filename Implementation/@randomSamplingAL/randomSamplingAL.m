# usage: obj = randomSamplingAL(features, labels)

function obj = randomSamplingAL(features, labels)

    obj = [];
    
    if((nargin != 0) && (nargin != 2))
        print_usage();
    endif
    
    obj.activeLearner = [];
    al = @activeLearner();
    
    if(nargin == 2)
        if(!ismatrix(features) || !isvector(labels))
            error("@randomSamplingAL/randomSamplingAL: requires matrix, vector");
        endif
        
        al.unlabeledFeatures = features;
        al.unlabeledLabels = labels;
    endif
    
    obj = class(obj, "randomSamplingAL", al);

endfunction