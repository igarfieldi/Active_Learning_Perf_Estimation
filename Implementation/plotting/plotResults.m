# usage: handles = plotResults(mus, vars, figures, used, colors, names)

function handles = plotResults(mus, vars, figures, used, colors, names)

    if(nargin != 6)
        print_usage();
    elseif(!isvector(figures) || !isvector(used) || !ismatrix(colors)
            || !iscell(names))
        error("plotting/plotResults: requires 3d_mat, 3d_mat, vector, vector, \
matrix, cell");
    endif
    
    # disregard methods not used in evaluation
    used = (1:length(used)) .* used;
    used(used == 0) = [];
    mus = mus(:, :, used);
    vars = vars(:, :, used);
	#colors = colors(used, :);
    names = names(used);
    
    # get the averages
    averMus = sum(mus, 1) ./ size(mus, 1);
    averVars = sum(vars, 1) ./ size(vars, 1);
    
    # compute difference, absolute error, squared error and variance
    averErrors = sum(mus .- mus(:, :, 1), 1) ./ size(mus, 1);
    averAbsErrors = sum(abs(mus .- mus(:, :, 1)), 1) ./ size(mus, 1);
    averSquErrors = sum((mus .- mus(:, :, 1)).^2, 1) ./ size(mus, 1);
    variance = var(mus);
	
	handles = [];
    
	if(figures(1) > 0)
		# plot accuracy averages
		handles(1) = figure(figures(1));
		clf;
		hold on;
		for i = 1:size(mus, 3)
			if(i == 1)
				plot(3:size(mus, 2), averMus(:, 3:end, i), "-", "color", colors(i, :), "linewidth", 4);
			else
				plot(3:size(mus, 2), averMus(:, 3:end, i), "-", "color", colors(i, :));
			endif
		endfor
		title("Accuracies");
		xlabel("Training instances");
		ylabel("Accuracies");
		legend(names, "location", "southeastoutside");
		axis([3, size(mus, 2), 0, 1]);
	endif
    
	if(figures(2) > 0)
		# plot error (simple difference)
		handles(2) = figure(figures(2));
		clf;
		hold on;
		for i = 2:size(averErrors, 3)
			plot(3:size(averErrors, 2), averErrors(:, 3:end, i), "-", "color", colors(i, :));
		endfor
		title("Differences to hold-out");
		xlabel("Training instances");
		ylabel("Differences");
		legend(names(1:end), "location", "southeastoutside");
		axis([3, size(averErrors, 2)]);
	endif
    
	if(figures(3) > 0)
		# plot squared error
		handles(3) = figure(figures(3));
		clf;
		hold on;
		for i = 2:size(averSquErrors, 3)
			plot(3:size(averSquErrors, 2), averSquErrors(:, 3:end, i),
				"-", "color", colors(i, :));
		endfor
		title("Squared error");
		xlabel("Training instances");
		ylabel("err²");
		legend(names(1:end), "location", "southeastoutside");
		axis([3, size(averSquErrors, 2)]);
	endif
    
	if(figures(4) > 0)
		# plot variance
		if(size(mus, 1) > 1)
			handles(4) = figure(figures(4));
			clf;
			hold on;
			for i = 1:size(variance, 3)
				plot(3:size(variance, 2), variance(:, 3:end, i),
					"-", "color", colors(i, :));
			endfor
			title("Variance");
			xlabel("Training instances");
			ylabel("Variance");
			legend(names(1:end), "location", "southeastoutside");
			axis([3, size(variance, 2)]);
		endif
	endif

endfunction
