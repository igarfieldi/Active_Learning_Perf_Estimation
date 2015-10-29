1;
clc;
more off;
pkg load optim;
clear;

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
addpath("estimationMethods");
addpath("functionFitting");
addpath("IO");
addpath("kernelEstimation");
addpath("plotting");
addpath("utility");

global debug = 1;
global notConverged = {};

# color code
colors = {[1, 0, 1], [1, 0, 0], [0, 0, 0], [0, 1, 0], [0, 1, 1],...
            [0, 0, 1], [1, 1, 0]};
methodNames = {"Holdout", "CrossVal", ".632+", "MC", "RegMC", "ResMC", "Aver"};

testParams.iterations = 7;
testParams.runs = 6;
testParams.samples = @(i) i;#i .^ 2;
testParams.foldSize = 5;
testParams.useMethod = [1, 1, 0, 1, 1, 1, 1];

functionParams = [struct("template", @(x, p) p(1) .+ p(2) .* exp(x .* p(3)),
                        "bounds", [0, 1; -Inf, 0; -Inf, 0],
                        "inits", [0, 1, 1; 1, 10, 10]),
                struct("template", @(x, p) -p(1)./2 .+ p(1)./(1.+exp(-p(2).*(x.-p(3)))),
                        "bounds", [0, 2; 0, Inf; -Inf, Inf],
                        "inits", [0, 0, 0.5; 2, 6, 8])];

dataFiles = {"checke1.mat", "2dData.mat", "seeds.mat", "abalone.mat"};


data = dataReader();
classifier = parzenWindowClassifier();
ALs = {randomSamplingAL(getFeatureVectors(data), getLabels(data)),
        uncertaintySamplingAL(getFeatureVectors(data), getLabels(data)),
        probabilisticAL(getFeatureVectors(data), getLabels(data))};


data = readData(data, [dataDir, dataFiles{1}]);
orac = oracle(getFeatureVectors(data), getLabels(data), length(unique(getLabels(data))));

[~, mus, vars] = estimatePerformanceMeasures(classifier, orac, ALs{1},
                                            testParams, functionParams(1));

plotResults(mus, vars, [1,2,3], colors, methodNames);