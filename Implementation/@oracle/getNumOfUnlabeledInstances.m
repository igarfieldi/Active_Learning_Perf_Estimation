# usage: ret = getNumOfUnlabeledInstances(oracle)

function ret = getNumOfUnlabeledInstances(oracle)

    ret = [];
    
    if(nargin != 1)
        print_usage();
    elseif(!isa(oracle, "oracle"))
        error("@oracle/getNumOfUnlabeledInstances: requires oracle");
    endif
    
    ret = length(oracle.labels);

endfunction