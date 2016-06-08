function [ alignedLine,alignedBody ] = cell_lineage( results, kthFrame, pt1Ref, pt2Ref )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
shftRange = 0:10;
nShftRange = length(shftRange);
expFs = 0.9:0.01:1.25;
nExpFs = length(expFs);
pt1 = pt1Ref;
pt2 = pt2Ref;
cells1 = results(kthFrame).cells;
cells2 = results(kthFrame+1).cells;
pt2Sref = cells2(pt2).sS;
pt2S = pt2Sref;
stiLine2L = length(results(kthFrame+1).stitchedLine);
alignedLine = [];
alignedBody = [];
allExpFs = [];
tempCell = [];
allCell = [];
%fprintf('min expFs = ');
%% right side
while pt1 <= length(cells1) && pt2S <= stiLine2L
    line1origin = smooth(cells1(pt1).profile,5)';    
    allLine1L = zeros(1,nExpFs);
    line1 = cell(nExpFs,nShftRange);     line2 = cell(nExpFs,nShftRange);
    body1 = cell(nExpFs,nShftRange);     body2 = cell(nExpFs,nShftRange);
    cellS = cell(nExpFs,nShftRange);     cellE = cell(nExpFs,nShftRange);
    err_std = zeros(nExpFs,nShftRange);
    for kk = 1:nExpFs
        expCoeff = expFs(kk);
        line1Base = expand_trace (line1origin, expCoeff);
        body1Base = expand_body (cells1(pt1).body, expCoeff);
        for jj = 1:nShftRange            
            line1{kk,jj} = [zeros(1,shftRange(jj)) line1Base];
            body1{kk,jj} = [zeros(18,shftRange(jj)) body1Base];
            allLine1L(kk,jj) = length(line1{kk,jj});
            %pt2S = pt2Sref;%+shftRange(jj);
            cellS{kk,jj} = pt2S;
            if pt2S+allLine1L(kk,jj)-1 <= stiLine2L
                line2{kk,jj} = results(kthFrame+1).stitchedLine(pt2S:pt2S+allLine1L(kk,jj)-1);
                body2{kk,jj} = results(kthFrame+1).stitchedCh(:,pt2S:pt2S+allLine1L(kk,jj)-1);
                cellE{kk,jj} = pt2S+allLine1L(kk,jj)-1;
            else
                line2{kk,jj} = [results(kthFrame+1).stitchedLine(pt2S:end) zeros(1,pt2S+allLine1L(kk,jj)-1-stiLine2L)];
                body2{kk,jj} = [results(kthFrame+1).stitchedCh(:,pt2S:end) zeros(18,pt2S+allLine1L(kk,jj)-1-stiLine2L)];
                cellE{kk,jj} = stiLine2L;
            end
            err_std(kk,jj) = std(line1{kk,jj}-line2{kk,jj});
        end
    end
    [minErr minkjLoc] = min(err_std(:));
    [minkLoc,minjLoc] = ind2sub(size(err_std), minkjLoc);
    alignedLine = [alignedLine [line1{minkLoc,minjLoc};line2{minkLoc,minjLoc}]];
    alignedBody = [alignedBody [body1{minkLoc,minjLoc};body2{minkLoc,minjLoc}] zeros(36,10)];
    pt2S = pt2S + allLine1L(minkLoc,minjLoc);
    pt1 = pt1 + 1;
    %fprintf('%f  ',expFs(minkLoc));
    allExpFs = [allExpFs expFs(minkLoc)];
    tempCell.newS = cellS{minkLoc,minjLoc};
    tempCell.newE = cellE{minkLoc,minjLoc};
    allCell = [allCell tempCell];
end
%%
alignedBody = [zeros(36,10) alignedBody]; 

%% left side
pt1 = pt1Ref - 1;
pt2 = pt2Ref - 1;
if pt1 > 0 && pt2 > 0
    pt2Sref = cells2(pt2).sS;
    pt2E = pt2Sref + length(cells2(pt2).profile) - 1;
else    
    fprintf('min ExpF = %f      max ExpF = %f\n',min(allExpFs),max(allExpFs));
    return;
end
while pt1 > 0 && pt2E > 0
    line1origin = smooth(cells1(pt1).profile,5)';    
    allLine1L = zeros(1,nExpFs);
    line1 = cell(nExpFs,nShftRange);     line2 = cell(nExpFs,nShftRange);
    body1 = cell(nExpFs,nShftRange);     body2 = cell(nExpFs,nShftRange);
    cellS = cell(nExpFs,nShftRange);     cellE = cell(nExpFs,nShftRange);
    err_std = zeros(nExpFs,nShftRange);
    for kk = 1:nExpFs
        expCoeff = expFs(kk);
        line1Base = expand_trace (line1origin, expCoeff);
        body1Base = expand_body (cells1(pt1).body, expCoeff);
        for jj = 1:nShftRange
            line1{kk,jj} = [line1Base zeros(1,shftRange(jj)) ];
            body1{kk,jj} = [body1Base zeros(18,shftRange(jj))];
            allLine1L(kk,jj) = length(line1{kk,jj});
            cellE{kk,jj} = pt2E;
            %pt2S = pt2Sref;%+shftRange(jj);
            if pt2E-allLine1L(kk,jj) >= 0
                line2{kk,jj} = results(kthFrame+1).stitchedLine(pt2E-allLine1L(kk,jj)+1:pt2E);
                body2{kk,jj} = results(kthFrame+1).stitchedCh(:,pt2E-allLine1L(kk,jj)+1:pt2E);
                cellS{kk,jj} = pt2E-allLine1L(kk,jj)+1;
            else
                line2{kk,jj} = [zeros(1,allLine1L(kk,jj)-pt2E) results(kthFrame+1).stitchedLine(1:pt2E) ];
                body2{kk,jj} = [zeros(18,allLine1L(kk,jj)-pt2E) results(kthFrame+1).stitchedCh(:,1:pt2E) ];
                cellS{kk,jj} = 1;
            end
            err_std(kk,jj) = std(line1{kk,jj}-line2{kk,jj});
        end
    end
    [minErr minkjLoc] = min(err_std(:));
    [minkLoc,minjLoc] = ind2sub(size(err_std), minkjLoc);
    alignedLine = [[line1{minkLoc,minjLoc};line2{minkLoc,minjLoc}] alignedLine ];
    alignedBody = [zeros(36,10) [body1{minkLoc,minjLoc};body2{minkLoc,minjLoc}] alignedBody ];
    pt2E = pt2E - allLine1L(minkLoc,minjLoc);
    pt1 = pt1 - 1;
%    fprintf('%f  ',expFs(minkLoc));    
    allExpFs = [allExpFs expFs(minkLoc)];    
    tempCell.newS = cellS{minkLoc,minjLoc};
    tempCell.newE = cellE{minkLoc,minjLoc};
    allCell = [tempCell allCell];
end
%% construct cells for kthFrame + 1
stitchedIm = [];
for ii = 1:length(allCell)
    newS = results(kthFrame+1).stitchedLine_Loc(allCell(ii).newS);
    newE = results(kthFrame+1).stitchedLine_Loc(allCell(ii).newE);
    if newE - newS < 3
        continue;
    end
    
    [ peaks ] = search_cell(results(kthFrame+1).channel, results(kthFrame+1).lineProfile(newS:newE), 500, 700);
    fprintf('peaks number = %f\n',length(peaks));
    stitchedProfile = [];
    for jj = 1:length(peaks)
        stitchedProfile = [stitchedProfile (peaks(jj).profile)];
    end
    plot(stitchedProfile);
    hold on;
    plot(results(kthFrame+1).lineProfile(newS:newE)+500,'r');
    hold off;
    
    
    
    if newE - newS == allCell(ii).newE - allCell(ii).newS
        allCell(ii).newS = newS;
        allCell(ii).newE = newE;
        allCell(ii).length = newE-newS+1;
        allCell(ii).profile = results(kthFrame+1).lineProfile(newS:newE);
        allCell(ii).body = results(kthFrame+1).channel(:,newS:newE);
        stitchedIm = [stitchedIm allCell(ii).body zeros(18,10)];
        [ peaks ] = search_cell(results(kthFrame+1).channel, results(kthFrame+1).lineProfile(newS:newE), 500, 700);
        if length(peaks) == 2
            imagesc(allCell(ii).body);
        end
        a = 1;
    else
        imagesc(results(kthFrame+1).channel(:,newS:newE));
        stitchedIm = [stitchedIm results(kthFrame+1).channel(:,newS:newE) zeros(18,10)];
        [ peaks ] = search_cell(results(kthFrame+1).channel, results(kthFrame+1).lineProfile(newS:newE), 500, 700);
    end
end
imagesc(stitchedIm);
%%
fprintf('min ExpF = %f      max ExpF = %f\n',min(allExpFs),max(allExpFs));
end