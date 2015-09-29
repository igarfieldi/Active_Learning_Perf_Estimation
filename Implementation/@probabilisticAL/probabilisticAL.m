# usage: obj = probabilisticAL(features, labels)

function obj = probabilisticAL(features, labels)

    obj.activeLearner = [];
    al = @activeLearner();
    
    if(nargin == 2)
        al.unlabeledFeatures = features;
        al.unlabeledLabels = labels;
    endif
    
    obj = class(obj, "probabilisticAL", al);

endfunction