1;
clc;
more off;
warning("off");
pkg load optim;
clear;

basePath = pwd();

dataDir = [basePath, "/data/"];
resDir = [basePath, "/results/"];

addpath(genpath(basePath));

global debug = 1;

args = argv();
useFile = args{1}
useAL = str2num(args{2})

testParams.iterations = 30;
testParams.runs = 1;
testParams.samples = @(i) min(i^2, ceil(10000 / i));
testParams.averMaxSamples = 50;
testParams.bsMaxSamples = 50;
testParams.foldSize = 5;
testParams.bsSamples = 50;
testParams.useMethod = [1,1,1,...
						1,1,1,1, 1,1,1,1, 1,...
						1,1,1,1, 1,1,1,1, 1,...
						1,1,1,1, 1,1,1,1, 1];

functionParams = [struct("template", @(x, p) p(1) .+ p(2) .* exp(x .* p(3)),
						"derivative", @(x, f, p, dp, F, bounds) [ones(length(x), 1),...
											exp(p(3).*x), p(2).*x.+exp(p(3).*x)],
						"params", 3,
                        "bounds", [0, 1; -Inf, 0; -Inf, 0],
                        "inits", [0, 1, 1; 1, 2, 2],
						"useData", @(size) 1:size),
                struct("template", @(x, p) 2.*(p(1).-p(2)).*(1./(1.+exp(p(3).*x)).-0.5).+p(1),
						"derivative", @(x, f, p, dp, F, bounds) [2./(exp(p(3).*x).+1),...
								-2.*(1./(exp(p(3).*x).+1).-0.5),...
								2.*x.*exp(p(3).*x).*(p(2).-p(1))./((exp(p(3).*x).+1).^2)],
						"params", 3,
                        "bounds", [0, 1; 0, 1; 0, Inf],
                        "inits", [0, 0, 0.5; 1, 1, 8],
						"useData", @(size) 1:size),
                struct("template", @(x, p) p(1) .+ p(2) .* x,
						"derivative", @(x, f, p, dp, F, bounds) [ones(length(x), 1), x],
						"params", 2,
                        "bounds", [0, 1; 0, Inf],
                        "inits", [0, 0; 1, 4],
						"useData", @(size) max(size-3, 1):size)];

data = dataReader();
classifier = parzenWindowClassifier();
ALs = {randomSamplingAL(),
        uncertaintySamplingAL(),
        probabilisticAL()};

data = readData(data, [dataDir, useFile]);
classifier = estimateSigma(classifier, getFeatureVectors(data));
orac = oracle(getFeatureVectors(data), getLabels(data), length(unique(getLabels(data))));

[~, mus, vars, times] = evaluatePerformanceMeasures(classifier, orac, ALs{useAL},
                                            testParams, functionParams);

mus = mus
vars = vars
times = times
				
storeResults([resDir, strsplit(useFile, "."){1}, "_", num2str(useAL), "_",...
				num2str(time()), "_", num2str(randi(20000000)), ".mat"], mus, vars, times);