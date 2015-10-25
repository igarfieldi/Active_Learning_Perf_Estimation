function visualizeDensities(feat, lab, fig, i, imax)

	pwc = parzenWindowClassifier();
	pwc = setTrainingData(pwc, feat, lab, 2);

	r = linspace(0, 1, 100);
	[X, Y] = meshgrid(r, r);
	instances = [reshape(X, 1, rows(X)*columns(X)); reshape(Y, 1, rows(Y)*columns(Y))]';


	res = classifyInstances(pwc, instances);
	class = max(res) == res(1, :);

	figure(fig);
	dims = [ceil(sqrt(imax))];
	dims = [dims(1), ceil(imax / dims(1))];
	subplot(dims(1), dims(2), i);
	
	z = linspace(0, 1, 256)';
	cm = [z, zeros(256, 1), 1 .- z];
	cmap = colormap(cm);
	image([0, 1], [0, 1], reshape(ceil(res(1, :) * 256), length(r), length(r)));
	
	axis([0, 1, 0, 1], "off");
	

endfunction