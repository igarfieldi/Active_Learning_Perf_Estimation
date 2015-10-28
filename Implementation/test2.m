1;
clc;
more off;

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
addpath("kernelEstimation");
addpath("plotting");
addpath("utility");


funcTemplates = {@(x, p) p(1) .+ p(2) .* exp(x .* p(3)),...
				@(x, p) -p(1) ./ 2 .+ p(1) ./ (1 .+ exp(-p(2).*(x .- p(3))))};
bounds = {[0, 1; -Inf, 0; -Inf, 0], [0, 2; 0, Inf; -Inf, Inf]};
inits = {[0, 1, 1; 1, 10, 10], [0, 0, 0.5; 2, 6, 8]};

data = dataReader();
data = readData(data, "data/checke1.mat");

rand = randomSamplingAL(getFeatureVectors(data), getLabels(data));
cert = uncertaintySamplingAL(getFeatureVectors(data), getLabels(data));
prob = probabilisticAL(getFeatureVectors(data), getLabels(data));

pwc = parzenWindowClassifier();

ALs = {rand, cert, prob};

res = zeros(300, length(ALs));

pwc = estimateSigma(pwc, getFeatureVectors(data));

for j = 2:2#length(ALs)
	orac = oracle(getFeatureVectors(data), getLabels(data), 2);
	
	for i = 1:size(res, 1)
		disp(sprintf("Holdout iteration %d", i));
		[ALs{j}, orac, ~, ~] = selectInstance(ALs{j}, pwc, orac);
		
		# train the classifier with the currently labeled instances
		[feat, lab] = getQueriedInstances(orac);
		pwc = setTrainingData(pwc, feat, lab, getNumberOfLabels(orac));
		
		# get the holdout accuracies
		[Hsamples, ~] = estimatePerformanceHoldout(pwc, orac, 20);
		res(i, j) = sum(Hsamples) ./ length(Hsamples);
		
		[feat, lab] = getAllInstances(orac);
		
		if(i == 100 || i == 300)
			plotClassPrediction(pwc, feat, lab, i, 1, 1);
		endif
		#plotClassPrediction(pwc, feat, lab, j+1, i, size(res, 1));
	endfor
endfor


figure(1);
hold on;
plot(1:size(res, 1), res(:, 1), "-", "color", [1, 0, 0]);
plot(1:size(res, 1), res(:, 2), "-", "color", [0, 1, 0]);
plot(1:size(res, 1), res(:, 3), "-", "color", [0, 0, 1]);
axis([1, size(res, 1), 0, 1]);
