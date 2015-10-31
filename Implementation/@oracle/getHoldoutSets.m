# usage: [feat, lab] = getHoldoutSets(oracle, size, limit, state)

function [feat, lab] = getHoldoutSets(oracle, size, limit, state)

    feat = [];
    lab = [];
    
    if((nargin == 3) || (nargin == 4))
        if(!isa(oracle, "oracle") || !isscalar(size) || !isscalar(limit))
            error("@oracle/getHoldoutSets: requires oracle, scalar, scalar");
        elseif((nargin == 4) && !isvector(state))
            error("getHoldoutSets: state has to be a vector");
        endif
    else
        print_usage();
    endif
    
    # if wanted, set RNG to given state
    if(nargin == 4)
        rand("state", state);
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