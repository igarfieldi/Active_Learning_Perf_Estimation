1;
clc;
more off;
warning("off");
pkg load optim;
clear;

dataDir = "./data/";
resDir = "./results/";

addpath(genpath(pwd()));

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
colors = jet(19);
colors = [1, 0, 1; 0, 0, 1; 0, 1, 0; 1, 0, 0];

methodNames = {"Holdout", "CV", ".632+",...
                    "MCFit", "SuperMCFit", "AverFit", "632Fit",...
                    "MCFitW", "SuperMCFitW", "AverFitW", "632FitW",...
                    "MCFitNI", "SuperMCFitNI", "AverFitNI", "632FitNI",...
                    "MCFitWNI", "SuperMCFitWNI", "AverFitWNI", "632FitWNI", "A", "B", "C", "D", "E"};

testParams.iterations = 16;
testParams.runs = 1;
testParams.samples = @(i) i;#min(i^2, ceil(10000 / i));
testParams.averMaxSamples = 100;
testParams.bsMaxSamples = 50;
testParams.foldSize = 5;
testParams.bsSamples = 50;
testParams.useMethod = [1,0,0,...
						0,0,0,0, 0,0,0,0, 0,...
						0,0,0,0, 0,0,0,0, 0,...
						0,0,0,0, 0,0,0,0, 0];

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

dataFiles = {"checke1.mat", "2dData.mat", "seeds.mat", "abaloneReduced.mat"};
#		1		82				172			
#		2		22				53			63.6			111.6
#		3		80.9			79.8		125.83			300.28

useFile = 1;
useAL = 3;
useFunc = 1;

data = dataReader();
classifier = parzenWindowClassifier();
ALs = {randomSamplingAL(),
        uncertaintySamplingAL(),
        probabilisticAL()};


data = readData(data, [dataDir, dataFiles{useFile}]);
classifier = estimateSigma(classifier, getFeatureVectors(data));
orac = oracle(getFeatureVectors(data), getLabels(data), length(unique(getLabels(data))));

[~, mus, vars, times] = evaluatePerformanceMeasures(classifier, orac, ALs{useAL},
												testParams, functionParams);

#storeResults([resDir, strsplit("checke1.mat", "."){1}, "_", num2str(useAL), "_", num2str(useFunc), "_",...
#				num2str(time()), "_", num2str(randi(20000000)), ".mat"], mus, vars, times);

#addResults([resDir, "res_AL_", num2str(useAL), "_Func_", num2str(useFunc), "_",...
#        dataFiles{useFile}], mus, vars);

#plotResults(mus, vars, [2,0,0,0], testParams.useMethod, colors, methodNames);