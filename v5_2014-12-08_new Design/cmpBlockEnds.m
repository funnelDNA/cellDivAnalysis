function [expF] = cmpBlockEnds(b1, b2, expFs)
    nExpFs = length(expFs);
    %nExpFs = length(shftRange);
    err_std = zeros(1,nExpFs);
    for kk = 1:nExpFs
        expCoeff = expFs(kk);
        line11 = expand_trace (b1, expCoeff);
        err_std(kk) = std(line11(1:length(b2)) - b2);
    end
    [minErr, minkLoc] = min(err_std);
    expF = expFs(minkLoc);
end