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

testParams.useMethod = [1, 1, 0,...
                        0, 1, 1, 0,...
                        0, 0, 0, 0,...
                        0, 0, 0, 0,...
                        0, 0, 0, 0];
list = readdir("resultsRaw")(3:end);

files = {"checke1", "2dData", "seeds", "abaloneReduced"};
lists = cell(length(files), 3, 3);

allMus = cell(length(files), 3, 3);
allVars = cell(length(files), 3, 3);
allTimes = cell(length(files), 3, 3);
counter = 10 .* ones(4, 3, 3);

for i = 1:length(list)
    for j = 1:length(files)
        if(!isempty(strfind(list{i}, files{j})))
            al = str2num(strsplit(list{i}, "_"){2});
            fun = str2num(strsplit(list{i}, "_"){3});
            lists{j, al, fun} = [lists{j, al}; list{i}];
			counter(j, al, fun)++;
            
            load(["resultsRaw/", list{i}], "mus", "vars", "times");
            
			save(["results/", files{j}, "_", num2str(al), "_", num2str(fun), "_",...
					num2str(counter(j, al, fun)), ".mat"], "mus", "vars", "times");
			
            if(size(mus, 2) == 30)
                allMus{j, al, fun} = cat(1, allMus{j, al, fun}, mus);
                allVars{j, al, fun} = cat(1, allVars{j, al, fun}, vars);
                allTimes{j, al, fun} = cat(1, allTimes{j, al, fun}, times);
            endif
			
        endif
    endfor
endfor

plotResults(allMus{1, 1, 1}, allVars{1, 1, 1}, 1:4, testParams.useMethod, colors, methodNames);
