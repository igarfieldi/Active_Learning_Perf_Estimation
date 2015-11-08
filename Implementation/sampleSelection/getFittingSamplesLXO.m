# usage: [samples, pos, allSamples] = getFittingSamplesLXO(purchased, numOfSamples,
#                                                           allSamples)

function [samples, pos, allSamples] = getFittingSamplesLXO(purchased, numOfSamples,
                                                            allSamples)

	samples = [];
    pos = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!isscalar(purchased) || !isscalar(numOfSamples) || (!isvector(allSamples)
            && !isempty(allSamples)))
        error("sampleSelection/getFittingSamplesLXO: requires scalar, scalar, vector");
    endif
    
    for j = 1:numOfSamples
        currSample = [];
        
        for k = 1:purchased-1
            currSample = [currSample, sum(2 .^ (randperm(purchased, k) .- 1))];
        endfor
        
        samples = [samples; currSample];
    endfor
    
    pos = length(allSamples)+1:length(allSamples)+prod(size(samples));
    allSamples = [allSamples; vec(samples)];
    
endfunction