# usage: splitSet(features, labels)

function ret = splitSet(features, labels)

    if(nargin != 2)
        print_usage();
    elseif(!ismatrix(features) || !isvector(labels))
        error("@estimator/splitSet: requires matrix, vector");
    elseif(size(features, 1) != size(labels, 1))
        error("@estimator/splitSet: number of rows for both parameters has to be equal");
    endif
    
    

endfunction