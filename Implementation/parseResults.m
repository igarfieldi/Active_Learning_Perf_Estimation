1;
clc;
clear;
more off;
warning("off");

dataDir = "./data/";
resDir = "./results/";

addpath(genpath(pwd()));

colors = jet(19);
colors = [1, 0, 1;
          1, 0, 0;
          1, 0.5, 0.2;
          0, 0, 1;
          0, 1, 1;
          0, 1, 0;
          1, 1, 0;
          0, 0, 0.6;
          0, 0.6, 0.6;
          0, 0.6, 0;
          0.6, 0.6, 0;
          0.1, 0.1, 0.1];

colors = [0, 0, 0;
          0.6, 0, 0;
          1, 0, 0;
          0, 0.4, 0.4;
          0, 0.6, 0.6;
          0, 0.8, 0.8;
          0, 1, 1;
          0, 0.4, 0;
          0, 0.6, 0;
          0, 0.8, 0;
          0, 1, 0;
          0, 0, 1];

methodNames = {"Holdout", "K-fold CV", ".632+ BS",...
                    "path", "pathSuper", "averaged", "averagedBS",...
                    "pathW", "pathSuperW", "averagedW", "averagedBSW",...
                    "pathSuperWNI"};

testParams.useMethod = [1, 1, 1,...
                        1, 1, 1, 1,...
                        1, 1, 1, 1,...
                        0, 0, 0, 0,...
                        0, 1, 0, 0];
list = readdir(resDir)(3:end);

files = {"checke1", "2dData", "seeds", "abaloneReduced"};
lists = cell(length(files), 3, 3);

allMus = cell(length(files), 3, 3);
allVars = cell(length(files), 3, 3);
allTimes = cell(length(files), 3, 3);

for i = 1:length(list)
    for j = 1:length(files)
        if(!isempty(strfind(list{i}, files{j})))
            al = str2num(strsplit(list{i}, "_"){2});
            func = str2num(strsplit(list{i}, "_"){3});
            lists{j, al, func} = [lists{j, al, func}; list{i}];
            
            load([resDir, list{i}], "mus", "vars", "times");
            
            if(size(mus, 2) == 30)
                allMus{j, al, func} = cat(1, allMus{j, al, func}, mus);
                allVars{j, al, func} = cat(1, allVars{j, al, func}, vars);
                allTimes{j, al, func} = cat(1, allTimes{j, al, func}, times);
            endif
        endif
    endfor
endfor

used = (1:length(testParams.useMethod)) .* testParams.useMethod;
used(used == 0) = [];


for fi = 1:4
    figure(fi);
    clf;
    hold on;
    clear latexInp;
    latexInp.data = [];
    for al = 1:3
        for fu = 1:3
            T = [];
            for i = used(2:end)
                T = [T, mean(mean((allMus{fi, al, fu}(:, :, 1) .- allMus{fi, al, fu}(:, :, i))))];
            endfor
            latexInp.data = [latexInp.data; T];
        endfor
    endfor
    bar(latexInp.data, "hist", 0.9);
    colormap(colors(2:end, :));
    set(gca, "xtick", 1:9);
    set(gca, "xticklabel", {"Exp", "Sig", "Lin", "Exp", "Sig", "Lin", "Exp", "Sig", "Lin"});
    ylabel("Mean Error");
    title(files(fi));
    ax = axis;
    ax(1) = 0.4;
    ax(2) = 9.6;
    axis(ax);
    text(1, ax(3)-(abs(ax(3))+abs(ax(4)))/12, "Random Sampling");
    text(3.8, ax(3)-(abs(ax(3))+abs(ax(4)))/12, "Uncertainty Sampling");
    text(7.8, ax(3)-(abs(ax(3))+abs(ax(4)))/12, "PAL");
    if(fi == 1)
        legend(methodNames(2:end), "location", "southwest");
    endif
    print(["../Thesis/pics/diffErrBar", files{fi}, ".pdf"]);
endfor
