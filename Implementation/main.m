1;
clc;
more off;
pkg load optim;
clear;

dataDir = ".\\data\\";
resDir = ".\\results\\";

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
colors = [1, 0, 0; 0, 0, 1];

methodNames = {"Holdout", "CV", ".632+",...
                    "MCFit", "SuperMCFit", "AverFit", "632Fit",...
                    "MCFitW", "SuperMCFitW", "AverFitW", "632FitW",...
                    "MCFitNI", "SuperMCFitNI", "AverFitNI", "632FitNI",...
                    "MCFitWNI", "SuperMCFitWNI", "AverFitWNI", "632FitWNI"};

testParams.iterations = 30;
testParams.runs = 200;
testParams.samples = @(i) 2*i;
testParams.averMaxSamples = 1000;
testParams.bsMaxSamples = 50;
testParams.foldSize = 5;
testParams.bsSamples = 50;
testParams.useMethod = [1, 1, 0,...
                        0, 0, 0, 0,...
                        0, 0, 0, 0,...
                        0, 0, 0, 0,...
                        0, 0, 0, 0];

functionParams = [struct("template", @(x, p) p(1) .+ p(2) .* exp(x .* p(3)),
                        "bounds", [0, 1; -Inf, 0; -Inf, 0],
                        "inits", [0, 1, 1; 1, 2, 2]),
                struct("template", @(x, p) -p(1)./2 .+ p(1)./(1.+exp(-p(2).*(x.-p(3)))),
                        "bounds", [0, 2; 0, Inf; -Inf, Inf],
                        "inits", [0, 0, 0.5; 2, 6, 8])];

dataFiles = {"checke1.mat", "2dData.mat", "seeds.mat", "abaloneReduced.mat"};
#		1		82				172			
#		2		22				53			63.6			111.6
#		3		80.9			79.8		125.83			300.28

useFile = 2;
useAL = 1;
useFunc = 1;


data = dataReader();
classifier = parzenWindowClassifier();
ALs = {randomSamplingAL(),
        uncertaintySamplingAL(),
        probabilisticAL()};


data = readData(data, [dataDir, dataFiles{useFile}]);
classifier = estimateSigma(classifier, getFeatureVectors(data));
orac = oracle(getFeatureVectors(data), getLabels(data), length(unique(getLabels(data))));

t1 = time();
[~, mus, vars] = evaluatePerformanceMeasures(classifier, orac, ALs{useAL},
                                            testParams, functionParams(useFunc));

disp(time()-t1);

[mus, vars] = addResults("results/testingsChecke1.mat", mus, vars);

#addResults([resDir, "res_AL_", num2str(useAL), "_Func_", num2str(useFunc), "_",...
#        dataFiles{useFile}], mus, vars);

plotResults(mus, vars, 1:4, testParams.useMethod, colors, methodNames);