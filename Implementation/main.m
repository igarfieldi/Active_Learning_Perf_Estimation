1;
clc;
more off;

addpath("@activeLearner");
addpath("@classifier");
addpath("@dataReader");
addpath("@estimator");
addpath("@parzenWindowClassifier");
addpath("@randomSamplingAL");
addpath("@uncertaintySamplingAL");

data_file = "data/seeds.mat";

data = dataReader();
data = readData(data, data_file);

disp(length(getLabels(data)));

rand = randomSamplingAL(getFeatureVectors(data), getLabels(data));

cert = uncertaintySamplingAL(getFeatureVectors(data), getLabels(data));

pwC = parzenWindowClassifier();

estimate(cert, pwC, 2, 0.1);