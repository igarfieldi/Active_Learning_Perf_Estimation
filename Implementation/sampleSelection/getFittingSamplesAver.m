# usage: [samples, sizes, pos, allSamples] = getFittingSamplesAver(purchased,
#                                                       maxSamples, allSamples)

function [samples, sizes, pos, allSamples] = getFittingSamplesAver(purchased,
                                                        maxSamples, allSamples)

	samples = [];
    sizes = [];
    pos = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!isscalar(purchased) || !isscalar(maxSamples) || (!isvector(allSamples)
            && !isempty(allSamples)))
        error("sampleSelection/getFittingSamplesAver: requires scalar, scalar, vector");
    endif
    
    # how many samples will be produced
    totalSamples = min(2^purchased - 2, maxSamples);
    if(totalSamples < 0)
        totalSamples = 2^purchased - 2;
    endif
    
    for i = 1:purchased-1
        # compute the amount of samples for the current iteration
        # (num. of training instances)
        sizes = [sizes, ceil(totalSamples * nchoosek(purchased, i) / (2^purchased - 2))];
        
        # get the samples as decimals of the binary set representation
        # (1 = in training set, 0 = in test set)
        for j = 1:sizes(end)
            samples = [samples; sum(2 .^ (randperm(purchased, i) .- 1))];
        endfor
    endfor
    
    pos = length(allSamples)+1:length(allSamples)+prod(size(samples));
    allSamples = [allSamples; samples];

endfunction