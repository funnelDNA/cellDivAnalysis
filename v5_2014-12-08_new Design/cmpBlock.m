function [minErr, ob1, ob2] = cmpBlock(b1, b2, expFs, shftRange, varargin)
if length(varargin) ~= 0
    adLv = varargin{1};
else
    adLv = 0;
end
    nExpFs = length(expFs);
    nShftRange = length(shftRange);
    err_std = zeros(nExpFs,nShftRange);
    line1 = cell(nExpFs,nShftRange);     line2 = cell(nExpFs,nShftRange);    
    %adLv = offLinePenalty;
    for kk = 1:nExpFs
        expCoeff = expFs(kk);
        line1Base = expand_trace (b1, expCoeff);
        for jj = 1:nShftRange
            line1{kk,jj} = [zeros(1,shftRange(jj)) line1Base];
            %[line1{kk,jj} line2{kk,jj}] = cmpLines(line1{kk,jj},b2,mean(line1{kk,jj})-offLinePenalty);
            [line1{kk,jj} line2{kk,jj}] = cmpLines(line1{kk,jj},b2,adLv);
            
            %err_std(kk,jj) = std(line1{kk,jj}-line2{kk,jj});
            %err_std(kk,jj) = sum(abs(line1{kk,jj}-line2{kk,jj}));
            err_std(kk,jj) = mean(abs(line1{kk,jj}-line2{kk,jj}));
            %err_std(kk,jj) = std((line1{kk,jj}-line2{kk,jj}));
        end
    end
    [minErr minkjLoc] = min(err_std(:));
    [minkLoc,minjLoc] = ind2sub([nExpFs nShftRange], minkjLoc);
    ob1 = line1{minkLoc,minjLoc};
    ob2 = line2{minkLoc,minjLoc};
end