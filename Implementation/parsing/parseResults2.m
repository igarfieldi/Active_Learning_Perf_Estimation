1;
clc;
more off;
warning("off");

dataDir = "./data/";
resDir = "./results/";
logDir = "./log/";

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


currFile = 0;
files = {"abaloneReduced", "2dData", "seeds", "checke1"};

for f = 1:4
	for al = 1:3
		for func = 1:3
			for run = 1:10
				file = [logDir, num2str(currFile), ".o"]
				currFile++;
				T = strsplit(fileread(file), "\n");

				ind = 4;

				muText = [];
				varText = [];
				timesText = [];

				vals = cell(3, 1);
				texts = cell(4, 1);

				for i = 1:length(T)
					if(strcmp(T{i}, "mus ="))
						ind = 1;
						continue;
					endif
					if(strcmp(T{i}, "vars ="))
						ind = 2;
						continue;
					endif
					if(strcmp(T{i}, "times ="))
						ind = 3;
						continue;
					endif
					
					if((length(T{i}) > 3) && !strcmp(substr(T{i}, 1, 4), " Col"))
						texts{ind} = [texts{ind}, "\n", T{i}];
					endif
				endfor

				for k = 1:3
					spl = strsplit(texts{k}, "\n")(2:end);
					
					currD = 0;
					currVal = [];
					
					for i = 1:length(spl)
						if(strcmp(substr(spl{i}, 1, 4), "ans("))
							if(currD > 0)
								vals{k} = cat(3, vals{k}, currVal);
								currVal = [];
							endif
							currD = str2num(strsplit(strsplit(spl{i}, ","){3}, ")"){1});
						elseif(!strcmp(substr(spl{i}, 1, 4), " Col"))
							currVal = [currVal, str2num(spl{i})];
						endif
					endfor
					vals{k} = cat(3, vals{k}, currVal);
				endfor
				
				mus = vals{1};
				vars = vals{2};
				times = vals{3};
				
				save([resDir, files{f}, "_", num2str(al), "_", num2str(func), "_",...
						num2str(run), ".mat"], "mus", "vars", "times");
				
				disp([resDir, files{f}, "_", num2str(al), "_", num2str(func), "_",...
						num2str(run), ".mat"]);
			endfor
		endfor
	endfor
endfor