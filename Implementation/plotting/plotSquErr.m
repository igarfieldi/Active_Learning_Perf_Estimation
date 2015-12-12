1;
clc;

if(!exist("allMus") || isempty(allMus))
	load("results/allResults.mat", "allMus", "allVars", "allTimes");
endif

colors = [1,0,0;
		  1,0,1;
		  0.5,0.5,1;
		  0,1,1;
		  0,1,0;
		  1,1,0;
		  0.7,0,0;
		  0.7,0,0.7;
		  0.3,0.3,0.7;
		  0,0.7,0.7;
		  0,0.7,0;
		  0.8,0.8,0;
		  0.5,0,0;
		  0.5,0,0.5;
		  0,0,0.5;
		  0,0.5,0.5;
		  0,0.5,0;
		  0.6,0.6,0];

use = [2,3,4,5,6,7];
names = {"K-Fold CV", ".632+ BS", "path", "pathSuper", "averaged", "averagedBS"};
files = {"checke1", "2dData", "seeds", "abalone"};

func = 1;

for fi = 4:4
	barData = [];
	for al = 1:3
		A = 1:100;
		if((fi == 4) && (al == 1))
			A(7) = [];
			A(69) = [];
		endif
		barData = [barData; vec(mean(mean((allMus{fi, al, func}(A, 1:7, 1) .- allMus{fi, al, func}(A, 1:7, use)).^2)))'];
		barData = [barData; vec(mean(mean((allMus{fi, al, func}(A, 8:15, 1) .- allMus{fi, al, func}(A, 8:15, use)).^2)))'];
		barData = [barData; vec(mean(mean((allMus{fi, al, func}(A, 16:30, 1) .- allMus{fi, al, func}(A, 16:30, use)).^2)))'];
	endfor
	
	figure(1);
	clf;
	hold on;
	
	caxis([1,18]);
	colormap(colors);
	barDataPos = barData;
	barDataNeg = barData;
	barDataPos(barDataPos < 0) = 0;
	barDataNeg(barDataNeg >= 0) = 0;
	
	hRSP = zeros(length(use), 3);
	hUCP = zeros(length(use), 3);
	hPALP = zeros(length(use), 3);
	hRSN = zeros(length(use), 3);
	hUCN = zeros(length(use), 3);
	hPALN = zeros(length(use), 3);
	
	
	for j = 1:length(use)
		hRSP(j, :) = bar([j-1, j], [0, 0, 0; barDataPos(1:3, j)'], "stacked", 1);
		hUCP(j, :) = bar([j+length(use), j+length(use)+1], [0, 0, 0; barDataPos(4:6, j)'], "stacked", 1);
		hPALP(j, :) = bar([j+2*length(use)+1, j+2*length(use)+2], [0, 0, 0; barDataPos(7:9, j)'], "stacked", 1);
		hRSN(j, :) = bar([j-1, j], [0, 0, 0; barDataNeg(1:3, j)'], "stacked", 1);
		hUCN(j, :) = bar([j+length(use), j+7], [0, 0, 0; barDataNeg(4:6, j)'], "stacked", 1);
		hPALN(j, :) = bar([j+2*length(use)+1, j+2*length(use)+2], [0, 0, 0; barDataNeg(7:9, j)'], "stacked", 1);
		for i = 1:3
			set(get(hRSP(j, i),'children'),'cdata', (i-1)*length(use)+j);
			set(get(hUCP(j, i),'children'),'cdata', (i-1)*length(use)+j);
			set(get(hPALP(j, i),'children'),'cdata', (i-1)*length(use)+j);
			set(get(hRSN(j, i),'children'),'cdata', (i-1)*length(use)+j);
			set(get(hUCN(j, i),'children'),'cdata', (i-1)*length(use)+j);
			set(get(hPALN(j, i),'children'),'cdata', (i-1)*length(use)+j);
		endfor
	endfor
	
	ax = axis();
	ax(1) = 0.2;
	ax(2) = length(use)*3+2.8;
	axis(ax);
	ylabel("Summed Squared Error");
	title(["Spread for ", files{fi}, " w. exp. function; darker = larger training sets"]);
    set(gca, "xtick", [(1+length(use))/2, (8+2*length(use)+1)/2, (15+2*length(use)+2)/2]);
    set(gca, "xticklabel", {"Random", "Uncertainty", "PAL"});
	
	
	if(fi == 2)
		legend([hRSP(:, 2)], names, "location", "northwest");
	endif
	
	print(["../Thesis/pics/squErr", files{fi}, ".pdf"]);
endfor