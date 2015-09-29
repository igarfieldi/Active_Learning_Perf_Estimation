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

data_file = "data/seeds.mat";

data = dataReader();
data = readData(data, data_file);

orac = oracle(getFeatureVectors(data), getLabels(data), 2);

rand = randomSamplingAL(getFeatureVectors(data), getLabels(data));
cert = uncertaintySamplingAL(getFeatureVectors(data), getLabels(data));
prob = probabilisticAL(getFeatureVectors(data), getLabels(data));
pwC = parzenWindowClassifier();

currAL = cert;
iterations = 8;
holdoutBetas = zeros(iterations, 2);


[currAL, ~, orac] = learnClassifierAL(currAL, pwC, orac, iterations);

[feat, lab] = getLabeledInstances(currAL);
for i = 1:size(getQueriedInstances(orac), 1)
    pwC = setTrainingData(pwC, feat(1:i, :), lab(1:i), getNumberOfLabels(orac));
    [holdoutP, holdoutQ] = estimateBetaDist(estimateHoldoutAccuracy(pwC, orac, 20));
    holdoutBetas(i, :) = [holdoutP, holdoutQ];
endfor

plotBetaDists(holdoutBetas, 10000, 1, [1, 0, 1], 1);
