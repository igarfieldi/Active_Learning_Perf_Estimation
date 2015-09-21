function obj = randomSamplingAL(features, labels)

    obj.activeLearner = [];
    al = @activeLearner();
    
    if(nargin == 2)
        al.unlabeledFeatures = features;
        al.unlabeledLabels = labels;
    endif
    
    obj = class(obj, "randomSamplingAL", al);

endfunction