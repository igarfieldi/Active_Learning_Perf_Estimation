1;
more off;
clc;

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

# TODO: graph showing some estimation paths
# TODO: graph showing the difference between weighted and unweighted acc curve
# TODO: showcase no-information rate