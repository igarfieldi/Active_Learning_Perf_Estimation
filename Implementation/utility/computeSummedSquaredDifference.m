# usage: diff = computeSummedSquaredDifference(P, Q, res)

function diff = computeSummedSquaredDifference(P, Q, res)

    diff = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!ismatrix(P) || !ismatrix(Q) || !isscalar(res))
        error("computeSummedSquaredDifference: requires matrix, matrix, scalar");
    endif
    
    X = repmat(linspace(0+1/res, 1-1/res, res), size(P, 1), 1);
    
    pVal = betapdf(X, repmat(P(:, 1), 1, res), repmat(P(:, 2), 1, res));
    qVal = betapdf(X, repmat(Q(:, 1), 1, res), repmat(Q(:, 2), 1, res));
    
    diff = sum((pVal .- qVal) .^ 2, 2);

endfunction