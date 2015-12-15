# usage: activeLearner = setLabeledInstances(activeLearner, features, labels)

function activeLearner = setLabeledInstances(activeLearner, features, labels)

    if(nargin != 3)
        print_usage();
		#{
	elseif(!isa(activeLearner, "activeLearner") || !ismatrix(features) || !isvector(labels))
        error("@activeLearner/setLabeledInstances: requires activeLearner, matrix, vector");
    elseif(rows(features) != length(labels))
        error("@activeLearner/setLabeledInstances: unequal number of feature vectors and labels");
		#}
    endif
    
    activeLearner.features = features;
    activeLearner.labels = labels;
    
endfunction