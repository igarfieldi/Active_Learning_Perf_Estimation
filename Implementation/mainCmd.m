1;
clc;
more off;
pkg load optim;
clear;

dataDir = "./data/";
resDir = "./results/";

addpath("./@activeLearner");
addpath("./@classifier");
addpath("./@dataReader");
addpath("./@oracle");
addpath("./@parzenWindowClassifier");
addpath("./@probabilisticAL");
addpath("./@randomSamplingAL");
addpath("./@uncertaintySamplingAL");
addpath("./estimation");
addpath("./estimationMethods");
addpath("./functionFitting");
addpath("./IO");
addpath("./kernelEstimation");
addpath("./plotting");
addpath("./sampleSelection");
addpath("./utility");

global debug = 1;

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

colors = jet(19);

methodNames = {"Holdout", "CV", ".632+", "MCFit", "SuperMCFit", "HigherMCFit",...
                    "AverFit", "AverNIFit", "BSFit", "632Fit", "632MCFit", "RegNIMCFit"};

methodNames = {"Holdout", "CV", ".632+",...
                    "MCFit", "SuperMCFit", "AverFit", "632Fit",...
                    "MCFitW", "SuperMCFitW", "AverFitW", "632FitW",...
                    "MCFitNI", "SuperMCFitNI", "AverFitNI", "632FitNI",...
                    "MCFitWNI", "SuperMCFitWNI", "AverFitWNI", "632FitWNI"};

testParams.iterations = 40;
testParams.runs = 1;
testParams.samples = @(i) 2*i;
testParams.averMaxSamples = 1000;
testParams.bsMaxSamples = 50;
testParams.foldSize = -1;
testParams.bsSamples = 50;
testParams.useMethod = [1, 1, 1,...
                        1, 1, 1, 1,...
                        1, 1, 1, 1,...
                        0, 0, 0, 0,...
                        0, 0, 0, 0];

functionParams = [struct("template", @(x, p) p(1) .+ p(2) .* exp(x .* p(3)),
                        "bounds", [0, 1; -Inf, 0; -Inf, 0],
                        "inits", [0, 1, 1; 1, 2, 2]),
                struct("template", @(x, p) -p(1)./2 .+ p(1)./(1.+exp(-p(2).*(x.-p(3)))),
                        "bounds", [0, 2; 0, Inf; -Inf, Inf],
                        "inits", [0, 0, 0.5; 2, 6, 8])];

dataFiles = {"checke1.mat", "2dData.mat", "seeds.mat", "abalone.mat"};


args = argv();
useFile = str2num(args{1});
useAL = str2num(args{2});
useFunc = str2num(args{3});


data = dataReader();
classifier = parzenWindowClassifier();
ALs = {randomSamplingAL(),
        uncertaintySamplingAL(),
        probabilisticAL()};

data = readData(data, [dataDir, dataFiles{useFile}]);
classifier = estimateSigma(classifier, getFeatureVectors(data));
orac = oracle(getFeatureVectors(data), getLabels(data), length(unique(getLabels(data))));

[~, mus, vars] = evaluatePerformanceMeasures(classifier, orac, ALs{useAL},
                                            testParams, functionParams(useFunc));

storeResults([resDir, "res_", num2str(useAL), "_", num2str(useFunc), "_",...
        num2str(useFile), "_", num2str(time()), "_", num2str(randi(2000)), ".mat"],
        mus, vars);