function obj = parzenWindowClassifier(features, labels, sigma)

    obj.sigma = [0.1];
    obj.classifier = [];
    clas = @classifier();
    
    obj = class(obj, "parzenWindowClassifier", clas);
    
    if(nargin >= 2)
        obj = setTrainingData(obj, features, labels);
    endif
    if(nargin == 3)
        obj.sigma = sigma;
    endif

endfunction