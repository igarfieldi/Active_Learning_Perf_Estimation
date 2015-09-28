# usage:[obj, feat, lab] = queryInstance(oracle, index)

function [obj, feat, lab] = queryInstance(oracle, index)
    
    obj = [];
    feat = [];
    lab = [];
    
    if(nargin != 2)
        print_usage();
    elseif(!isa(oracle, "oracle") || !isscalar(index))
        error("@oracle/queryInstance: requires oracle, scalar");
    endif
    
    obj = oracle;
    feat = obj.features(index, :);
    lab = obj.labels(index);
    
    obj.features(index, :) = [];
    obj.labels(index) = [];
    obj.queriedFeatures = [obj.queriedFeatures; feat];
    obj.queriedLabels = [obj.queriedLabels; lab];

endfunction