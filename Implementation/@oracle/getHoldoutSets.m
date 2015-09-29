# usage: [feat, lab] = getHoldoutSets(oracle, size)

function [feat, lab] = getHoldoutSets(oracle, size, limit)

    feat = [];
    lab = [];
    
    if(nargin != 3)
        print_usage();
    elseif(!isa(oracle, "oracle") || !isscalar(size) || !isscalar(limit))
        error("@oracle/getHoldoutSets: requires oracle, scalar, scalar");
    endif
    
    remInst = length(oracle.labels);
    
    size = min(size, remInst);
    
    if(size > 0)
        setNumber = ceil(remInst / size);
        
        if(limit < 0)
            limit = setNumber;
        endif
        limit = min(limit, setNumber);
        
        feat = cell(1, setNumber);
        feat = cell(1, setNumber);
        
        randomizer = randperm(length(oracle.labels));
        
        oracFeat = oracle.features(randomizer, :);
        oracLab = oracle.labels(randomizer);
        
        for i = 1:min(setNumber, limit)
            feat{i} = oracFeat(((i-1)*size+1):min(i*size, end), :);
            lab{i} = oracLab(((i-1)*size+1):min(i*size, end));
        endfor
    endif

endfunction