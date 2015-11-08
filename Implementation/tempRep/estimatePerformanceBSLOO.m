# usage: [mu, bsSamples] = estimatePerformanceBSLOO(classifier, oracle,
#                                                           totalSamples)

function [mu, bsSamples] = estimatePerformanceBSLOO(classifier, oracle,
                                                            totalSamples)

    mu = [];
    bsSamples = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle")
            || !isscalar(totalSamples))
        error("estimatePerformanceBootstrap: requires classifier, oracle, scalar");
    endif
    
    [feat, lab] = getQueriedInstances(oracle);
    
    # get the bootstrap samples
    bsSamples = randi(length(lab), totalSamples, length(lab));
    
    bsErr = 0;
    
    # train the classifier for all bootstrap samples and test against the
    # obtained instances
    for i = 1:totalSamples
        # exclude instances included in the bootstrap sample though
        testIndices = setdiff(1:length(lab), bsSamples(i, :));
        
        if(!isempty(testIndices))
            classifier = setTrainingData(classifier, feat(bsSamples(i, :), :),
                                lab(bsSamples(i, :)), getNumberOfLabels(oracle));
            
            bsErr += 1 - computeAccuracy(classifier, feat(testIndices, :), lab(testIndices));
        endif
    endfor
    
    bsErr /= totalSamples;
    
    mu = 1 - bsErr;

endfunction