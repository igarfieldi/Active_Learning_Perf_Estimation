# usage: obj = dataReader()

function obj = dataReader()

    obj.featureVectors = [];
    obj.labels = [];
    obj = class(obj, "dataReader");

endfunction