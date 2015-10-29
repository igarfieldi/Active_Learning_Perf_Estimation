# usage: 

function [mu, var, std] = getSampleStatistics(samples)

    mu = [];
    var = [];
    std = [];
    
    if(nargin != 1)
        print_usage();
    elseif(!ismatrix(samples))
        error("getSampleStatistics: requires matrix");
    endif
    
    mu = sum(samples, 1) ./ size(samples, 1);
    var = sum((samples .- mu).^2, 1) ./ (size(samples, 1) - 1);
    std = sqrt(sum((samples .- mu).^2, 1) ./ (size(samples, 1) - 1.5));

endfunction