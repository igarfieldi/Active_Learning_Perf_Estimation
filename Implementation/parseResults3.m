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
                    "MCFit", "SuperMCFit", "AverFit", "632Fit",...
                    "MCFitW", "SuperMCFitW", "AverFitW", "632FitW",...
                    "MCFitNI", "SuperMCFitNI", "AverFitNI", "632FitNI",...
                    "MCFitWNI", "SuperMCFitWNI", "AverFitWNI", "632FitWNI"};

testParams.useMethod = [1, 0, 0,...
                        1, 1, 1, 0,...
                        0, 0, 0, 0,...
                        0, 0, 0, 0,...
                        0, 0, 0, 0];
list = readdir(resDir)(3:end);

files = {"checke1", "2dData", "seeds", "abaloneReduced"};
al = 1;
func = 1;
lists = cell(length(files), 3);

allMus = cell(length(files), 3, 3);
allVars = cell(length(files), 3, 3);
allTimes = cell(length(files), 3, 3);

for f = 1:4
	for al = 1:3
		for func = 1:3
			for i = 1:10
				load([resDir, files{f}, "_", num2str(al), "_", num2str(func), "_", num2str(i), ".mat"],
					"mus", "vars", "times");
				allMus{f, al, func} = cat(1, allMus{f, al, func}, mus);
				allVars{f, al, func} = cat(1, allVars{f, al, func}, vars);
				allTimes{f, al, func} = cat(1, allTimes{f, al, func}, times);
			endfor
		endfor
	endfor
endfor

plotResults(allMus{2, 3, 3}, allVars{2, 3, 3}, 1:4, testParams.useMethod, colors, methodNames);