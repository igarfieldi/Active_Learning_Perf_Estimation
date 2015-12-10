1;
clc;
clear;
more off;
warning("off");

addpath(genpath(pwd()));

files = {"checke1", "2dData", "seeds", "abaloneReduced"};
load("results/allResults.mat", "allMus", "allVars", "allTimes");

used = [5, 8, 17];
iter = 3:8;

al = 1;
fu = 1;

for fi = 1:4
    figure(fi);
    clf;
    hold on;
    
    plot(iter, mean(allMus{fi, al, fu}(:, iter, 1) .- allMus{fi, al, fu}(:, iter, 5)), "-", "color", [0, 1, 1]);
    plot(iter, mean(allMus{fi, al, fu}(:, iter, 1) .- allMus{fi, al, fu}(:, iter, 9)), "-", "color", [0, 1, 0]);
    plot(iter, mean(allMus{fi, al, fu}(:, iter, 1) .- allMus{fi, al, fu}(:, iter, 17)), "-", "color", [0, 0, 1]);
    
    plot(iter, zeros(1, length(iter)), "-", "color", [0,0,0]);
    title(files{fi});
    xlabel("Training set size");
    ylabel("Mean Error");
    if(fi == 1)
        legend({"pathSuper", "pathSuperW", "pathSuperWNI"}, "location", "southeast");
    endif
    print(["../Thesis/pics/meanErrLowIter", files{fi}, ".pdf"]);
endfor
