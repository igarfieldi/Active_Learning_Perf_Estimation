# usage: plotRegressedFunctions(regFuncs, funcHandle, fig, color, holdOn)

function plotRegressedFunctions(regFuncs, funcHandle, funcParamNum, resolution, fig, color, holdOn)

	holding = 0;
	
	if(nargin == 7)
		if(!iscell(regFuncs) || !is_function_handle(funcHandle) || !isscalar(funcParamNum)
			|| !isscalar(resolution) || !isscalar(fig) || !isvector(color) || !isscalar(holdOn))
			error("plotting/plotRegressedFunctions(5): requires cell, function handle, scalar, scalar, scalar, vector, scalar");
		endif
		if(holdOn != 0)
			holding = 1;
		endif
	elseif(nargin == 6)
		if(!iscell(regFuncs) || !is_function_handle(funcHandle) || !isscalar(funcParamNum)
			|| !isscalar(resolution) || !isscalar(fig) || !isvector(color))
			error("plotting/plotRegressedFunctions(4): requires cell, function handle, scalar, scalar, scalar, vector");
		endif
	else
		print_usage();
	endif
	
    dims = [ceil(sqrt(length(regFuncs)+1)), ceil((length(regFuncs)+1) / ceil(sqrt(length(regFuncs)+1)))];
	figure(fig);
	
	for i = 1:length(regFuncs)
		# create subplots
		subplot(dims(1), dims(2), i+1);
		if(holding != 0)
			hold on;
		else
			hold off;
		endif
		
		X = linspace(1, i+1, resolution);
		
		for j = 1:size(regFuncs{i}, 1)
			plot(X, funcHandle(X, regFuncs{i}(j, 1:funcParamNum)), "-", "color", color);
		endfor
		
		axis([0, i+2, 0, 1]);
		xlabel("Training instances");
		ylabel("Estimated accuracy");
		title(sprintf("Iteration: %d", i));
	endfor

endfunction