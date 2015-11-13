# usage: dataReader = readData(dataReader, path)

function dataReader = readData(dataReader, path)

    if(nargin != 2)
        print_usage();
    elseif(!isa(dataReader, "dataReader") || !ischar(path))
        error("@dataReader/readData: requires dataReader, char");
    endif
    
    data = load(path, "X", "Y");
    
    dataReader.featureVectors = data.X;
    dataReader.labels = data.Y;

endfunction