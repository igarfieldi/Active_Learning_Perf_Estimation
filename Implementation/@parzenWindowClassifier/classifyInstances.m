# usage: ret = classifyInstances(pwc, instances)

function ret = classifyInstances(pwc, instances)

    ret = [];
    
    if(nargin != 2)
        print_usage();
    elseif(!isa(pwc, "parzenWindowClassifier") || !ismatrix(instances))
        error("@parzenWindowClassifier/classifyInstances: requires \
parzenWindowClassifier, matrix");
    elseif(sum(size(instances)) < 2)
        error("@parzenWindowClassifier/classifyInstances: instance dimensions \
must be at least 1x1");
    endif
    
    [features, ~, labelInd] = getTrainingInstances(pwc);
    
    densities = zeros(length(labelInd), size(instances, 1));
    priorEstimates = zeros(length(labelInd), 1);
    
    old = 1;
    # for each class label
    for i = 1:length(labelInd)
        priorEstimates(i) = (labelInd(i) - old + 1) / size(features, 1);
        
        # check if training instances for the class are present
        if(labelInd(i) - old >= 0)
            # use kernel density estimation (Parzen-Window)
            densities(i, :) = estimateKernelDensities(instances,
                                features(old:labelInd(i), :), getSigma(pwc));
        endif
        
        old = labelInd(i)+1;
    endfor
    
    # use density estimation and estimated prior probabilities to estimate posteriors
    ret = (priorEstimates .* densities) ./ sum(priorEstimates .* densities, 1);
    
endfunction