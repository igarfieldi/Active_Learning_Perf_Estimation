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

use = [2,3,13,14,15,16];
files = {"checke1", "2dData", "seeds", "abalone"};
names = {"5-Fold CV", ".632+ BS", "path", "pathSuper", "averaged", "averagedBS"};

for fi = 1:4
	barData = [];
	for al = 1:3
		barData = [barData; vec(mean(mean(allMus{fi, al}(:, 3:7, 1) .- allMus{fi, al}(:, 3:7, use))))'];
		barData = [barData; vec(mean(mean(allMus{fi, al}(:, 8:15, 1) .- allMus{fi, al}(:, 8:15, use))))'];
		barData = [barData; vec(mean(mean(allMus{fi, al}(:, 16:30, 1) .- allMus{fi, al}(:, 16:30, use))))'];
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
	
	hLowP = zeros(6, 3);
	hMidP = zeros(6, 3);
	hHighP = zeros(6, 3);
	hLowN = zeros(6, 3);
	hMidN = zeros(6, 3);
	hHighN = zeros(6, 3);
	
	for j = 1:6
		for k = 1:3
			hLowP(j, k) = bar([(j-1)*3+(k-1)*20,(j-1)*3+(k-1)*20+1], [0,barDataPos((k-1)*3+1, j)], "histc", 1);
			hMidP(j, k) = bar([(j-1)*3+(k-1)*20+1,(j-1)*3+(k-1)*20+2], [0,barDataPos((k-1)*3+2, j)], "histc", 1);
			hHighP(j, k) = bar([(j-1)*3+(k-1)*20+2,(j-1)*3+(k-1)*20+3], [0,barDataPos((k-1)*3+3, j)], "histc", 1);
			hLowN(j, k) = bar([(j-1)*3+(k-1)*20,(j-1)*3+(k-1)*20+1], [0,barDataNeg((k-1)*3+1, j)], "histc", 1);
			hMidN(j, k) = bar([(j-1)*3+(k-1)*20+1,(j-1)*3+(k-1)*20+2], [0,barDataNeg((k-1)*3+2, j)], "histc", 1);
			hHighN(j, k) = bar([(j-1)*3+(k-1)*20+2,(j-1)*3+(k-1)*20+3], [0,barDataNeg((k-1)*3+3, j)], "histc", 1);
			
			set(get(hLowP(j, k),'children'),'cdata', (1-1)*6+j);
			set(get(hMidP(j, k),'children'),'cdata', (1-1)*6+j);
			set(get(hHighP(j, k),'children'),'cdata', (1-1)*6+j);
			set(get(hLowN(j, k),'children'),'cdata', (1-1)*6+j);
			set(get(hMidN(j, k),'children'),'cdata', (1-1)*6+j);
			set(get(hHighN(j, k),'children'),'cdata', (1-1)*6+j);
		endfor
	endfor
	
	ax = axis();
	ax(1) = 0.2;
	ax(2) = 60.2;
	plot([20,20], [-1,1], "--", "color", [0,0,0]);
	plot([40,40], [-1,1], "--", "color", [0,0,0]);
	axis(ax);
	ylabel("Average Mean Error");
	title(["Bias for ", files{fi}, " w. sig. function"]);
	
	for j = 1:6
		for k = 1:3
			hatch(get(hMidP(j,k), "children"), 40, [0.1,0.1,0.1], '-', 6,1);
			hatch(get(hMidN(j,k), "children"), 40, [0.1,0.1,0.1], '-', 6,1);
			hatch(get(hHighP(j,k), "children"), 40, [0.1,0.1,0.1], '-', 4,1);
			hatch(get(hHighN(j,k), "children"), 40, [0.1,0.1,0.1], '-', 4,1);
			hatch(get(hHighP(j,k), "children"), -40, [0.1,0.1,0.1], '-', 4,1);
			hatch(get(hHighN(j,k), "children"), -40, [0.1,0.1,0.1], '-', 4,1);
		endfor
	endfor
	
    set(gca, "xtick", [10, 30, 50]);
    set(gca, "xticklabel", {"Random", "Uncertainty", "PAL"});
	
	
	if(fi == 1)
		legend([hMidP(:, 1)], names, "location", "northwest");
	endif
	
	print(["../Thesis/pics/meanErrSig", files{fi}, ".pdf"]);
	
endfor