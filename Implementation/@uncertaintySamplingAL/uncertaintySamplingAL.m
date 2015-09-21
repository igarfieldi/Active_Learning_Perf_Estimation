function obj = uncertaintySamplingAL(features, labels)

    obj.activeLearner = [];
    al = @activeLearner();
    
    if(nargin == 2)
        al.unlabeledFeatures = features;
        al.unlabeledLabels = labels;
    endif
    
    obj = class(obj, "uncertaintySamplingAL", al);

endfunction