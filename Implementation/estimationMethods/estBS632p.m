# usage: [mu, bsSamples] = estBS632p(classifier, oracle, totalSamples)

function [mu, bsSamples] = estBS632p(classifier, oracle, totalSamples)

    mu = [];
    bsSamples = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle")
            || !isscalar(totalSamples))
        error("estimationMethods/estBS632p: requires classifier, oracle, scalar");
    endif
    
    [feat, lab] = getQueriedInstances(oracle);
    
    # get the bootstrap samples
    bsSamples = randi(length(lab), totalSamples, length(lab));
    
    bsErr = 0;
    bsTotal = 0;
    gammaHat = 0;
    
    # train the classifier for all bootstrap samples and test against the
    # obtained instances
    for i = 1:totalSamples
        # exclude instances included in the bootstrap sample though
        testIndices = setdiff(1:length(lab), bsSamples(i, :));
        
        if(!isempty(testIndices))
            classifier = setTrainingData(classifier, feat(bsSamples(i, :), :),
                                lab(bsSamples(i, :)), getNumberOfLabels(oracle));
            
            # compute the first correction factor (no-information rate)
            # count the proportions of unequal labels (see the paper for better
            # description)
            [~, predictions] = max(classifyInstances(classifier, feat(testIndices, :)));
            
            frequTrain = histc(lab(testIndices), unique(lab(testIndices)));
            frequPred = histc(predictions, unique(predictions));
            # make sure that we have one column vector
            if(rows(frequTrain) == 1)
                frequTrain = frequTrain';
            endif
            
            gammaHat = (sum(sum(frequTrain * frequPred)) .- sum(frequTrain' .* frequPred))...
                        / (length(testIndices) ^ 2);
            
            bsErr += sum((predictions' .- 1) != lab(testIndices)) ./ length(testIndices);
            bsTotal++;
        endif
    endfor
    
    bsErr /= bsTotal;
    
    # compute the "training error" ie. test against the training set itself
    classifier = setTrainingData(classifier, feat, lab, getNumberOfLabels(oracle));
    trainingErr = 1 - computeAccuracy(classifier, feat, lab);
    
    # compute the second, derived factor (relative overfitting)
    R = 0;
    if((bsErr > trainingErr) && (gammaHat > trainingErr))
        R = (bsErr - trainingErr) / (gammaHat - trainingErr);
    endif
    
    # .632+ rule
    mu = 1- ((1/e * trainingErr + (1-1/e) * bsErr)...
            + (min(bsErr, gammaHat) - trainingErr) * 1/e*(1-1/e)*R / (1 - 1/e*R));

endfunction