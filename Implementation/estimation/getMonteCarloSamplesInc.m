# usage: samples = getMonteCarloSamplesInc(accumAccs, numOfSamples)
#
# Returns the desired number of Monte-Carlo samples for fitting.
# Only uses sample points with accuracies higher or equal to the
# previous highest sample point (if available).

function samples = getMonteCarloSamplesInc(accumAccs, numOfSamples)

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
        
        lastAcc = 0;
        found = false;
        
        for k = 1:length(currSize)
            # randomly choose samples according to frequency
            # but only of those that are larger than the last accuracy
            largerIndices = find(accumAccs{k}(1, :) >= lastAcc);
            if(isempty(largerIndices))
                largerIndices = 1:size(accumAccs{k}, 2);
            endif
            currIndex = discrete_rnd(largerIndices, accumAccs{k}(2, largerIndices), 1);
            currSample = [currSample, accumAccs{k}(1, currIndex)];
            
            # if no larger accuracy for the current training set size exist,
            # do not raise the last accuracy
            if(accumAccs{k}(1, currIndex) > lastAcc)
                lastAcc = accumAccs{k}(1, currIndex);
            endif
        endfor
        
        samples = [samples; currSample];
    endfor

endfunction