# usage: obj = activeLearner(features, labels)

function obj = activeLearner(features, labels)
    
    obj.features = [];
    obj.labels = [];
    
    if(nargin == 2)
        if(!ismatrix(features) || !isvector(labels))
            error("@activeLearner/activeLearner: requires matrix, vector");
        endif
        
        obj.features = features;
        obj.labels = labels;
    endif
    
    obj = class(obj, "activeLearner");
    
endfunction