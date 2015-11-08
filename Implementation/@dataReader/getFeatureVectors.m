# usage: feat = getFeatureVectors(dataReader)

function feat = getFeatureVectors(dataReader)

    if(nargin != 1)
        print_usage();
    elseif(!isa(dataReader, "dataReader"))
        error("@dataReader/getFeatureVectors: requires dataReader");
    endif
    
    feat = dataReader.featureVectors;

endfunction