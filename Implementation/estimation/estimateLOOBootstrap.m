# usage: accs = estimateLXOBootstrap(classifier, oracle, totalSamples)

function accs = estimateLOOBootstrap(classifier, oracle, totalSamples, prevAcc)

    accs = [];
    
    if((nargin == 3) || (nargin == 4))
        if(!isa(classifier, "classifier") || !isa(oracle, "oracle")
                || !isscalar(totalSamples))
            error("estimateLXOBootstrap: requires classifier, oracle, scalar");
        elseif((nargin == 4) && !iscell(prevAcc))
            error("estimateLXOBootstrap: requires classifier, oracle, scalar, cell");
        endif
    else
        print_usage();
    endif
    
    [feat, lab] = getQueriedInstances(oracle);
    
    # if we have the accuracies from last iteration, use them
    accs = cell(length(lab)-1, 1);
    if(nargin == 4)
        accs = prevAcc;
    endif
    
    # the new powerset... is the OLD powerset!
    # well not really, but if we have the old accs, the new instance sets are
    # the old ones + the newest instance
    pwr = powerset(1:length(lab))(2:end-1);
    if(nargin == 4)
        pwr = powerset(1:length(lab)-1)(2:end-1);
        pwr{end+1} = [];
    endif
    
    for i = 1:length(pwr)
        currSet = pwr{i};
        
        # add newest instance if we have old accs
        if(nargin == 4)
            currSet = [currSet, length(lab)];
        endif
        
        if(length(accs) < length(currSet))
            accs{length(currSet)} = [];
        endif
        
        tAcc = 0;
        
        # create the bootstrap samples
        bsSamples = discrete_rnd(currSet, ones(1, length(currSet)), totalSamples,
                            length(currSet));
        
        # perform leave-one-out bootstrapping
        for k = 1:length(currSet)
            for j = 1:totalSamples
                testIndices = setdiff(currSet(k), bsSamples(j, :));
                
                if(!isempty(testIndices))
                    classifier = setTrainingData(classifier, feat(bsSamples(j, :), :),
                                    lab(bsSamples(j, :)), getNumberOfLabels(oracle));
                    tAcc = computeAccuracy(classifier, feat(testIndices, :),
                                                lab(testIndices));
                    
                    accs{length(currSet)} = [accs{length(currSet)}, tAcc];
                endif
            endfor
        endfor
    endfor
    

endfunction