# usage: [oracle, mus, vars] = estimatePerformanceMeasures(classifier, oracle,
#                                           activeLearner, testParams, functionParams)

function [oracle, mus, vars] = estimatePerformanceMeasuresExp(classifier, oracle,
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
            
            allSamples = [];
            
            # 3-layer computation:
            # First, methods compute which samples they would like to be computed.
            # Then, all unique samples needed are computed.
            # Last, each method draws the wanted sample accuracies from the shared
            # pool and does their thing.
            
            
            # First stage (some methods share samples, currently anyway TODO??)
            # use MC Fitting
            if(testParams.useMethod(4) || testParams.useMethod(8)
                    || testParams.useMethod(10))
                MCsamples = getFittingSamplesExp(i, testParams.samples(i));
                MCpos = length(allSamples)+1:length(allSamples)+prod(size(MCsamples));
                allSamples = [allSamples; vec(MCsamples)];
            endif
            
            # use MC Fitting with Supersets
            if(testParams.useMethod(4) || testParams.useMethod(9)
                    || testParams.useMethod(11))
                SMCsamples = getFittingSamplesSuperExp(i, testParams.samples(i));
                SMCpos = length(allSamples)+1:length(allSamples)+prod(size(SMCsamples));
                allSamples = [allSamples; vec(SMCsamples)];
            endif
            
            # use averaged Fitting (only subset of all)
            if(testParams.useMethod(6) || testParams.useMethod(12))
                [averSamples, averSizes] = getFittingSamplesAverExp(i, testParams.averSize);
                averPos = length(allSamples)+1:length(allSamples)+prod(size(averSamples));
                allSamples = [allSamples; averSamples];
            endif
            
            # Second stage
            [uniqueSamples, ~, pos] = unique(allSamples);
			estAccs = estimateAccuraciesExperimental(classifier, currOracle, uniqueSamples);
            
            # Third stage
            
            if(testParams.useMethod(4))
                MCsamples = reshape(estAccs(pos(MCpos)), size(MCsamples));
                mus(r, i, 4) = estimatePerformanceMCFitExp(MCsamples, functionParams);
            endif
            
            if(testParams.useMethod(5))
                SMCsamples = reshape(estAccs(pos(SMCpos)), size(SMCsamples));
                mus(r, i, 5) = estimatePerformanceMCFitExp(SMCsamples, functionParams);
            endif
            
            if(testParams.useMethod(6))
                averSamples = estAccs(pos(averPos));
                
                averages = [];
                oldPos = 0;
                for k = 1:length(averSizes)
                    currSamples = averSamples(oldPos+1:averSizes(k));
                    
                    if(prod(size(currSamples)) == 0)
                        keyboard;
                    endif
                    
                    averages = [averages; sum(currSamples) / prod(size(currSamples))];
                endfor
                
                mus(r, i, 6) = estimatePerformanceMCFitExp(averages, functionParams);
            endif
            
            if(testParams.useMethod(7))
                mus(r, i, 7) = estimatePerformance632Fit(classifier,
                                                    currOracle, functionParams,
                                                    testParams.bsSamples);
            endif
            
		endfor
        
	endfor
	oracle = currOracle;

endfunction