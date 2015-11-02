# usage: [oracle, mus, vars] = estimatePerformanceMeasures(classifier, oracle,
#                                           activeLearner, testParams, functionParams)

function [oracle, mus, vars] = estimatePerformanceMeasures(classifier, oracle,
                                            activeLearner, testParams, functionParams)

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
        bsAccs = cell(2, 1);
		
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
			
			# estimate the accuracies with leave-x-out cv
			[estAccs, accumEstAccs, wis, combs] = estimateAccuracies(classifier, currOracle);
            
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
                mus(r, i, 3) = estimatePerformanceBS632plus(classifier, currOracle,
                                                    testParams.bsSamples);
            endif
            
            if(testParams.useMethod(9))
                if(i > 3)
                    [mus(r, i, 9), ~, ~, bsAccs] = estimatePerformanceBSFit(classifier,
                                                        currOracle, functionParams,
                                                        testParams.bsSamples, bsAccs);
                else
                    [mus(r, i, 9), ~, ~, bsAccs] = estimatePerformanceBSFit(classifier,
                                                        currOracle, functionParams,
                                                        testParams.bsSamples);
                endif
            endif
            
            if(testParams.useMethod(10))
                mus(r, i, 10) = estimatePerformance632Fit(classifier,
                                                    currOracle, functionParams,
                                                    testParams.bsSamples);
            endif
            
            if(testParams.useMethod(11))
                mus(r, i, 11) = estimatePerformance632MCFit(classifier, currOracle,
                                                    functionParams, testParams.samples(i));
            endif
            
            if(testParams.useMethod(12))
               [mus(r, i, 12), vars(r, i, 12)] = estimatePerformanceRegNIFit(estAccs,
                                                    functionParams, wis, combs,
                                                    testParams.samples(i), classifier,
                                                    currOracle);
            endif
			
			# use our approaches (curve fitting with leave-x-out CV)
            if(testParams.useMethod(4))
                [mus(r, i, 4), vars(r, i, 4)] = estimatePerformanceMCFit(accumEstAccs,
                                                    functionParams, testParams.samples(i));
            endif
            
            if(testParams.useMethod(5))
                [mus(r, i, 5), vars(r, i, 5)] = estimatePerformanceRegFit(estAccs,
                                                    functionParams, wis, combs,
                                                    testParams.samples(i));
            endif
            
            if(testParams.useMethod(6))
                [mus(r, i, 6), vars(r, i, 6)] = estimatePerformanceRestrictedFit(
                                                    accumEstAccs, functionParams,
                                                    testParams.samples(i));
			endif
            
			# use averaging + fitting
            if(testParams.useMethod(7))
                mus(r, i, 7) = estimatePerformanceAverFit(accumEstAccs, functionParams);
            endif
			
			if(testParams.useMethod(8))
				mus(r, i, 8) = estimatePerformanceAverNIFit(accumEstAccs, functionParams,
                                                    classifier, currOracle);
			endif
            
		endfor
        
	endfor
	oracle = currOracle;

endfunction