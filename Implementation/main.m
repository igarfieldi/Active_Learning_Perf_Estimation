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
addpath("utility");

global debug = 1;
global notConverged = 0;

dataFile = "checke1.mat";
resolution = 50;
holdoutSize = 20;
foldSize = 5;
funcTemplates = {@(x, p) p(1) .+ p(2) .* exp(x .* p(3)),...
				@(x, p) -p(1) ./ 2 .+ p(1) ./ (1 .+ exp(-p(2).*(x .- p(3))))};
bounds = {[0, 1; -Inf, 0; -Inf, 0], [0, 2; 0, Inf; -Inf, Inf]};
inits = {[0, 1, 1; 1, 10, 10], [0, 0, 0.5; 2, 6, 8]};
samples = @(i) i .^ 2;#min(factorial(i), 10);
iterations = 10;
testRuns = 1;

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

[~, Hmu, CVmu, CFmu, AFmu] = estimatePerformanceMeasures(
							pwC, orac, currAL, iterations, testRuns, samples,
							foldSize, funcTemplates{1}, bounds{1}, inits{1});


CFerr = sum(CFmu .- Hmu, 2) / size(Hmu, 2);
CVerr = sum(CVmu .- Hmu, 2) / size(Hmu, 2);
AFerr = sum(AFmu .- Hmu, 2) / size(Hmu, 2);

CFerrSq = sum((CFmu .- Hmu) .^ 2, 2) / size(Hmu, 2);
AFerrSq = sum((AFmu .- Hmu) .^ 2, 2) / size(Hmu, 2);
CVerrSq = sum((CVmu .- Hmu) .^ 2, 2) / size(Hmu, 2);

Hmu = sum(Hmu, 2) ./ size(Hmu, 2);
CVmu = sum(CVmu, 2) ./ size(CVmu, 2);
CFmu = sum(CFmu, 2) ./ size(CFmu, 2);
AFmu = sum(AFmu, 2) ./ size(AFmu, 2);

figure(1);
hold on;
axis([3, length(Hmu)+2, 0, 1]);
plot(3:length(Hmu)+2, Hmu', "*-", "color", [0, 0, 1]);
plot(3:length(CFmu)+2, CFmu', "*-", "color", [1, 0, 1]);
plot(3:length(CVmu)+2, CVmu', "*-", "color", [0, 1, 0]);
plot(3:length(AFmu)+2, AFmu', "*-", "color", [1, 0, 0]);
#{
figure(2);
hold on;
plot(3:length(CFerr)+2, CFerr', "*-", "color", [1, 0, 1]);
plot(3:length(CVerr)+2, CVerr', "*-", "color", [0, 1, 0]);
plot(3:length(AFerr)+2, AFerr', "*-", "color", [1, 0, 0]);
figure(3);
hold on;
plot(3:length(CFerr)+2, CFerrSq', "*-", "color", [1, 0, 1]);
plot(3:length(CVerr)+2, CVerrSq', "*-", "color", [0, 1, 0]);
plot(3:length(AFerr)+2, AFerrSq', "*-", "color", [1, 0, 0]);
#}
