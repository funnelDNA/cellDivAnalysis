function [ alignedLine, allLink, results ] = block_align( results, kthFrame, pt1Ref, pt2Ref, uniThreshold, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if length(varargin) ~= 0
    switch varargin{1}
        case 'single'
            cells1 = results(kthFrame).blockL;
            cells2 = results(kthFrame).blockS;
        case 'double'
            cells1 = results(kthFrame).blockL;
            cells2 = results(kthFrame+1).blockS;
    end
end
hold off;
shftRange = 0:10;
expFs = 0.9:0.02:1.25;
shftRange = 0:2:10;
smoothLevel = 3;
% expFs = 0.90:0.02:1.25;
pt1 = pt1Ref;
pt2 = pt2Ref;
alignedLine = [];
allLink = {};
%% right side
nCell1 = length(cells1);
nCell2 = length(cells2);
x0 = 1;
while pt1 <= nCell1 && pt2 <= nCell2
    dLink = [];
    line1 = smooth(cells1(pt1).profile,smoothLevel)';
    line2 = cells2(pt2).profile;
    [err2, ob21, ob22] = cmpBlock(line1,smooth(line2,smoothLevel)', expFs, shftRange);
    err1 = inf;
    while err2 < err1
        dLink = [dLink pt2];
        pt2 = pt2 + 1;
        err1 = err2;    ob11 = ob21;    ob12 = ob22;
        if pt2 <= nCell2
            line3 = cells2(pt2).profile;
            line2 = [line2 line3];
            [err2, ob21, ob22] = cmpBlock(line1,smooth(line2,smoothLevel)', expFs, shftRange);
        else
            err2 = inf;
        end
    end
    
    alignedLine = [alignedLine {[x0:x0+length(ob11)-1;ob11;ob12]}];
    plot(x0:x0+length(ob11)-1,ob11);        hold on;
    plot(x0:x0+length(ob11)-1,ob12, 'r');
    x0 = x0 + length(ob11) + 9;
    
    allLink = [allLink {[pt1 dLink]}];
    fprintf('pt1 = %d ---> pt2 = ',pt1);
    fprintf('%d ',dLink);
    fprintf('         \n');
    pt1 = pt1 + 1;
end
%% left side
x0 = -15;
pt1 = pt1Ref-1;
pt2 = pt2Ref-1;
while pt1 > 0 && pt2 > 0
    dLink = [];
    line1 = smooth(cells1(pt1).profile,smoothLevel)';
    line1 = line1(end:-1:1);
    line2 = cells2(pt2).profile;
    line2cmp = smooth(line2,smoothLevel)';
    line2cmp = line2cmp(end:-1:1);
    [err2, ob21, ob22] = cmpBlock(line1,line2cmp, expFs, shftRange);
    err1 = inf;
    while err2 < err1
        dLink = [pt2 dLink];
        pt2 = pt2 - 1;
        err1 = err2;    ob11 = ob21;    ob12 = ob22;
        if pt2 > 0
            line3 = cells2(pt2).profile;
            line2 = [line3 line2];
            line2cmp = smooth(line2,smoothLevel)';
            line2cmp = line2cmp(end:-1:1);
            [err2, ob21, ob22] = cmpBlock(line1,line2cmp, expFs, shftRange);
        else
            err2 = inf;
        end
    end
    ob11 = ob11(end:-1:1);
    ob12 = ob12(end:-1:1);
    
    alignedLine = [{[x0-length(ob11)+1:x0;ob11;ob12]} alignedLine];
    plot(x0-length(ob11)+1:x0,ob11);
    plot(x0-length(ob11)+1:x0,ob12, 'r');
    x0 = x0 - length(ob11) - 9;
    
    allLink = [{[pt1 dLink]} allLink];
    fprintf('pt1 = %d ---> pt2 = ',pt1);
    fprintf('%d ',dLink);
    fprintf('         \n');
    pt1 = pt1 - 1;
end
fprintf('\n\n');
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
            [line1{kk,jj} line2{kk,jj}] = cmpLines(line1{kk,jj},b2,0);
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