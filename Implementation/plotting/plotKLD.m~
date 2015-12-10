1;
clc;
clear;
more off;
warning("off");

addpath(genpath(pwd()));

files = {"checke1", "2dData", "seeds", "abaloneReduced"};
load("results/allResults.mat", "allMus", "allVars", "allTimes");

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

used = [2, 4, 5, 8, 9];
iter = 3:8;

al = 1;
fu = 2;

for fi = 1:1
    
    KLD = zeros(30, length(used));
    counter = zeros(30, length(used));
    for j = 1:100
        disp(j);
        for k = 3:30
            [p, q] = getBetaFromMuVar(allMus{fi, al, fu}(j, k, 1), allVars{fi, al, fu}(j, k, 1));
            
            for i = 1:length(used)
                [tp, tq] = getBetaFromMuVar(allMus{fi, al, fu}(j, k, used(i)), allVars{fi, al, fu}(j, k, used(i)));
                
                kld = computeKullbackLeiblerDivergence([p, tp], [q, tq], 10000);
                if(!isnan(kld))
                    KLD(k, i) += kld;
                    counter(k, i)++;
                endif
            endfor
        endfor
    endfor
    KLD = KLD ./ counter;
    
    figure(fi);
    clf;
    hold on;
    
    for i = 1:length(used)
        plot(3:30, KLD(3:30, i), "-", "color", colors(used(i), :));
    endfor
    
    title(files{fi});
    #{
    xlabel("Training set size");
    ylabel("Mean Error");
    if(fi == 1)
        legend({"pathSuper", "pathSuperW", "pathSuperWNI"}, "location", "southeast");
    endif
    print(["../Thesis/pics/meanErrLowIter", files{fi}, ".pdf"]);
    #}
endfor
