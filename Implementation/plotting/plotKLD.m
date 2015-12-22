1;
clc;

if(!exist("allMus") || isempty(allMus))
	load("results/allResults.mat", "allMus", "allVars", "allTimes");
endif

colors = [1,0,0;
		  0.5,0.5,1;
		  0.8,0.8,1;
		  0,1,1;
		  0.4,1,0.8;
		  0.7,0,0;
		  0.3,0.3,0.7;
		  0.6,0.6,0.8;
		  0,0.7,0.7;
		  0.25,0.8,0.6;
		  0.5,0,0;
		  0,0,0.5;
		  0.2,0.2,0.5;
		  0,0.5,0.5;
		  0.1,0.5,0.3];

use = [2,13,17,23,27];
names = {"K-Fold CV", "path sig.", "pathW sig.", "pathSuper lin.", "pathSuperW lin."};
files = {"checke1", "2dData", "seeds", "abalone"};

func = 1;

for fi = 1:4
	barData = zeros(9, length(use));
	for al = 1:3
		KLD = zeros(30, length(use), 3);
		counter = zeros(30, length(use), 3);
		for j = 1:2
			for k = 3:7
				[p, q] = getBetaFromMuVar(allMus{fi, al, func}(j, k, 1), allVars{fi, al, func}(j, k, 1));
				
				for i = 1:length(use)
					[tp, tq] = getBetaFromMuVar(allMus{fi, al, func}(j, k, use(i)), allVars{fi, al, func}(j, k, use(i)));
					
					kld = computeKullbackLeiblerDivergence([p, tp], [q, tq], 10000);
					if(!isnan(kld))
						KLD(k, i, 1) += kld;
						counter(k, i, 1)++;
					endif
				endfor
			endfor
			for k = 8:15
				[p, q] = getBetaFromMuVar(allMus{fi, al, func}(j, k, 1), allVars{fi, al, func}(j, k, 1));
				
				for i = 1:length(use)
					[tp, tq] = getBetaFromMuVar(allMus{fi, al, func}(j, k, use(i)), allVars{fi, al, func}(j, k, use(i)));
					
					kld = computeKullbackLeiblerDivergence([p, tp], [q, tq], 10000);
					if(!isnan(kld))
						KLD(k, i, 2) += kld;
						counter(k, i, 2)++;
					endif
				endfor
			endfor
			for k = 16:30
				[p, q] = getBetaFromMuVar(allMus{fi, al, func}(j, k, 1), allVars{fi, al, func}(j, k, 1));
				
				for i = 1:length(use)
					[tp, tq] = getBetaFromMuVar(allMus{fi, al, func}(j, k, use(i)), allVars{fi, al, func}(j, k, use(i)));
					
					kld = computeKullbackLeiblerDivergence([p, tp], [q, tq], 10000);
					if(!isnan(kld))
						KLD(k, i, 3) += kld;
						counter(k, i, 3)++;
					endif
				endfor
			endfor
		endfor
		barData((al-1)*3+1, :) = vec(mean(KLD(:, :, 1) ./ max(1, counter(:, :, 1))))';
		barData((al-1)*3+2, :) = vec(mean(KLD(:, :, 2) ./ max(1, counter(:, :, 2))))';
		barData((al-1)*3+3, :) = vec(mean(KLD(:, :, 3) ./ max(1, counter(:, :, 3))))';
	endfor
	
	figure(1);
	clf;
	hold on;
	
	set(gca, "fontname", "roman");
	set(gca, "fontsize", 17);
	
	caxis([1,size(colors, 1)]);
	colormap(colors);
	
	hRS = zeros(length(use), 3);
	hUC = zeros(length(use), 3);
	hPAL = zeros(length(use), 3);
	
	for j = 1:length(use)
		hRS(j, :) = bar([j-1, j], [0, 0, 0; barData(1:3, j)'], "stacked", 1);
		hUC(j, :) = bar([j+length(use), j+length(use)+1], [0, 0, 0; barData(4:6, j)'], "stacked", 1);
		hPAL(j, :) = bar([j+2*length(use)+1, j+2*length(use)+2], [0, 0, 0; barData(7:9, j)'], "stacked", 1);
		for i = 1:3
			set(get(hRS(j, i),'children'),'cdata', (i-1)*length(use)+j);
			set(get(hUC(j, i),'children'),'cdata', (i-1)*length(use)+j);
			set(get(hPAL(j, i),'children'),'cdata', (i-1)*length(use)+j);
		endfor
	endfor
	
	
	ax = axis();
	ax(1) = 0.2;
	ax(2) = length(use)*3+2.8;
	plot([6,6], [0,30], "color", [0,0,0], "--");
	plot([12,12], [0,30], "color", [0,0,0], "--");
	axis(ax);
	ylabel("Average KL divergence");
	title(["KL divergence for ", files{fi}, "; darker = larger training sets"]);
    set(gca, "xtick", [(1+length(use))/2, (8+2*length(use)+1)/2, (17+2*length(use)+2)/2]);
    set(gca, "xticklabel", {"Random", "Uncertainty", "PAL"});
	
	if(fi == 2)
		legend([hRS(:, 2)], names, "location", "northwest");
	endif
	
	print(["../Thesis/pics/klDiv", files{fi}, ".pdf"]);
endfor