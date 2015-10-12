# usage: storeAccuracies(path, accs)

function [iterations, samples, holdoutSize, data_file, orac, currAL, accumEstAccs,
	MCSamples, funcs, holdoutBetas, predictedBetas] = loadResults(file)

	if(nargin != 1)
		print_usage();
	endif
	
	if(!ischar(file))
		error("IO/storeResults: requires char, ...");
	endif
	
	res = load(file, "res");
	
	iterations = res.iterations;
	samples = res.samples;
	holdoutSize = res.holdoutSize;
	data_file = res.data_file;
	orac = res.orac;
	currAL = res.currAL;
	accumEstAccs = res.accumEstAccs;
	MCSamples = res.MCSamples;
	funcs = res.funcs;
	holdoutBetas = res.holdoutBetas;
	predictedBetas = res.predictedBetas;

endfunction