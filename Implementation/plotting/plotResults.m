# usage: plotResults(mus, vars, figures)

function plotResults(mus, vars, figures, used, colors, names)

    if(nargin != 6)
        print_usage();
    elseif(!isvector(figures) || !isvector(used) || !ismatrix(colors)
            || !iscell(names))
        error("plotResults: requires 3d_mat, 3d_mat, vector, vector, matrix, cell");
    endif
    
    # disregard methods not used in evaluation
    used = (1:length(used)) .* used;
    used(used == 0) = [];
    mus = mus(:, :, used);
    vars = vars(:, :, used);
    colors = colors(used, :);
    names = names(used);
    
    # get the averages
    averMus = sum(mus, 1) ./ size(mus, 1);
    averVars = sum(vars, 1) ./ size(vars, 1);
    
    # compute difference, absolute error, squared error and variance
    averErrors = sum(mus .- mus(:, :, 1), 1) ./ size(mus, 1);
    averAbsErrors = sum(abs(mus .- mus(:, :, 1)), 1) ./ size(mus, 1);
    averSquErrors = sum((mus .- mus(:, :, 1)).^2, 1) ./ size(mus, 1);
    variance = var(mus);
    
    figure(figures(1));
    clf;
    hold on;
    for i = 1:size(mus, 3)
        plot(3:size(mus, 2), averMus(:, 3:end, i), "-", "color", colors(i, :));
    endfor
    title("Accuracies");
    xlabel("Training instances");
    ylabel("Accuracies");
    legend(names, "location", "southeast");
    axis([3, size(mus, 2), 0, 1]);
    
    figure(figures(2));
    clf;
    hold on;
    for i = 2:size(averErrors, 3)
        plot(3:size(averErrors, 2), averErrors(:, 3:end, i), "-", "color", colors(i, :));
    endfor
    title("Differences to hold-out");
    xlabel("Training instances");
    ylabel("Differences");
    legend(names(2:end), "location", "northeast");
    axis([3, size(averErrors, 2)]);
    
    figure(figures(3));
    clf;
    hold on;
    for i = 2:size(averSquErrors, 3)
        plot(3:size(averSquErrors, 2), averSquErrors(:, 3:end, i),
            "-", "color", colors(i, :));
    endfor
    title("Squared error");
    xlabel("Training instances");
    ylabel("err²");
    legend(names(2:end), "location", "northeast");
    axis([3, size(averSquErrors, 2)]);
    
    if(size(mus, 1) > 1)
        figure(figures(4));
        clf;
        hold on;
        for i = 1:size(variance, 3)
            plot(3:size(variance, 2), variance(:, 3:end, i),
                "-", "color", colors(i, :));
        endfor
        title("Squared error");
        xlabel("Training instances");
        ylabel("err²");
        legend(names(2:end), "location", "northeast");
        axis([3, size(variance, 2)]);
    endif

endfunction