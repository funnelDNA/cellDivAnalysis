clear;
intMode = 'lastFrIntNor';
intMode = 'lastFrInt';

isSingleFile = 0;
singleFolderName = 'DK1437_1mMIPTG(series 16)-1-130_rotated_cropped_backgrndsub50';
singleFileName = 'ch2_allCell.mat';
folders = [];
folders{1} = 'DK14371mM_IPTG.nd2 (series 02)-1-250_stabilized-backgrndsub10';
folders{2} = 'DK14371mM_IPTG.nd2 (series 03)-1-250_stabilized-backgrndsub10';
folders{3} = 'DK14371mM_IPTG.nd2 (series 04)-1-250-stabilized-backgrndsub10';
folders{4} = 'DK14371mM_IPTG.nd2 (series 05)-1-250-stabilized-backgrndsub10';
folders{5} = 'DK14371mM_IPTG.nd2 (series 06)-1-250-stabilized-backgrndsub10';
folders{6} = 'DK14371mM_IPTG.nd2 (series 07)-1-250-stabilized-backgrndsub10';
folders{7} = 'DK14371mM_IPTG.nd2 (series 08)-1-250-stabilized-backgrndsub10';
folders{8} = 'DK14371mM_IPTG.nd2 (series 09)-1-268-stabilized-backgrndsub10';
folders{9} = 'DK14371mM_IPTG.nd2 (series 10)-1-250_stabilized-backgrndsub10';
folders{10} = 'DK14371mM_IPTG.nd2 (series 11)-1-250-stabilized-backgrndsub10';
folders{11} = 'DK14371mM_IPTG.nd2 (series 12)-1-250-stabilized-backgrndsub10';
folders{12} = 'DK14371mM_IPTG.nd2 (series 13)-1-250-stabilized-backgrndsub10';
folders{13} = 'DK14371mM_IPTG.nd2 (series 14)-1-250_stabilized-backgrndsub10';
folders{14} = 'DK14371mM_IPTG.nd2 (series 15)-1-250-stabilized-backgrndsub10';
folders{15} = 'DK14371mM_IPTG.nd2 (series 16)-1-250-stabilized-backgrndsub10';

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
    cd(folders{kthFolder});
    disp(folders{kthFolder});
    files2Load = dir('ch*_allCell_contour.mat');
    if isSingleFile == 1
        endFile = 1;
        files2Load(1).name = singleFileName;
    else
        endFile = length(files2Load);
    end
    for kthFile = 1:endFile
        generation1 = [];
        serieA = [];    serieB = [];
        load (files2Load(kthFile).name); % load 'allCell'
        disp(files2Load(kthFile).name);
        for kthCell = 1:length(allCell)
            if allCell(kthCell).isComplete == true && allCell(kthCell).generation == startGen
                generation1 = [generation1 allCell(kthCell).id];
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
                if length(allCell(serieA).dLink) == 2 %&& allCell(allCell(serieA).dLink(1)).isComplete == 1 && allCell(allCell(serieA).dLink(2)).isComplete == 1
                    generation1 = [generation1 allCell(serieA).dLink];
                end
                if length(allCell(serieB).dLink) == 2 %&& allCell(allCell(serieB).dLink(1)).isComplete == 1 && allCell(allCell(serieB).dLink(2)).isComplete == 1
                    generation1 = [generation1 allCell(serieB).dLink];
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
                    if strcmp(intMode, 'lastFrIntNor')
                        for ii = 1:length(serieA)
                            if ~isempty(allCell(serieA(ii)).dLink) && allCell(allCell(serieA(ii)).dLink(1)).isComplete == 1
                                serieAchld = [serieAchld allCell(serieA(ii)).dLink(1)];
                                serieAInt = [serieAInt allCell(allCell(serieA(ii)).dLink(1)).lastFrIntNor];
                            end
                            if length(allCell(serieA(ii)).dLink) == 2 && allCell(allCell(serieA(ii)).dLink(2)).isComplete == 1
                                serieAchld = [serieAchld allCell(serieA(ii)).dLink(2)];
                                serieAInt = [serieAInt allCell(allCell(serieA(ii)).dLink(2)).lastFrIntNor];
                            end
                        end
                        for ii = 1:length(serieB)
                            if ~isempty(allCell(serieB(ii)).dLink) && allCell(allCell(serieB(ii)).dLink(1)).isComplete == 1
                                serieBchld = [serieBchld allCell(serieB(ii)).dLink(1)];
                                serieBInt = [serieBInt allCell(allCell(serieB(ii)).dLink(1)).lastFrIntNor];
                            end
                            if length(allCell(serieB(ii)).dLink) == 2 && allCell(allCell(serieB(ii)).dLink(2)).isComplete == 1
                                serieBchld = [serieBchld allCell(serieB(ii)).dLink(2)];
                                serieBInt = [serieBInt allCell(allCell(serieB(ii)).dLink(2)).lastFrIntNor];
                            end
                        end
                    else
                        for ii = 1:length(serieA)
                            if ~isempty(allCell(serieA(ii)).dLink) && allCell(allCell(serieA(ii)).dLink(1)).isComplete == 1
                                serieAchld = [serieAchld allCell(serieA(ii)).dLink(1)];
                                serieAInt = [serieAInt allCell(allCell(serieA(ii)).dLink(1)).lastFrInt];
                            end
                            if length(allCell(serieA(ii)).dLink) == 2 && allCell(allCell(serieA(ii)).dLink(2)).isComplete == 1
                                serieAchld = [serieAchld allCell(serieA(ii)).dLink(2)];
                                serieAInt = [serieAInt allCell(allCell(serieA(ii)).dLink(2)).lastFrInt];
                            end
                        end
                        for ii = 1:length(serieB)
                            if ~isempty(allCell(serieB(ii)).dLink) && allCell(allCell(serieB(ii)).dLink(1)).isComplete == 1
                                serieBchld = [serieBchld allCell(serieB(ii)).dLink(1)];
                                serieBInt = [serieBInt allCell(allCell(serieB(ii)).dLink(1)).lastFrInt];
                            end
                            if length(allCell(serieB(ii)).dLink) == 2 && allCell(allCell(serieB(ii)).dLink(2)).isComplete == 1
                                serieBchld = [serieBchld allCell(serieB(ii)).dLink(2)];
                                serieBInt = [serieBInt allCell(allCell(serieB(ii)).dLink(2)).lastFrInt];
                            end
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