function ret = setTrainingData(classifier, features, labels)
    
    ret = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!isa(classifier, "classifier") || !ismatrix(features) || !isvector(labels))
        error("setTrainingData: requires classifier, matrix, vector");
    else
        ret = classifier;
        
        ret.trainingFeatures = zeros(0, 0);
        ret.trainingLabelInd = [0];
        
        for i=1:length(labels)
            if((labels(i)+1) > length(ret.trainingLabelInd))
                ret.trainingLabelInd = [ret.trainingLabelInd, repmat(ret.trainingLabelInd(end),
                                        1, labels(i) - length(ret.trainingLabelInd) + 1)];
            endif
            
            ret.trainingFeatures = [ret.trainingFeatures(1:ret.trainingLabelInd(labels(i)+1), :);
                                    features(i, :);
                                    ret.trainingFeatures((ret.trainingLabelInd(labels(i)+1)+1):end, :)];
            ret.trainingLabelInd(labels(i)+1:end)++;
        endfor
    end

endfunction