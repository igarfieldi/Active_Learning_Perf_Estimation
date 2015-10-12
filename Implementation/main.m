1;
clc;
more off;

# load the optim package for least square fitting
pkg load optim;

dataDir = "data/";
resDir = "results/";

addpath("@activeLearner");
addpath("@classifier");
addpath("@dataReader");
addpath("@oracle");
addpath("@parzenWindowClassifier");
addpath("@probabilisticAL");
addpath("@randomSamplingAL");
addpath("@uncertaintySamplingAL");
addpath("estimation");
addpath("functionFitting");
addpath("IO");
addpath("plotting");

global debug = 1;

dataFile = "2dData.mat";
resolution = 50;
holdoutSize = 20;
samples = @(i) min(factorial(i+2), 8);
iterations = 7;

data = dataReader();
data = readData(data, [dataDir, dataFile]);

orac = oracle(getFeatureVectors(data), getLabels(data), 2);

rand = randomSamplingAL(getFeatureVectors(data), getLabels(data));
cert = uncertaintySamplingAL(getFeatureVectors(data), getLabels(data));
prob = probabilisticAL(getFeatureVectors(data), getLabels(data));
pwC = parzenWindowClassifier();

# active learner to be used
currAL = rand;

# function template used for fitting
funcTemplate = @(x, p) p(1) .+ p(2) .* exp(x .* p(3));
fitFunc = @(X, Y) fitExponential(X, Y);

[currAL, ~, orac] = learnClassifierAL(currAL, pwC, orac, iterations);
[~, accumEstAccs] = estimateAccuracies(pwC, orac);

MCSamples = getMonteCarloSamples(accumEstAccs, samples);
funcs = fitFunctions(MCSamples, fitFunc);

# estimate holdout performance of the classifier at each iteration
[~, iterHoldoutAccs] = estimateHoldoutAccuracy(pwC, orac, holdoutSize);
holdoutBetas = estimateBetaDist(iterHoldoutAccs);
[holdoutMu, holdoutVar] = getMuVarFromBeta(holdoutBetas(:, 1), holdoutBetas(:, 2));

# estimate performance level for the iterations
[predictedMu, predictedVar, predictedBetas] = estimatePerformanceLevel(funcs, funcTemplate);

# plot results
plotResults(funcs, funcTemplate, MCSamples, accumEstAccs,
			predictedBetas, holdoutBetas, holdoutMu, predictedMu,
			holdoutVar, predictedVar,resolution, 1);

# store results
storeResults([resDir, dataFile], iterations, samples, holdoutSize, dataFile,
		orac, currAL, accumEstAccs, MCSamples, funcs, holdoutBetas, predictedBetas);
