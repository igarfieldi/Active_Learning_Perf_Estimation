function obj = activeLearner(features, labels)
    
    obj.labeledFeatures = [];
    obj.labeledLabels = [];
    obj.unlabeledFeatures = [];
    obj.unlabeledLabels = [];
    
    if(nargin == 2)
        obj.unlabeledFeatures = features;
        obj.unlabeledLabels = labels;
    endif
    
    obj = class(obj, "activeLearner");
    
endfunction