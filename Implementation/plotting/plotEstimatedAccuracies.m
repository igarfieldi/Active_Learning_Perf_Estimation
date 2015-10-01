# usage: plotEstimatedAccuracies(accs, fig, color, holdOn)

function plotEstimatedAccuracies(accs, fig, color, holdOn)

	holding = 0;
	
	if(nargin == 4)
		if(!iscell(accs) || !isscalar(fig) || !isvector(color) || !isscalar(holdOn))
			error("plotting/plotEstimatedAccuracies(4): requires cell, scalar, vector, scalar");
		endif
		if(holdOn != 0)
			holding = 1;
		endif
	elseif(nargin == 3)
		if(!iscell(accs) || !isscalar(fig) || !isvector(color))
			error("plotting/plotEstimatedAccuracies(3): requires cell, scalar, vector");
		endif
	else
		print_usage();
	endif
	
	figure(fig);
	
    dims = [ceil(sqrt(length(accs))), ceil(length(accs) / ceil(sqrt(length(accs))))];
	
	for i = 1:length(accs)
		# create subplots
		subplot(dims(1), dims(2), i);
		if(holding != 0)
			hold on;
		else
			hold off;
		endif
		
		# iterate through the accuracies
		currIterAccs = accs{i};
		
		for j = 1:length(currIterAccs)
			plot(j .* ones(1, length(currIterAccs{j}(1, :))), currIterAccs{j}(1, :), "+", "color", color);
		endfor
		
		axis([0, i+1, 0, 1]);
		xlabel("Training instances");
		ylabel("Estimated accuracy");
		title(sprintf("Iteration: %d", i));
	endfor

endfunction