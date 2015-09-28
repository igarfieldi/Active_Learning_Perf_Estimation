# usage: obj = oracle(features, labels)

function obj = oracle(features, labels)

    obj = [];
    
    if(nargin != 2)
        print_usage();
    elseif(!ismatrix(features) || !isvector(labels))
        error("@oracle/oracle: requires matrix, vector");
    elseif(rows(features) != length(labels))
        error("@oracle/oracle: unequal number of feature vectors and labels");
    endif
    
    obj.features = features;
    obj.labels = labels;
    obj.queriedFeatures = [];
    obj.queriedLabels = [];
    
    obj = class(obj, "oracle");

endfunction