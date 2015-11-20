# usage: funcReg = fitFunctions(iterations, accSamples, functionParams,
#                                   sampleWeights, maxTrials)

function funcReg = fitFunctions(iterations, accSamples, functionParams,
                                    sampleWeights, maxTrials)

	funcReg = [];
	
    if((nargin < 3) || (nargin > 5))
        print_usage();
    elseif(!isvector(iterations))
        error("functionFitting/fitFunctions: X component for fitting (iterations) \
needs to be of vector form");
    elseif(!ismatrix(accSamples))
        error("functionFitting/fitFunctions: accuracy samples have to be provided \
as matrix");
    elseif(length(iterations) != size(accSamples, 2))
        error("functionFitting/fitFunctions: length of iterations and number of \
accuracy samples have to coincide");
    elseif(!isstruct(functionParams))
        error("functionFitting/fitFunctions: function parameters have to provided \
as struct");
    endif
    
    iterations = vec(iterations);
    
    # default weights
    weights = ones(length(iterations), 1);
    trials = 5;
    
    if((nargin == 4) && !isempty(sampleWeights))
        if(!isvector(sampleWeights))
            error("functionFitting/fitFunctions: sample weights have to be \
provided as vector");
        elseif(length(sampleWeights) != length(iterations))
            error("functionFitting/fitFunctions: number of sample weights and \
number of iterations have to coincide");
        endif
        
        weights = vec(sampleWeights);
    endif
    
    if((nargin == 5) && !isempty(maxTrials))
        if(!isscalar(maxTrials))
            error("functionFitting/fitFunctions: maximal amount of trials has \
to be scalar");
        endif
        
        trials = max(1, maxTrials);
    endif
	
	funcReg = [];
	iterSize = length(iterations);
	
	options.bounds = functionParams.bounds;
	weights = weights(functionParams.useData(iterSize));
    
    # iterate over all samples and fit a curve for each one
    for j = 1:size(accSamples, 1)
		X = iterations(functionParams.useData(iterSize));
		Y = vec(accSamples(j, functionParams.useData(iterSize)));
		
		
		MSE = Inf;
		counter = 0;
		flag = 0;
		
		bestParams = [];
		
		while(counter < trials)
			# Select initial parameters for fitting
			# The range (in form of a substract and scaling factor) are given as parameters
			init = (rand(1, functionParams.params).-functionParams.inits(1, :)) .* functionParams.inits(2, :);
			try
				# For linear fit, we can compute the best parameters directly
				[values, fittedParams] = leasqr(X, Y, init,
											functionParams.template, 0.0001,
											300, weights, 0.001 * ones (size (init)),
											functionParams.derivative, options);
			catch
				# If we encounter an error, simply select new initial parameters
				# *cough* Octave-3.8.2 and optim-1.4.0 only *cough*
				continue;
			end_try_catch
            
			currMSE = sum((values .- Y) .^ 2);
			counter++;
			
			if((currMSE < MSE) || isempty(bestParams))
				bestParams = fittedParams;
				MSE = currMSE;
			endif
		endwhile
        
        funcReg = [funcReg; bestParams'];
    endfor

endfunction