# usage: samples = getFittingSamplesExp(purchased, numOfSamples)

function samples = getFittingSamplesExp(purchased, numOfSamples)

	samples = [];
    
    for j = 1:numOfSamples
        currSample = [];
        
        for k = 1:purchased-1
            currSample = [currSample, sum(2 .^ (randperm(purchased, k) .- 1))];
        endfor
        
        samples = [samples; currSample];
    endfor
    
endfunction