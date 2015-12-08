# usage: [oracle, mus, vars] = evaluatePerformanceMeasures(classifier, oracle,
#                                           activeLearner, testParams, functionParams)

function [oracle, mus, vars, times] = evaluatePerformanceMeasures(classifier, oracle,
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
    times = zeros(testParams.runs, testParams.iterations, length(testParams.useMethod));

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
			
            [feat, lab] = getQueriedInstances(currOracle);
            classifier = setTrainingData(classifier, feat, lab,
                                getNumberOfLabels(currOracle));
            # get the holdout accuracies
            if(testParams.useMethod(1))
                # train the classifier with the currently labeled instances
                t1 = time();
                holdoutAccs = estHoldout(classifier, currOracle, i);
                mus(r, i, 1) = mean(holdoutAccs');
                vars(r, i, 1) = var(holdoutAccs');
                times(r, i, 1) = time() - t1;
            endif
            
            # use adaptive incremental K-fold cross-validation
            if(testParams.useMethod(2))
                t1 = time();
                [mus(r, i, 2), vars(r, i, 2)] = estAIKFoldCV(classifier, currOracle,
																testParams.foldSize);
                times(r, i, 2) = time() - t1;
            endif
			
			# use .632+ bootstrapping
            if(testParams.useMethod(3))
                t1 = time();
                mus(r, i, 3) = estBS632p(classifier, currOracle, testParams.bsSamples);
                times(r, i, 3) = time() - t1;
            endif
            
            CVSamples = [];
            BSSamples = [];
            
            # 3-layer computation:
            # First, methods compute which samples they would like to be computed.
            # Then, all unique samples needed are computed.
            # Last, each method draws the wanted sample accuracies from the shared
            # pool and does their thing.
            
            
            #
            # First stage (some methods share samples, currently anyway TODO??)
            #
            
            
            # use sampled fitting
            if(sum(testParams.useMethod([4,8,12,16])) > 0)
				MCt = time();
                [MCsamples, MCpos, CVSamples] = getFittingSamplesLXO(i,
                                                        testParams.samples(i),
                                                        CVSamples);
				MCt = time() - MCt;
            endif
            
            # use sampled fitting with Supersets
            if(sum(testParams.useMethod([5,9,13,17])) > 0)
				SMCt = time();
                [SMCsamples, SMCpos, CVSamples] = getFittingSamplesSuperLXO(i,
                                                        testParams.samples(i),
                                                        CVSamples);
				SMCt = time() - SMCt;
            endif
            
            
            # use averaged fitting (only subset of all)
            if(sum(testParams.useMethod([6,10,14,18])) > 0)
				AVt = time();
                [averSamples, averSizes, averPos, CVSamples]...
                                                = getFittingSamplesAver(i,
                                                    testParams.averMaxSamples,
                                                    CVSamples);
				AVt = time() - AVt;
            endif
            
            # use .632 bootstrap fitting (only subset of all)
            if(sum(testParams.useMethod([7,11,15,19])) > 0)
				BSAt = time();
                [BS632Samples, BS632sizes, BS632Pos, BSSamples]...
                                        = getFittingSamples632(i,
                                                    testParams.bsMaxSamples,
                                                    BSSamples);
				BSAt = time() - BSAt;
            endif
            
            #
            # Second stage
            #
            
            # cross-validation accuracy estimation
            [uniqueCVSamples, ~, CVpos] = unique(CVSamples);
			CVt = time();
			CVAccs = estimateAccuracies(classifier, currOracle, uniqueCVSamples);
			CVt = time() - CVt;
            
            # .632 bootstrap accuracy estimation
            [uniqueBSSamples, ~, BSpos] = unique(BSSamples);
			BSt = time();
            BSAccs = estimate632Bootstrap(classifier, currOracle, uniqueBSSamples,
                                                testParams.bsSamples);
			BSt = time() - BSt;
            
            # get the requested accuracies and shape them as before
            if(sum(testParams.useMethod([4,8,12,16])) > 0)
                MCsamples = reshape(CVAccs(CVpos(MCpos)), size(MCsamples));
            endif
            
            if(sum(testParams.useMethod([5,9,13,17])) > 0)
                SMCsamples = reshape(CVAccs(CVpos(SMCpos)), size(SMCsamples));
            endif
            
            if(sum(testParams.useMethod([6,10,14,18])) > 0)
                averSamples = CVAccs(CVpos(averPos));
            endif
            
            if(sum(testParams.useMethod([7,11,15,19])) > 0)
                BS632Samples = BSAccs(BSpos(BS632Pos));
            endif
            
            # compute the no-information rate
			NIt = time();
            niRate = computeNoInformationRate(classifier, currOracle);
            NIt = time() - NIt;
            
            #
            # Third stage
            #
            
            # Normal methods
            if(testParams.useMethod(4))
				t1 = time();
                [mus(r, i, 4), vars(r, i, 4)] = estSampleFit(MCsamples,
                                                            functionParams);
				times(r, i, 4) = MCt + CVt*prod(size(MCsamples))/length(uniqueCVSamples)...
									+ (time() - t1);
            endif
            
            if(testParams.useMethod(5))
				t1 = time();
                [mus(r, i, 5), vars(r, i, 5)] = estSampleFit(SMCsamples,
                                                            functionParams);
                times(r, i, 5) = SMCt + CVt*prod(size(SMCsamples))/length(uniqueCVSamples)...
									+ (time() - t1);
            endif
            
            if(testParams.useMethod(6))
				t1 = time();
                [mus(r, i, 6), ~, averages] = estAverFit(averSamples, averSizes, functionParams);
				times(r, i, 6) = AVt + CVt*prod(size(averSamples))/length(uniqueCVSamples)...
									+ (time() - t1);
				mus(r, i, 5) = averages(end);
            endif
            
            if(testParams.useMethod(7))
				t1 = time();
                mus(r, i, 7) = est632Fit(BS632Samples, BS632sizes, functionParams);
				times(r, i, 7) = BSAt + BSt + (time() - t1);
            endif
            
            # Weighted fitting
            if(testParams.useMethod(8))
				t1 = time();
                [mus(r, i, 8), vars(r, i, 8)] = estSampleFit(MCsamples,
                                                            functionParams, true);
				times(r, i, 8) = MCt + CVt*prod(size(MCsamples))/length(uniqueCVSamples)...
									+ (time() - t1);
            endif
            
            if(testParams.useMethod(9))
				t1 = time();
                [mus(r, i, 9), vars(r, i, 9)] = estSampleFit(SMCsamples,
                                                            functionParams, true);
				times(r, i, 9) = SMCt + CVt*prod(size(SMCsamples))/length(uniqueCVSamples)...
									+ (time() - t1);
            endif
            
            if(testParams.useMethod(10))
				t1 = time();
                mus(r, i, 10) = estAverFit(averSamples, averSizes,
                                            functionParams, true);
				times(r, i, 10) = AVt + CVt*prod(size(averSamples))/length(uniqueCVSamples)...
									+ (time() - t1);
            endif
            
            if(testParams.useMethod(11))
				t1 = time();
                mus(r, i, 11) = est632Fit(BS632Samples, BS632sizes,
                                            functionParams, true);
				times(r, i, 11) = BSAt + BSt + (time() - t1);
            endif
            
            # No-information fitting
            if(testParams.useMethod(12))
				t1 = time();
                [mus(r, i, 12), vars(r, i, 12)] = estSampleFit(MCsamples,
                                                functionParams, false, niRate);
				times(r, i, 12) = MCt + CVt*prod(size(MCsamples))/length(uniqueCVSamples)...
									+ NIt + (time() - t1);
            endif
            
            if(testParams.useMethod(13))
				t1 = time();
                [mus(r, i, 13), vars(r, i, 13)] = estSampleFit(SMCsamples,
                                                functionParams, false, niRate);
				times(r, i, 13) = SMCt + CVt*prod(size(SMCsamples))/length(uniqueCVSamples)...
									+ NIt + (time() - t1);
            endif
            
            if(testParams.useMethod(14))
				t1 = time();
                mus(r, i, 14) = estAverFit(averSamples, averSizes,
                                            functionParams, false, niRate);
				times(r, i, 14) = AVt + CVt*prod(size(averSamples))/length(uniqueCVSamples)...
									+ NIt + (time() - t1);
            endif
            
            if(testParams.useMethod(15))
				t1 = time();
                mus(r, i, 15) = est632Fit(BS632Samples, BS632sizes,
                                            functionParams, false, niRate);
				times(r, i, 15) = BSAt + BSt + NIt + (time() - t1);
            endif
            
            # No-information and weighted fitting
            if(testParams.useMethod(16))
                [mus(r, i, 16), vars(r, i, 16)] = estSampleFit(MCsamples,
                                                functionParams, true, niRate);
				times(r, i, 16) = MCt + CVt*prod(size(MCsamples))/length(uniqueCVSamples)...
									+ NIt + (time() - t1);
            endif
            
            if(testParams.useMethod(17))
                [mus(r, i, 17), vars(r, i, 17)] = estSampleFit(SMCsamples,
                                                functionParams, true, niRate);
				times(r, i, 17) = SMCt + CVt*prod(size(SMCsamples))/length(uniqueCVSamples)...
									+ NIt + (time() - t1);
            endif
            
            if(testParams.useMethod(18))
                mus(r, i, 18) = estAverFit(averSamples, averSizes,
                                            functionParams, true, niRate);
				times(r, i, 18) = AVt + CVt*prod(size(averSamples))/length(uniqueCVSamples)...
									+ NIt + (time() - t1);
            endif
            
            if(testParams.useMethod(19))
                mus(r, i, 19) = est632Fit(BS632Samples, BS632sizes,
                                            functionParams, true, niRate);
				times(r, i, 19) = BSAt + BSt + NIt + (time() - t1);
            endif
            
		endfor
	endfor
    
	oracle = currOracle;

endfunction