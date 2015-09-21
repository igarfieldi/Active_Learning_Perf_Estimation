function ret = addInstance(classifier, feature, label)
    
    ret = classifier;
    
    if(nargin != 3)
        print_usage();
    else
        if((label+1) > length(ret.trainingLabelInd))
            ret.trainingLabelInd = [ret.trainingLabelInd, repmat(ret.trainingLabelInd(end),
                                    1, label - length(ret.trainingLabelInd) + 1)];
        endif
        
        
        ret.trainingFeatures = [ret.trainingFeatures(1:ret.trainingLabelInd(label+1), :);
                                feature;
                                ret.trainingFeatures((ret.trainingLabelInd(label+1)+1):end, :)];
        ret.trainingLabelInd(label+1:end)++;
    endif

endfunction