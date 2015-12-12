1;
clc;

addpath(genpath(pwd()));

if(!exist("allMus") || isempty(allMus))
	load("results/allResults.mat", "allMus", "allVars", "allTimes");
endif

plotMeanErr;
plotSquErr;
plotKLD;
plotTimeAll;
plotTimeHist;