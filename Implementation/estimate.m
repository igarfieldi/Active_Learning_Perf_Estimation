function estimate(activeLearner, classifier, labelNum, cutoff)
    
    instances = length(getUnlabeledLabels(activeLearner));
    
    limit = 12;
    
    accuracies = cell(limit, 1);
    
    cutoffSize = ceil(cutoff * instances);
    
    plotData = [];
    plotAver = [];
    
    for i = 1:min(limit, instances)
        disp(i);
        
        accuracies{i} = {};
        
        [activeLearner,feat,lab] = selectInstance(activeLearner, classifier, labelNum);
        
        if(i < 2)
            continue;
        endif
        
        # get the already labeled instances
        labFeat = getLabeledFeatures(activeLearner);
        labLab = getLabeledLabels(activeLearner);
        
        # compute all possible two-set splits of the labeled instances
        #[combFeat, combLab] = splitSet(labFeat, labLab);
        
        averNum = 0;
        averDenom = 0;
        
        # compute the powerset of the instance indices
        pwr = powerset([1:i])(2:end-1);
        revPwr = fliplr(pwr);
        
        # shuffle indices for random cutoff
        shfl = randperm(size(pwr, 2));
        pwr = pwr(shfl);
        revPwr = revPwr(shfl);
        
        sizePwr = size(pwr, 2);
        
        for tr = 1:sizePwr
            # train a classifier on the indexed instances...
            classifier = setTrainingData(classifier, labFeat(pwr{tr}, :), labLab(pwr{tr}), 2);
            
            # ...and compute the accuracy with the other ones
            # (due to "symmetry" of the power set computation we can use the indices
            # read from the other direction. Also cut off if there are enough to test)
            acc = computeAccuracy(classifier, labFeat(revPwr{tr}(1:min(end, cutoffSize)), :), labLab(revPwr{tr}(1:min(end, cutoffSize))));
            
            # compute data to store or draw
            accuracies{i} = [accuracies{i}; acc];
            averNum += sum(acc);
            averDenom += length(acc);
            
            plotData = [plotData, [i .* ones(length(acc), 1); acc]];
        endfor
        
        plotAver = [plotAver, [i; averNum / averDenom]];
    endfor
    
    figure(1);
    clf;
    hold on;
    
    plot(plotData(1, :), plotData(2, :), "+", "color", [0, 0, 0.5]);
    plot(plotAver(1, :), plotAver(2, :), "*-", "color", [1, 0, 0]);
    
    
endfunction