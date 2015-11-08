# usage: [samples, sizes, pos, allSamples] = getFittingSamples632(purchased,
#                                                       maxSamples, allSamples)

function [samples, sizes, pos, allSamples] = getFittingSamples632(purchased,
                                                        maxSamples, allSamples)

	samples = [];
    sizes = [];
    pos = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!isscalar(purchased) || !isscalar(maxSamples) || (!isvector(allSamples)
            && !isempty(allSamples)))
        error("sampleSelection/getFittingSamples632: requires scalar, scalar, vector");
    endif
    
    # how many samples will be produced
    totalSamples = min(2^purchased - 2 - purchased, maxSamples);
    if(totalSamples < 0)
        totalSamples = 2^purchased - 2 - purchased;
    endif
    
    for i = 2:purchased-1
        # compute the amount of samples for the current iteration
        # (num. of training instances)
        sizes = [sizes, ceil(totalSamples * nchoosek(purchased, i) /...
                                (2^purchased - 2 - purchased))];
        
        # get the samples as decimals of the binary set representation
        # (1 = in training set, 0 = in test set)
        for j = 1:sizes(end)
            samples = [samples; sum(2 .^ (randperm(purchased, i) .- 1))];
        endfor
    endfor
    
    pos = length(allSamples)+1:length(allSamples)+prod(size(samples));
    allSamples = [allSamples; vec(samples)];

endfunction