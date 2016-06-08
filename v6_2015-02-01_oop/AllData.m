classdef AllData < matlab.mixin.Copyable
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        allFr
        newIm
        channelW
        startFr
    end
    
    methods 
        function allData = AllData(allFr, newIm)
            allData.allFr = allFr;
            allData.newIm = newIm;
        end
        function allCell = extractCell(allData)
            %% extract cells
            %allFr = allData.allFr;
            kthCell = 1;
            allCell = CellHist;
            nGoodCell = 0;
            for kthFr = allData.startFr:length(allData.allFr)-1
                cells = allData.allFr(kthFr).cells.cells;
                for jthCell = 1:length(cells)
                    if cells(jthCell).cellId == 0 % new cell
                        allData.allFr(kthFr).cells.cells(jthCell).cellId = kthCell;
                        cells(jthCell).cellId = kthCell;
                        allCell(kthCell).id = kthCell;
                        %allCell(kthCell).startFr = kthFr;
                        %allCell(kthCell).startCell = jthCell;
                        allCell(kthCell).frLocs = [allCell(kthCell).frLocs; kthFr, jthCell];
                        allCell(kthCell).mLink = [];
                        allCell(kthCell).leftPole = 0;
                        allCell(kthCell).rightPole = 0;
                        if kthFr == allData.startFr
                            allCell(kthCell).generation = 0;
                        end
                        kthCell = kthCell + 1;
                    else
                        allCell(cells(jthCell).cellId).frLocs = [allCell(cells(jthCell).cellId).frLocs; kthFr, jthCell];
                    end
                    switch length(cells(jthCell).dLink)
                        case 0 % cell leaves channel
                            %allCell(cells(jthCell).cellId).endFr = kthFr;
                            %allCell(cells(jthCell).cellId).endCell = jthCell;

                        case 1 % cell history continues
                            allData.allFr(kthFr+1).cells.cells(cells(jthCell).dLink).cellId = cells(jthCell).cellId;
                        case 2 % cell history ends, creat two new cells
                            % modify allCell(cells(jthCell).id)
                            allCell(cells(jthCell).cellId).dLink = [kthCell kthCell + 1];
                            %  check isComplete, get endFr
                            if ~isempty(allCell(cells(jthCell).cellId).mLink)
                                allCell(cells(jthCell).cellId).isComplete = true;
                                nGoodCell = nGoodCell + 1;
                            end
                            %allCell(cells(jthCell).cellId).endFr = kthFr;
                            %allCell(cells(jthCell).cellId).endCell = jthCell;
                            % create two new cells
                            allCell(kthCell).id = kthCell;
                            %allCell(kthCell).startFr = kthFr + 1;
                            %allCell(kthCell).startCell = cells(jthCell).dLink(1);
                            allData.allFr(kthFr+1).cells.cells(cells(jthCell).dLink(1)).cellId = kthCell;
                            allCell(kthCell).mLink = cells(jthCell).cellId;
                            allCell(kthCell).sister = kthCell + 1;
                            allCell(kthCell).generation = allCell(cells(jthCell).cellId).generation + 1;
                            
                            kthCell = kthCell + 1;

                            allCell(kthCell).id = kthCell;
                            %allCell(kthCell).startFr = kthFr + 1;
                            %allCell(kthCell).startCell = cells(jthCell).dLink(2);
                            allData.allFr(kthFr+1).cells.cells(cells(jthCell).dLink(2)).cellId = kthCell;
                            allCell(kthCell).mLink = cells(jthCell).cellId;
                            allCell(kthCell).sister = kthCell - 1;
                            allCell(kthCell).generation = allCell(cells(jthCell).cellId).generation + 1;
                            
                            %disp(kthFr);
                            %disp(cells(jthCell).dLink);
                            blockS1 = allData.allFr(kthFr+1).cells.cells(cells(jthCell).dLink(1)).block.blockS;
                            blockS2 = allData.allFr(kthFr+1).cells.cells(cells(jthCell).dLink(2)).block.blockS;
                            if blockS1 < blockS2
                                allCell(kthCell-1).leftPole = 0; % pole == 0 means old pole
                                allCell(kthCell-1).rightPole = 1; % pole == 1 means new pole
                                allCell(kthCell).leftPole = 1;
                                allCell(kthCell).rightPole = 0;
                                
                                if allCell(cells(jthCell).cellId).leftPole == 1
                                    allCell(kthCell-1).cellType = 1; % swarmer, divided from the new pole, age = 1
                                    allCell(kthCell-1).age = 1;
                                    allCell(kthCell).cellType = 0;   % stalk, divided from the old pole, age = age of mother + 1
                                    if allCell(cells(jthCell).cellId).age ~= -1
                                        allCell(kthCell).age = allCell(cells(jthCell).cellId).age + 1;
                                    end
                                end
                                if allCell(cells(jthCell).cellId).rightPole == 1
                                    allCell(kthCell-1).cellType = 0; % stalk
                                    if allCell(cells(jthCell).cellId).age ~= -1
                                        allCell(kthCell-1).age = allCell(cells(jthCell).cellId).age + 1;
                                    end
                                    allCell(kthCell).cellType = 1;   % swarmer
                                    allCell(kthCell).age = 1;
                                end
                            else
                                allCell(kthCell-1).leftPole = 1;
                                allCell(kthCell-1).rightPole = 0;
                                allCell(kthCell).leftPole = 0;
                                allCell(kthCell).rightPole = 1;
                                
                                if allCell(cells(jthCell).cellId).leftPole == 1
                                    allCell(kthCell-1).cellType = 0; % stalk
                                    if allCell(cells(jthCell).cellId).age ~= -1
                                        allCell(kthCell-1).age = allCell(cells(jthCell).cellId).age + 1;
                                    end
                                    allCell(kthCell).cellType = 1;   % swarmer
                                    allCell(kthCell).age = 1;
                                end
                                if allCell(cells(jthCell).cellId).rightPole == 1
                                    allCell(kthCell-1).cellType = 1; % swarmer
                                    allCell(kthCell-1).age = 1;
                                    allCell(kthCell).cellType = 0;   % stalk
                                    if allCell(cells(jthCell).cellId).age ~= -1
                                        allCell(kthCell).age = allCell(cells(jthCell).cellId).age + 1;
                                    end
                                end
                            end
                            kthCell = kthCell + 1;
                        otherwise
                            fprintf('dLink length of the cell is neither 0 or 1 or 2,\t');
                            fprintf('Frame %d,\tCell %d\n',kthFr,kthCell);
                    end
                end
            end
            %% process good cells, calculate growthRate, endFrPos, divT
            %h1 = figure;
            deviceW = size(allData.allFr(allData.startFr).channel,2);
            for kthCell = 1:length(allCell)
                if allCell(kthCell).isComplete == true
                    frLocs = allCell(kthCell).frLocs;
                    % get divT
                    allCell(kthCell).divT = size(frLocs,1); % in the unit of frame
                    % get endFrPos
                    endCellBlock = allData.allFr(frLocs(end,1)).cells.cells(frLocs(end,2)).block;
                    allCell(kthCell).endFrPos = (endCellBlock.blockS + endCellBlock.blockE)/2/deviceW;
                    % get growthRate, fit allLen
                    allLen = [];
                    allArea = [];
                    for kthFr = frLocs(1,1):frLocs(end,1)
                        allLen = [allLen; allData.allFr(kthFr).cells.cells(frLocs(kthFr-frLocs(1,1)+1,2)).block.length];
                        allArea = [allArea; allData.allFr(kthFr).cells.cells(frLocs(kthFr-frLocs(1,1)+1,2)).area];
                    end
                    x = (1:length(allLen))';
                    coEff = polyfit(x,allLen,1);
                    allCell(kthCell).grLength = coEff(1);
                    yfit = polyval(coEff,x);
                    
                    x = (1:length(allArea))';
                    coEff = polyfit(x,allArea,1);
                    allCell(kthCell).grArea = coEff(1);
                    yfit = polyval(coEff,x);
                    %figure(h1);  plot(x,allLen,'b',x,yfit,'r');
                end
            end
            %% For startFr is larger than 1, should correct the generation number
            aveDivT = 9;
            generationCorE = floor(allData.startFr/9);
            for kthCell = 1:length(allCell)
                if allCell(kthCell).generation ~= -1
                    allCell(kthCell).generation = allCell(kthCell).generation + generationCorE;
                end
            end
            %%
            %save ([chName '_allCell.mat'], 'allCell');
        end
        function newIm = linkedIm (allData)
            newIm = [];
            allFr = allData.allFr;
            for kthFrame = allData.startFr:length(allData.allFr)-1
                b = allFr(kthFrame);
                c = allFr(kthFrame+1);

                d = TwoFrame1Ch;
                d.frameNum = b.frameNum;
                d.fr1 = b;
                d.fr2 = c;
                d.constructIm;
                newIm = [newIm; d.fr1NewIm];
                allFr(kthFrame).newIm = d.fr1NewIm;
                allFr(kthFrame+1).newCh = d.fr2NewCh;
            end
            newIm = [newIm; d.fr2NewCh];
        end
        function cleanData(allData)
            startFr = allData.startFr;
            allData.newIm = [];
            for ii = startFr:length(allData.allFr)
                allData.allFr(ii).newIm = [];
                allData.allFr(ii).newCh = [];
                
                for jj = 1:length(allData.allFr(ii).blockLs.blockLs)
                    allData.allFr(ii).blockLs.blockLs(jj).block.body = [];
                end
                for jj = 1:length(allData.allFr(ii).blockSs.blockSs)
                    allData.allFr(ii).blockSs.blockSs(jj).block.body = [];
                end
                for jj = 1:length(allData.allFr(ii).cells.cells)
                    allData.allFr(ii).cells.cells(jj).block.body = [];
                end
            end
        end
    end
end

