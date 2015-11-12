1;
clc;
more off;
pkg load optim;
clear;

basePath = fileparts(program_invocation_name())

dataDir = [basePath, "\\data\\"];
resDir = [basePath, "\\results\\"];

addpath(genpath(basePath()));

global debug = 1;

args = argv();
useFile = args{1};
useAL = str2num(args{2});

testParams.iterations = 30;
testParams.runs = 1;
testParams.samples = @(i) i^2;
testParams.averMaxSamples = 10000;
testParams.bsMaxSamples = 50;
testParams.foldSize = 5;
testParams.bsSamples = 50;
testParams.useMethod = [1, 1, 1,...
                        1, 1, 1, 1,...
                        1, 1, 1, 1,...
                        0, 0, 0, 0,...
                        0, 1, 0, 0];

functionParams = struct("template", @(x, p) p(1) .+ p(2) .* exp(x .* p(3)),
                        "bounds", [0, 1; -Inf, 0; -Inf, 0],
                        "inits", [0, 1, 1; 1, 2, 3]);

data = dataReader();
classifier = parzenWindowClassifier();
ALs = {randomSamplingAL(),
        uncertaintySamplingAL(),
        probabilisticAL()};

data = readData(data, [dataDir, useFile]);
classifier = estimateSigma(classifier, getFeatureVectors(data));
orac = oracle(getFeatureVectors(data), getLabels(data), length(unique(getLabels(data))));

[~, mus, vars] = evaluatePerformanceMeasures(classifier, orac, ALs{useAL},
                                            testParams, functionParams);

mus = mus
vars = vars

storeResults([resDir, "res_", num2str(useAL), "_", num2str(time()),...
				"_", num2str(randi(20000000)), "_", useFile], mus, vars);