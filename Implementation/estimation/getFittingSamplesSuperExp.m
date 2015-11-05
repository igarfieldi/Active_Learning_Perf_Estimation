# usage: samples = getFittingSamplesSuperExp(purchased, numOfSamples)

function samples = getFittingSamplesSuperExp(purchased, numOfSamples)

	samples = [];
    
    for j = 1:numOfSamples
        currSample = [];
        
        # keep track of the already selected and still available instances
        remSet = 1:purchased;
        selected = [];
        
        for k = 1:purchased-1
            # choose an instance from the remaining with equal prob.
            currSelected = discrete_rnd(remSet, ones(1, length(remSet)), 1, 1);
            
            selected = [selected, currSelected];
            remSet = setdiff(remSet, currSelected);
            
            currSample = [currSample, sum(2 .^ (selected .- 1))];
        endfor
        
        samples = [samples; currSample];
    endfor
    
endfunction