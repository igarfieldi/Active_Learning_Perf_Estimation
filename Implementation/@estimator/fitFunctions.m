# usage: 

function funcReg = fitFunctions(accEstimates, funcHandle)

	funcReg = [];
	
	if(nargin != 2)
		print_usage();
	elseif(!iscell(accEstimates) || !is_function_handle(funcHandle))
		error("@estimator/fitFunctions: requires cell, funcHandle");
	endif
	
	# check if accumulated accuracies have been used
	accum = 0;
	if(size(accEstimates{1}{1}, 1) == 2)
		accum = 1;
	endif
	
	funcReg = cell(0, 0);
    
    kernel = @(x, p) p(1) .+ p(2) .* exp(x .* p(3));
    fig = 1;
	
	for i = 2:length(accEstimates)
		itSize = zeros(1, i-1);
		
		for j = 1:length(accEstimates{i})
			itSize(j) = size(accEstimates{i}{j}, 2);
		endfor
        
        funcReg = [funcReg, []];
		
		# create indices for all combinations
		indices = [];
		for j = 1:length(itSize)
			vec = (1:itSize(length(itSize)-j+1));
			S = repmat(repelems(vec',
					[vec; prod(itSize((length(itSize)-j+2):end)) .* ones(1, itSize(length(itSize)-j+1))])',
					prod(itSize((1:(length(itSize)-j)))), 1);
			indices = [S, indices];
		endfor
        
		# iterate over all indices and fit a curve for each set of accuracies
		for j = 1:size(indices, 1)
			samps = [];
			
			for k = 1:length(itSize)
				samps = [samps, accEstimates{i}{k}(:, indices(j, k))];
			endfor
            
			params = funcHandle((1:length(itSize)), samps(1, :));
			if(accum)
				params = [params; prod(samps(2, :))];
			endif
			
			funcReg{end} = [funcReg{end}; params'];
            
            figure(fig);
            hold on;
            
            X = linspace(1, length(accEstimates{i}{k}(:, indices(j, k))), 1000);
            plot((1:length(samps)), samps(1, :), "+", "color", [1, 0, 0]);
            plot(X, kernel(X, params'), "-", "color", [1, 0, 0]);
            
            axis([0, size(samps, 2) + 1, 0, 1]);
            
            fig++;
		endfor
		
	endfor

endfunction