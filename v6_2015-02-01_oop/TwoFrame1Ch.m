classdef TwoFrame1Ch < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here    
    properties
        frameNum
        fr1
        fr2
        ptLRef
        ptSRef
        profileAlignErr
        fr1NewIm
        fr2NewCh
    end
    methods
        function ProfileAlign( TFC, varargin )
        %UNTITLED Summary of this function goes here
        %   align kthFrame and kthFrame+1. Vary expansion coeff. find smallest
        %   std(line1-line2)
        plotToggle = 0;
            offLinePenalty = 4000;
            if length (varargin) == 1 && strcmp(varargin{1},'bright')
                allInt = [];
                for ii = 1:length(TFC.fr1.blockLs.blockLs)
                    if TFC.fr1.blockLs.blockLs(ii).isSkip == 0
                        allInt = [allInt max(TFC.fr1.blockLs.blockLs(ii).block.profile)];
                    end
                end
                [maxInt pt1] = max(allInt);
            else
                pt1 = round(length(TFC.fr1.blockLs.blockLs)/2);
                while TFC.fr1.blockLs.blockLs(pt1).isSkip ~= 0
                    pt1 = pt1 + 1;
                end
            end
            err_std = [];   err_sum = [];
            matchedLineL = [];
            matchedLineR = [];
            line1origin = TFC.fr1.blockLs.stitchedLine;
            line2 = TFC.fr2.blockSs.stitchedLine;

            pt1S = round(TFC.fr1.blockLs.blockLs(pt1).block.stitchS);
            pt1Ref = pt1;
            kk = 1;
            %expFs = 1:0.01:1.08;
            expFs = 1.02:0.03:1.2;
            shftRange = 0;

            line1 = line1origin;
            pt1S = round(TFC.fr1.blockLs.blockLs(pt1).block.stitchS);
            for pt2 = 1:length(TFC.fr2.blockSs.blockSs)
                pt2S = round(TFC.fr2.blockSs.blockSs(pt2).block.stitchS);
        %% two segments
        %         line1L = line1(1:pt1S);
        %         line1R = line1(pt1S+1:end);
        %         line2L = line2(1:pt2S);
        %         line2R = line2(pt2S+1:end);
        % 
        %         [errL, ob21, ob22] = cmpBlock(line1L,line2L, expFs, shftRange, mean(line1)-offLinePenalty);
        %         matchedLineL{pt2} = [ob21(end:-1:1); ob22(end:-1:1)];
        %         [errR, ob21, ob22] = cmpBlock(line1R,line2R, expFs, shftRange, mean(line1)-offLinePenalty);
        %         matchedLineR{pt2} = [ob21; ob22];
        %         err(pt2) = errL + errR;
        %% four segments
                line1L = line1(pt1S:-1:1);
                line1R = line1(pt1S+1:end);
                line2L = line2(pt2S:-1:1);
                line2R = line2(pt2S+1:end);
                [errL, ob21, ob22] = cmpBlockL(line1L,line2L, expFs, shftRange, mean(line1)-offLinePenalty);
                matchedLineL{pt2} = [ob21(end:-1:1); ob22(end:-1:1)];
                [errR, ob21, ob22] = cmpBlockL(line1R,line2R, expFs, shftRange, mean(line1)-offLinePenalty);
                [errR, ob21, ob22] = cmpBlock(line1R,line2R, expFs, shftRange, mean(line1)-offLinePenalty);
                matchedLineR{pt2} = [ob21; ob22];
                err(pt2) = errL + errR;
            end
            [minErr pt2Ref] = (min(err));
%             figure; hold off;
%             plot(err);
            if plotToggle == 1
                %figure; hold off;
                plot ([matchedLineL{pt2Ref}(1,:) zeros(1,10) matchedLineR{pt2Ref}(1,:)]);
                hold on;
                plot ([matchedLineL{pt2Ref}(2,:) zeros(1,10) matchedLineR{pt2Ref}(2,:)],'r');
                hold off;
            end
%             expF = 1;
            TFC.ptLRef = pt1Ref;
            TFC.ptSRef = pt2Ref;
            TFC.profileAlignErr = err;
            TFC.fr1.ptLRef = pt1Ref;
            TFC.fr1.ptSRef = pt2Ref;
            TFC.fr1.profileAlignErr = err;
        end 
        function BlockAlign(TFC)
        %UNTITLED Summary of this function goes here
        %   Detailed explanation goes here
            plotToggle = 0;
            showLinkToggle = 0;
            
            cells1 = TFC.fr1.blockLs.blockLs;
            cells2 = TFC.fr2.blockSs.blockSs;
            hold off;
            %expFs = 0.9:0.02:1.25;
            expFs = 0.8:0.02:1.25;
%            expFs = 1;
%            shftRange = 0:2:10;
            shftRange = 0:2:10;
            %shftRange = 0:1:2;
            smoothLevel = 3;
            pt1Ref = TFC.ptLRef;
            pt2Ref = TFC.ptSRef;
            alignedLine = [];
            allLink = {};
            %% right side
            pt1 = pt1Ref;
            pt2 = pt2Ref;
            nCell1 = length(cells1);
            nCell2 = length(cells2);
            x0 = 1;
            while pt1 <= nCell1 && pt2 <= nCell2
                if cells1(pt1).isSkip == 1
                    pt1 = pt1 + 1;
                    continue;
                end
                dLink = [];
                line1 = smooth(cells1(pt1).block.profile,smoothLevel)';
                line2 = cells2(pt2).block.profile;
                [err2, ob21, ob22] = cmpBlock(line1,smooth(line2,smoothLevel)', expFs, shftRange);
                err1 = inf;
                while err2 < err1
                    dLink = [dLink pt2];
                    pt2 = pt2 + 1;
                    err1 = err2;    ob11 = ob21;    ob12 = ob22;
                    if pt2 <= nCell2
                        line3 = cells2(pt2).block.profile;
                        line2 = [line2 line3];
                        [err2, ob21, ob22] = cmpBlock(line1,smooth(line2,smoothLevel)', expFs, shftRange);
                    else
                        err2 = inf;
                    end
                end

                alignedLine = [alignedLine {[x0:x0+length(ob11)-1;ob11;ob12]}];
                if plotToggle == 1
                    plot(x0:x0+length(ob11)-1,ob11, 'b');        hold on;
                    plot(x0:x0+length(ob11)-1,ob12-200, 'r');
                end

                x0 = x0 + length(ob11) + 9;

                allLink = [allLink {[pt1 dLink]}];
                if showLinkToggle == 1
                    fprintf('pt1 = %d ---> pt2 = ',pt1);
                    fprintf('%d ',dLink);
                    fprintf('         \n');
                end
                pt1 = pt1 + 1;
            end
            %% left side
            x0 = -15;
            pt1 = pt1Ref-1;
            pt2 = pt2Ref-1;
            while pt1 > 0 && pt2 > 0
                if cells1(pt1).isSkip == 1
                    pt1 = pt1 - 1;
                    continue;
                end
                dLink = [];
                line1 = smooth(cells1(pt1).block.profile,smoothLevel)';
                line1 = line1(end:-1:1);
                line2 = cells2(pt2).block.profile;
                line2cmp = smooth(line2,smoothLevel)';
                line2cmp = line2cmp(end:-1:1);
                [err2, ob21, ob22] = cmpBlock(line1,line2cmp, expFs, shftRange);
                err1 = inf;
                while err2 < err1
                    dLink = [pt2 dLink];
                    pt2 = pt2 - 1;
                    err1 = err2;    ob11 = ob21;    ob12 = ob22;
                    if pt2 > 0
                        line3 = cells2(pt2).block.profile;
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
                if plotToggle == 1
                    plot(x0-length(ob11)+1:x0,ob11, 'b');
                    plot(x0-length(ob11)+1:x0,ob12-200, 'r');
                end
                x0 = x0 - length(ob11) - 9;

                allLink = [{[pt1 dLink]} allLink];
                if showLinkToggle == 1
                    fprintf('pt1 = %d ---> pt2 = ',pt1);
                    fprintf('%d ',dLink);
                    fprintf('         \n');
                end
                pt1 = pt1 - 1;
            end
            if showLinkToggle == 1
                fprintf('\n\n');
            end
            %% converting results from allLink into FC
            for ii = 1:length(allLink)
                TFC.fr1.blockLs.blockLs(allLink{ii}(1)).kp1sLink = allLink{ii}(2:end);
                for jj = 1:length(allLink{ii}(2:end))
                    TFC.fr2.blockSs.blockSs(allLink{ii}(jj+1)).km1lLink = allLink{ii}(1);
                end
            end
            TFC.fr1.alignedLine = alignedLine;
        end
        function [isTriSplit] = CellTransfer( TFC )
            %UNTITLED Summary of this function goes here
            %   Detailed explanation goes here
            isTriSplit = 0;
            maxOff = 6; % minimum cell size? 10 for Bsubtilis
            maxGap = 3.5;  % 5 for B subtilis
            maxOff2 = 5;
            maxGap = 3;
            %% align kthfr cell and kp1 sBlock
            c1 = TFC.fr1.cells;
            cells = c1.cells(1);  % cells will be the new cells for frame2
            kthCell = 1;
            ptc0 = 0;       ptc = 1;
            cellsP = [];
            expFs = 1:0.02:1.2;
            %% check is a new cell enters from the left of the channel
            if ~isempty(TFC.fr1.blockLs.blockLs(1).kp1sLink) && TFC.fr1.blockLs.blockLs(1).kp1sLink(1) > 1
                if ~isempty(TFC.fr2.blockSs.blockSs(TFC.fr1.blockLs.blockLs(1).kp1sLink(1)-1).lLink)
                    cells(kthCell).lLink = TFC.fr2.blockSs.blockSs(TFC.fr1.blockLs.blockLs(1).kp1sLink(1)-1).lLink;
                    cells(kthCell).mLink = [];
                    cells(kthCell).block.blockS = TFC.fr2.blockSs.blockSs(1).block.blockS;
                    cells(kthCell).block.blockE = TFC.fr2.blockSs.blockSs(TFC.fr1.blockLs.blockLs(1).kp1sLink(1)-1).block.blockE;
                    kthCell = kthCell + 1;
                end
            end
            
            
            %% this loop map all the cells to next seperator, doesn't care if the cell seperats.
            for ii = 1:length(TFC.fr1.blockLs.blockLs)
                b1 = TFC.fr1.blockLs.blockLs(ii);
                if b1.isSkip == 1
                    continue;
                end
                cellsP = [];
                if isempty(b1.kp1sLink) || isempty(b1.cLink)
                    continue;
                end
                cellsL = [0];    blocksL = [0];     allB2 = [];%allB2 = results(kthFrame+1).blockS(b1.kp1sLink(1));
                stitchedCell = [];  stitchedBlock = [];
                ptc = 1:length(b1.cLink) + ptc0;
                ptc0 = ptc0 + length(b1.cLink); 
                for jj = 1:length(b1.cLink) % compare fr1-blockL to fr1-cells, get cellsL
                    cellsL = [cellsL cellsL(end)+c1.cells(b1.cLink(jj)).block.length];
                    stitchedCell = [stitchedCell c1.cells(b1.cLink(jj)).block.profile];
                end
%                 for jj = 1:length(b1.kp1sLink) % compare fr1-blockL to fr2-blockS, get blocksL
%                     pt1 = b1.kp1sLink(jj);
%                     b2 = TFC.fr2.blockSs.blockSs(pt1);
%                     allB2 = [allB2 b2];
%                     blocksL = [blocksL blocksL(end)+b2.block.length];
%                     stitchedBlock = [stitchedBlock b2.block.profile];
%                 end
                
                
                for jj = 1:length(b1.kp1sLink) % compare fr1-blockL to fr2-blockS, get blocksL
                    pt1 = b1.kp1sLink(jj);
                    if ii == 1 && ~isempty(TFC.fr2.blockLs.blockLs(1).sLink) && pt1 < TFC.fr2.blockLs.blockLs(1).sLink(1)
                        continue;
                    end
                    b2 = TFC.fr2.blockSs.blockSs(pt1);
                    allB2 = [allB2 b2];
                    blocksL = [blocksL blocksL(end)+b2.block.length];
                    stitchedBlock = [stitchedBlock b2.block.profile];
                end
                if cellsL(end) - blocksL(end) > maxOff2
                    if (ii == 1)
                        [expF] = cmpBlockEnds(stitchedCell(end:-1:1), stitchedBlock(end:-1:1), expFs);
                        cellsL = cellsL*expF;
                        cellsL = cellsL - (cellsL(end) - blocksL(end));
                        cellsL(cellsL <= 0) = [];
                        cellsL = [0 cellsL];
                    elseif ii == length(TFC.fr1.blockLs.blockLs)
                        [expF] = cmpBlockEnds(stitchedCell, stitchedBlock, expFs);
                        cellsL = cellsL*expF;
                        cellsL(cellsL > blocksL(end)) = [];
                        cellsL = [cellsL blocksL(end)];
                    end
                end
                cellsL = cellsL./cellsL(end).*blocksL(end);
                jj = 1;
                if kthCell == 1
                    jj = 1;
                elseif kthCell == 2
                    jj = 2;
                    %jj = TFC.fr1.blockLs.blockLs(1).kp1sLink(1);
                end
                bx0 = blocksL(jj);
                cellBlock = [];
                kthCell0 = kthCell;
                if length(cellsL) == 1
                    continue;
                end
                for kk = 1:length(cellsL)-1
                    cx0 = cellsL(kk);
                    %% find the first blockS that's not too less than cell pointer
                    while jj < length(blocksL) && bx0 < cx0 - maxOff2
                        if jj == length(blocksL)-1 || (jj < length(blocksL)-1 && allB2(jj+1).block.blockS - allB2(jj).block.blockE < maxGap)
                            jj = jj + 1;
                            bx0 = blocksL(jj);
                        else
                            jj = jj + 1;
                            bx0 = blocksL(jj);
                        end
                    end
                    %% assign a cell seperator
                    if jj <= length(allB2)
                        cellsP = [cellsP allB2(jj).block.blockS - (bx0 - cx0)];     
                        cells(kthCell) = c1.cells(1);
                        cells(kthCell).block.blockS = allB2(jj).block.blockS - (bx0 - cx0);
                    else
                        cellsP = [cellsP allB2(jj-1).block.blockE - (bx0 - cx0)];
                        cells(kthCell) = c1.cells(1);
                        cells(kthCell).block.blockS = allB2(jj-1).block.blockE - (bx0 - cx0);
                    end
                    %% create initial cells
                    %cells(kthCell) = c1(1);
                    %cells(kthCell).blockS = allB2(jj).blockS - (bx0 - cx0);
                    cells(kthCell).dLink = [];
                    cells(kthCell).mLink = kk + b1.cLink(1) - 1;
                    TFC.fr1.cells.cells(kk + b1.cLink(1) - 1).dLink = kthCell;
                    if kk > 1
                        if jj >1
                            cells(kthCell-1).block.blockE = allB2(jj-1).block.blockE - (bx0 - cx0);
                        else
                            cells(kthCell-1).block.blockE = allB2(jj).block.blockS - (bx0 - cx0) - 1;
                        end
                    end
                    kthCell = kthCell + 1;
                end
                cells(kthCell-1).block.blockE = allB2(end).block.blockE;
                cellsP = [cellsP allB2(end).block.blockE];
            end
            %% modify cells and connect them with blockLs
            kthCell = 1;
            allBl2 = TFC.fr2.blockLs.blockLs;

            cellN = length(cells);
            isSplit = 0;
            %% connect them with blockLs, split cell if blockL's end divides in the middle
            ii = 1;
            while ii <= length(allBl2)
                bl2 = allBl2(ii);
                if kthCell > cellN
                    break;
                end
                %% cell leaves from the end
%                 if kthCell == 1 && (cells(kthCell).block.blockS - bl2.block.blockE > maxOff)
%                     continue;
%                 end
                %% has an extra blockL in the next frame
                %fprintf('cells length = %d allB2 length = %d kthCell = %d\n',length(cells),length(allB2),kthCell);
                if ii == 1 
                    while length(allBl2)>1 && (cells(kthCell).block.blockS - allBl2(ii).block.blockE) > -maxGap
                        ii = ii + 1;
                    end
                end
                %% doesn't care if new cell enters the channel. might need to update later.
                while ii == 1 && kthCell < cellN && bl2.block.blockS - cells(kthCell).block.blockS > maxOff
                    kthCell = kthCell + 1;
                end
%                 if isSplit == 1
%                     isSplit = 0;
%                     if cells(kthCell).block.blockE - bl2.block.blockE > maxOff
%                         continue;
%                     end
%                 end
                while kthCell <= cellN && bl2.block.blockE - cells(kthCell).block.blockE > maxOff
                    cells(kthCell).lLink = ii;
                    TFC.fr2.blockLs.blockLs(ii).cLink = [TFC.fr2.blockLs.blockLs(ii).cLink kthCell];
                    kthCell = kthCell + 1;
                end
                %% split cell ?
                if kthCell <= cellN
                    if cells(kthCell).block.blockE - allBl2(ii).block.blockE > maxOff && allBl2(ii).block.blockE - cells(kthCell).block.blockS > -maxGap
                        if ii< length(allBl2)-1 && cells(kthCell).block.blockE - allBl2(ii+1).block.blockE > maxOff % split into 3 cells
                            isSplit = 1;
                            TFC.fr2.cells.cells = cells;
                            midPt = (allBl2(ii).block.blockS + allBl2(ii+2).block.blockE)/2;
                            if abs(allBl2(ii).block.blockE - midPt) < abs(allBl2(ii+2).block.blockS - midPt)
                                % first separation closer to mid point,
                                % combine second and thrid (ii+1,+2): blockL: blockS,
                                % blockE, length, profile, body
                                TFC.fr2.blockLs.blockLs(ii+1).block.blockE = TFC.fr2.blockLs.blockLs(ii+2).block.blockE;
                                TFC.fr2.blockLs.blockLs(ii+1).block.length = TFC.fr2.blockLs.blockLs(ii+1).block.blockE - TFC.fr2.blockLs.blockLs(ii+1).block.blockS + 1;
                                TFC.fr2.blockLs.blockLs(ii+1).block.profile = [TFC.fr2.blockLs.blockLs(ii+1).block.profile TFC.fr2.blockLs.blockLs(ii+2).block.profile];
                                TFC.fr2.blockLs.blockLs(ii+1).block.body = [TFC.fr2.blockLs.blockLs(ii+1).block.body TFC.fr2.blockLs.blockLs(ii+2).block.body];
                                TFC.fr2.blockLs.blockLs(ii+2) = [];

%                                 TFC.splitCell( kthCell, allBl2(ii).block.blockE );
%                                 cells = TFC.fr2.cells.cells;
%                                 cells(kthCell).lLink = ii;
%                                 cells(kthCell+1).lLink = [ii+1 ii+2];
%                                 TFC.fr2.blockLs.blockLs(ii).cLink = [TFC.fr2.blockLs.blockLs(ii).cLink kthCell];        
%                                 TFC.fr2.blockLs.blockLs(ii+1).cLink = [TFC.fr2.blockLs.blockLs(ii+1).cLink kthCell+1];
%                                 TFC.fr2.blockLs.blockLs(ii+2).cLink = [TFC.fr2.blockLs.blockLs(ii+2).cLink kthCell+1];
                            else
                                TFC.fr2.blockLs.blockLs(ii).block.blockE = TFC.fr2.blockLs.blockLs(ii+1).block.blockE;
                                TFC.fr2.blockLs.blockLs(ii).block.length = TFC.fr2.blockLs.blockLs(ii).block.blockE - TFC.fr2.blockLs.blockLs(ii).block.blockS + 1;
                                TFC.fr2.blockLs.blockLs(ii).block.profile = [TFC.fr2.blockLs.blockLs(ii).block.profile TFC.fr2.blockLs.blockLs(ii+1).block.profile];
                                TFC.fr2.blockLs.blockLs(ii).block.body = [TFC.fr2.blockLs.blockLs(ii).block.body TFC.fr2.blockLs.blockLs(ii+1).block.body];
                                TFC.fr2.blockLs.blockLs(ii+1) = [];
                            end
                            isTriSplit = 1;
                            return;
                        elseif ii < length(allBl2)
                            isSplit = 1;
                            nextBlockEnded = 1;
                            if ii< length(allBl2) && allBl2(ii+1).block.blockE - cells(kthCell).block.blockE > maxOff % next blockL not ended yet
                                nextBlockEnded = 0;
                            end
                            TFC.fr2.cells.cells = cells;
                            TFC.splitCell( kthCell, bl2.block.blockE );
                            cells = TFC.fr2.cells.cells;
                            cells(kthCell).lLink = ii;
                            cells(kthCell+1).lLink = ii+1;        
                            TFC.fr2.blockLs.blockLs(ii).cLink = [TFC.fr2.blockLs.blockLs(ii).cLink kthCell];        
                            TFC.fr2.blockLs.blockLs(ii+1).cLink = [TFC.fr2.blockLs.blockLs(ii+1).cLink kthCell+1];
                            if nextBlockEnded == 1
                                ii = ii + 1;
                            end
                            kthCell = kthCell + 2;
                            cellN = cellN + 1;
                             
%                             kthCell = kthCell + 2;
%                             cellN = cellN + 1;
%                             ii = ii + 2;
                        end
                    else % cell did not split
                        cells(kthCell).lLink = ii;
                        TFC.fr2.blockLs.blockLs(ii).cLink = [TFC.fr2.blockLs.blockLs(ii).cLink kthCell];
                        kthCell = kthCell + 1;
                    end
                end
%                 if kthCell <= cellN
%                     if ii< length(allBl2) && ((abs(cells(kthCell).block.blockE - allBl2(ii+1).block.blockE) < maxOff && allBl2(ii+1).block.blockS - bl2.block.blockE < maxGap) || cells(kthCell).block.blockE - bl2.block.blockE > maxOff) % cell split into 2 blocks
%                     %if ii< length(allBl2) && ((abs(cells(kthCell).block.blockE - allBl2(ii+1).block.blockE) < maxOff && allBl2(ii+1).block.blockS - bl2.block.blockE < maxGap) || cells(kthCell).block.blockE - bl2.block.blockE > maxOff) % cell split into 2 blocks
%                 %if kthCell <= cellN && cells(kthCell).blockE - bl2.blockE > maxOff && ( ii< length(allBl2) && allBl2(ii+1).blockS - bl2.blockE < maxGap)
%                         if cells(kthCell).block.blockE - bl2.block.blockE > maxOff    
%                             isSplit = 1;
%                             TFC.fr2.cells.cells = cells;
%                             TFC.splitCell( kthCell, bl2.block.blockE );
%                             cells = TFC.fr2.cells.cells;
%                             cells(kthCell).lLink = ii;
%                             cells(kthCell+1).lLink = ii+1;        
%                             TFC.fr2.blockLs.blockLs(ii).cLink = [TFC.fr2.blockLs.blockLs(ii).cLink kthCell];        
%                             TFC.fr2.blockLs.blockLs(ii+1).cLink = [TFC.fr2.blockLs.blockLs(ii+1).cLink kthCell+1];
%                             ii = ii + 1;
%                             if cells(kthCell).block.blockE - bl2.block.blockE > maxOff % next blockL not ended yet
%                                 ii = ii - 1;
%                             end
%                             kthCell = kthCell + 2;
%                             cellN = cellN + 1;
% 
%                         else
% %                             cells(kthCell).lLink = ii;
% %                             TFC.fr2.blockLs.blockLs(ii).cLink = [TFC.fr2.blockLs.blockLs(ii).cLink kthCell];
% %                             kthCell = kthCell + 1;
%                         end
%                     else
%                         if ( ii< length(allBl2)-1 && abs(cells(kthCell).block.blockE - allBl2(ii+2).block.blockE) < maxOff && allBl2(ii+2).block.blockS - allBl2(ii+1).block.blockE < maxGap) % cell split into 3 blocks
%                             % try to combine the blockL if needed.
%                             isSplit = 1;
%                             TFC.fr2.cells.cells = cells;
%                             midPt = (allBl2(ii).block.blockS + allBl2(ii+2).block.blockE)/2;
%                             if abs(allBl2(ii).block.blockE - midPt) < abs(allBl2(ii+2).block.blockS - midPt)
%                                 % first separation closer to mid point,
%                                 % combine second and thrid (ii+1,+2): blockL: blockS,
%                                 % blockE, length, profile, body
%                                 TFC.fr2.blockLs.blockLs(ii+1).block.blockE = TFC.fr2.blockLs.blockLs(ii+2).block.blockE;
%                                 TFC.fr2.blockLs.blockLs(ii+1).block.length = TFC.fr2.blockLs.blockLs(ii+1).block.blockE - TFC.fr2.blockLs.blockLs(ii+1).block.blockS + 1;
%                                 TFC.fr2.blockLs.blockLs(ii+1).block.profile = [TFC.fr2.blockLs.blockLs(ii+1).block.profile TFC.fr2.blockLs.blockLs(ii+2).block.profile];
%                                 TFC.fr2.blockLs.blockLs(ii+1).block.body = [TFC.fr2.blockLs.blockLs(ii+1).block.body TFC.fr2.blockLs.blockLs(ii+2).block.body];
%                                 TFC.fr2.blockLs.blockLs(ii+2) = [];
% 
% %                                 TFC.splitCell( kthCell, allBl2(ii).block.blockE );
% %                                 cells = TFC.fr2.cells.cells;
% %                                 cells(kthCell).lLink = ii;
% %                                 cells(kthCell+1).lLink = [ii+1 ii+2];
% %                                 TFC.fr2.blockLs.blockLs(ii).cLink = [TFC.fr2.blockLs.blockLs(ii).cLink kthCell];        
% %                                 TFC.fr2.blockLs.blockLs(ii+1).cLink = [TFC.fr2.blockLs.blockLs(ii+1).cLink kthCell+1];
% %                                 TFC.fr2.blockLs.blockLs(ii+2).cLink = [TFC.fr2.blockLs.blockLs(ii+2).cLink kthCell+1];
%                             else
%                                 TFC.fr2.blockLs.blockLs(ii).block.blockE = TFC.fr2.blockLs.blockLs(ii+1).block.blockE;
%                                 TFC.fr2.blockLs.blockLs(ii).block.length = TFC.fr2.blockLs.blockLs(ii).block.blockE - TFC.fr2.blockLs.blockLs(ii).block.blockS + 1;
%                                 TFC.fr2.blockLs.blockLs(ii).block.profile = [TFC.fr2.blockLs.blockLs(ii).block.profile TFC.fr2.blockLs.blockLs(ii+1).block.profile];
%                                 TFC.fr2.blockLs.blockLs(ii).block.body = [TFC.fr2.blockLs.blockLs(ii).block.body TFC.fr2.blockLs.blockLs(ii+1).block.body];
%                                 TFC.fr2.blockLs.blockLs(ii+1) = [];
%                             end
%                             isTriSplit = 1;
%                             return;
%                              
% %                             kthCell = kthCell + 2;
% %                             cellN = cellN + 1;
% %                             ii = ii + 2;
%                         else
%                             cells(kthCell).lLink = ii;
%                             TFC.fr2.blockLs.blockLs(ii).cLink = [TFC.fr2.blockLs.blockLs(ii).cLink kthCell];
%                             kthCell = kthCell + 1;
%                         end
%                     end
%                 end
                ii = ii + 1;
            end
            %% correct cell profile and length
            for ii = 1:length(cells)
                cells(ii).block.blockS = round(cells(ii).block.blockS);
                cells(ii).block.blockE = round(cells(ii).block.blockE);
                if ii > 1 && cells(ii).block.blockS < cells(ii-1).block.blockE
                    cells(ii).block.blockS = cells(ii-1).block.blockE + 1;
                end
                cells(ii).block.length = cells(ii).block.blockE - cells(ii).block.blockS + 1;
                cells(ii).block.profile = TFC.fr2.lineProfile(cells(ii).block.blockS:cells(ii).block.blockE);
            end
            TFC.fr2.cells.cells = cells;
        end
        function splitCell( TFC, kthCell, newE )
        %UNTITLED3 Summary of this function goes here
        %   used only with cell Transfer function. not the one used for post processing
            cells = TFC.fr2.cells.cells;
            for ii = length(cells)+1:-1:kthCell+1
                cells(ii) = cells(ii-1);
            end
            km1thCell = cells(kthCell).mLink;
            c1 = TFC.fr1.cells.cells;
            for ii = km1thCell+1:length(c1)
                c1(ii).dLink = c1(ii).dLink + 1;
            end
            if ~isempty(km1thCell)
                if ~isempty(c1(km1thCell).dLink)
                    c1(km1thCell).dLink = [c1(km1thCell).dLink c1(km1thCell).dLink(end)+1];
                else
                    c1(km1thCell).dLink = 1;
                end
            end
            TFC.fr1.cells.cells = c1;
            cells(kthCell).block.blockE = newE-1;
            cells(kthCell).block.length = newE - cells(kthCell).block.blockS;
            cells(kthCell).block.profile = TFC.fr1.lineProfile(cells(kthCell).block.blockS:cells(kthCell).block.blockE);
            cells(kthCell).block.body    = TFC.fr1.channel(:,cells(kthCell).block.blockS:cells(kthCell).block.blockE);
            
            cells(kthCell+1).block.blockS = newE;
            cells(kthCell+1).block.length = cells(kthCell+1).block.blockE - cells(kthCell+1).block.blockS + 1;
            cells(kthCell+1).block.profile = TFC.fr1.lineProfile(cells(kthCell+1).block.blockS:cells(kthCell+1).block.blockE);
            cells(kthCell+1).block.body    = TFC.fr1.channel(:,cells(kthCell+1).block.blockS:cells(kthCell+1).block.blockE);
            TFC.fr2.cells.cells = cells;
        end
%         function combineCell( TFC, kthCell )
%             
%         end
    end
    methods
        function constructIm(TFC)
        %UNTITLED3 Summary of this function goes here
        %   Detailed explanation goes here
            spacerW = 10;
            channelL = size(TFC.fr1.channel,2);
            spacer = zeros(spacerW,channelL);
            labelColor = 6649;
            labelW = 3 ;
            ch1 = TFC.fr1.cells.cells;
            ch2 = TFC.fr2.cells.cells;
            mChannel = TFC.fr1.channel;
            maxColor = max(mChannel(:));
            for ithCell = 1:length(ch1)
                mChannel([1:5 14:18],round((ch1(ithCell).block.blockS + ch1(ithCell).block.blockE)/2)) = labelColor;
                %mChannel(1:3,[int64(cellS+cellE)/2]) = maxColor;
                if mod(ithCell,3) == 0
                    mChannel(1,int64(ch1(ithCell).block.blockS:ch1(ithCell).block.blockE)) = maxColor;
                elseif mod(ithCell,3) == 1
                    mChannel(2,int64(ch1(ithCell).block.blockS:ch1(ithCell).block.blockE)) = maxColor;
                else
                    mChannel(3,int64(ch1(ithCell).block.blockS:ch1(ithCell).block.blockE)) = maxColor;
                end
                daughtNum = length(ch1(ithCell).dLink);
                switch daughtNum
                    case 1
                        xT = (ch1(ithCell).block.blockS + ch1(ithCell).block.blockE)/2;
                        jthCell = ch1(ithCell).dLink;
                        if ~isempty(jthCell)
                            if jthCell>0
                                xB = (ch2(jthCell).block.blockS + ch2(jthCell).block.blockE)/2;
                                for xx = 1:spacerW
                                    yy = round((xx-1)*(xB-xT)/(spacerW-1)+xT);
                                    if yy+labelW > channelL
                                        spacer(xx,yy-labelW:end) = labelColor;
                                    else
                                        spacer(xx,max([yy-labelW,1]):yy+labelW) = labelColor;
                                    end

                                end
                            else
                                %disp(jthCell);
                            end
                        end
                    case 2
                        xT = (ch1(ithCell).block.blockS + ch1(ithCell).block.blockE)/2;
                        jthCell = ch1(ithCell).dLink;
                        xB1 = (ch2(jthCell(1)).block.blockS + ch2(jthCell(1)).block.blockE)/2;
                        xB2 = (ch2(jthCell(2)).block.blockS + ch2(jthCell(2)).block.blockE)/2;
                        for xx = 1:spacerW
                            yy = round((xx-1)*(xB1-xT)/(spacerW-1)+xT);
                            if yy+labelW > channelL
                                spacer(xx,yy-labelW:end) = labelColor;
                            else
                                spacer(xx,max([yy-labelW,1]):yy+labelW) = labelColor;                    
                            end
                            yy = round((xx-1)*(xB2-xT)/(spacerW-1)+xT);
                            if yy+labelW > channelL
                                spacer(xx,yy-labelW:end) = labelColor;
                            else
                                spacer(xx,max([yy-labelW,1]):yy+labelW) = labelColor;
                            end
                        end
                end
            end
            newIm1 = [mChannel; spacer];
%             TFC.newIm = [newIm1; TFC.fr2.channel];
             TFC.fr1.newIm = newIm1;
            TFC.fr1NewIm = newIm1;
%             if TFC.frameNum == 1
%                 TFC.fr1.newCh = mChannel;
%             end
            mChannel = TFC.fr2.channel;
            ch1 = TFC.fr2.cells.cells;
            for ithCell = 1:length(ch1)
                mChannel([1:5 14:18],round((ch1(ithCell).block.blockS + ch1(ithCell).block.blockE)/2)) = labelColor;
                %mChannel(1:3,[int64(cellS+cellE)/2]) = maxColor;
                if mod(ithCell,3) == 0
                    mChannel(1,int64(ch1(ithCell).block.blockS:ch1(ithCell).block.blockE)) = maxColor;
                elseif mod(ithCell,3) == 1
                    mChannel(2,int64(ch1(ithCell).block.blockS:ch1(ithCell).block.blockE)) = maxColor;
                else
                    mChannel(3,int64(ch1(ithCell).block.blockS:ch1(ithCell).block.blockE)) = maxColor;
                end
            end
            TFC.fr2NewCh = mChannel;
            TFC.fr2.newCh = mChannel;
        end
    end
end