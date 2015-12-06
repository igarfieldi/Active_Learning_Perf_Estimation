# usage: activeLearner = addLabeledInstances(activeLearner, features, labels)

function activeLearner = addLabeledInstances(activeLearner, features, labels)

    if(nargin != 3)
        print_usage();
    elseif(!isa(activeLearner, "activeLearner") || !ismatrix(features) || !isvector(labels))
        error("@activeLearner/addLabeledInstances: requires activeLearner, matrix, vector");
    elseif(rows(features) != length(labels))
        error("@activeLearner/addLabeledInstances: unequal number of feature vectors and labels");
    endif
    
    activeLearner.features = [activeLearner.features; features];
    activeLearner.labels = [activeLearner.labels; labels];

endfunction