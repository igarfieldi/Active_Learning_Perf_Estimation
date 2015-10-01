# usage: [params, func] = fitExponential(X, Y)

function [params, func] = fitExponential(X, Y)

    params = [];
    
    if(nargin != 2)
        print_usage();
    elseif(!isvector(X) || !isvector(Y))
        error("fitExponential: requires vector, vector");
    elseif(length(X) != length(Y))
        error("fitExponential: vector lengths do not match");
    endif
    
    f = @(x, p) p(1) + p(2)*exp(x*p(3));
    
    # estimate initial parameters
    init = rand(1, 3) .- 0.5;
    if(length(Y) >= 3)
        indices = (1:length(X));
        n = floor(rand(1) * length(indices)) + 1;
        i1 = indices(n);
        indices(n) = [];
        n = floor(rand(1) * length(indices)) + 1;
        i2 = indices(n);
        indices(n) = [];
        n = floor(rand(1) * length(indices)) + 1;
        i3 = indices(n);
        indices(n) = [];
        
        d1 = (Y(i2) - Y(i1)) / (X(i2) - X(i1));
        d2 = (Y(i3) - Y(i2)) / (X(i3) - X(i2));
        
        if(d1 == d2)
            a0 = rand(1);
        else
            a0 = (d1*Y(i2) - d2*Y(i1))/(d1 - d2);
        endif
        if(Y(i1) == a0)
            a2 = rand(1);
        else
            a2 = d1/(Y(i1) - a0);
        endif
        a1 = (Y(i1) - a0)*exp(-a2*X(i1));
        
        init = [a0, a1, a2];
    endif
    
    # set statistical weights
    wt = 1 ./ sqrt(min(max(Y, 0.00000000000001), 1));
    
    [values, params, cvg] = leasqr(X, Y, init, f, 0.0001,
                                max(4000/length(Y), 600), wt, max(length(Y)^2*0.000005, 0.0001) * ones(1, 3));
    
    func = @(x) params(1) + params(2)*exp(x*params(3));

endfunction