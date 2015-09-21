function obj = classifier(features, labels)

    obj.trainingFeatures = zeros(0,0);
    obj.trainingLabelInd = {};
    
    obj = class(obj, "classifier");
    
    if(nargin == 2)
        obj = setTrainingData(obj, features, labels);
    endif
    

endfunction