# usage: samples = getMonteCarloSamples(accumAccs, numOfSamples)

function samples = getMonteCarloSamples(accumAccs, numOfSamples)

	global debug;
	
	samples = [];
	
	if(nargin != 2)
		print_usage();
	elseif(!iscell(accumAccs) || (!isscalar(numOfSamples) && (!isvector(numOfSamples)
			|| (length(numOfSamples) < length(accumAccs))) && !is_function_handle(numOfSamples)))
		error("estimation/getMonteCarloSamples: requires cell, scalar/vector with enough fields/function handle");
	endif
	
	samples = cell(length(accumAccs), 1);
	
	for i = 1:length(accumAccs)
		if(debug)
			disp(sprintf("Monte-Carlo iteration: %d", i+2));
		endif
		
		currSize = [];
		
		for j = 1:length(accumAccs{i})
			currSize = [currSize, size(accumAccs{i}{j}, 2)];
		endfor
		
		if(!isscalar(numOfSamples))
			currNumOfSamples = numOfSamples(i);
		else
			if(is_function_handle(numOfSamples))
				currNumOfSamples = numOfSamples(i);
			else
				currNumOfSamples = numOfSamples;
			endif
		endif
		
		samples{i} = [];
		
		for j = 1:currNumOfSamples
			currSample = [];
			
			for k = 1:length(currSize)
				# randomly choose samples according to frequency
				currIndex = discrete_rnd((1:currSize(k)), accumAccs{i}{k}(2, :), 1);
				currSample = [currSample, accumAccs{i}{k}(1, currIndex)];
			endfor
			
			samples{i} = [samples{i}; currSample];
		endfor
	endfor

endfunction