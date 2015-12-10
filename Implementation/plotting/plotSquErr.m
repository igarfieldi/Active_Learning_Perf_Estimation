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
		  0.7,0.7,0;
		  0.5,0,0;
		  0.5,0,0.5;
		  0,0,0.5;
		  0,0.5,0.5;
		  0,0.5,0;
		  0.5,0.5,0];

use = [2,3,4,5,6,7];
files = {"checke1", "2dData", "seeds", "abalone"};

for fi = 4:4
	barData = [];
	for al = 1:3
		A = 1:100;
		if((fi == 4) && (al == 1))
			A(7) = [];
			A(69) = [];
		endif
		barData = [barData; vec(mean(mean((allMus{fi, al, 1}(A, 1:7, 1) .- allMus{fi, al, 1}(A, 1:7, use)).^2)))'];
		barData = [barData; vec(mean(mean((allMus{fi, al, 1}(A, 8:15, 1) .- allMus{fi, al, 1}(A, 8:15, use)).^2)))'];
		barData = [barData; vec(mean(mean((allMus{fi, al, 1}(A, 16:30, 1) .- allMus{fi, al, 1}(A, 16:30, use)).^2)))'];
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
	
	hRSP = zeros(6, 3);
	hUCP = zeros(6, 3);
	hPALP = zeros(6, 3);
	hRSN = zeros(6, 3);
	hUCN = zeros(6, 3);
	hPALN = zeros(6, 3);
	
	for j = 1:6
		hRSP(j, :) = bar([j-1, j], [0, 0, 0; barDataPos(1:3, j)'], "stacked", 1);
		hUCP(j, :) = bar([j+6, j+7], [0, 0, 0; barDataPos(4:6, j)'], "stacked", 1);
		hPALP(j, :) = bar([j+13, j+14], [0, 0, 0; barDataPos(7:9, j)'], "stacked", 1);
		hRSN(j, :) = bar([j-1, j], [0, 0, 0; barDataNeg(1:3, j)'], "stacked", 1);
		hUCN(j, :) = bar([j+6, j+7], [0, 0, 0; barDataNeg(4:6, j)'], "stacked", 1);
		hPALN(j, :) = bar([j+13, j+14], [0, 0, 0; barDataNeg(7:9, j)'], "stacked", 1);
		for i = 1:3
			set(get(hRSP(j, i),'children'),'cdata', (i-1)*6+j);
			set(get(hUCP(j, i),'children'),'cdata', (i-1)*6+j);
			set(get(hPALP(j, i),'children'),'cdata', (i-1)*6+j);
			set(get(hRSN(j, i),'children'),'cdata', (i-1)*6+j);
			set(get(hUCN(j, i),'children'),'cdata', (i-1)*6+j);
			set(get(hPALN(j, i),'children'),'cdata', (i-1)*6+j);
		endfor
	endfor
	
	ax = axis();
	ax(1) = 0.2;
	ax(2) = 20.8;
	axis(ax);
	ylabel("Summed Squared Error");
	title(["Spread for ", files{fi}, " w. exp. function; darker = larger training sets"]);
    set(gca, "xtick", [3.5, 10.5, 17.5]);
    set(gca, "xticklabel", {"Random", "Uncertainty", "PAL"});
	
	
	if(fi == 2)
		legend([hRSP(:, 1)], "K-Fold CV", ".632+ BS", "path", "pathSuper", "averaged", "averagedBS",
					"location", "northwest");
	endif
	
	print(["../Thesis/pics/squErr", files{fi}, ".pdf"]);
endfor