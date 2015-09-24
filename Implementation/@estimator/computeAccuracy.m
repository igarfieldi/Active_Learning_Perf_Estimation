function ret = computeAccuracy(classifier, testFeat, testLab)
    
    ret = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!isa(classifier, "classifier") || !ismatrix(testFeat) || !isvector(testLab))
        error("@estimator/computeAccuracy: requires classifier, matrix, vector");
    elseif(rows(testFeat) != length(testLab))
        error("@estimator/computeAccuracy: uneven number of feature vectors and labels");
    endif
    
    [classProb, label] = max(classifyInstances(classifier, testFeat));
    
    ret = sum((label' .- 1) == testLab) ./ length(testLab);
    
endfunction