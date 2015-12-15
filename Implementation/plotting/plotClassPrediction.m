# usage: plotClassPrediction(classifier, features, labels, fig)

function plotClassPrediction(classifier, features, labels, fig)

    if(nargin != 4)
        print_usage();
    elseif(!isa(classifier, "classifier") || !ismatrix(features) || !ismatrix(labels)
            || !isscalar(fig))
        error("plotting/plotClassPrediction: requires classifier, matrix, \
matrix, scalar");
    endif
    
    
    colorRes = 256;
    meshRes = 100;
    
    res = classifyInstances(classifier, features);
        
	#h = subplot(1,4,fig);
    h = figure(fig);
	hold on;

    X = linspace(0, 1, colorRes)';
    colors = [1 .- X, zeros(colorRes, 1), X];
    cmap = colormap(colors);

    X = linspace(0, 1, meshRes);
    [XX, YY] = meshgrid(X, X);
    coords = [reshape(XX, rows(XX)*columns(XX), 1), reshape(YY, rows(YY)*columns(YY), 1)];
    coordRes = classifyInstances(classifier, coords)(2, :);
    
    image([0, 1], [0, 1], ceil(colorRes .* reshape(coordRes, meshRes, meshRes)));
    
    
    neg = features(nthargout(2, @max, res) == 1, :);
    pos = features(nthargout(2, @max, res) == 2, :);
    plot(neg(:, 1), neg(:, 2), ".", "markersize", 10, "color", [0.5, 0, 0]);
    plot(pos(:, 1), pos(:, 2), ".", "markersize", 9, "color", [0, 0, 0.5]);
    
    neg = features(labels == 0, :);
    pos = features(labels == 1, :);
    plot(neg(:, 1), neg(:, 2), "s", "markersize", 6, "linewidth", 2,...
        "color", [1, 0, 0]);
    plot(pos(:, 1), pos(:, 2), "s", "markersize", 6, "linewidth", 2,...
        "color", [0, 0, 1]);
    
    axis("square");
	axis([0,1,0,1]);
	#set(h, "xtick", [0, 0.5, 1]);
	#set(h, "ytick", [0, 0.5, 1]);
	xlabel([num2str(fig*2+1), " instances"]);
    
endfunction