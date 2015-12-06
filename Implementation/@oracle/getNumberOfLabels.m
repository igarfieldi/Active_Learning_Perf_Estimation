# usage: labelNum = getNumberOfLabels(oracle)

function labelNum = getNumberOfLabels(oracle)

    labelNum = [];
    
    if(nargin != 1)
        print_usage();
    elseif(!isa(oracle, "oracle"))
        error("@oracle/getNumberOfLabels: requires oracle");
    endif
    
    labelNum = oracle.labelNum;

endfunction