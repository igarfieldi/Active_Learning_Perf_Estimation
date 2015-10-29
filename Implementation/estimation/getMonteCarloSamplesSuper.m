# usage: samples = getMonteCarloSamplesSuper(accs, wis, combs, numOfSamples)
#
# Returns the desired number of Monte-Carlo samples for fitting.
# Training sets for higher iterations have to contain the instances of
# previous iterations.

function samples = getMonteCarloSamplesSuper(accs, wis, combs, numOfSamples)

	samples = [];
	
	if(nargin != 4)
		print_usage();
	elseif(!iscell(accs) || !iscell(wis) || !iscell(combs) || !isscalar(numOfSamples))
		error("perfEstimation/getMonteCarloSamplesIter: requires cell, cell, cell, scalar");
	endif
    
    currSize = [];
    
    for j = 1:length(accs)
        currSize = [currSize, size(accs{j}, 2)];
    endfor
    
    for j = 1:numOfSamples
        currSample = [];
        
        indices = [];
        for k = 1:length(currSize)
            # identify the choosable accuracy estimation indices
            choosable = 1:currSize(k);
            for i = 1:length(indices)
                choosable = intersect(choosable, wis{k}(indices(i), :));
            endfor
            
            # randomly choose from available samples
            currIndex = discrete_rnd(choosable, ones(1, length(choosable)), 1);
            # add the new instance's index to the index set
            indices = [indices, setdiff(combs{k}(currIndex, :), indices)];
            currSample = [currSample, accs{k}(currIndex)];
        endfor
        
        samples = [samples; currSample];
    endfor

endfunction