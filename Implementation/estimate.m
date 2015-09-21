function estimate(activeLearner)
    
    instances = length(getUnlabeledLabels(activeLearner));
    
    #clf;
    #hold on;
    
    combinations = zeros(instances, instances+1);
    
    for i = 1:instances
        [activeLearner,feat,lab] = selectInstance(activeLearner);
        
        if(i < 2)
            continue;
        endif
        labFeat = getLabeledFeatures(activeLearner);
        labLab = getLabeledLabels(activeLearner);
        
        combinations(i, 1:i-1) = factorial(i .* ones(1, i-1)) ./ (factorial([1:i-1])
            .* factorial(i .* ones(1, i-1) .- [1:i-1]));
    endfor
    
    o = combinations
    
endfunction