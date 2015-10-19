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
addpath("perfEstimation");
addpath("plotting");
addpath("utility");

global debug = 1;

dataFile = "2dData.mat";
resolution = 50;
holdoutSize = 20;
foldSize = 5;
funcTemplate = @(x, p) p(1) .+ p(2) .* exp(x .* p(3));
#funcTemplate = @(x, p) -p(1) ./ 2 .+ p(1) ./ (1 .+ exp(-p(2).*(x .- p(3))));
fitFunc = @(X, Y) fitExponential(X, Y);
#fitFunc = @(X, Y) fitSigmoid(X, Y);
samples = @(i) min(factorial(i+2), 10);
iterations = 10;

data = dataReader();
data = readData(data, [dataDir, dataFile]);

orac = oracle(getFeatureVectors(data), getLabels(data), 2);

rand = randomSamplingAL(getFeatureVectors(data), getLabels(data));
cert = uncertaintySamplingAL(getFeatureVectors(data), getLabels(data));
prob = probabilisticAL(getFeatureVectors(data), getLabels(data));
pwC = parzenWindowClassifier();

# active learner to be used
currAL = rand;

Hmu = [];
CVmu = [];
CFmu = [];
AFmu = [];

for i = 1:20
	disp(i);
	[~, HmuT, CVmuT, CFmuT, AFmuT] = estimatePerformanceMeasures(
								pwC, orac, currAL, iterations, samples, holdoutSize,
								foldSize, funcTemplate, fitFunc);
								
	Hmu = [Hmu, HmuT];
	CVmu = [CVmu, CVmuT];
	CFmu = [CFmu, CFmuT];
	AFmu = [AFmu, AFmuT];
endfor

CFerr = sum(CFmu .- Hmu, 2) / size(Hmu, 2);
CVerr = sum(CVmu .- Hmu, 2) / size(Hmu, 2);
AFerr = sum(AFmu .- Hmu, 2) / size(Hmu, 2);

figure(1);
hold on;
plot(3:length(CFerr)+2, CFerr', "*-", "color", [1, 0, 1]);
plot(3:length(CVerr)+2, CVerr', "*-", "color", [0, 1, 0]);
plot(3:length(AFerr)+2, AFerr', "*-", "color", [1, 0, 0]);
axis([0, length(Hmu)+3, -1, 1]);

#{
KLDiv = computeKullbackLeiblerDivergence(Hbeta, CFbeta, 50);
SSD = computeSummedSquaredDifference(Hbeta, CFbeta, 50);
figure(2);
hold on;
plot(3:size(CFbeta, 1)+2, KLDiv', "*-", "color", [1, 0, 0]);
plot(3:size(CFbeta, 1)+2, SSD', "*-", "color", [0, 0, 1]);
#}
#{
[currAL, ~, orac] = learnClassifierAL(currAL, pwC, orac, iterations);

# estimate the performance with adaptive incremental k-fold cross-validation
CVPerfs = [];
for i = 3:iterations
	CVPerfs = [CVPerfs, estimatePerformanceAIKFoldCV(pwC, orac, i-1, i)];
endfor

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
			holdoutBetas, predictedBetas, holdoutMu, predictedMu,
			holdoutVar, predictedVar, CVPerfs, resolution, 1);

# store results
storeResults([resDir, dataFile], iterations, samples, holdoutSize, dataFile,
		orac, currAL, accumEstAccs, MCSamples, funcs, holdoutBetas, predictedBetas);
#}