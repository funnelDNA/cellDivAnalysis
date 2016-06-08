function [ alignedLine,alignedBody,results ] = cell_lineage( results, kthFrame, pt1Ref, pt2Ref, uniThreshold )
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
pt2Sref = cells2(pt2).sS;
pt2S = pt2Sref;
stiLine2L = length(results(kthFrame+1).stitchedLine);
alignedLine = [];
alignedBody = [];
allExpFs = [];
tempCell = [];
allTempCell = [];
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
            %cellS{kk,jj} = pt2S+shftRange(jj);
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
    alignedLine = [alignedLine zeros(2,10) [line1{minkLoc,minjLoc};line2{minkLoc,minjLoc}]];
    alignedBody = [alignedBody [body1{minkLoc,minjLoc};body2{minkLoc,minjLoc}] zeros(36,10)];
    pt2S = pt2S + allLine1L(minkLoc,minjLoc);
    %fprintf('%f  ',expFs(minkLoc));
    allExpFs = [allExpFs expFs(minkLoc)];
    tempCell.newS = cellS{minkLoc,minjLoc};
    tempCell.newE = cellE{minkLoc,minjLoc};
    tempCell.mLink = pt1;
    allTempCell = [allTempCell tempCell];
    pt1 = pt1 + 1;
end
%%
alignedBody = [zeros(36,10) alignedBody]; 

%% left side
pt1 = pt1Ref - 1;
pt2 = pt2Ref - 1;
if pt1 > 0 && pt2 > 0
    pt2Sref = cells2(pt2).sS;
    pt2E = pt2Sref + length(cells2(pt2).profile) - 1;
end
while pt1 > 0 && pt2 > 0 && pt2E > 0
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
            %cellE{kk,jj} = pt2E-shftRange(jj);
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
    alignedLine = [[line1{minkLoc,minjLoc};line2{minkLoc,minjLoc}] zeros(2,10) alignedLine ];
    alignedBody = [zeros(36,10) [body1{minkLoc,minjLoc};body2{minkLoc,minjLoc}] alignedBody ];
    pt2E = pt2E - allLine1L(minkLoc,minjLoc);
%    fprintf('%f  ',expFs(minkLoc));    
    allExpFs = [allExpFs expFs(minkLoc)];    
    tempCell.newS = cellS{minkLoc,minjLoc};
    tempCell.newE = cellE{minkLoc,minjLoc};
    tempCell.mLink = pt1;
    allTempCell = [tempCell allTempCell];
    pt1 = pt1 - 1;
end
%% construct cells for kthFrame + 1
stitchedIm = [];
allCell = [];
kthCell = 1;
for ii = 1:length(allTempCell)
    newS = results(kthFrame+1).stitchedLine_Loc(allTempCell(ii).newS);
    newE = results(kthFrame+1).stitchedLine_Loc(allTempCell(ii).newE);
    if newE - newS < 3
        continue;
    end
    if newS-2 < 1
        newS = 1;
    else
        newS = newS - 2;
    end
    if newE+2 > length(results(kthFrame+1).lineProfile)
        newE = length(results(kthFrame+1).lineProfile);
    else
        newE = newE + 2;
    end
    [ peaks ] = search_cell(results(kthFrame+1).channel(:,newS:newE), results(kthFrame+1).lineProfile(newS:newE), 800, uniThreshold);
    peakHeightMin = 700;
    while length(peaks) == 0 && peakHeightMin > 90
        [ peaks ] = search_cell(results(kthFrame+1).channel(:,newS:newE), results(kthFrame+1).lineProfile(newS:newE), peakHeightMin, uniThreshold);
        peakHeightMin = peakHeightMin - 100;
    end
    if length(peaks) == 0
        peaks(1).start = 1;
        peaks(1).hill = 2;
        peaks(1).end = newE-newS+1;
        peaks(1).newS = 1;
        peaks(1).newE = newE-newS+1;
        peaks(1).length = newE-newS+1;
        peaks(1).profile = results(kthFrame+1).lineProfile(newS:newE);
        peaks(1).height = 3000;
        peaks(1).area = 70000;
        peaks(1).bkLevel = uniThreshold;
        peaks(1).body = results(kthFrame+1).channel(:,newS:newE);
        peaks(1).cellS = peaks(1).newS;
        peaks(1).cellE = peaks(1).newE;
    end
        
        
        
    subplot(3,1,1);
    imagesc(results(kthFrame+1).channel(:,newS:newE));
    subplot(3,1,2);
    allBody = [];
    for jj = 1:length(peaks)
        peaks(jj).newS = peaks(jj).newS + newS - 1;
        peaks(jj).newE = peaks(jj).newE + newS - 1;
        peaks(jj).cellS = peaks(jj).newS;
        peaks(jj).cellE = peaks(jj).newE;
        allBody = [allBody peaks(jj).body];
    end
    imagesc(allBody);
    subplot(3,1,3);
    imagesc(alignedBody);
    switch length(peaks)
        case 0
            disp('no peak!');
            imagesc(results(kthFrame+1).channel(:,newS:newE));
            pause;
        case 1
            peaks.mLink = allTempCell(ii).mLink;
            allCell = [allCell peaks];
            results(kthFrame).cells(peaks.mLink).dLink = kthCell;
            kthCell = kthCell + 1;
        case 2
            peaks(1).mLink = allTempCell(ii).mLink;
            peaks(2).mLink = allTempCell(ii).mLink;
            allCell = [allCell peaks];
            results(kthFrame).cells(peaks(1).mLink).dLink = [kthCell kthCell+1];
            kthCell = kthCell + 2;
        otherwise
            disp('Error: cell divided into 3 cells!');
            pause;
    end
%     
%     fprintf('peaks number = %f\n',length(peaks));
%     stitchedProfile = [];
%     for jj = 1:length(peaks)
%         stitchedProfile = [stitchedProfile (peaks(jj).profile)];
%     end
%     plot(stitchedProfile);
%     hold on;
%     plot(results(kthFrame+1).lineProfile(newS:newE)+500,'r');
%     hold off;
%     
%     
%     
%     if newE - newS == allTempCell(ii).newE - allTempCell(ii).newS
%         allTempCell(ii).newS = newS;
%         allTempCell(ii).newE = newE;
%         allTempCell(ii).length = newE-newS+1;
%         allTempCell(ii).profile = results(kthFrame+1).lineProfile(newS:newE);
%         allTempCell(ii).body = results(kthFrame+1).channel(:,newS:newE);
%         stitchedIm = [stitchedIm allTempCell(ii).body zeros(18,10)];
%         [ peaks ] = search_cell(results(kthFrame+1).channel, results(kthFrame+1).lineProfile(newS:newE), 500, 700);
%         if length(peaks) == 2
%             imagesc(allTempCell(ii).body);
%         end
%         a = 1;
%     else
%         imagesc(results(kthFrame+1).channel(:,newS:newE));
%         stitchedIm = [stitchedIm results(kthFrame+1).channel(:,newS:newE) zeros(18,10)];
%         [ peaks ] = search_cell(results(kthFrame+1).channel, results(kthFrame+1).lineProfile(newS:newE), 500, 700);
%     end
end
%imagesc(stitchedIm);
%% check overlap
for ii = 1:length(allCell)-1
    if allCell(ii).newE >= allCell(ii+1).newS
        overlap = ceil((allCell(ii).newE-allCell(ii+1).newS+1)/2);
        allCell(ii).newE = allCell(ii).newE-overlap;
        allCell(ii).length = allCell(ii).length-overlap;
        allCell(ii).profile(end-overlap:end) = [];
        allCell(ii).body(:,end-overlap:end) = [];
        allCell(ii).cellE = allCell(ii).newE;
        allCell(ii+1).newS = allCell(ii+1).newS+overlap;
        allCell(ii+1).length = allCell(ii+1).length-overlap;
        allCell(ii+1).profile(1:overlap) = [];
        allCell(ii+1).body(:,1:overlap) = [];
        allCell(ii+1).cellS = allCell(ii+1).newS;     
    end
end
%%
results(kthFrame+1).cells = allCell;
%%
fprintf('min ExpF = %f      max ExpF = %f\n',min(allExpFs),max(allExpFs));
end