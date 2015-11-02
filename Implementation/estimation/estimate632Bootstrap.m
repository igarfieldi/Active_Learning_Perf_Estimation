# usage: accs = estimate632Bootstrap(classifier, oracle, totalSamples)

function accs = estimate632Bootstrap(classifier, oracle, totalSamples, subset)

    accs = [];
    
    if((nargin == 3) || (nargin == 4))
        if(!isa(classifier, "classifier") || !isa(oracle, "oracle")
            || !isscalar(totalSamples))
            error("estimate632Bootstrap: requires classifier, oracle, scalar");
        elseif((nargin == 4) && !isvector(subset))
            error("estimate632Bootstrap: requires classifier, oracle, scalar, vector");
        endif
    else
        print_usage();
    endif
    
    [feat, lab] = getQueriedInstances(oracle);
    
    # if we have the accuracies from last iteration, use them
    accs = cell(length(lab)-1, 1);
    
    pwr = powerset(1:length(lab))(2:end-1);
    if(nargin == 4)
        pwr = pwr(subset);
    endif
    
    for i = 1:length(pwr)
        currSet = pwr{i};
        
        tAcc = 0;
        
        # create the bootstrap samples
        bsSamples = discrete_rnd(currSet, ones(1, length(currSet)), totalSamples,
                            length(currSet));
        
        tErr = 0;
        tTotal = 0;
        
        # perform leave-one-out bootstrapping
        for k = 1:length(currSet)
            for j = 1:totalSamples
                testIndices = setdiff(currSet(k), bsSamples(j, :));
                
                if(!isempty(testIndices))
                    classifier = setTrainingData(classifier, feat(bsSamples(j, :), :),
                                    lab(bsSamples(j, :)), getNumberOfLabels(oracle));
                    tErr += 1-computeAccuracy(classifier, feat(testIndices, :),
                                                lab(testIndices));
                    tTotal++;
                endif
            endfor
        endfor
        
        if(tTotal > 0)
            tErr /= tTotal;
            
            # get the training error
            classifier = setTrainingData(classifier, feat(currSet, :), lab(currSet),
                                        getNumberOfLabels(oracle));
            trainingErr = 1 - computeAccuracy(classifier, feat(currSet, :), lab(currSet));
            
            accs{length(currSet)} = [accs{length(currSet)},...
                                        1-((1-1/e) * tErr + 1/e * trainingErr)];
        endif
    endfor
    

endfunction