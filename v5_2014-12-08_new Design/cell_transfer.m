function [ results ] = cell_transfer( results, kthFrame )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% plot aligned blocks and cells
x0 = 1;
kp1cellN = 1;
kthCell = 1;
cells = [];
hold off;
lineSpace = 1200;
allx0 = x0;
for ii = 1:length(results(kthFrame).blockL)
    b1 = results(kthFrame).blockL(ii);
    plot(x0:x0+(b1.cellE-b1.cellS),b1.profile+2*lineSpace); hold on;
    plot([x0+(b1.cellE-b1.cellS) x0+(b1.cellE-b1.cellS)],[b1.profile(end)+lineSpace*2.5 b1.profile(end)+lineSpace*1.5]);
    x0c = x0;
    for jj = 1:length(b1.cLink)
        c1 = results(kthFrame).cells(b1.cLink(jj));
        if length(c1.profile) > 0
            plot(x0c:x0c+(c1.cellE-c1.cellS),c1.profile+lineSpace,'r');
            plot([x0c+(c1.cellE-c1.cellS) x0c+(c1.cellE-c1.cellS)],[c1.profile(end)+lineSpace*1.5 c1.profile(end)+lineSpace/2],'r');
            x0c = x0c + (c1.cellE-c1.cellS) +1;
        end
    end
    x0s = x0;
    for jj = 1:length(b1.kp1sLink)
        b2 = results(kthFrame+1).blockS(b1.kp1sLink(jj));
        plot(x0s:x0s+(b2.cellE-b2.cellS),b2.profile,'k');
        plot([x0s+(b2.cellE-b2.cellS) x0s+(b2.cellE-b2.cellS)],[b2.profile(end)+lineSpace/2 b2.profile(end)-lineSpace/2],'k');
        x0s = x0s + (b2.cellE-b2.cellS) +1;
    end
    x0 = max([x0s x0c x0+(b1.cellE-b1.cellS)+1]);
    allx0 = [allx0 x0];
end
x0 = 1;     jj = 1;     
for ii = 1:length(results(kthFrame+1).blockL)
    %x0 = allx0(ii);
    b1 = results(kthFrame+1).blockL(ii);
    plot(x0:x0+(b1.cellE-b1.cellS),b1.profile-lineSpace,'g'); hold on;
    plot([x0+(b1.cellE-b1.cellS) x0+(b1.cellE-b1.cellS)],[b1.profile(end)-1.5*lineSpace b1.profile(end)-0.5*lineSpace]);
    x0 = x0+(b1.cellE-b1.cellS)+1;
end
%% align kthfr cell and kp1 sBlock
c1 = results(kthFrame).cells;
cells = c1(1);
ptc0 = 0;       ptc = 1;
cellsP = [];
maxOff2 = 5;
maxGap = 3;
for ii = 1:length(results(kthFrame).blockL)
    b1 = results(kthFrame).blockL(ii);
    cellsP = [];
    if length(b1.kp1sLink) == 0 || length(b1.cLink) == 0
        continue;
    end
    cellsL = [0];    blocksL = [0];     allB2 = [];%allB2 = results(kthFrame+1).blockS(b1.kp1sLink(1));
    ptc = 1:length(b1.cLink) + ptc0;
    ptc0 = ptc0 + length(b1.cLink);
    for jj = 1:length(b1.cLink)
        cellsL = [cellsL cellsL(end)+c1(b1.cLink(jj)).length];
    end
    for jj = 1:length(b1.kp1sLink)
        pt1 = b1.kp1sLink(jj);
        b2 = results(kthFrame+1).blockS(pt1);
        allB2 = [allB2 b2];
        blocksL = [blocksL blocksL(end)+b2.length];
    end
    cellsL = cellsL./cellsL(end).*blocksL(end);
    jj = 1;     bx0 = blocksL(jj);
    cellBlock = [];
    kthCell0 = kthCell;
    for kk = 1:length(cellsL)-1
        cx0 = cellsL(kk);
        while jj < length(blocksL) && bx0 < cx0 - maxOff2
            if jj == length(blocksL)-1 || (jj < length(blocksL)-1 && allB2(jj+1).cellS - allB2(jj).cellE < maxGap)
                jj = jj + 1;
                bx0 = blocksL(jj);
            else
                jj = jj + 1;
            end
        end
        if jj <= length(allB2)
            cellsP = [cellsP allB2(jj).cellS - (bx0 - cx0)];     
            cells(kthCell) = c1(1);
            cells(kthCell).cellS = allB2(jj).cellS - (bx0 - cx0);
        else
            cellsP = [cellsP allB2(jj-1).cellE - (bx0 - cx0)];
            cells(kthCell) = c1(1);
            cells(kthCell).cellS = allB2(jj-1).cellE - (bx0 - cx0);
        end
        %% create initial cells
        %cells(kthCell) = c1(1);
        %cells(kthCell).cellS = allB2(jj).cellS - (bx0 - cx0);
        cells(kthCell).mLink = kk + b1.cLink(1) - 1;
        results(kthFrame).cells(kk + b1.cLink(1) - 1).dLink = kthCell;
        if kk > 1
            if jj >1
                cells(kthCell-1).cellE = allB2(jj-1).cellE - (bx0 - cx0);
            else
                cells(kthCell-1).cellE = allB2(jj).cellS - (bx0 - cx0) - 1;
            end
        end
        kthCell = kthCell + 1;
    end
    cells(kthCell-1).cellE = allB2(end).cellE;
    cellsP = [cellsP allB2(end).cellE];    
end
%% modify cells and connect them with blockLs
kthCell = 1;
allBl2 = results(kthFrame+1).blockL;
maxOff = 10;
maxGap = 5;
cellN = length(cells);
isSplit = 0;
%% connect them with blockLs
for ii = 1:length(allBl2)
    bl2 = allBl2(ii);
    if kthCell > cellN
        break;
    end
    if kthCell == 1 && (cells(kthCell).cellS - bl2.cellE > maxOff)
        continue;
    end
    while ii == 1 && kthCell < cellN && bl2.cellS - cells(kthCell).cellS > maxOff
        kthCell = kthCell + 1;
    end
    if isSplit == 1
        isSplit = 0;
        if cells(kthCell).cellE - bl2.cellE > maxOff
            continue;
        end
    end
    while kthCell <= cellN && bl2.cellE - cells(kthCell).cellE > maxOff
        cells(kthCell).lLink = ii;
        results(kthFrame+1).blockL(ii).cLink = [results(kthFrame+1).blockL(ii).cLink kthCell];        
        kthCell = kthCell + 1;
    end
    %% split cell
    if kthCell <= cellN && ( ii< length(allBl2) && abs(cells(kthCell).cellE - allBl2(ii+1).cellE) < maxOff && allBl2(ii+1).cellS - bl2.cellE < maxGap)
    %if kthCell <= cellN && cells(kthCell).cellE - bl2.cellE > maxOff && ( ii< length(allBl2) && allBl2(ii+1).cellS - bl2.cellE < maxGap)
        isSplit = 1;
        [cells results] = splitCell( results, kthFrame, cells, kthCell, bl2.cellE );    
        cells(kthCell).lLink = ii;
        cells(kthCell+1).lLink = ii+1;        
        results(kthFrame+1).blockL(ii).cLink = [results(kthFrame+1).blockL(ii).cLink kthCell];        
        results(kthFrame+1).blockL(ii+1).cLink = [results(kthFrame+1).blockL(ii+1).cLink kthCell+1];
        kthCell = kthCell + 2;
        cellN = cellN + 1;
    else
        cells(kthCell).lLink = ii;
        results(kthFrame+1).blockL(ii).cLink = [results(kthFrame+1).blockL(ii).cLink kthCell];        
        kthCell = kthCell + 1;
    end
end
%% correct cell profile and length
for ii = 1:length(cells)
    cells(ii).cellS = round(cells(ii).cellS);
    cells(ii).cellE = round(cells(ii).cellE);
    cells(ii).length = cells(ii).cellE - cells(ii).cellS + 1;
    cells(ii).profile = results(kthFrame+1).lineProfile(cells(ii).cellS:cells(ii).cellE);
end
results(kthFrame+1).cells = cells;
end
