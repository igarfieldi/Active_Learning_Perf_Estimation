1;
clc;

if(!exist("allMus") || isempty(allMus))
	load("results/allResults.mat", "allMus", "allVars", "allTimes");
endif

colors = [0,0,1;
		  0,0,1;
		  0,0,1;
		  0,1,0;
		  0,1,0;
		  0,1,0;
		  1,0,0;
		  1,0,0;
		  1,0,0;];

colors2 = [1,0,1;
		  1,0,1;
		  1,0,1;
		  0,1,1;
		  0,1,1;
		  0,1,1;];

use = [2,3,4,5,6,7];
files = {"checke1", "2dData", "seeds", "abalone"};
names = {"pathSuper", "pathSuperW", "pathSuperNI", "averaged", "averagedW"};

func = 1;

for fi = 1:4
	figure(1);
	clf;
	hold on;
	h = zeros(5);
	
	h(1) = plot(3:10, mean(allMus{fi,1}(:,3:10,1) .- allMus{fi,1}(:,3:10,5)),
			"-", "color", colors((1-1)*3+1, :));
	h(2) = plot(3:10, mean(allMus{fi,1}(:,3:10,1) .- allMus{fi,1}(:,3:10,9)),
			"--", "color", colors((1-1)*3+2, :));
	h(3) = plot(3:10, mean(allMus{fi,1}(:,3:10,1) .- allMus{fi,1}(:,3:10,12)),
			"-*", "color", colors((1-1)*3+3, :), "markersize", 7);
	h(4) = plot(3:10, mean(allMus{fi,1}(:,3:10,1) .- allMus{fi,1}(:,3:10,6)),
			"-", "color", colors((3-1)*3+1, :));
	h(5) = plot(3:10, mean(allMus{fi,1}(:,3:10,1) .- allMus{fi,1}(:,3:10,10)),
			"--", "color", colors((3-1)*3+2, :));
	
	plot(3:10, zeros(1, 8), "-", "color", [0,0,0]);
	
	xlabel("Training set size");
	ylabel("Average Mean error");
	ax = axis();
	ax(1) = 3;
	ax(2) = 10;
	axis(ax);
	
	if(fi == 4)
		legend(h, names, "location", "southeast");
	endif
	
	print(["../Thesis/pics/meanErrLI", files{fi}, ".pdf"]);
endfor