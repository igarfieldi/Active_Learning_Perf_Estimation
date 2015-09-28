function obj = activeLearner(features, labels)
    
    obj.features = [];
    obj.labels = [];
    
    if(nargin == 2)
        obj.features = features;
        obj.labels = labels;
    endif
    
    obj = class(obj, "activeLearner");
    
endfunction