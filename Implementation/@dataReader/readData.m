function ret = readData(reader, path)
    ret = reader;
    
    data = load(path, "X", "Y");
    
    ret.featureVectors = data.X;
    ret.labels = data.Y';
endfunction