1;
clc;
more off;
warning("off");

dataDir = "./data/";
resDir = "./results/";

addpath(genpath(pwd()));

colors = jet(19);
colors = [1, 0, 1; 1, 0, 0; 0, 0.4, 0.5; 0, 0, 1; 0, 1, 0];

methodNames = {"Holdout", "CV", ".632+",...
                    "path", "pathSuper", "averaged", "averaged632",...
                    "pathW", "pathSuperW", "averagedW", "averaged632W",...
                    "pathNI", "pathSuperNI", "averagedNI", "averaged632NI",...
                    "pathWNI", "pathSuperWNI", "averagedWNI", "averaged632WNI"};

testParams.useMethod = [1, 0, 0,...
                        0, 1, 0, 0,...
                        0, 1, 0, 0,...
                        0, 0, 0, 0,...
                        0, 1, 0, 0];
load("results/allResults.mat", "allMus", "allVars", "allTimes");

for f = 1:4
	for al = 1:3
		figure((f-1)*3+al);
		clf;
		hold on;
		for fun = 1:3
			subplot(3, 1, fun);
			hold on;
			plotResults(allMus{f, al, fun}, allVars{1, 1, 1}, [5,0,0,0], testParams.useMethod, colors, methodNames);
		endfor
	endfor
endfor