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
		  0.6,0.6,0;
		  0.9,0.9,0.9;
		  0.7,0.7,0.7;
		  0.4,0.4,0.4];

use = [2,3,13,5,15,25];
names = {"5-Fold CV", ".632+ BS", "path Sig", "pathSuper Exp", "averaged Sig", "averagedBS Lin", "3 - 7", "8 - 15", "16 - 30"};
files = {"checke1", "2dData", "seeds", "abalone"};

func = 1;

for fi = 1:1
	barData = [];
	for al = 1:3
		A = 1:size(allMus{fi, al}, 1);
		low = vec(mean(mean((allMus{fi, al}(A, 3:7, 1) .- allMus{fi, al}(A, 3:7, use)).^2)));
		mid = vec(mean(mean((allMus{fi, al}(A, 8:15, 1) .- allMus{fi, al}(A, 8:15, use)).^2)));
		high = vec(mean(mean((allMus{fi, al}(A, 16:30, 1) .- allMus{fi, al}(A, 16:30, use)).^2)));
		barData = [barData; 5/28*(low')];
		barData = [barData; 8/28*(mid')];
		barData = [barData; 15/28*(high')];
	endfor
	
	figure(1);
	clf;
	hold on;
	
	set(gca, "fontname", "roman");
	set(gca, "fontsize", 17);
	
	caxis([1,21]);
	colormap(colors);
	
	hRS = zeros(6, 3);
	hUC = zeros(6, 3);
	hPAL = zeros(6, 3);
	
	for j = 1:6
		hRS(j, :) = bar([j-1, j], [0,0,0;barData(1:3, j)'], "stacked", 1);
		hUC(j, :) = bar([j+6, j+7], [0,0,0;barData(4:6, j)'], "stacked", 1);
		hPAL(j, :) = bar([j+13, j+14], [0,0,0;barData(7:9, j)'], "stacked", 1);
		
		for k = 1:3
			set(get(hRS(j, k),'children'),'cdata', j+(k-1)*6);
			set(get(hUC(j, k),'children'),'cdata', j+(k-1)*6);
			set(get(hPAL(j, k),'children'),'cdata', j+(k-1)*6);
		endfor
	endfor
	
	hLow = bar(7, 0, "histc");
	hMid = bar(7, 0, "histc");
	hHigh = bar(7, 0, "histc");
	set(get(hLow, "children"), "cdata", 19);
	set(get(hMid, "children"), "cdata", 20);
	set(get(hHigh, "children"), "cdata", 21);
	
	ax = axis();
	ax(1) = 0.2;
	ax(2) = length(use)*3+2.8;
	plot([7,7], [-20,0.202], "color", [0,0,0], "--");
	plot([14,14], [-20,20], "color", [0,0,0], "--");
	
	ylabel("Average Squared Error");
	title(["Spread for ", files{fi}, ""]);
	
	axis(ax);
    set(gca, "xtick", [(1+length(use))/2, 7+(length(use)+1)/2, 14+(length(use)+1)/2]);
    set(gca, "xticklabel", {"Random", "Uncertainty", "PAL"});
	
	if(fi == 1)
		legend([hRS(:, 1)], names{1:length(use)}, "location", "northwest");
	elseif(fi == 2)
		legend([hLow; hMid; hHigh], names{length(use)+1:end}, "location", "northwest");
	endif
	
	print(["../Thesis/pics/squErr", files{fi}, ".pdf"]);
endfor