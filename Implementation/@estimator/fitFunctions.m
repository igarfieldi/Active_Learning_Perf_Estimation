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
	
	for i = 1:length(accEstimates)
		itSize = zeros(1, i-1);
		
		for j = 1:i-1
			itSize(j) = size(accEstimates{i}{j}, 2);
		endfor
		
		if(length(itSize) != 0)
			funcReg = [funcReg, []];
		endif
		
		# create indices for all combinations
		indices = [];
		for j = 1:i-1
			vec = (1:itSize(i-j));
			S = repmat(repelems(vec',
					[vec; prod(itSize((i-j+1):end)) .* ones(1, itSize(i-j))])',
					prod(itSize((1:(i-j-1)))), 1);
			indices = [S, indices];
		endfor
		
		# iterate over all indices and fit a curve for each set of accuracies
		for j = 1:size(indices, 1)
			samps = [];
			
			for k = 1:i-1
				samps = [samps, accEstimates{i}{k}(:, indices(j, k))];
			endfor
			
			params = funcHandle((1:i-1), samps(1, :));
			if(accum)
				params = [params; prod(samps(2, :))];
			endif
			
			funcReg{end} = [funcReg{end}; params'];
		endfor
		
	endfor

endfunction