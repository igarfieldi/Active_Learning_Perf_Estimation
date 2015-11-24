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
                        0, 0, 1, 0,...
                        0, 0, 1, 0,...
                        0, 0, 0, 0,...
                        0, 0, 0, 0];
list = readdir(resDir)(3:end);

files = {"checke1", "2dData", "seeds", "abaloneReduced"};
lists = cell(length(files), 3);

allMus = cell(length(files), 3);
allVars = cell(length(files), 3);
allTimes = cell(length(files), 3);

for i = 1:length(list)
    for j = 1:length(files)
        if(!isempty(strfind(list{i}, files{j})))
            al = str2num(strsplit(list{i}, "_"){2});
            lists{j, al} = [lists{j, al}; list{i}];
            
            load([resDir, list{i}], "mus", "vars", "times");
            
            if(size(mus, 2) == 30)
                allMus{j, al} = cat(1, allMus{j, al}, mus);
                allVars{j, al} = cat(1, allVars{j, al}, vars);
                allTimes{j, al} = cat(1, allTimes{j, al}, times);
            endif
        endif
    endfor
endfor

d = allMus{4, 1}(:, :, 2)
z = find(round(d(:, 3)*100000) == 100000)
allMus{4, 1}(z, :, 2)

#plotResults(allMus{1, 1}, allVars{1, 1}, 1:4, testParams.useMethod, colors, methodNames);