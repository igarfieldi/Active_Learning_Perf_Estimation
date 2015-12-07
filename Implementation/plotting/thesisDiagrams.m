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

#{
plotClassPrediction3d([1, 1], [0, 0; 1.3, 0], 0.4, 2);
xlabel("X");
ylabel("Y");
zlabel("Kernel density");
title("Maximal KDEs for a grid of instances and their classification");
caxis([0, 256]);
colorbar("ytick", [0, 128, 256], "yticklabel", {"Neg. instance", "Ambiguous", "Pos. instance"});
print("../Thesis/pics/KDE3inst.pdf");
#}

#{
load("data/2dData.mat", "X", "Y");
labInd = randperm(size(X, 1), 5);
unlabInd = setdiff(1:size(X, 1), labInd);
labFeat = X(labInd, :);
labLab = Y(labInd);
pwc = parzenWindowClassifier();
pwc = setTrainingData(pwc, labFeat, labLab, 2);
[~, ~, labLabInd] = getTrainingInstances(pwc);
# get unlabeled instances
unlabFeat = X(unlabInd, :);
unlabLab = Y(unlabInd);

# calculate label statistics
nx = estimateKernelFrequencies(unlabFeat, labFeat);
py = [];
old = 1;
for i = 1:2
    py = [py; estimateKernelFrequencies(unlabFeat,...
                labFeat(old:labLabInd(i), :))];
    old = labLabInd(i) + 1;
endfor

pmax = (max(py)+10^(-30)) ./ (nx+2*10^(-30));

dx = estimateKernelFrequencies(unlabFeat, [labFeat; unlabFeat]);
dx ./ sum(dx);

pgain = OPALgain(nx, pmax, 0.5, 1) .* dx;

minp = min(pgain);
maxp = max(pgain);

mappedgain = (pgain - minp) ./ (maxp - minp);


figure(3);
clf;
hold on;

for i = 1:size(pgain, 2)
  plot(X(unlabInd(i), 1), X(unlabInd(i), 2), ".", "markersize", 4, "color", [0, mappedgain(i), 0]);
endfor

for i = 1:length(labInd)
  plot(X(labInd(i), 1), X(labInd(i), 2), ".", "markersize", 13, "color", [(Y(labInd(i)) == 0), 0, (Y(labInd(i)) == 1)]);
endfor

title("Probabilistic classifier improval for instances on the 2dData set");
cm = [repmat(0, 128, 1), linspace(0, 1, 128)', repmat(0, 128, 1)];
colormap(cm);
caxis([0, 128]);
colorbar("ytick", [0, 128], "yticklabel", {"Low gain", "High gain"});
print("../Thesis/pics/PALIllustration.pdf");
#}

#{
load("checke1.mat", "X", "Y");
figure(4);
clf;
hold on;
posInd = find(Y == 1);
negInd = find(Y == 0);
plot(X(posInd, 1), X(posInd, 2), ".", "markersize", 6, "color", [0, 0, 1]);
plot(X(negInd, 1), X(negInd, 2), ".", "markersize", 6, "color", [1, 0, 0]);
xlabel("X");
ylabel("Y");
title(["checke1 set (", num2str(size(X, 1)), " Instances)"]);
legend({"positive instances", "negative instances"}, "location", "southeast");
print("../Thesis/pics/checke1Illustration.pdf");
#}
#{
dataset = "abaloneReduced";
load(["data/", dataset, ".mat"], "X", "Y");
posInd = find(Y == 1);
negInd = find(Y == 0);
lowD = tsne(X, [], 2, [], []);
figure(5);
clf;
hold on;

plot(lowD(posInd, 1), lowD(posInd, 2), ".", "markersize", 7, "color", [0, 0, 1]);
plot(lowD(negInd, 1), lowD(negInd, 2), ".", "markersize", 7, "color", [1, 0, 0]);
xlabel("X");
ylabel("Y");
title(["Two-dimensional t-SNE repesentation of the ", dataset, " set (", num2str(size(X, 1)), " instances)"]);
legend({"positive instances", "negative instances"}, "location", "southeast");
print(["../Thesis/pics/", dataset, "Illustration.pdf"]);
#}
figure(1);
clf;
hold on;
z = linspace(1, 10, 10000);
a1 = @(x) x .^ 2;
a2 = @(x) gamma(x+1);
semilogy(z, a1(z), "color", [1, 0, 0]);
semilogy(z, a2(z), "color", [0, 0, 1]);
xlabel("x");
ylabel("f(x)");
legend({"f(x) = x^2", "f(x) = x!"}, "location", "northwest");
title("Curve progression");
print("../Thesis/pics/squareFacDiff.pdf");