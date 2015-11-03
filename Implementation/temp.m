1;

clf;

colors = [1.00000   0.00000   1.00000
		  0.00000   0.00000   0.50000
		  0.00000   0.00000   1.00000
		  0.00000   1.00000   0.20000
		  0.00000   0.80000   0.20000
		  0.00000   0.50000   0.20000
		  0.00000   0.50000   0.50000
		  1.00000   1.00000   0.00000
		  1.00000   0.66667   0.00000
		  1.00000   0.33333   0.00000
		  1.00000   0.00000   0.00000
		  0.66667   0.00000   0.00000];

methodNames = {"Holdout", "CV", ".632+", "MCFit", "SuperMCFit", "HigherMCFit",...
                    "AverFit", "AverNIFit", "BSFit", "632Fit", "632MCFit", "RegNIMCFit"};

resDir = "results/";
dataFiles = {"checke1.mat", "2dData.mat", "seeds.mat", "abalone.mat"};

useFile = 1;
useAL = 3;
useFunc = 1;

load([resDir, "res_AL_", num2str(useAL), "_Func_", num2str(useFunc), "_",...
		dataFiles{useFile}], "mus", "vars");


handles = plotResults(mus, vars, 1:4, ones(1, 12), colors, methodNames);

saveas(handles(1), [resDir, "res_AL_", num2str(useAL), "_Func_", num2str(useFunc), "_checke1_accs.pdf"]);
saveas(handles(2), [resDir, "res_AL_", num2str(useAL), "_Func_", num2str(useFunc), "_checke1_diff.pdf"]);
saveas(handles(3), [resDir, "res_AL_", num2str(useAL), "_Func_", num2str(useFunc), "_checke1_squErr.pdf"]);
saveas(handles(4), [resDir, "res_AL_", num2str(useAL), "_Func_", num2str(useFunc), "_checke1_var.pdf"]);