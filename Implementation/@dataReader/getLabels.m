# usage: ret = getLabels(dataReader)

function lab = getLabels(dataReader)

    lab = [];
    
    if(nargin != 1)
        print_usage();
    elseif(!isa(dataReader, "dataReader"))
        error("@dataReader/getLabels: requires dataReader");
    endif
    
    lab = dataReader.labels;

endfunction