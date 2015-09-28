1;
clc;
more off;

addpath("@activeLearner");
addpath("@classifier");
addpath("@dataReader");
addpath("@estimator");
addpath("@oracle");
addpath("@parzenWindowClassifier");
addpath("@probabilisticAL");
addpath("@randomSamplingAL");
addpath("@uncertaintySamplingAL");
addpath("functionFitting");

pkg load optim;

data_file = "data/2dData.mat";

data = dataReader();
data = readData(data, data_file);

orac = oracle(getFeatureVectors(data), getLabels(data));

rand = randomSamplingAL(getFeatureVectors(data), getLabels(data));
cert = uncertaintySamplingAL(getFeatureVectors(data), getLabels(data));

pwC = parzenWindowClassifier();

estimate(rand, pwC, orac, 2, 0.1);