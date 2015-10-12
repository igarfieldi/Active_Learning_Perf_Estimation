# usage: plotResults(regFuncs, funcHandle, samples, allAccs,
#								resPerOne, figInit)

function plotResults(regFuncs, funcHandle, samples, allAccs,
								holdoutBetas, predictedBetas,
								holdoutMu, predictedMu,
								holdoutVar, predictedVar,
								resPerOne, figInit)
	#{
	if(nargin == 7)
		if(!iscell(regFuncs) || !is_function_handle(funcHandle) || !iscell(samples)
			|| !iscell(allAccs) || !isscalar(resPerOne) || !isscalar(figInit))
			error("plotting/plotRegressedFunctions(5): requires cell, function handle, scalar, scalar, vector, scalar");
		endif
	else
		print_usage();
	endif
    #}
	
	for i = 1:length(regFuncs)
		# add space for the predicted and holdout betas
		totalSize = size(regFuncs{i}, 1) + 1;
		dims = [ceil(sqrt(totalSize))];
		dims = [dims(1), ceil(totalSize / dims(1))];
		
		figure(figInit++);
		
		title(sprintf("Total instances: %d", size(samples{i}, 2)));
		
		X = linspace(0, 1, resPerOne);
		subplot(dims(1), dims(2), totalSize);
		hold on;
		plot(X, betapdf(X, holdoutBetas(i, 1), holdoutBetas(i, 2)), "-", "color", [1, 0, 1]);
		plot(X, betapdf(X, predictedBetas(i, 1), predictedBetas(i, 2)), "-", "color", [0, 1, 0]);
		title("Beta distributions");
		
		
		allAccsPlot = [];
		for k = 1:length(allAccs{i})
			allAccsPlot = [allAccsPlot, [k .* ones(1, size(allAccs{i}{k}, 2)); allAccs{i}{k}(1, :)]];
		endfor
		
		X = linspace(0, size(samples{i}, 2) + 1, resPerOne * (size(samples{i}, 2) + 1));
		for j = 1:size(regFuncs{i}, 1)
			# create subplots
			subplot(dims(1), dims(2), j);
			hold on;
			
			# plot 1. all accuracies, 2. the currently fitted accuracies, 3. the curve,
			# 4. holdouts and predictions
			plot(allAccsPlot(1, :), allAccsPlot(2, :), "+", "color", [0, 0, 1]);
			plot(1:size(samples{i}, 2), samples{i}(j, :), "*", "color", [1, 0.3, 0.3]);
			
			plot(X, min(1, max(0, funcHandle(X, regFuncs{i}(j, :)))), "-", "color", [1, 0, 0]);
			plot(size(samples{i}, 2) + 1, holdoutMu(i), "+", "color", [1, 0, 1]);
			plot(size(samples{i}, 2) + 1, predictedMu(i), "+", "color", [0, 1, 0]);
			plot(size(samples{i}, 2) + 1, predictedMu(i) + predictedVar(i), "+", "color", [0, 0.6, 0]);
			plot(size(samples{i}, 2) + 1, predictedMu(i) - predictedVar(i), "+", "color", [0, 0.6, 0]);
			plot(size(samples{i}, 2) + 1, holdoutMu(i) + holdoutVar(i), "+", "color", [0.6, 0, 0.6]);
			plot(size(samples{i}, 2) + 1, holdoutMu(i) - holdoutVar(i), "+", "color", [0.6, 0, 0.6]);
			axis([0, size(samples{i}, 2) + 2, 0, 1]);
			xlabel("Training instances");
			ylabel("Estimated accuracy");
			title(sprintf("Sample: %d", j));
		endfor
	endfor
	
	figure(figInit);
	hold on;
	title("Average plot");
	
	plot(3:size(predictedBetas, 1)+2, holdoutMu, "*-", "color", [1, 0, 1]);
	plot(3:size(predictedBetas, 1)+2, predictedMu, "*-", "color", [0, 1, 0]);
	plot(3:size(predictedBetas, 1)+2, holdoutMu .- holdoutVar, "*", "color", [0.6, 0, 0.6]);
	plot(3:size(predictedBetas, 1)+2, holdoutMu .+ holdoutVar, "*", "color", [0.6, 0, 0.6]);
	plot(3:size(predictedBetas, 1)+2, predictedMu .- predictedVar, "*", "color", [0, 0.6, 0]);
	plot(3:size(predictedBetas, 1)+2, predictedMu .+ predictedVar, "*", "color", [0, 0.6, 0]);
	
	axis([0, size(predictedBetas, 1)+3, 0, 1]);

endfunction