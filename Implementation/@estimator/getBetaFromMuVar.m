# usage: [p, q] = getBetaFromMuVar(mu, var)

function [p, q] = getBetaFromMuVar(mu, var)

    p = 0;
    q = 0;
    
    if(nargin != 2)
        print_usage();
    elseif(!isscalar(mu) || !isscalar(var))
        error("@estimator/getBetaFromMuVar: requires scalar, scalar");
    elseif(var == 0)
        error("@estimtor/getBetaFromMuVar: variance == 0");
    endif
    
    q = -(mu.^2.*var./((1-mu).^2)+var+2.*mu.*var./(1-mu)-mu./(1-mu));
    q = q./(var.*(mu.^3./((1-mu).^3)+1+3.*mu.^2./((1-mu).^2)+3*mu./(1-mu)));
    p = mu.*q./(1-mu);

endfunction