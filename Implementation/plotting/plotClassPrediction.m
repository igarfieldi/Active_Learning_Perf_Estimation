# usage: 

function plotClassPrediction(classifier, features, labels, fig, index, maxI)

    if(nargin != 6)
        print_usage();
    elseif(!isa(classifier, "classifier") || !ismatrix(features) || !ismatrix(labels)
            || !isscalar(fig) || !isscalar(index) || !isscalar(maxI))
        error("plotClassPrediction: requires classifier, matrix, matrix, scalar, scalar, scalar");
    endif
    
    
    colorRes = 256;
    meshRes = 100;
    
    res = classifyInstances(classifier, features);
        
    figure(fig);
	
	dims = [ceil(sqrt(maxI))];
	dims = [dims(1), ceil(maxI / dims(1))];
	
	subplot(dims(1), dims(2), index);
    hold on;

    X = linspace(0, 1, colorRes)';
    colors = [1 .- X, zeros(colorRes, 1), X];
    cmap = colormap(colors);

    [XX, YY] = meshgrid(linspace(0, 1, meshRes), linspace(0, 1, meshRes));
    coords = [reshape(XX, rows(XX)*columns(XX), 1), reshape(YY, rows(YY)*columns(YY), 1)];
    coordRes = ceil(colorRes .* classifyInstances(classifier, coords)(2, :));

    image([0, 1], [0, 1], reshape(coordRes, meshRes, meshRes));
	
	[feat, labs] = getTrainingInstances(classifier);
    neg = feat(labs == 0, :);
    pos = feat(labs == 1, :);
    plot(neg(:, 1), neg(:, 2), ".", "markersize", 10,...
        "color", [0.8, 0, 0]);
    plot(pos(:, 1), pos(:, 2), ".", "markersize", 10,...
        "color", [0, 0, 0.8]);
    #{
    neg = features(nthargout(2, @max, res) == 1, :);
    pos = features(nthargout(2, @max, res) == 2, :);
    plot(neg(:, 1), neg(:, 2), ".", "markersize", 10, "color", [1, 0, 0]);
    plot(pos(:, 1), pos(:, 2), ".", "markersize", 9, "color", [0, 0, 1]);
    
    neg = features(labels == 0, :);
    pos = features(labels == 1, :);
    plot(neg(:, 1), neg(:, 2), "s", "markersize", 6, "linewidth", 2,...
        "color", [1, 0, 0]);
    plot(pos(:, 1), pos(:, 2), "s", "markersize", 6, "linewidth", 2,...
        "color", [0, 0, 1]);
    #}

endfunction