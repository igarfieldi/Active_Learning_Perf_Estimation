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

#{
lists = cell(length(files), 3, 3);
list = readdir(resDir)(3:end);

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
#}


files = {"checke1", "2dData", "seeds", "abaloneReduced"};
load("results/allResults.mat", "allMus", "allVars", "allTimes");

used = (1:length(testParams.useMethod)) .* testParams.useMethod;
used(used == 0) = [];
iter = 1:8;

for fi = 1:4
    squErr = [];
    meanErr = [];
    for al = 1:3
        for fu = 1:3
            T1 = [];
            T2 = [];
            A = 1:100;
            if((fi == 4) && (al == 1) && (fu == 1))
                A(7) = [];
            elseif((fi == 4) && (al == 3) && (fu == 3))
                A(72) = [];
            endif
            for i = used(2:end)
                T1 = [T1, mean(mean((allMus{fi, al, fu}(A, iter, 1) .- allMus{fi, al, fu}(A, iter, i)).^2))];
                T2 = [T2, mean(mean((allMus{fi, al, fu}(A, iter, 1) .- allMus{fi, al, fu}(A, iter, i))))];
            endfor
            squErr = [squErr; T1];
            meanErr = [meanErr; T2];
        endfor
    endfor
    figure(fi);
    clf;
    hold on;
    bar(meanErr, "hist", 0.9);
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
    #print(["../Thesis/pics/meanErrBar", files{fi}, ".pdf"]);
    
    
    figure(fi+4);
    clf;
    hold on;
    bar(squErr, "hist", 0.9);
    colormap(colors(2:end, :));
    set(gca, "xtick", 1:9);
    set(gca, "xticklabel", {"Exp", "Sig", "Lin", "Exp", "Sig", "Lin", "Exp", "Sig", "Lin"});
    ylabel("Squared Error");
    title(files(fi));
    ax = axis;
    ax(1) = 0.4;
    ax(2) = 9.6;
    axis(ax);
    text(1, ax(3)-(abs(ax(3))+abs(ax(4)))/12, "Random Sampling");
    text(3.8, ax(3)-(abs(ax(3))+abs(ax(4)))/12, "Uncertainty Sampling");
    text(7.8, ax(3)-(abs(ax(3))+abs(ax(4)))/12, "PAL");
    if(fi == 4)
        legend(methodNames(2:end), "location", "northeast");
    endif
    #print(["../Thesis/pics/squErrBar", files{fi}, ".pdf"]);
endfor


#{
nw = [4,5,6,7];
w = [8,9,10,11];
for fi = 1:4
    squErrW = [];
    meanErrW = [];
    squErrNW = [];
    meanErrNW = [];
    for al = 1:3
        for fu = 1:3
            T1W = [];
            T2W = [];
            T1NW = [];
            T2NW = [];
            for i = w
                T1W = [T1W, mean(mean((allMus{fi, al, fu}(:, :, 1) .- allMus{fi, al, fu}(:, :, i)).^2))];
                T2W = [T2W, mean(mean((allMus{fi, al, fu}(:, :, 1) .- allMus{fi, al, fu}(:, :, i))))];
            endfor
            for i = nw
                T1NW = [T1NW, mean(mean((allMus{fi, al, fu}(:, :, 1) .- allMus{fi, al, fu}(:, :, i)).^2))];
                T2NW = [T2NW, mean(mean((allMus{fi, al, fu}(:, :, 1) .- allMus{fi, al, fu}(:, :, i))))];
            endfor
            squErrW = [squErrW; T1W];
            meanErrW = [meanErrW; T2W];
            squErrNW = [squErrNW; T1NW];
            meanErrNW = [meanErrNW; T2NW];
        endfor
    endfor
    figure(fi);
    clf;
    hold on;
    bar(abs(meanErrNW)-abs(meanErrW), "hist", 0.9);
    colormap(colors(8:11, :));
    
    set(gca, "xtick", 1:9);
    set(gca, "xticklabel", {"Exp", "Sig", "Lin", "Exp", "Sig", "Lin", "Exp", "Sig", "Lin"});
    ylabel("Mean Error Difference");
    
    title(files(fi));
    ax = axis;
    ax(1) = 0.4;
    ax(2) = 9.6;
    
    axis(ax);
    text(1, ax(3)-(abs(ax(3))+abs(ax(4)))/12, "Random Sampling");
    text(3.8, ax(3)-(abs(ax(3))+abs(ax(4)))/12, "Uncertainty Sampling");
    
    text(7.8, ax(3)-(abs(ax(3))+abs(ax(4)))/12, "PAL");
    if(fi == 1)
        legend(methodNames(4:7), "location", "northwest");
    endif
    
    print(["../Thesis/pics/meanErrDiffBar", files{fi}, ".pdf"]);
    
    #{
    figure(fi+4);
    clf;
    hold on;
    bar(abs(squErrNW)-abs(squErrW), "hist", 0.9);
    colormap(colors(8:11, :));
    
    set(gca, "xtick", 1:9);
    set(gca, "xticklabel", {"Exp", "Sig", "Lin", "Exp", "Sig", "Lin", "Exp", "Sig", "Lin"});
    ylabel("Squared Error");
    title(files(fi));
    ax = axis;
    ax(1) = 0.4;
    ax(2) = 9.6;
    axis(ax);
    text(1, ax(3)-(abs(ax(3))+abs(ax(4)))/12, "Random Sampling");

    text(3.8, ax(3)-(abs(ax(3))+abs(ax(4)))/12, "Uncertainty Sampling");
    text(7.8, ax(3)-(abs(ax(3))+abs(ax(4)))/12, "PAL");
    if(fi == 4)
        legend(methodNames(2:end), "location", "northeast");

    endif
    #}
    #print(["../Thesis/pics/squErrBar", files{fi}, ".pdf"]);
endfor
#}
