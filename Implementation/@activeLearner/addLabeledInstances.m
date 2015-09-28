# usage: ret = addLabeledInstances(activeLearner, features, labels)

function ret = addLabeledInstances(activeLearner, features, labels)

    ret = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!isa(activeLearner, "activeLearner") || !ismatrix(features) || !isvector(labels))
        error("@activeLearner/addLabeledInstances: requires activeLearner, matrix, vector");
    elseif(rows(features) != length(labels))
        error("@activeLearner/addLabeledInstances: unequal number of feature vectors and labels");
    endif
    
    ret = activeLearner;
    ret.features = [ret.features; features];
    ret.labels = [ret.labels; labels];

endfunction