# usage: [feat, lab] = getLabeledInstances(activeLearner)

function [feat, lab] = getLabeledInstances(activeLearner)

    if(nargin != 1)
        print_usage();
    elseif(!isa(activeLearner, "activeLearner"))
        error("@activeLearner/getLabeledInstances: requires activeLearner");
    endif
    
    feat = activeLearner.features;
    lab = activeLearner.labels;

endfunction