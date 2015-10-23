# usage: [oracle, CVmu, CFmu, CFvar, CFbeta, Hmu, Hvar, Hbeta] = ...
#                    estimatePerformanceMeasures(classifier, oracle, activeLearner,
#                                            iterations, samples, holdoutSize, k,
#                                            functionTemplate,
#                                            fittingFunction)

function [oracle, Hmu, CVmu, CFmu, AFmu] = ...
                    estimatePerformanceMeasures(classifier, oracle, activeLearner,
                                            iterations, runs, samples, k,
                                            functionTemplate, bounds, inits)

    global debug;
    
    if(nargin != 10)
        print_usage();
    elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle")
            || !isa(activeLearner, "activeLearner") || !isscalar(iterations)
            || !isscalar(runs) || !isvector(samples) || !isscalar(k)
            || !is_function_handle(functionTemplate)
            || !ismatrix(bounds) || !ismatrix(inits))
        error("estimatePerformanceMeasures: requires classifier, oracle, \
activeLearner, scalar, vector, scalar, function handle, matrix, matrix");
    endif
    
    instances = getNumOfUnlabeledInstances(oracle);
    
    iterations = min(instances, iterations);
    if(iterations < 0)
        iterations = instances;
    endif
	
    feat = [];
    lab = [];
    
    CVmu = [];
    CFmu = [];
    CFvar = [];
    CFbeta = [];
	AFmu = [];
    Hmu = [];
    Hvar = [];
    Hbeta = [];
    
	for r = 1:runs
		if(debug)
			disp(sprintf("Test run: %d", r));
		endif
		currOracle = oracle;
		
		currCVmu = [];
		currCFmu = [];
		currCFvar = [];
		currCFbeta = [];
		currAFmu = [];
		currHmu = [];
		currHvar = [];
		currHbeta = [];
		
		# select initial 2 instances before any performance estimation can be applied
		for i = 1:min(iterations, 2)
			[activeLearner, currOracle, ~, ~] = selectInstance(activeLearner,
															classifier, currOracle);
		endfor
		
		for i = 3:iterations
			if(debug)
				disp(sprintf("Measure iteration: %d", i));
			endif
			
			[activeLearner, currOracle, ~, ~] = selectInstance(activeLearner,
															classifier, currOracle);
			
			# train the classifier with the currently labeled instances
			[feat, lab] = getQueriedInstances(currOracle);
			classifier = setTrainingData(classifier, feat, lab, getNumberOfLabels(currOracle));
			
			# get the holdout accuracies
			[Hsamples, ~] = estimatePerformanceHoldout(classifier, currOracle, i);
			HbetaTemp = estimateBetaDist(Hsamples);
			currHbeta = [currHbeta; struct("p", HbetaTemp(1), "q", HbetaTemp(2))];
			[HmuTemp, HvarTemp] = getMuVarFromBeta(HbetaTemp(1), HbetaTemp(2));
			currHmu = [currHmu; HmuTemp];
			currHvar = [currHvar; HvarTemp];
			
			# use adaptive incremental K-fold cross-validation
			currCVmu = [currCVmu; estimatePerformanceAIKFoldCV(classifier, currOracle, k)];
			
			# TODO: use .632+ bootstrapping
			
			# use our approach (curve fitting with leave-x-out CV)
			[CFmuTemp, CFvarTemp, CFbetaTemp] = ...
					estimatePerformanceMCFit(classifier, currOracle, samples(i),
												functionTemplate, bounds, inits);
			
			currCFmu = [currCFmu; CFmuTemp];
			currCFvar = [currCFvar; CFvarTemp];
			currCFbeta = [currCFbeta; struct("p", CFbetaTemp(1), "q", CFbetaTemp(2))];
			
			
			# use averaging + fitting
			currAFmu = [currAFmu; estimatePerformanceAverFit(classifier, currOracle,
										functionTemplate, bounds, inits)];
			
		endfor
		
		CVmu = [CVmu, currCVmu];
		CFmu = [CFmu, currCFmu];
		CFvar = [CFvar, currCFvar];
		CFbeta = [CFbeta, currCFbeta];
		AFmu = [AFmu, currAFmu];
		Hmu = [Hmu, currHmu];
		Hvar = [Hvar, currHvar];
		Hbeta = [Hbeta, currHbeta];
	endfor
	
	oracle = currOracle;
	

endfunction