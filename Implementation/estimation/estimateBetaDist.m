# usage: estimateBetaDist(values)
#
# Estimates the parameters p and q for a beta distribution
# based on the mean and variance of the provided data samples.

function dist = estimateBetaDist(values)

    if(nargin != 1)
        print_usage();
    elseif(!ismatrix(values))
        error("@estimator/estimateBetaDist: requires matrix");
    elseif((max(max(values)) > 1) || (min(min(values)) < 0))
        error("@estimator/estimateBetaDist: inputs not between 0 and 1");
    elseif(length(values) < 2)
        error("@estimator/estimateBetaDist: too few inputs for estimation");
    endif
	
    # calculate mean and variance
    mu = sum(values, 2) ./ columns(values);
    var = sum((values - mu) .^ 2, 2)/(columns(values)-1);

    # put mu and var into rearranged formulas for mean and variance of
    # beta distribution
    dist = getBetaFromMuVar(mu, var);

endfunction