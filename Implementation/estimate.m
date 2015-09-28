function estimate(activeLearner, classifier, oracle, labelNum, cutoff)
    
    instances = getNumOfUnlabeledInstances(oracle);
    limit = 14;
    
    accuracies = cell(limit, 1);
    holdoutAccuracies = zeros(1, min(limit, instances));
    cutoffSize = instances;#ceil(cutoff * instances);
    
    plotAver = [];
    averEst = [];
    
    diffSum = 0;
    sqDiffSum = 0;
    
    figure(1);
    clf;
    hold on;
    
    figure(2);
    clf;
    hold on;
    
    for i = 1:min(limit, instances)
        disp(i);
        
        # select new instance for active learning
        [activeLearner,oracle,aquFeat,aquLab] = selectInstance(activeLearner, classifier, oracle, labelNum);
        
        # get the already labeled instances
        [labFeat, labLab] = getLabeledInstances(activeLearner);
        
        # estimate holdout accuracy
        [holdFeat, holdLab] = getHoldoutSets(oracle, 20, instances);
        
        currentHoldoutAccs = [];
        for j = 1:length(holdLab)
            classifier = setTrainingData(classifier, labFeat, labLab, labelNum);
            currentHoldoutAccs = [currentHoldoutAccs, computeAccuracy(classifier, holdFeat{j}, holdLab{j})];
            holdoutAccuracies(i) += currentHoldoutAccs(end);
        endfor
        holdoutAccuracies(i) /= length(holdLab);
        
        if(i < 3)
            continue;
        endif
        
        
        # initialize the vectors for storing the accuracy measures as well as
        # the plotting data
        averN = zeros(1, i-1);
        averD = zeros(1, i-1);
        accuracies{i} = cell(i-1, 1);
        plotData = [];
        
        # compute all possible two-set splits of the labeled instances by
        # computing the powerset of the instance indices
        pwr = powerset([1:i])(2:end-1);
        revPwr = fliplr(pwr);
        
        # shuffle indices for random cutoff
        shfl = randperm(size(pwr, 2));
        pwr = pwr(shfl);
        revPwr = revPwr(shfl);
        
        counter = 0;
        accSize = zeros(1, i-1);
        for tr = 1:size(pwr, 2);
            if((counter > 50) && (prod(accSize) != 0))
                break;
            endif
            # train a classifier on the indexed instances...
            classifier = setTrainingData(classifier, labFeat(pwr{tr}, :), labLab(pwr{tr}), labelNum);
            
            # ...and compute the accuracy with the other ones
            # (due to "symmetry" of the power set computation we can use the indices
            # read from the other direction. Also cut off if there are enough to test)
            acc = computeAccuracy(classifier, labFeat(revPwr{tr}(1:min(end, cutoffSize)), :), labLab(revPwr{tr}(1:min(end, cutoffSize))));
            
            # compute data to store or draw
            accuracies{i}{length(pwr{tr})} = [accuracies{i}{length(pwr{tr})}; acc];
            accSize(length(pwr{tr}))++;
            
            averN(length(pwr{tr})) += acc;
            averD(length(pwr{tr}))++;
            
            plotData = [plotData, [length(pwr{tr}); acc]];
            counter++;
        endfor
        
        # plot data
        plotAver = [1:i-1; averN ./ averD];
        
        # find unique accuracy estimates and their frequency
        uniqueAccs = cell(1, i-1);
        uniqueSize = zeros(1, i-1);
        for j = 1:i-1
            [u, ~, h] = unique(accuracies{i}{j});
            uniqueAccs{j} = [accumarray(h, 1), u];
            uniqueSize(j) = length(u);
        endfor
        
        # find fits of exponential functions for each combination of unique accuracy
        # estimates and store their frequency
        regFuncs = [];
        
        for j = 0:prod(uniqueSize)-1
            t = [];
            divid = 1;
            for k = 1:length(uniqueSize)
                ind = mod(floor(j / divid), uniqueSize(length(uniqueSize) - k + 1))+1;
                t = [uniqueAccs{length(uniqueSize) - k + 1}(ind, :); t];
                divid *= uniqueSize(length(uniqueSize) - k + 1);
            endfor
            
            [p, ~] = fitExponential(1:length(t(:, 2)), t(:, 2)');
            
            regFuncs = [regFuncs, [p; prod(t(:, 1))]];
        endfor
        
        # estimate next iteration's performance
        [currAver, currStdDev] = estimatePerformanceLevel(regFuncs, @(x, p) p(1) + p(2)*exp(x*p(3)));
        averEst = [averEst, currAver];
        
        # estimate beta dists for both holdout and estimation
        [holdoutP, holdoutQ] = estimateBetaDist(currentHoldoutAccs);
        [estimateP, estimateQ] = getBetaFromMuVar(currAver, max(currStdDev, 10^(-20)));
        
        # plot stuff
        figure(1);
        subplot(ceil(sqrt(min(limit, instances)-1)), ceil((min(limit, instances)-1) / ceil(sqrt(min(limit, instances)-1))), i-1);
        hold on;
        
        # plot accuracy tests
        plot(plotData(1, :), plotData(2, :), "+", "color", [0, 0, 0.5]);
        plot(plotAver(1, :), plotAver(2, :), "*-", "color", [1, 0, 0]);
        plot(1:i, holdoutAccuracies(1:i), "*-", "color", [1, 0, 1]);
        # plot estimates (est. val and std. dev.)
        plot((i-length(averEst)+1):i, averEst, "x-", "color", [0.2, 0.9, 0.1]);
        plot(i, currAver+currStdDev, "x", "color", [0.8, 0.9, 0.1]);
        plot(i, currAver-currStdDev, "x", "color", [0.8, 0.9, 0.1]);
        diffSum += averEst(end) - holdoutAccuracies(i);
        sqDiffSum += (averEst(end) - holdoutAccuracies(i))^2;
        
        axis([1, i, 0, 1]);
        xlabel("Training set size");
        ylabel("Accuracy");
        title(sprintf("Aquired labels: %d", i));
        
        # plot distributions
        figure(2);
        subplot(ceil(sqrt(min(limit, instances)-1)), ceil((min(limit, instances)-1) / ceil(sqrt(min(limit, instances)-1))), i-1);
        hold on;
        
        plot((0:0.001:1), betapdf((0:0.001:1), estimateP, estimateQ), "-", "color", [0, 1, 0]);
        plot((0:0.001:1), betapdf((0:0.001:1), holdoutP, holdoutQ), "-", "color", [1, 0, 1]);
    endfor
    
    disp(sprintf("diffSum: %f", diffSum / (i-1)));
    disp(sprintf("sqDiffSum: %f", sqDiffSum / (i-1)));

endfunction