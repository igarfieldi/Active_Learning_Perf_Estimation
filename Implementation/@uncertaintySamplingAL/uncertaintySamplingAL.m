# usage: obj = uncertaintySamplingAL(features, labels)

function obj = uncertaintySamplingAL(features, labels)

    obj = [];
    
    if((nargin != 0) && (nargin != 2))
        print_usage();
    endif
    
    obj.activeLearner = [];
    al = @activeLearner();
    
    if(nargin == 2)
        if(!ismatrix(features) || !isvector(labels))
            error("@uncertaintySamplingAL/uncertaintySamplingAL: requires matrix, vector");
        endif
        
        al.unlabeledFeatures = features;
        al.unlabeledLabels = labels;
    endif
    
    obj = class(obj, "uncertaintySamplingAL", al);

endfunction