function [ results ] = cell_transfer( results, kthFrame )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% plot aligned blocks and cells
x0 = 1;
kp1cellN = 1;
hold off;
for ii = 1:length(results(kthFrame).blockL)
    b1 = results(kthFrame).blockL(ii);
    plot(x0:x0+(b1.cellE-b1.cellS),b1.profile+600); hold on;
    plot([x0+(b1.cellE-b1.cellS) x0+(b1.cellE-b1.cellS)],[b1.profile(end)+300 b1.profile(end)+900]);
    x0c = x0;
    for jj = 1:length(b1.cLink)
        c1 = results(kthFrame).cells(b1.cLink(jj));
        plot(x0c:x0c+(c1.cellE-c1.cellS),c1.profile,'r');
        plot([x0c+(c1.cellE-c1.cellS) x0c+(c1.cellE-c1.cellS)],[c1.profile(end)-300 c1.profile(end)+300],'r');
        x0c = x0c + (c1.cellE-c1.cellS) +1;
    end
    x0s = x0;
    for jj = 1:length(b1.kp1sLink)
        b2 = results(kthFrame+1).blockS(b1.kp1sLink(jj));
        plot(x0s:x0s+(b2.cellE-b2.cellS),b2.profile-600,'k');
        plot([x0s+(b2.cellE-b2.cellS) x0s+(b2.cellE-b2.cellS)],[b2.profile(end)-900 b2.profile(end)-300],'k');
        x0s = x0s + (b2.cellE-b2.cellS) +1;
    end
    x0 = max([x0s x0c x0+(b1.cellE-b1.cellS)+1]);
end
x0 = 1;
for ii = 1:length(results(kthFrame+1).blockL)
    b1 = results(kthFrame+1).blockL(ii);
    plot(x0:x0+(b1.cellE-b1.cellS),b1.profile-1200); hold on;
    plot([x0+(b1.cellE-b1.cellS) x0+(b1.cellE-b1.cellS)],[b1.profile(end)-1500 b1.profile(end)-900]);
    x0 = x0+(b1.cellE-b1.cellS)+1;
end
%%
c1 = results(kthFrame).cells;
ptc0 = 0;       ptc = 1;
for ii = 1:length(results(kthFrame).blockL)
    sBlockW = 0;
    ptc0 = ptc0 + ptc - 1;
    ptc = 1;
    b1 = results(kthFrame).blockL(ii);
    if isempty(b1.kp1sLink)
        if ~isempty(b1.cLink)
            ptc0 = ptc0 + length(b1.cLink);
        end
        continue;
    end
    isAna = 0;
    for jj = 1:length(b1.kp1sLink)
        pt1 = b1.kp1sLink(jj);
        b2 = results(kthFrame+1).blockS(pt1);
        if length(b1.cLink) < (ptc) || length(c1) < b1.cLink(ptc)
            continue;
        end
        if isAna == 1
            isAna = 0;
            continue;
        end
        %% cell division
        if jj<length(results(kthFrame).blockL(ii).kp1sLink) && abs(c1(b1.cLink(ptc)).length - results(kthFrame+1).blockS(pt1+1).length - b2.length) < abs(c1(b1.cLink(ptc)).length - b2.length)
            disp('cell division');
            cells(kp1cellN) = rmfield (b2 ,'km1lLink');
            cells(kp1cellN + 1) = rmfield (results(kthFrame+1).blockS(pt1+1),'km1lLink');
%             cells(kp1cellN) = rmfield (cells(kp1cellN)  ,'km1lLink');
%             cells(kp1cellN+1) = rmfield (cells(kp1cellN+1),'km1lLink');
            cells(kp1cellN).sLink = pt1;
            cells(kp1cellN + 1).sLink = pt1+1;
            
            cells(kp1cellN).mLink = ptc + ptc0;
            cells(kp1cellN + 1).mLink = ptc + ptc0;
            
            results(kthFrame).cells(ptc + ptc0).dLink = [kp1cellN kp1cellN+1];
            results(kthFrame+1).blockS(pt1).cLink = kp1cellN;
            results(kthFrame+1).blockS(pt1+1).cLink = kp1cellN + 1;
            kp1cellN = kp1cellN + 2;
            ptc = ptc + 1;
            isAna = 1;
            continue;
        end
        %% one block for several cells
        err1 = inf;
        err2 = (b2.length-c1(b1.cLink(ptc)).length);
        allLink = [];
        allCellL = [];
        allCell = [];
        ptcBak = ptc;
        while abs(err2) < abs(err1)
            allLink = [allLink ptc];
            allCellL = [allCellL c1(b1.cLink(ptc)).length];
            %allCell = [allCell rmfield(c1(b1.cLink(ptc)),'cLink');];
            allCell = [allCell (c1(b1.cLink(ptc)))];
            ptc = ptc + 1;
            err1 = err2;
            if ptc <= length(b1.cLink)
                err2 = err2 - c1(b1.cLink(ptc)).length;
            else
                err2 = inf;
            end
        end
        %% construct cells and linkage for b2
        x0 = b2.cellS-1;
        allBlockL = b2.length.*(allCellL./(sum(allCellL)));
        allLink = [];
        ptc = ptcBak;
        for kk = 1:length(allCell)
            %allCell(kk) = rmfield(allCell(kk),'cLink');
            allCell(kk).cellS   = x0+1;
            allCell(kk).cellE   = x0+allBlockL(kk);
            allCell(kk).length  = allBlockL(kk);
            allCell(kk).profile = results(kthFrame+1).lineProfile(allCell(kk).cellS:allCell(kk).cellE);
            allCell(kk).sLink   = pt1; 
            allCell(kk).lLink   = [];
            allCell(kk).mLink   = ptc + ptc0;
            results(kthFrame).cells(ptc + ptc0).dLink = kp1cellN;
            
            cells(kp1cellN) = allCell(kk);
            allLink = [allLink kp1cellN];
            kp1cellN = kp1cellN + 1;
            ptc = ptc + 1;
            x0 = x0+allBlockL(kk);
        end
        results(kthFrame+1).blockS(pt1).cLink = allLink;
        sBlockW = sBlockW + b2.length;
    end    
    fprintf('%f  ',sBlockW/results(kthFrame).blockL(ii).length);
end
results(kthFrame+1).cells = cells;
%% link blockL and cells via blockS
for ii = 1:length(results(kthFrame+1).blockL)
    fr1 = results(kthFrame+1);
    bL = fr1.blockL(ii);
    allLink = [];
    for jj = 1:length(bL.sLink)
        bS = fr1.blockS(bL.sLink(jj));
        if ~isempty(bS.cLink)
            allLink = [allLink bS.cLink];
            for kk = 1:length(bS.cLink)
                results(kthFrame+1).cells(bS.cLink(kk)).lLink = ii;
            end
        end    
    end
    results(kthFrame+1).blockL(ii).cLink = allLink;
end

fprintf('\n');
end
