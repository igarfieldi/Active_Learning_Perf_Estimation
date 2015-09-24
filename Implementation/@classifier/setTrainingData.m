# usage: ret = setTrainingData(classifier, features, labels, labelNum)

function ret = setTrainingData(classifier, features, labels, labelNum)
    
    ret = [];
    
    if(nargin != 4)
        print_usage();
    elseif(!isa(classifier, "classifier") || !ismatrix(features) || !isvector(labels) || !isscalar(labelNum))
        error("setTrainingData: requires classifier, matrix, vector, number");
    endif
    
    ret = classifier;
    
    ret.trainingFeatures = zeros(0, 0);
    ret.trainingLabelInd = zeros(labelNum, 1);
    ret.labelNum = labelNum;
    
    for i=1:length(labels)
        if((labels(i)+1) > length(ret.trainingLabelInd))
            error("@classifier/setTrainingData: encountered label larger than labelNum");
        endif
        
        ret.trainingFeatures = [ret.trainingFeatures(1:ret.trainingLabelInd(labels(i)+1), :);
                                features(i, :);
                                ret.trainingFeatures((ret.trainingLabelInd(labels(i)+1)+1):end, :)];
        ret.trainingLabelInd(labels(i)+1:end)++;
    endfor

endfunction