# usage: [PAL, oracle, aquFeat, aquLab] = selectInstance(PAL, pwc, oracle, dx)

function [PAL, oracle, aquFeat, aquLab] = selectInstance(PAL, pwc, oracle, dx)
    
    aquFeat = [];
    aquLab = [];
    
    if(nargin == 3)
        if(!isa(PAL, "probabilisticAL")
            || !isa(pwc, "parzenWindowClassifier") || !isa(oracle, "oracle"))
            error("@probabilisticAL/selectInstance(3): requires randomSamplingAL, \
\parzenWindowClassifier, oracle");
        endif
    elseif(nargin == 4)
        if(!isa(PAL, "probabilisticAL")
            || !isa(pwc, "parzenWindowClassifier") || !isa(oracle, "oracle")
            || !ismatrix(dx))
            error("@probabilisticAL/selectInstance(4): requires randomSamplingAL, \
parzenWindowClassifier, oracle, matrix");
        endif
    else
        print_usage();
    endif
    
	# only defined for 2-class problem?
	if(getNumberOfLabels(oracle) != 2)
		error("selectInstance@randomSamplingAL: only works for binary class problem");
	endif
    
    unlabeledSize = getNumOfUnlabeledInstances(oracle);
    
    # if unlabeled instances remain
    if(unlabeledSize > 0)
        # if no instances have been labeled yet, choose randomly
        if(size(getQueriedInstances(oracle), 1) < 1)
            nextLabelIndex = floor(rand(1) * unlabeledSize) + 1;
        else
            # get labeled instances and sort them using the classifier's setTrainingData
            [labFeat, labLab] = getQueriedInstances(oracle);
            pwc = setTrainingData(pwc, labFeat, labLab,
                                        getNumberOfLabels(oracle));
            [labFeat, ~, labLabInd] = getTrainingInstances(pwc);
            # get unlabeled instances
            [unlabFeat, unlabLab] = getUnlabeledInstances(oracle);
			
            # calculate label statistics
            nx = estimateKernelDensities(unlabFeat, labFeat, 0.1, false);
			
            py = [];
            old = 1;
            for i = 1:getNumberOfLabels(oracle)
                py = [py; estimateKernelDensities(unlabFeat,...
                            labFeat(old:labLabInd(i), :), 0.1, false)];
                old = labLabInd(i) + 1;
            endfor
            
            pmax = (max(py)+10^(-30)) ./ (nx+2*10^(-30));
            
            if(nargin < 4)
                dx = estimateKernelDensities(unlabFeat, [labFeat; unlabFeat], 0.1, false);
				dx ./ sum(dx);
            endif
			
			pgain = OPALgain(nx, pmax, 0.5, 1) .* dx;
            
			# find instances that maximize the pgain (if multiple maxima, select random)
            maxIndices = find(pgain == max(pgain));
            
            # In theory shouldn't happen, but just to make sure there's no bs going on
            if(length(maxIndices) < 1)
                nextLabelIndex = randi(unlabeledSize);
            else
                nextLabelIndex = maxIndices(randi(length(maxIndices)));
            endif
        endif
        
        # query the wanted instance
        [oracle, aquFeat, aquLab] = queryInstance(oracle, nextLabelIndex);
        
        # add it to the active learner
        PAL = addLabeledInstances(PAL, aquFeat, aquLab);
    endif
    
endfunction

# function to compute error (from PAL)

function ret = computeError(p, x)

    ret = [];
	
    if(nargin != 2)
        print_usage();
	endif
	
	if(isscalar(p) && isscalar(x))
		ret = 1 - p;
		if(x < 0.5)
			ret = p;
		endif
	elseif(isvector(p) && isscalar(x))
		ret = 1 .- p;
		if(x < 0.5)
			ret = p;
		endif
	elseif(isscalar(p) && isvector(x))
		ret = repmat(1 - p, 1, length(x));
		ret(x < 0.5) = p;
		r = ret;
	elseif(isvector(p) && isvector(x))
		ret = repmat(reshape((1 .- p), length(p), 1), 1, length(x));
		x = repmat(reshape(x, 1, length(x)), length(p), 1);
		indices = find(x < 0.5);
		ret(indices) = 1 .- ret(indices);
	else
		error("@probabilisticAL/computeError: requires either scalars or vectors");
	endif

endfunction