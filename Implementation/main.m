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
global converged = {};

# color code
colors = [1.00000   0.00000   1.00000
		  0.00000   0.00000   0.50000
		  0.00000   0.00000   1.00000
		  0.00000   1.00000   0.20000
		  0.00000   0.80000   0.20000
		  0.00000   0.50000   0.20000
		  0.00000   0.50000   0.50000
		  1.00000   1.00000   0.00000
		  1.00000   0.66667   0.00000
		  1.00000   0.33333   0.00000
		  1.00000   0.00000   0.00000
		  0.66667   0.00000   0.00000];
methodNames = {"Holdout", "CV", ".632+", "MCFit", "SuperMCFit", "HigherMCFit",...
                    "AverFit", "AverNIFit", "BSFit", "632Fit", "632MCFit", "RegNIMCFit"};

testParams.iterations = 7;
testParams.runs = 6;
testParams.samples = @(i) i .^ 2;
testParams.foldSize = 5;
testParams.bsSamples = 50;
testParams.useMethod = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];

functionParams = [struct("template", @(x, p) p(1) .+ p(2) .* exp(x .* p(3)),
                        "bounds", [0, 1; -Inf, 0; -Inf, 0],
                        "inits", [0, 1, 1; 1, 2, 2]),
                struct("template", @(x, p) -p(1)./2 .+ p(1)./(1.+exp(-p(2).*(x.-p(3)))),
                        "bounds", [0, 2; 0, Inf; -Inf, Inf],
                        "inits", [0, 0, 0.5; 2, 6, 8])];

dataFiles = {"checke1.mat", "2dData.mat", "seeds.mat", "abalone.mat"};

useFile = 1;
useAL = 3;
useFunc = 2;


data = dataReader();
classifier = parzenWindowClassifier();
ALs = {randomSamplingAL(getFeatureVectors(data), getLabels(data)),
        uncertaintySamplingAL(getFeatureVectors(data), getLabels(data)),
        probabilisticAL(getFeatureVectors(data), getLabels(data))};


data = readData(data, [dataDir, dataFiles{useFile}]);
classifier = estimateSigma(classifier, getFeatureVectors(data));
orac = oracle(getFeatureVectors(data), getLabels(data), length(unique(getLabels(data))));

[~, newMus, newVars] = estimatePerformanceMeasures(classifier, orac, ALs{useAL},
                                            testParams, functionParams(useFunc));

mus = [];
vars = [];
#load([resDir, "res_AL_", num2str(useAL), "_Func_", num2str(useFunc), "_",...
#		dataFiles{useFile}], "mus", "vars");
mus = cat(1, mus, newMus);
vars = cat(1, vars, newVars);
save([resDir, "res_AL_", num2str(useAL), "_Func_", num2str(useFunc), "_",...
		dataFiles{useFile}], "mus", "vars");

plotResults(mus, vars, 1:4, testParams.useMethod, colors, methodNames);