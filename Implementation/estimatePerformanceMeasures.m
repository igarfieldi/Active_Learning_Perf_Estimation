# usage: [oracle, CVmu, CFmu, CFvar, CFbeta, Hmu, Hvar, Hbeta] = ...
#                    estimatePerformanceMeasures(classifier, oracle, activeLearner,
#                                            iterations, samples, holdoutSize, k,
#                                            functionTemplate,
#                                            fittingFunction)

function [oracle, mus, vars] = ...
                    estimatePerformanceMeasures(classifier, oracle, activeLearner,
                                            testParams, functionParams)

    global debug;
    
    if(nargin != 5)
        print_usage();
    elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle")
            || !isa(activeLearner, "activeLearner") || !isstruct(testParams)
            || !isstruct(functionParams))
        error("estimatePerformanceMeasures: requires classifier, oracle, \
activeLearner,struct, struct");
    endif
    
    instances = getNumOfUnlabeledInstances(oracle);
    
    testParams.iterations = min(instances, testParams.iterations);
    if(testParams.iterations < 0)
        testParams.iterations = instances;
    endif
	
    feat = [];
    lab = [];
    
    mus = zeros(testParams.runs, testParams.iterations, length(testParams.useMethod));
    vars = zeros(testParams.runs, testParams.iterations, length(testParams.useMethod));
    
	for r = 1:testParams.runs
		if(debug)
			disp(sprintf("Test run: %d", r));
		endif
		currOracle = oracle;
		
		# select initial 2 instances before any performance estimation can be applied
		for i = 1:min(testParams.iterations, 2)
			[activeLearner, currOracle, ~, ~] = selectInstance(activeLearner,
															classifier, currOracle);
		endfor
		
		for i = 3:testParams.iterations
			if(debug)
				disp(sprintf("Measure iteration: %d", i));
			endif
			
			[activeLearner, currOracle, ~, ~] = selectInstance(activeLearner,
															classifier, currOracle);
			
			# train the classifier with the currently labeled instances
			[feat, lab] = getQueriedInstances(currOracle);
			classifier = setTrainingData(classifier, feat, lab, getNumberOfLabels(currOracle));
            
			# get the holdout accuracies
            if(testParams.useMethod(1))
                holdoutAccs = estimatePerformanceHoldout(classifier, currOracle, i);
                [mus(r, i, 1), vars(r, i, 1), ~] = getSampleStatistics(holdoutAccs');
            endif
            
            # use adaptive incremental K-fold cross-validation
            if(testParams.useMethod(2))
                mus(r, i, 2) = estimatePerformanceAIKFoldCV(classifier, currOracle,
                                                    testParams.foldSize);
            endif
			
			# TODO: use .632+ bootstrapping
            if(testParams.useMethod(3))
                mus(r, i, 3) = estimatePerformanceBootstrap(classifier, currOracle,
                                                    testParams.bsSamples);
            endif
			
			# estimate the accuracies with leave-x-out cv
			[estAccs, accumEstAccs, wis, combs] = estimateAccuracies(classifier, currOracle);
			
			# use our approaches (curve fitting with leave-x-out CV)
            if(testParams.useMethod(4))
                [mus(r, i, 4), vars(r, i, 4)] = estimatePerformanceMCFit(classifier,
                                                    currOracle, testParams.samples(i),
                                                    functionParams, accumEstAccs);
            endif
            
            if(testParams.useMethod(5))
                [mus(r, i, 5), vars(r, i, 5)] = estimatePerformanceRegFit(estAccs,
                                                    functionParams, wis, combs,
                                                    testParams.samples(i));
            endif
            
            if(testParams.useMethod(6))
                [mus(r, i, 6), vars(r, i, 6)] = estimatePerformanceRestrictedFit(
                                                    classifier, currOracle, 
                                                    testParams.samples(i),
                                                    functionParams, accumEstAccs);
			endif
            
			# use averaging + fitting
            if(testParams.useMethod(7))
                mus(r, i, 7) = estimatePerformanceAverFit(classifier, currOracle,
                                                    functionParams, accumEstAccs);
            endif
			
			if(testParams.useMethod(8))
				mus(r, i, 8) = estimatePerformanceAllFit(classifier, currOracle,
													functionParams);
			endif
            
		endfor
        
	endfor
	oracle = currOracle;

endfunction