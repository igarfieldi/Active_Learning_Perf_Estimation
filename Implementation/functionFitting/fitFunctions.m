# usage: funcReg = fitFunctions(accSamples, funcHandle)

function funcReg = fitFunctions(iterations, accSamples, functionParams)

	global notConverged;
	global converged;
	funcReg = [];
	
	if(nargin != 3)
		print_usage();
	elseif(!isvector(iterations) || !ismatrix(accSamples) || !isstruct(functionParams))
		error("@perfEstimation/fitFunctionsIter: requires vector, matrix, struct");
	endif
	
	funcReg = [];
	
	options.bounds = functionParams.bounds;
    
    # iterate over all samples and fit a curve for each one
    for j = 1:size(accSamples, 1)
		X = iterations;
		Y = accSamples(j, :);
		
		
		MSE = Inf;
		counter = 0;
		flag = 0;
		
		bestParams = [];
		bestStdRes = [];
		
		while((MSE > 10^(-3)) && (counter < 10))
			init = (rand(1, 3) .- functionParams.inits(1, :)) .* functionParams.inits(2, :);
			[values, fittedParams, cvg, ~, ~, ~, ~, stdres] = leasqr(X', Y', init,
                                        functionParams.template, 0.0001,
										400, [], [], [], options);
			
			currMSE = sum((values' .- Y) .^ 2);
			counter++;
			
			if((currMSE < MSE) || isempty(bestParams))
				bestParams = fittedParams;
				MSE = currMSE;
				bestStdRes = stdres;
			endif
		endwhile
		
		#{
		if((counter >= 10) && (length(iterations) > 5))
			figure(5);
			clf;
			hold on;
			plot(X, Y, "*", "color", [0, 0, 1]);
			z = linspace(min(X), max(X), 1000);
			plot(z, functionParams.template(z, bestParams), "-", "color", [0, 0, 1]);
            
            [~, mi] = max(abs(bestStdRes));
            X(mi) = [];
            Y(mi) = [];
            
            
			init = (rand(1, 3) .- functionParams.inits(1, :)) .* functionParams.inits(2, :);
			[values, fittedParams, cvg, ~, ~, ~, ~, stdres] = leasqr(X', Y', init,
                                        functionParams.template, 0.0001,
										400, [], [], [], options);
            
			plot(X, Y, "*", "color", [1, 0, 0]);
			plot(z, functionParams.template(z, bestParams), "-", "color", [1, 0, 0]);
            
            keyboard;
        endif
        #}
        
        funcReg = [funcReg; bestParams'];
    endfor

endfunction