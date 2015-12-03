1;
more off;
clc;

#{
figure(1);
clc;
hold on;
k = 6;
axis([0, k, 0, 1]);
box off;
grid on;
grid minor off;
xlabel("Subset size");
ylabel("Accuracy");
title("All possible accuracies for training subsets with k = 6");

dataX = [];
dataY = [];
for i = 1:k-1
	dataX = [dataX, i .* ones(1, k-i+1)];
	dataY = [dataY, (0:k-i) ./ (k-i)];
endfor

plot(dataX, dataY, "*", "markersize", 8);
print("../Thesis/pics/accDemonstration.pdf");
#}

plotClassPrediction3d([1, 1], [0, 0; 1.3, 0], 0.4, 2);
xlabel("X");
ylabel("Y");
zlabel("Kernel density");
title("Maximal KDEs for a grid of instances and their classification");
caxis([0, 256]);
colorbar("ytick", [0, 128, 256], "yticklabel", {"Neg. instance", "Ambiguous", "Pos. instance"});
print("../Thesis/pics/KDE3inst.pdf");