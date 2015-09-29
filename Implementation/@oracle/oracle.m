# usage: obj = oracle(features, labels, labelNum)

function obj = oracle(features, labels, labelNum)

    obj = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!ismatrix(features) || !isvector(labels) || !isscalar(labelNum))
        error("@oracle/oracle: requires matrix, vector, scalar");
    elseif(rows(features) != length(labels))
        error("@oracle/oracle: unequal number of feature vectors and labels");
    endif
    
    obj.features = features;
    obj.labels = labels;
    obj.queriedFeatures = [];
    obj.queriedLabels = [];
    obj.labelNum = labelNum;
    
    obj = class(obj, "oracle");

endfunction