# usage: ret = entropy(p)

function ret = entropy(p)

    ret = [];
    
    if(nargin != 1)
        print_usage();
    elseif(!isvector(p))
        error("utility/entropy: requires vector");
    endif
    
    ret = -sum(p ./ sum(p) .* log2(max(1, p) ./ sum(p)));

endfunction