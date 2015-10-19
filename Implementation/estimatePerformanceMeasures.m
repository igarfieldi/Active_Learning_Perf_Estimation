# usage: [oracle, CVmu, CFmu, CFvar, CFbeta, Hmu, Hvar, Hbeta] = ...
#                    estimatePerformanceMeasures(classifier, oracle, activeLearner,
#                                            iterations, samples, holdoutSize, k,
#                                            functionTemplate,
#                                            fittingFunction)

function [oracle, Hmu, CVmu, CFmu, AFmu] = ...
                    estimatePerformanceMeasures(classifier, oracle, activeLearner,
                                            iterations, samples, holdoutSize, k,
                                            functionTemplate,
                                            fittingFunction)

    global debug;
    
    if(nargin != 9)
        print_usage();
    elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle")
            || !isa(activeLearner, "activeLearner") || !isscalar(iterations)
            || !isvector(samples) || !isscalar(holdoutSize) || !isscalar(k)
            || !is_function_handle(functionTemplate)
            || !is_function_handle(fittingFunction))
        error("estimatePerformanceMeasures: requires classifier, oracle, \
activeLearner, scalar, vector, scalar, function handle, function handle");
    endif
    
    instances = getNumOfUnlabeledInstances(oracle);
    
    iterations = min(instances, iterations);
    if(iterations < 0)
        iterations = instances;
    endif
    
    # select initial 2 instances before any performance estimation can be applied
    for i = 1:min(iterations, 2)
        [activeLearner, oracle, ~, ~] = selectInstance(activeLearner,
                                                        classifier, oracle);
    endfor
    
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
    
    for i = 3:iterations
        if(debug)
            disp(sprintf("Measure iteration: %d", i));
        endif
        
        [activeLearner, oracle, ~, ~] = selectInstance(activeLearner,
                                                        classifier, oracle);
        
        # train the classifier with the currently labeled instances
        [feat, lab] = getQueriedInstances(oracle);
        classifier = setTrainingData(classifier, feat, lab, getNumberOfLabels(oracle));
        
        # get the holdout accuracies
        [Hsamples, ~] = estimateHoldoutAccuracy(classifier, oracle, holdoutSize);
        Hbeta = [Hbeta; estimateBetaDist(Hsamples)];
        [HmuTemp, HvarTemp] = getMuVarFromBeta(Hbeta(end, 1), Hbeta(end, 2));
        Hmu = [Hmu; HmuTemp];
        Hvar = [Hvar; HvarTemp];
        
        # use adaptive incremental K-fold cross-validation
        CVmu = [CVmu; estimatePerformanceAIKFoldCV(classifier, oracle, k)];
        
        # TODO: use .632+ bootstrapping
        
        # use our approach (curve fitting with leave-x-out CV)
        [CFmuTemp, CFvarTemp, CFbetaTemp] = ...
                estimatePerformanceMCFit(classifier, oracle, samples(i-2),
                                            functionTemplate, fittingFunction);
        
        CFmu = [CFmu; CFmuTemp];
        CFvar = [CFvar; CFvarTemp];
        CFbeta = [CFbeta; CFbetaTemp];
		
		
		# use averaging + fitting
		AFmu = [AFmu; estimatePerformanceAverFit(classifier, oracle,
							functionTemplate, fittingFunction)];
        
    endfor
	
	#{
	CFerr = CFmu .- Hmu;
	CFerrA = abs(CFmu .- Hmu);
	CFerrSq = (CFmu .- Hmu) .^ 2;
	CVerr = CVmu .- Hmu;
	CVerrA = abs(CVmu .- Hmu);
	CVerrSq = (CVmu .- Hmu) .^ 2;
	AFerr = AFmu .- Hmu;
	AFerrA = abs(AFmu .- Hmu);
	AFerrSq = (AFmu .- Hmu) .^ 2;
	
	figure(1);
	hold on;
	#plot(3:size(CFbeta, 1)+2, (Hmu .- CFmu)', "*-", "color", [0, 0, 1]);
	plot(3:length(CFerr)+2, CFerr', "*-", "color", [1, 0, 1]);
	plot(3:length(CVerr)+2, CVerr', "*-", "color", [0, 1, 0]);
	plot(3:length(AFerr)+2, AFerr', "*-", "color", [1, 0, 0]);
	axis([0, length(Hmu)+3, -1, 1]);
	#}

endfunction