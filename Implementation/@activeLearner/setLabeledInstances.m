# usage: ret = setLabeledInstances(activeLearner, features, labels)

function ret = setLabeledInstances(activeLearner, features, labels)

    ret = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!isa(activeLearner, "activeLearner") || !ismatrix(features) || !isvector(labels))
        error("@activeLearner/setLabeledInstances: requires activeLearner, matrix, vector");
    elseif(rows(features) != length(labels))
        error("@activeLearner/setLabeledInstances: unequal number of feature vectors and labels");
    endif
    
    ret = activeLearner;
    ret.features = features;
    ret.labels = labels;
    
endfunction