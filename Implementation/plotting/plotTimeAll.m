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
		  0.4,0.8,0.9;
		  0.7,0,0;
		  0.7,0,0.7;
		  0.3,0.3,0.7;
		  0,0.7,0.7;
		  0,0.7,0;
		  0.8,0.8,0;
		  0.25,0.5,0.7;
		  0.5,0,0;
		  0.5,0,0.5;
		  0,0,0.5;
		  0,0.5,0.5;
		  0,0.5,0;
		  0.6,0.6,0;
		  0.1,0.2,0.5];

files = {"checke1", "2dData", "seeds", "abalone"};
names = {"K-Fold CV", ".632+ BS", "path", "pathSuper", "averaged", "averagedBS", "pathSuperW"};

t = zeros(4,length(use),3);

for fi = 1:4
	for al = 1:3
        t(fi,:,1) += vec(mean(mean(allTimes{fi,al}(:,1:7,use))))';
        t(fi,:,2) += vec(mean(mean(allTimes{fi,al}(:,8:15,use))))';
        t(fi,:,3) += vec(mean(mean(allTimes{fi,al}(:,16:30,use))))';
	endfor
endfor

figure(1);
clf;
hold on;

set(gca, "fontname", "roman");
set(gca, "fontsize", 17);

caxis([1,size(colors, 1)]);
colormap(colors);

h = zeros(length(use), 4, 3);

for i = 1:length(use)
	for fi = 1:4
		h(i, fi, :) = bar([(fi-1)*(length(use)+1)+i-1,(fi-1)*(length(use)+1)+i], [0,0,0; vec(t(fi,i,:))'], "stacked", 1);
		for j = 1:3
			set(get(h(i,fi,j), 'children'),'cdata', (j-1)*length(use)+i);
		endfor
	endfor
endfor

ax = axis();
ax(1) = 0.4;
ax(2) = length(use)*4+4.6;
plot([8,8], [0,3000], "color", [0,0,0], "--");
plot([16,16], [0,3000], "color", [0,0,0], "--");
plot([24,24], [0,3000], "color", [0,0,0], "--");
axis(ax);

ylabel("Time in s");
title("Average computation time per dataset");
set(gca, "xtick", [5:8:30]);
set(gca, "xticklabel", files);

legend(h(:,1,2), names);

print("../Thesis/pics/timeAll.pdf");