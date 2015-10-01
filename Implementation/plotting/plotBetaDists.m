# usage: 

function plotBetaDists(betaDists, resolution, fig, color, holdOn)
    
    holding = 0;
    
    if(nargin == 5)
        if(!ismatrix(betaDists) || !isscalar(resolution) || !isscalar(fig)
            || !isvector(color)|| !isscalar(holdOn))
            error("plotting/plotNBetaDists(5): requires matrix, scalar, scalar, vector, scalar");
        elseif(size(betaDists, 2) != 2)
            error("plotting/plotNBetaDists(5): matrix dimensions must be Nx2");
        elseif(length(color) != 3)
            error("plotting/plotNBetaDists(5): vector lengthhas must be 3");
        endif
        if(holdOn == 1)
            holding = 1;
        endif
    elseif(nargin == 3)
        if(!ismatrix(betaDists) || !isscalar(resolution) || !isscalar(fig)
            || !isvector(color))
            error("plotting/plotNBetaDists(4): requires matrix, scalar, scalar, vector");
        elseif(size(betaDists, 2) != 2)
            error("plotting/plotNBetaDists(4): matrix dimensions has to be Nx2");
        elseif(length(color) != 3)
            error("plotting/plotNBetaDists(4): vector lengthhas must be 3");
        endif
    else
        print_usage();
    endif
    
    dists = size(betaDists, 1);
    dims = [ceil(sqrt(dists)), ceil(dists / ceil(sqrt(dists)))];
    X = linspace(0, 1, resolution);
    
    figure(fig);
    
    for i = 1:dists
        subplot(dims(1), dims(2), i);
        if(holding == 1)
            hold on;
        else
            hold off;
        endif
        
        plot(X, betapdf(X, betaDists(i, 1), betaDists(i, 2)), "-", "color", color);
		
        xlabel("Accuracy");
        ylabel("pdf value");
        title(sprintf("Distribution %d", i));
		legend("hide");
    endfor
    
endfunction