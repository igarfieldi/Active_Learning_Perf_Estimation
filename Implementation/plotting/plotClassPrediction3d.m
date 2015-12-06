# usage: plotClassPrediction3d(classifier, features, labels, fig)

function plotClassPrediction3d(posFeats, negFeats, sigma, fig)

    colorRes = 256;
    meshRes = 30;
        
    figure(fig);
    hold on;

    X = linspace(0, 1, colorRes)';
    colors = [max(1 .- 1.5*X, 0), zeros(colorRes, 1), max(1.5*X .- 0.5, 0)];
    cmap = colormap(colors);

    X = linspace(-0.5, 1.5, meshRes);
    [XX, YY] = meshgrid(X, X);
    insts = [vec(XX), vec(YY)];
    
    ZZ1 = estimateKernelDensities(insts, negFeats, sigma)';
    ZZ2 = estimateKernelDensities(insts, posFeats, sigma)';
    
    pwc = parzenWindowClassifier();
    pwc = setTrainingData(pwc, [negFeats; posFeats],
        [repmat(0, size(negFeats, 1), 1); repmat(1, size(posFeats, 1), 1)], 2);
    pwc = setSigma(pwc, sigma);
    U = classifyInstances(pwc, insts);
    
    ind = find(U(2, :) > U(1, :));
    ZZmax = 1;
    
    CC1 = round(colorRes * (0.5 - U(1, :)./ 2));
    CC2 = round(colorRes * (U(2, :) ./ 2 + 0.5));
    
    CC = CC1;
    CC(ind) = CC2(ind);
    CC = reshape(CC, size(XX));
    
    mesh(XX, YY, reshape(max(ZZ1, ZZ2), size(XX)), CC);
    
    view(-70, 40);
    
    box off;
    grid on;
    
endfunction