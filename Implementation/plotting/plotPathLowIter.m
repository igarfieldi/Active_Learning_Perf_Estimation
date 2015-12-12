1;
clc;

if(!exist("allMus") || isempty(allMus))
	load("results/allResults.mat", "allMus", "allVars", "allTimes");
endif

colors = [0,0,1;
		  0.1,0.2,1;
		  0.2,0.3,1;
		  0,1,0;
		  0.2,1,0.1;
		  0.3,0.8,0.2;
		  1,0,0;
		  0.8,0.1,0.2;
		  0.6,0.2,0.3];

colors = [0,0,1;
		  0,0,1;
		  0,0,1;
		  0,1,0;
		  0,1,0;
		  0,1,0;
		  1,0,0;
		  1,0,0;
		  1,0,0;];

use = [2,3,4,5,6,7];
files = {"checke1", "2dData", "seeds", "abalone"};

func = 1;

for fi = 1:4
	figure(1);
	clf;
	hold on;
	h = zeros(4,3);
	for al = 1:3
		h(al, 1) = plot(3:10, mean(allMus{fi,al,func}(:,3:10,1) .- allMus{fi,al,func}(:,3:10,5)),
				"-", "color", colors((al-1)*3+1, :));
		h(al, 2) = plot(3:10, mean(allMus{fi,al,func}(:,3:10,1) .- allMus{fi,al,func}(:,3:10,9)),
				"--", "color", colors((al-1)*3+2, :));
		h(al, 3) = plot(3:10, mean(allMus{fi,al,func}(:,3:10,1) .- allMus{fi,al,func}(:,3:10,17)),
				"-*", "color", colors((al-1)*3+3, :), "markersize", 7);
	endfor
	
	plot(3:10, zeros(1, 8), "-", "color", [0,0,0]);
	
	xlabel("Training set size");
	ylabel("Mean error");
	ax = axis();
	ax(1) = 3;
	ax(2) = 10;
	axis(ax);
	
	if(fi == 1)
		legend([h(:, 1)', h(1,:)], "Random", "Uncertainty", "PAL",
				"path", "pathSuper", "pathSuperW", "location", "northeast");
	endif
	
	print(["../Thesis/pics/meanErrLI", files{fi}, ".pdf"]);
endfor