1;
clc;

if(!exist("allMus") || isempty(allMus))
	load("results/allResults.mat", "allMus", "allVars", "allTimes");
endif

use = [2,3,4,5,6,7,12];
colors = [1,0,0;
		  1,0,1;
		  0.5,0.5,1;
		  0,1,1;
		  0,1,0;
		  1,1,0;
		  0,0,1];

files = {"checke1", "2dData", "seeds", "abalone"};
names = {"K-Fold CV", ".632+ BS", "path", "pathSuper", "averaged", "averagedBS", "pathSuperW"};

t = zeros(4,length(use));

for fi = 1:4
	for al = 1:3
        t(fi,:) += vec(mean(mean(allTimes{fi,al}(:,:,use))))';
	endfor
endfor

figure(1);
clf;
hold on;

caxis([1,length(use)]);
colormap(colors);

h = bar(t ./ 9, "histc", 0.95);

for i = 1:length(h)
	set(get(h(i), "children"), "cdata", i);
endfor

ax = axis();
ax(1) = 0.9;
ax(2) = 5.05;
axis(ax);

ylabel("Time in s");
title("Average computation time per dataset");
set(gca, "xtick", [1.455:1:4.455]);
set(gca, "xticklabel", files);

legend(names);

print("../Thesis/pics/timeAll.pdf");