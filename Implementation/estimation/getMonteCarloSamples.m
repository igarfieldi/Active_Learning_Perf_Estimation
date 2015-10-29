# usage: samples = getMonteCarloSamples(accumAccs, numOfSamples)

function samples = getMonteCarloSamples(accumAccs, numOfSamples)

	samples = [];
	
	if(nargin != 2)
		print_usage();
	elseif(!iscell(accumAccs) || !isscalar(numOfSamples))
		error("perfEstimation/getMonteCarloSamplesIter: requires cell, scalar");
	endif
		
    currSize = [];
    
    for j = 1:length(accumAccs)
        currSize = [currSize, size(accumAccs{j}, 2)];
    endfor
    
    for j = 1:numOfSamples
        currSample = [];
        
        for k = 1:length(currSize)
            # randomly choose samples according to frequency
            currIndex = discrete_rnd((1:currSize(k)), accumAccs{k}(2, :), 1);
            currSample = [currSample, accumAccs{k}(1, currIndex)];
        endfor
        
        samples = [samples; currSample];
    endfor

endfunction