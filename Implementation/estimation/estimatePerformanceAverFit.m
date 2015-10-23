# usage: [mu, var, beta] = estimatePerformanceAverFit(classifier, oracle,...
#                                                    functionTemplate,...
#                                                    bounds, inits)


function [mu, averages, func] = estimatePerformanceAverFit(classifier, oracle,
                                                    functionTemplate,
                                                    bounds, inits)

    mu = [];
	averages = [];
	func = [];
    
    if(nargin != 5)
        print_usage();
    elseif(!isa(classifier, "classifier") || !isa(oracle, "oracle")
            || !is_function_handle(functionTemplate)
            || !ismatrix(bounds) || !ismatrix(inits))
        error("estimatePerformanceFitting: requires classifier, oracle, \
function handle, matrix, matrix");
    endif
    
    # estimate the accuracies for all combinations of training/test set
    # with the queried instances
    [~, accumEstAccs] = estimateAccuraciesIter(classifier, oracle);
    # average the accuracies for every cell
	averages = [];
	for i = 1:length(accumEstAccs)
		averages = [averages, sum(accumEstAccs{i}(1, :) .* accumEstAccs{i}(2, :), 2)...
									/ sum(accumEstAccs{i}(2, :), 2)];
	endfor
    func = fitFunctionsIter(averages, functionTemplate, bounds, inits);
	
	#{
	figure(size(getQueriedInstances(oracle), 1)+3);
	hold on;
	X = linspace(1, length(averages), 1000);
	plot(X, functionTemplate(X, func), "-", "color", [0, 0, 1]);
	plot(1:length(averages), averages, "*", "color", [0, 0, 1]);
	
	axis([0, length(averages)+2, 0, 1]);
    #}
	if(isempty(func))
		mu = accumEstAccs(end);
	else
		mu = functionTemplate(length(accumEstAccs) + 2, func);
	endif

endfunction