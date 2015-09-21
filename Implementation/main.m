1;
clc;

addpath("@activeLearner");
addpath("@classifier");
addpath("@dataReader");
addpath("@estimator");
addpath("@parzenWindowClassifier");
addpath("@randomSamplingAL");
addpath("@uncertaintySamplingAL");

data_file = "data/test.mat";

data = dataReader();
data = readData(data, data_file);

rand = randomSamplingAL(getFeatureVectors(data), getLabels(data));

cert = uncertaintySamplingAL(getFeatureVectors(data), getLabels(data));

estimate(cert);