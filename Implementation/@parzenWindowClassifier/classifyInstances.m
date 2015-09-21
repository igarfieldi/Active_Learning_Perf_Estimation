function ret = classifyInstances(pwClassifier, instances)

    labelInd = getTrainingLabelIndices(getClassifier(pwClassifier));
    features = getTrainingFeatures(getClassifier(pwClassifier));
    
    densities = zeros(length(labelInd), size(instances, 1));
    priorEstimates = zeros(length(labelInd), 1);
    
    old = 1;
    
    # for each class label
    for i = 1:length(labelInd)
        priorEstimates(i) = (labelInd(i) - old + 1) / size(features, 1);
        
        # create big matrices repeating each instance and feature vector to match everyone with everyone
        bigMat = repmat(features(old:labelInd(i), :), [rows(instances), 1]);
        matReshape = reshape(repmat(instances', [rows(bigMat)/rows(instances), 1]),
                             columns(bigMat), rows(bigMat))';
        
        if(size(matReshape) > 0)
            # use kernel density estimation (Üarzen-Window)
            tempProb = -(sum((matReshape - bigMat) .^ 2, 2) .* (labelInd(i) - old + 1)) ./ (2 * pwClassifier.sigma^2);
            tempProb = sqrt((labelInd(i) - old + 1)) .* exp(tempProb) ./ (sqrt(2*pi) * pwClassifier.sigma);
            tempProb = reshape(tempProb, (labelInd(i) - old + 1), size(instances, 1));
            densities(i, :) = sum(tempProb, 1) ./ (labelInd(i) - old + 1);
        endif
        
        old = labelInd(i)+1;
    endfor
    
    # use density estimation and estimated prior probabilities to estimate posteriors
    ret = (priorEstimates .* densities) ./ sum(priorEstimates .* densities, 1);
    
endfunction