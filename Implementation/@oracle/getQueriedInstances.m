# usage: [feat, lab] = getQueriedInstances(oracle)

function [feat, lab] = getQueriedInstances(oracle)

    feat = [];
    lab = [];
    
    if(nargin != 1)
        print_usage();
    elseif(!isa(oracle, "oracle"))
        error("@oracle/getQueriedInstances: requires oracle");
    endif
    
    feat = oracle.queriedFeatures;
    lab = oracle.queriedLabels;

endfunction