# usage: storeResults(file, iterations, samples, holdoutSize, data_file,
#		accumEstAccs, MCSamples, funcs, holdoutBetas, predictedBetas)

function storeResults(file, iterations, samples, holdoutSize, data_file,
	orac, currAL, accumEstAccs, MCSamples, funcs, holdoutBetas, predictedBetas)

	if(nargin != 12)
		print_usage();
	endif
	
	if(!ischar(file))
		error("IO/storeResults: requires char, ...");
	endif
	
	res.iterations = iterations;
	res.samples = samples;
	res.holdoutSize = holdoutSize;
	res.data_file = data_file;
	res.orac = orac;
	res.currAL = currAL;
	res.accumEstAccs = accumEstAccs;
	res.MCSamples = MCSamples;
	res.funcs = funcs;
	res.holdoutBetas = holdoutBetas;
	res.predictedBetas = predictedBetas;
	
	save(file, "res");

endfunction