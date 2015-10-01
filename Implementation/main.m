1;
clc;
more off;

addpath("@activeLearner");
addpath("@classifier");
addpath("@dataReader");
addpath("@estimator");
addpath("@oracle");
addpath("@parzenWindowClassifier");
addpath("@probabilisticAL");
addpath("@randomSamplingAL");
addpath("@uncertaintySamplingAL");
addpath("functionFitting");
addpath("plotting");

pkg load optim;

data_file = "data/2dData.mat";

data = dataReader();
data = readData(data, data_file);

orac = oracle(getFeatureVectors(data), getLabels(data), 2);

rand = randomSamplingAL(getFeatureVectors(data), getLabels(data));
cert = uncertaintySamplingAL(getFeatureVectors(data), getLabels(data));
prob = probabilisticAL(getFeatureVectors(data), getLabels(data));
pwC = parzenWindowClassifier();

currAL = cert;
iterations = 6;
holdoutBetas = zeros(iterations, 2);


[currAL, ~, orac] = learnClassifierAL(currAL, pwC, orac, iterations);

[estAccs, accumEstAccs] = estimateAccuracies(pwC, orac, 2, iterations);

expFunc = @(x, p) p(1) .+ p(2) .* exp(x .* p(3));
funcs = fitFunctions(accumEstAccs, @(X, Y) fitExponential(X, Y));

[aver, std] = estimatePerformanceLevel(funcs{end}, expFunc)

# draw accuracies and regressed functions
plotEstimatedAccuracies(accumEstAccs, 1, [0, 0, 0.5], 1);
plotRegressedFunctions(funcs, expFunc, 3, 1000, 1, [1, 0, 0], 1);

# estimate holdout performance of the classifier at each iteration
[feat, lab] = getLabeledInstances(currAL);
[~, iterHoldoutAccs] = estimateHoldoutAccuracy(pwC, orac, 20);
[holdoutBetas(:, 1), holdoutBetas(:, 2)] = estimateBetaDist(iterHoldoutAccs);

#plotBetaDists(holdoutBetas, 10000, 2, [1, 0, 1], 1);
