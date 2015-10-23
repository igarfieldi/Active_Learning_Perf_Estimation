# usage: frequencies = estimateKernelDensities(instances, samples, sigma, kernel)

function densities = estimateKernelDensities(instances, samples, sigma)

    densities = [];
    
    if(nargin == 3)
        if(!ismatrix(instances) || !ismatrix(samples) || !isscalar(sigma))
            error("@estimator/estimateKernelDensities(3): requires matrix, matrix, scalar");
        elseif(size(instances, 2) != size(samples, 2))
            error("@estimator/estimateKernelDensities(3): instances and samples must have same number of columns");
        endif
        kernel = @(x) sum(exp(-x .^ 2 ./ 2) ./ sqrt(2 * pi), 2);
    else
        print_usage();
    endif
	
	if(rows(samples) < 1)
		densities = zeros(1, rows(instances));
	else
		# estimate 'smoothness' based on Silverman's rule of thumb
		q = size(samples, 2);	# dimensions
		v = 2;					# kernel order (order of first non-zero moment)
		R = 0.28209;			# kernel roughness (int_{-Inf}{Inf} k(x)^2 dx
		Cv = (pi^(q/2)*2^(q+v-1)*factorial(v)^2*R^q/...
			(v*1*(doubleFactorial(2*v-1)+(q-1)*doubleFactorial(v-1)^2)))^(1/(2*v+q));
		bandwidth = sigma * Cv * size(samples, 1)^(-1/(2*v+q));
		
		# create matrices to match each instance with each sample
		sampleMat = repmat(samples, [rows(instances), 1]);
		instanceMat = reshape(repmat(instances', [rows(sampleMat)/rows(instances), 1]),
							 columns(sampleMat), rows(sampleMat))';
		
		# estimate the frequencies using the kernel provided (multivariate)
		densities = kernel((instanceMat .- sampleMat) ./ bandwidth);
		densities = reshape(densities, rows(samples), rows(instances));
		densities = sum(densities, 1) ./ (size(samples, 1) * bandwidth^q);
	endif
    
endfunction

 (pi^(q/2)*2^(q+v-1)*factorial(v)^2*R^q/(v*1*(doubleFactorial(2*v-1)+(q-1)*doubleFactorial(v-1)^2)))^(1/(2*v+q))