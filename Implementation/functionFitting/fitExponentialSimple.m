# usage: [params, func] = fitExponentialSimple(X, Y)

function [params, func] = fitExponentialSimple(X, Y)

    params = [];
    
    if(nargin != 2)
        print_usage();
    elseif(!isvector(X) || !isvector(Y))
        error("fitExponential: requires vector, vector");
    elseif(length(X) != length(Y))
        error("fitExponential: vector lengths do not match");
    endif
    
    f = @(x, p) p(1)*exp(x*p(2));
    
    x2 = X .^ 2;
    
    sumY = sum(Y);
    sumXY = sum(X .* Y);
    sumX2Y = sum(x2 .* Y);
    sumYlnY = sum(Y .* log(Y));
    sumXYlnY = sum((X .* Y) .* log(Y));
    
    denom = sumY * sumX2Y - sumXY ^ 2;
    
    A = exp((sumX2Y * sumYlnY - sumXY * sumXYlnY) ./ denom);
    B = (sumY * sumXYlnY - sumXY * sumYlnY) ./ denom;
    
    params = [A, B];
    func = @(x) f(x, params);

endfunction