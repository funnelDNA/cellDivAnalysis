clear;
%intMode = 'lastFrIntNor';
intMode = 'lastFrInt';
ONOFFMode = 'ON';
isSingleFile = 0;
singleFolderName = 'DK1437_1mMIPTG(series 16)-1-130_rotated_cropped_backgrndsub50';
singleFileName = 'ch2_allCell.mat';
folders = [];
folders{1} = 'DK1437PLoC.nd2 (series 01)-1-151_cropped_backgrdsub10';
folders{2} = 'DK1437PLoC.nd2 (series 04)-1-235_cropped_backgrdsub10';
folders{3} = 'DK1437PLoC.nd2 (series 05)-1-235_cropped_backgrdsub10';
folders{4} = 'DK1437PLoC.nd2 (series 08)-1-45_cropped_backgrdsub10';
folders{5} = 'DK1437PLoC.nd2 (series 09)-1-50_cropped_backgrdsub10';
folders{6} = 'DK1437PLoC.nd2 (series 10)-1-235_cropped_backgrdsub10';
folders{7} = 'DK1437PLoC.nd2 (series 13)-1-50_cropped_backgrdsub10';

if isSingleFile == 1
    endFolder = 1;
    folders{1} = singleFolderName;
else
    endFolder = length(folders);
end

generation1 = [];
genInt{20} = [];
startGen = 1;
for kthFolder = 1:endFolder
    %% step into folder, list files to analyze
    cd(folders{kthFolder});
    disp(folders{kthFolder});
    files2Load = dir('ch*_allCell_contour.mat');
    if isSingleFile == 1
        endFile = 1;
        files2Load(1).name = singleFileName;
    else
        endFile = length(files2Load);
    end
    %% run through files
    for kthFile = 1:endFile
        %% load file
        generation1 = [];
        serieA = [];    serieB = [];
        load (files2Load(kthFile).name); % load 'allCell'
        disp(files2Load(kthFile).name);
        %% get all intensity of sencond channel, to determine threshold
%         threPerct = 20; % 20%
%         nCells = length(allCell);
%         allInt = zeros(nCells,1);
%         for kthCell = 1:nCells
%             if allCell(kthCell).isComplete == true
%                 allInt(kthCell) = allCell(kthCell).lastFrInt;
%             end
%         end
%         allInt(allInt==0) = [];
%         allIntSorted = sort(allInt);
%         thresholdON = allIntSorted(round(length(allInt)*threPerct/100));
%         thresholdOFF = allIntSorted(end-round(length(allInt)*threPerct/100));
        thresholdON = 2663;
        thresholdOFF = 1032;
        %%
        for kthCell = 1:length(allCell)
            if strcmp(ONOFFMode,'ON')
                if allCell(kthCell).isComplete == true && allCell(allCell(kthCell).mLink).lastFrInt > thresholdON
                    generation1 = [generation1 allCell(kthCell).id];
                end
            elseif strcmp(ONOFFMode,'OFF')
                if allCell(kthCell).isComplete == true && allCell(allCell(kthCell).mLink).lastFrInt < thresholdOFF
                    generation1 = [generation1 allCell(kthCell).id];
                end
            end
        end
        kthCell = 0;
        while kthCell < length(generation1)
            kthCell = kthCell + 1;
            if allCell(generation1(kthCell)).sister > allCell(generation1(kthCell)).id % found a pair
                curGen = 1;
                serieA = allCell(generation1(kthCell)).id;
                serieB = allCell(generation1(kthCell)).sister;
                if allCell(serieA).isComplete ~= 1 || allCell(serieB).isComplete ~= 1
                    continue;
                end
                if strcmp(intMode, 'lastFrIntNor')
                    genInt{1} = [genInt{1};  allCell(allCell(generation1(kthCell)).id).lastFrIntNor allCell(allCell(generation1(kthCell)).sister).lastFrIntNor];
                elseif strcmp(intMode, 'lastFrInt')
                    genInt{1} = [genInt{1};  allCell(allCell(generation1(kthCell)).id).lastFrInt allCell(allCell(generation1(kthCell)).sister).lastFrInt];
                else
                    fprintf('wrong mode');
                    exit;
                end
                while allCell(serieA(1)).isComplete == 1
                    curGen = curGen + 1;
                    serieAchld = [];    serieAInt = [];
                    serieBchld = [];    serieBInt = [];
                    isBreak = 0;
                        
                    for ii = 1:length(serieA)
                        if ~isempty(allCell(serieA(ii)).dLink) && allCell(allCell(serieA(ii)).dLink(1)).isComplete == 1
                            if strcmp(intMode, 'lastFrIntNor')
                                sA_d1_cellInt = allCell(allCell(serieA(ii)).dLink(1)).lastFrIntNor;
                            else
                                sA_d1_cellInt = allCell(allCell(serieA(ii)).dLink(1)).lastFrInt;
                            end
                            serieAchld = [serieAchld allCell(serieA(ii)).dLink(1)];
                            serieAInt = [serieAInt sA_d1_cellInt];
                        end
                        if length(allCell(serieA(ii)).dLink) == 2 && allCell(allCell(serieA(ii)).dLink(2)).isComplete == 1
                            if strcmp(intMode, 'lastFrIntNor')
                                sA_d2_cellInt = allCell(allCell(serieA(ii)).dLink(2)).lastFrIntNor;
                            else
                                sA_d2_cellInt = allCell(allCell(serieA(ii)).dLink(2)).lastFrInt;
                            end
                            serieAchld = [serieAchld allCell(serieA(ii)).dLink(2)];
                            serieAInt = [serieAInt sA_d2_cellInt];
                        end
                    end
                    for ii = 1:length(serieB)
                        if ~isempty(allCell(serieB(ii)).dLink) && allCell(allCell(serieB(ii)).dLink(1)).isComplete == 1
                            if strcmp(intMode, 'lastFrIntNor')
                                sB_d1_cellInt = allCell(allCell(serieB(ii)).dLink(1)).lastFrIntNor;
                            else
                                sB_d1_cellInt = allCell(allCell(serieB(ii)).dLink(1)).lastFrInt;
                            end
                            serieBchld = [serieBchld allCell(serieB(ii)).dLink(1)];
                            serieBInt = [serieBInt sB_d1_cellInt];
                        end
                        if length(allCell(serieB(ii)).dLink) == 2 && allCell(allCell(serieB(ii)).dLink(2)).isComplete == 1
                            if strcmp(intMode, 'lastFrIntNor')
                                sB_d2_cellInt = allCell(allCell(serieB(ii)).dLink(2)).lastFrIntNor;
                            else
                                sB_d2_cellInt = allCell(allCell(serieB(ii)).dLink(2)).lastFrInt;
                            end
                            serieBchld = [serieBchld allCell(serieB(ii)).dLink(2)];
                            serieBInt = [serieBInt sB_d2_cellInt];
                        end
                    end

                    if ~isempty(serieAInt) && ~isempty(serieBInt)
                        if curGen == 4
                            a = 1;
                        end
                        genInt{curGen} = [genInt{curGen}; mean(serieAInt) mean(serieBInt)];
                        serieA = serieAchld;
                        serieB = serieBchld;
                    else
                        break;
                    end
                end
            end
        end
    end
    cd('../');
end
%% plot for each generation
h1 = figure;
for ii = 1:length(genInt)
    if ~isempty (genInt{ii})
        %figure;
        %plot (genInt{ii}(:,1),genInt{ii}(:,2),'o');
            x = genInt{ii}(:,1);
            [coEff] = polyfit(x,genInt{ii}(:,2),1);
            slop = coEff(1);
            yfit = polyval(coEff,x);
            yresid = genInt{ii}(:,2) - yfit;
            rsq(ii) = 1-sum(yresid.^2)/((length(genInt{ii}(:,2))-1)*var(genInt{ii}(:,2)));
            figure();  plot(x,genInt{ii}(:,2),'o','color','b');
            hold on;
            plot(x,yfit,'r');
            xlabel('lineage "a" (int)');
            xlabel('lineage "b" (int)');
    end
end