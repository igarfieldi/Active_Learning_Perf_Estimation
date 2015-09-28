# usage: [feat, lab] = getAllInstances(oracle)

function [feat, lab] = getAllInstances(oracle)

    feat = [];
    lab = [];
    
    if(nargin != 1)
        print_usage();
    elseif(!isa(oracle, "oracle"))
        error("@oracle/getAllInstances: requires oracle");
    endif
    
    feat = [oracle.queriedFeatures; oracle.features];
    lab = [oracle.queriedLabels; oracle.labels];

endfunction