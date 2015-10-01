# usage: frequencies = estimateKernelFrequencies(instances, samples, kernel)

function frequencies = estimateKernelFrequencies(instances, samples, kernel)

    frequencies = [];
    
    if(nargin == 3)
        if(!ismatrix(instances) || !ismatrix(samples) || !is_function_handle(kernel))
            error("@estimator/estimateKernelFrequency(3): requires matrix, matrix, function_handle");
        elseif(size(instances, 2) != size(samples, 2))
            error("@estimator/estimateKernelFrequency(3): instances and samples must have same number of columns");
        endif
    elseif(nargin == 2)
        if(!ismatrix(instances) || !ismatrix(samples))
            error("@estimator/estimateKernelFrequency(2): requires matrix, matrix");
        elseif(size(instances, 2) != size(samples, 2))
            error("@estimator/estimateKernelFrequency(2): instances and samples must have same number of columns");
        endif
        kernel = @(x, n) exp(-sum(x .^ 2, 2) ./ 2);
    else
        print_usage();
    endif
	
	if(rows(samples) < 1)
		frequencies = zeros(1, rows(instances));
	else
		# create matrices to match each instance with each sample
		sampleMat = repmat(samples, [rows(instances), 1]);
		instanceMat = reshape(repmat(instances', [rows(sampleMat)/rows(instances), 1]),
							 columns(sampleMat), rows(sampleMat))';
		
		# estimate the frequencies using the kernel provided
		frequencies = kernel(instanceMat .- sampleMat, rows(samples));
		frequencies = reshape(frequencies, rows(samples), rows(instances));
		frequencies = sum(frequencies, 1);
	endif
    
endfunction