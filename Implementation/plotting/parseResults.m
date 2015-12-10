1;
clc;
more off;
warning("off");

dataDir = "./data/";
resDir = "./results/";

addpath(genpath(pwd()));

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


colors2 = [0, 0, 0;
          0.6, 0.4, 0.4;
          1, 0.4, 0.4;
          0.4, 0.4, 0.4;
          0.4, 0.6, 0.6;
          0.4, 0.8, 0.8;
          0.4, 1, 1;
          0.4, 0.4, 0;
          0.4, 0.6, 0;
          0.4, 0.8, 0;
          0.4, 1, 0;
          0.4, 0, 1];

colors3 = [0, 0, 0;
          0.6, 0.6, 0.6;
          1, 0.6, 0.6;
          0.6, 0.4, 0.4;
          0.6, 0.6, 0.6;
          0.6, 0.8, 0.8;
          0.6, 1, 1;
          0.6, 0.4, 0;
          0.6, 0.6, 0;
          0.6, 0.8, 0;
          0.6, 1, 0;
          0.6, 0, 1];

methodNames = {"Holdout", "K-fold CV", ".632+ BS",...
                    "path", "pathSuper", "averaged", "averagedBS",...
                    "pathW", "pathSuperW", "averagedW", "averagedBSW",...
                    "pathSuperWNI"};

testParams.useMethod = [1, 1, 1,...
                        1, 1, 1, 1,...
                        1, 1, 1, 1,...
                        0, 0, 0, 0,...
                        0, 1, 0, 0];

files = {"checke1", "2dData", "seeds", "abaloneReduced"};
ALs = {"RS", "UC", "PAL"};
if(!exist("allMus") || isempty(allMus))
	load("results/allResults.mat", "allMus", "allVars", "allTimes");
endif

used = (1:length(testParams.useMethod)) .* testParams.useMethod;
used(used == 0) = [];
iter = 1:30;

for fi = 1:4
	disp(fi);
    squErrL = [];
    meanErrL = [];
    squErrM = [];
    meanErrM = [];
    squErrH = [];
    meanErrH = [];
    for al = 1:1
        for fu = 1:3
            T1L = [];
            T2L = [];
            T1M = [];
            T2M = [];
            T1H = [];
            T2H = [];
            A = 1:100;
            if((fi == 4) && (al == 1) && (fu == 1))
                A(7) = [];
            elseif((fi == 4) && (al == 3) && (fu == 3))
                A(72) = [];
            endif
            for i = [2:11, 17]
                T1L = [T1L, mean(mean((allMus{fi, al, fu}(A, 1:7, 1) .- allMus{fi, al, fu}(A, 1:7, i)).^2))];
                T2L = [T2L, mean(mean((allMus{fi, al, fu}(A, 1:7, 1) .- allMus{fi, al, fu}(A, 1:7, i))))];
                T1M = [T1M, mean(mean((allMus{fi, al, fu}(A, 8:15, 1) .- allMus{fi, al, fu}(A, 8:15, i)).^2))];
                T2M = [T2M, mean(mean((allMus{fi, al, fu}(A, 8:15, 1) .- allMus{fi, al, fu}(A, 8:15, i))))];
                T1H = [T1H, mean(mean((allMus{fi, al, fu}(A, 16:30, 1) .- allMus{fi, al, fu}(A, 16:30, i)).^2))];
                T2H = [T2H, mean(mean((allMus{fi, al, fu}(A, 16:30, 1) .- allMus{fi, al, fu}(A, 16:30, i))))];
            endfor
            squErrL = [squErrL; T1L];
            meanErrL = [meanErrL; T2L];
            squErrM = [squErrM; T1M];
            meanErrM = [meanErrM; T2M];
            squErrH = [squErrH; T1H];
            meanErrH = [meanErrH; T2H];
        endfor
    endfor
    figure(fi);
    clf;
    hold on;
	#caxis([1,3]);
	colormap([0,0,0.6; 0,0.7,0; 0.7,0,0]);
	#caxis([1, 3*size(colors, 1)]);
    #colormap([colors;colors2;colors3]);
	h = bar(1:2, [squErrL(1, 1:2)', squErrM(1, 1:2)', squErrH(1, 1:2)'], "stacked");
	#set(get(h(1),'children'),'cdata', [2;3]);
	#set(get(h(2),'children'),'cdata', [14;15]);
	#set(get(h(3),'children'),'cdata', [26;27]);
	h = bar(4:12, [squErrL(1, 3:end)', squErrM(1, 3:end)', squErrH(1, 3:end)'], "stacked", 1);
	#set(get(h(1),'children'),'cdata', (4:12)');
	#set(get(h(2),'children'),'cdata', (16:24)');
	#set(get(h(3),'children'),'cdata', (28:36)');
	h = bar(14:22, [squErrL(2, 3:end)', squErrM(2, 3:end)', squErrH(2, 3:end)'], "stacked", 1);
	#set(get(h(1),'children'),'cdata', (4:12)');
	#set(get(h(2),'children'),'cdata', (16:24)');
	#set(get(h(3),'children'),'cdata', (28:36)');
	h = bar(24:32, [squErrL(3, 3:end)', squErrM(3, 3:end)', squErrH(3, 3:end)'], "stacked", 1);
	#set(get(h(1),'children'),'cdata', (4:12)');
	#set(get(h(2),'children'),'cdata', (16:24)');
	#set(get(h(3),'children'),'cdata', (28:36)');
	box off;
	grid on;
    set(gca, "xtick", [1.5, 8, 18, 28]);
    set(gca, "xticklabel", {"Reference", "Exp", "Sig", "Lin"});
    ylabel("Summed Squared Error");
    title([ALs{al}, " - ", files(fi)]);
    ax = axis;
    ax(1) = 0;
    ax(2) = 33;
    axis(ax);
    if(fi == 1)
        legend({"1-7","8-15","16-30"}, "location", "northeast");
    endif
    print(["../Thesis/pics/squErrBar", files{fi}, ALs{al}, ".pdf"]);
	
    figure(fi+4);
    clf;
    hold on;
	colormap([0,0,0.6; 0,0.7,0; 0.7,0,0]);
	caxis([1,3]);
	#caxis([1, 3*size(colors, 1)]);
    #colormap([colors;colors2;colors3]);
	meanErr = [mean(meanErrL(:, :)); mean(meanErrM(:, :)); mean(meanErrH(:, :))]';
	pos = find(meanErr >= 0);
	neg = find(meanErr < 0);
	meanPos = meanErr;
	meanNeg = meanErr;
	meanPos(neg) = 0;
	meanNeg(pos) = 0;
	h1 = bar(1:2, meanPos(1:2, :), "stacked");
	set(get(h1(1),'children'),'cdata', [1;1]);
	set(get(h1(2),'children'),'cdata', [2;2]);
	set(get(h1(3),'children'),'cdata', [3;3]);
	h2 = bar(1:2, meanNeg(1:2, :), "stacked");
	set(get(h2(1),'children'),'cdata', [1;1]);
	set(get(h2(2),'children'),'cdata', [2;2]);
	set(get(h2(3),'children'),'cdata', [3;3]);
	for i = 1:3
		meanErr = [meanErrL(i, :); meanErrM(i, :); meanErrH(i, :)]';
		pos = find(meanErr >= 0);
		neg = find(meanErr < 0);
		meanPos = meanErr;
		meanNeg = meanErr;
		meanPos(neg) = 0;
		meanNeg(pos) = 0;
		h1 = bar(3+i + ((i-1)*9:i*9-1), meanPos(3:end, :), "stacked", 1);
		set(get(h1(1),'children'),'cdata', repmat(1,9,1));
		set(get(h1(2),'children'),'cdata', repmat(2,9,1));
		set(get(h1(3),'children'),'cdata', repmat(3,9,1));
		h2 = bar(3+i + ((i-1)*9:i*9-1), meanNeg(3:end, :), "stacked", 1);
		set(get(h2(1),'children'),'cdata', repmat(1,9,1));
		set(get(h2(2),'children'),'cdata', repmat(2,9,1));
		set(get(h2(3),'children'),'cdata', repmat(3,9,1));
	endfor
	box off;
	grid on;
    set(gca, "xtick", [1.5, 8, 18, 28]);
    set(gca, "xticklabel", {"Reference", "Exp", "Sig", "Lin"});
    ylabel("Summed Mean Error");
    title([ALs{al}, " - ", files(fi)]);
    ax = axis;
    ax(1) = 0;
    ax(2) = 33;
    axis(ax);
    if(fi == 1)
        legend({"1-7","8-15","16-30"}, "location", "northeast");
    endif
    print(["../Thesis/pics/meanErrBar", files{fi}, ALs{al}, ".pdf"]);
    
    #{
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
	#}
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
