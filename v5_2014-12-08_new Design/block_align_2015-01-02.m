function [ alignedLine,results ] = block_align( results, kthFrame, pt1Ref, pt2Ref, uniThreshold )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
shftRange = 0:10;
nShftRange = length(shftRange);
expFs = 0.90:0.01:1.25;
%expFs = 1:0.01:1.15;
nExpFs = length(expFs);
pt1 = pt1Ref;
pt2 = pt2Ref;
cells1 = results(kthFrame).cells;
cells2 = results(kthFrame+1).cells;
stiLine2L = length(results(kthFrame+1).stitchedLine);
alignedLine = [];
alignedBody = [];
allExpFs = [];
tempCell = [];
allTempCell = [];
%fprintf('min expFs = ');
%% right side
nCell1 = length(cells1);
nCell2 = length(cells2);
while pt1 <= nCell1 && pt2 <= nCell2
    line1 = smooth(cells1(pt1).profile,5)';
    line2 = cells2(pt2).profile;
    [err2, ob21, ob22] = cmpBlock(line1,smooth(line2,5)', expFs, shftRange);
    err1 = inf;
    while err2 < err1
        pt2 = pt2 + 1;
        err1 = err2;    ob11 = ob21;    ob12 = ob22;
        if pt2 <= nCell2
            line3 = cells2(pt2).profile;
            line2 = [line2 line3];
            [err2, ob21, ob22] = cmpBlock(line1,smooth(line2,5)', expFs, shftRange);
        else
            err2 = inf;
        end
    end
    alignedLine = [alignedLine [ob11;ob12]];
    pt1 = pt1 + 1;
end
pt1 = pt1Ref-1;
pt2 = pt2Ref-1;
while pt1 > 0 && pt2 > 0
    line1 = smooth(cells1(pt1).profile,5)';
    line1 = line1(end:-1:1);
    line2 = cells2(pt2).profile;
    line2cmp = smooth(line2,5)';
    line2cmp = line2cmp(end:-1:1);
    [err2, ob21, ob22] = cmpBlock(line1,line2cmp, expFs, shftRange);
    err1 = inf;
    while err2 < err1
        pt2 = pt2 - 1;
        err1 = err2;    ob11 = ob21;    ob12 = ob22;
        if pt2 > 0
            line3 = cells2(pt2).profile;
            line2 = [line3 line2];
            line2cmp = smooth(line2,5)';
            line2cmp = line2cmp(end:-1:1);
            [err2, ob21, ob22] = cmpBlock(line1,line2cmp, expFs, shftRange);
        else
            err2 = inf;
        end
    end
    ob11 = ob11(end:-1:1);
    ob12 = ob12(end:-1:1);
    alignedLine = [[ob11;ob12] alignedLine];
    pt1 = pt1 - 1;
end
end

function [minErr, ob1, ob2] = cmpBlock(b1, b2, expFs, shftRange)
    nExpFs = length(expFs);
    nShftRange = length(shftRange);
    err_std = zeros(nExpFs,nShftRange);    
    line1 = cell(nExpFs,nShftRange);     line2 = cell(nExpFs,nShftRange);
    for kk = 1:nExpFs
        expCoeff = expFs(kk);
        line1Base = expand_trace (b1, expCoeff);
        for jj = 1:nShftRange
            line1{kk,jj} = [zeros(1,shftRange(jj)) line1Base];
            [line1{kk,jj} line2{kk,jj}] = cmpLines(line1{kk,jj},b2);
            err_std(kk,jj) = std(line1{kk,jj}-line2{kk,jj});
            err_std(kk,jj) = sum(abs(line1{kk,jj}-line2{kk,jj}));
        end
    end
    [minErr minkjLoc] = min(err_std(:));
    [minkLoc,minjLoc] = ind2sub([nExpFs nShftRange], minkjLoc);
    ob1 = line1{minkLoc,minjLoc};
    ob2 = line2{minkLoc,minjLoc};
end