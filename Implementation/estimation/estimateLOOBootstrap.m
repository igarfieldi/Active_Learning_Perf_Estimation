# usage: accs = estimateLOOBootstrap(classifier, oracle, samples, bsSampleNum)

function accs = estimateLOOBootstrap(classifier, oracle, samples, bsSampleNum)

    accs = [];
    
    if(nargin != 4)
        print_usage();
    elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle")
            || (!isvector(samples) && !isempty(samples)) || !isscalar(bsSampleNum))
        error("estimation/estimateLOOBootstrap: requires classifier, oracle, \
vector, scalar");
    endif
    
    [feat, lab] = getQueriedInstances(oracle);
    
    elemVec = 1:length(lab);
    
    for i = 1:length(samples)
        bits = logical(bitget(samples(i), elemVec));
        currSet = elemVec(bits);
        
        # create the bootstrap samples
        bsSamples = discrete_rnd(currSet, ones(1, length(currSet)), bsSampleNum,
                            length(currSet));
        
        tErr = 0;
        tTotal = 0;
        
        # perform leave-one-out bootstrapping
        for k = 1:length(currSet)
            for j = 1:bsSampleNum
                testIndices = setdiff(currSet(k), bsSamples(j, :));
                
                if(!isempty(testIndices))
                    classifier = setTrainingData(classifier, feat(bsSamples(j, :), :),
                                    lab(bsSamples(j, :)), getNumberOfLabels(oracle));
                    tErr += 1 - computeAccuracy(classifier, feat(testIndices, :),
                                                lab(testIndices));
                    tTotal++;
                endif
            endfor
        endfor
        
        if(tTotal > 0)
            tErr /= tTotal;
            
            accs = [accs, 1 - tErr];
        endif
    endfor
    

endfunction