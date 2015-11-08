# usage: samples = getFittingSamplesSuperLXO(purchased, numOfSamples)

function [samples, pos, allSamples] = getFittingSamplesSuperLXO(purchased,
                                                        numOfSamples, allSamples)

	samples = [];
    pos = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!isscalar(purchased) || !isscalar(numOfSamples) || (!isvector(allSamples)
            && !isempty(allSamples)))
        error("sampleSelection/getFittingSamplesSuperLXO: requires scalar, \
scalar, vector");
    endif
    
    for j = 1:numOfSamples
        currSample = [];
        
        # keep track of the already selected and still available instances
        remSet = 1:purchased;
        selected = [];
        
        for k = 1:purchased-1
            # choose an instance from the remaining with equal prob.
            currIndex = randi(length(remSet));
            currSelected = remSet(currIndex);
            
            selected = [selected, currSelected];
            remSet(currIndex) = [];
            
            currSample = [currSample, sum(2 .^ (selected .- 1))];
        endfor
        
        samples = [samples; currSample];
    endfor
    
    pos = length(allSamples)+1:length(allSamples)+prod(size(samples));
    allSamples = [allSamples; vec(samples)];
    
endfunction