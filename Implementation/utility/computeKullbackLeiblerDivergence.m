# usage: KLD = computeKullbackLeiblerDivergence(P, Q, res)

function KLD = computeKullbackLeiblerDivergence(P, Q, res)

    KLD = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!ismatrix(P) || !ismatrix(Q) || !isscalar(res))
        error("utility/computeKullbackLeiblerDivergence: requires matrix, \
matrix, scalar");
    endif
    
    X = repmat(linspace(0+1/res, 1-1/res, res), size(P, 1), 1);
    
    pVal = betapdf(X, repmat(P(:, 1), 1, res), repmat(P(:, 2), 1, res));
    qVal = betapdf(X, repmat(Q(:, 1), 1, res), repmat(Q(:, 2), 1, res));
    
    zeroInd = find(pVal == 0);
    pVal(zeroInd) = 1;
    qVal(zeroInd) = 1;
    zeroInd = find(qVal == 0);
    pVal(zeroInd) = 1;
    qVal(zeroInd) = 1;
    
    KLD = sum(pVal .* log2(pVal ./ qVal), 2);

endfunction