# usage: [feat, lab] = getUnlabeledInstances(oracle)

function [feat, lab] = getUnlabeledInstances(oracle)

    feat = [];
    lab = [];
    
    if(nargin != 1)
        print_usage();
    elseif(!isa(oracle, "oracle"))
        error("@oracle/getUnlabeledInstances: requires oracle");
    endif
    
    feat = oracle.features;
    lab = oracle.labels;

endfunction