# usage: funcReg = fitFunctionsExperimental(iterations, accSamples, functionParams)

function funcReg = fitFunctionsExperimental(iterations, accSamples, functionParams)

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
			
			
			# every 10 iterations, remove the most outlying data point
			if((mod(counter, 10) == 0) && (length(Y) > 2))
				r = stdres
				z = linspace(min(X), max(X), 10000);
				figure(5);
				hold on;
				plot(X, Y, "+");
				plot(z, functionParams.template(z, bestParams), "-");
				keyboard;
				[~, maxI] = max((values' .- Y) .^ 2);
				
				Y(maxI) = [];
				X(maxI) = [];
			endif
		endwhile
		
		#{
		if(counter >= 10)
			
			notConverged = [notConverged; bestStdRes];
			#fittedParams = [sum(Y) / length(Y); 0; 0];
		else
			figure(1);
			clf;
			hold on;
			plot(X, Y, "*");
			z = linspace(min(X), max(X), 1000);
			plot(z, functionParams.template(z, bestParams), "-");
			r = bestStdRes
			m = (values' .- Y) ./ std((values' .- Y))
			keyboard;
			converged = [converged; bestStdRes];
		endif
		#}
        
        funcReg = [funcReg; bestParams'];
    endfor

endfunction