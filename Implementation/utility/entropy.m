function ret = entropy(p)

    ret = -sum(p ./ sum(p) .* log2(max(1, p) ./ sum(p)));

endfunction