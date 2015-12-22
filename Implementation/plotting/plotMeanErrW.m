1;
clc;

if(!exist("allMus") || isempty(allMus))
	load("results/allResults.mat", "allMus", "allVars", "allTimes");
endif

colors = [1,0,0;
		  1,0,1;
		  0.5,0.5,1;
		  0.5,0.5,1;
		  0,1,1;
		  0,1,1;
		  0,1,1;
		  0,1,0;
		  0,1,0;
		  1,1,0;
		  1,1,0;
		  0.7,0,0;
		  0.7,0,0.7;
		  0.3,0.3,0.7;
		  0.3,0.3,0.7;
		  0,0.7,0.7;
		  0,0.7,0.7;
		  0,0.7,0.7;
		  0,0.7,0;
		  0,0.7,0;
		  0.8,0.8,0;
		  0.8,0.8,0;
		  0.5,0,0;
		  0.5,0,0.5;
		  0,0,0.5;
		  0,0,0.5;
		  0,0.5,0.5;
		  0,0.5,0.5;
		  0,0.5,0.5;
		  0,0.5,0;
		  0,0.5,0;
		  0.6,0.6,0;
		  0.6,0.6,0];

use = [2,3,13,17,23,27,30,15,19,25,29];
xc = [1,2,4,5,7,8,9,11,12,14,15];
files = {"checke1", "2dData", "seeds", "abalone"};
names = {"K-Fold CV", ".632+ BS", "path Sig", "pathSuper Lin", "averaged Sig", "averagedBS Lin."};

for fi = 1:4
	barData = [];
	for al = 1:1
		barData = [barData; vec(mean(mean(allMus{fi, al}(:, 3:7, 1) .- allMus{fi, al}(:, 3:7, use))))'];
		barData = [barData; vec(mean(mean(allMus{fi, al}(:, 8:15, 1) .- allMus{fi, al}(:, 8:15, use))))'];
		barData = [barData; vec(mean(mean(allMus{fi, al}(:, 16:30, 1) .- allMus{fi, al}(:, 16:30, use))))'];
	endfor
	
	figure(1);
	clf;
	hold on;
	set(gca, "fontname", "roman");
	set(gca, "fontsize", 17);
	caxis([1,size(colors,1)]);
	colormap(colors);
	barDataPos = barData;
	barDataNeg = barData;
	barDataPos(barDataPos < 0) = 0;
	barDataNeg(barDataNeg >= 0) = 0;
	
	hRSP = zeros(length(use), 3);
	hRSN = zeros(length(use), 3);
	
	plot([4.5,4.5], [-1,0], "--", "color", [0,0,0]);
	plot([9.5,9.5], [-1,0], "--", "color", [0,0,0]);
	plot([12.5,12.5], [-1,0], "--", "color", [0,0,0]);
	
	for j = 1:length(use)
		hRSP(j, :) = bar([xc(j)-1, xc(j)], [0, 0, 0; barDataPos(1:3, j)'], "histc", 1);
		hRSN(j, :) = bar([xc(j)-1, xc(j)], [0, 0, 0; barDataNeg(1:3, j)'], "histc", 1);
		for i = 1:3
			set(get(hRSP(j, i),'children'),'cdata', (i-1)*length(use)+j);
			set(get(hRSN(j, i),'children'),'cdata', (i-1)*length(use)+j);
		endfor
	endfor
	
	ax = axis();
	ax(1) = 0.5;
	ax(2) = 16.5;
	ax(3) = min(min(barData))*1.2;
	ax(4) = max(max(barData))*1.2;
	axis(ax);
	ylabel("Average Mean Error");
	title(["Bias for ", files{fi}, "; darker = larger training sets"]);
    set(gca, "xtick", [4.5,9.5,12.5]);
    set(gca, "xticklabel", {"unweighted", "NI-rate", "weighted"});
	
	
	if(fi == 1)
		legend([hRSP([1,2,3,5,8,10], 2)], names, "location", "northeast");
	endif
	
	print(["../Thesis/pics/meanErrWeighting", files{fi}, ".pdf"]);
endfor