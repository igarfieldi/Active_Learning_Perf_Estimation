1;
clc;

if(!exist("allMus") || isempty(allMus))
	load("results/allResults.mat", "allMus", "allVars", "allTimes");
endif

figure(1);
clf;
hold on;

caxis([1,25]);
colormap(jet(25));

hist(vec(allTimes{1,1}(:,:,5)), 25);
set(get(get(gca, "children"), "children"), "cdata", 1:25);
ax = axis();
h = plot([0, 2*max(vec(allTimes{1,1}(:,:,5)))], repmat(mean(vec(allTimes{1,1}(:,:,5))), 2, 1), "-",
		"color", [0,0,0]);
axis(ax);
ylabel("Amount");
xlabel("Time in s");
title("Example histogram of computation time for pathSuper on checke1");
legend(h, "Average time", "location", "northeast");

print("../Thesis/pics/timeHistExample.pdf");