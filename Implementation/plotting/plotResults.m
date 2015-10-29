# usage: plotResults(mus, vars, figures)

function plotResults(mus, vars, figures, colors, names)

    if(nargin != 5)
        print_usage();
    elseif(!isvector(figures))
        error("plotResults: requires 3d_mat, 3d_mat, vector, cell, cell");
    endif
    
    # get the averages
    averMus = sum(mus, 1) ./ size(mus, 1);
    averVars = sum(vars, 1) ./ size(vars, 1);
    
    # compute difference, absolute error and squared error
    averErrors = sum(mus .- mus(:, :, 1), 1) ./ size(mus, 1);
    averAbsErrors = sum(abs(mus .- mus(:, :, 1)), 1) ./ size(mus, 1);
    averSquErrors = sum((mus .- mus(:, :, 1)).^2, 1) ./ size(mus, 1);
    
    figure(figures(1));
    hold on;
    for i = 1:size(mus, 3)
        plot(3:size(mus, 2), averMus(:, 3:end, i), "-", "color", colors{i});
    endfor
    title("Accuracies");
    xlabel("Training instances");
    ylabel("Accuracies");
    legend(names, "location", "southeast");
    axis([3, size(mus, 2), 0, 1]);
    
    figure(figures(2));
    hold on;
    for i = 1:size(averErrors, 3)
        plot(3:size(averErrors, 2), averErrors(:, 3:end, i), "-", "color", colors{i});
    endfor
    title("Differences to hold-out");
    xlabel("Training instances");
    ylabel("Differences");
    legend(names, "location", "northeast");
    axis([3, size(averErrors, 2)]);
    
    figure(figures(3));
    hold on;
    for i = 1:size(averSquErrors, 3)
        plot(3:size(averSquErrors, 2), averSquErrors(:, 3:end, i),
            "-", "color", colors{i});
    endfor
    title("Squared error");
    xlabel("Training instances");
    ylabel("err²");
    legend(names, "location", "northeast");
    axis([3, size(averSquErrors, 2)]);

endfunction