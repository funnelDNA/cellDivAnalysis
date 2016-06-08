function [minErr, ob1, ob2] = cmpBlockL(b1, b2, expFs, shftRange, varargin)
if length(varargin) ~= 0
    adLv = varargin{1};
else
    adLv = 0;
end
    nExpFs = length(expFs);
    %nExpFs = length(shftRange);
    err_std = zeros(nExpFs,nExpFs);
    line1 = cell(nExpFs,nExpFs);     line2 = cell(nExpFs,nExpFs);    
    %adLv = offLinePenalty;
    halfP = round(length(b1)/2);
    b11 = b1(1:halfP);
    b12 = b1(halfP+1:end);
    for kk = 1:nExpFs
        expCoeff = expFs(kk);
        line11 = expand_trace (b11, expCoeff);
        for jj = 1:nExpFs
            if ~isempty(b12)
                line12 = expand_trace (b12, expCoeff);
            else
                line12 = b12;
            end
            line1{kk,jj} = [line11 line12];
            %[line1{kk,jj} line2{kk,jj}] = cmpLines(line1{kk,jj},b2,mean(line1{kk,jj})-offLinePenalty);
            [line1{kk,jj} line2{kk,jj}] = cmpLines(line1{kk,jj},b2,adLv);
            
            %err_std(kk,jj) = std(line1{kk,jj}-line2{kk,jj});
            %err_std(kk,jj) = sum(abs(line1{kk,jj}-line2{kk,jj}));
            %err_std(kk,jj) = mean(abs(line1{kk,jj}-line2{kk,jj}));
            err_std(kk,jj) = std((line1{kk,jj}-line2{kk,jj}));
        end
    end
    [minErr minkjLoc] = min(err_std(:));
    [minkLoc,minjLoc] = ind2sub([nExpFs nExpFs], minkjLoc);
    ob1 = line1{minkLoc,minjLoc};
    ob2 = line2{minkLoc,minjLoc};
end
