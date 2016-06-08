%viewAlignmentOop(allFr,2);
%d.CellTransfer;
anlyzeSingleFile = 1;
singleFileName = 'ch1.mat';
startFr = 1;
isNewAna = 1;
debuggingFr = 0;
cellType = 'C';
threshold4B = 1500;
threshold4C = 300;
%%
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
nFolders = length(folders);
if anlyzeSingleFile == 1
    nFolders = 1;
end
%%
switch cellType
    case 'B'
        threshold = threshold4B; %1500 for B Subtilis data
    case 'C'
        threshold = threshold4C; %1500 for B Subtilis data
    otherwise
        fprintf ('unknown cell type!');
        pause;
end
%%                
f1 = figure;
f2 = figure;
for kthFolder = 1:nFolders
    if anlyzeSingleFile ~= 1
        cd(folders{kthFolder});
        disp(folders{kthFolder});
    end
    %%
    allFiles = dir('*.mat');
    nFiles = length(allFiles);
    if anlyzeSingleFile == 1
        nFiles = 1;
    end
    for kthFile = 1:nFiles
        fName = allFiles(kthFile).name;
        %fName = 'ch2.mat';
        if anlyzeSingleFile == 1
            fName = singleFileName;
        end
        load(fName);
        fprintf('%s\t',fName);
        if anlyzeSingleFile == 0 && std(results(1).lineProfile) < 100
            fprintf('...skipped\n');
            continue;
        else
            fprintf('.................Analyzing.....................\n');
        end
        %%    
            if isNewAna == 1
            %    clear;channels
                %clc;
                %close all;
                isNewAna = 1;
                allFr = Frame1Ch();
            %    load ch1.mat
                %results(54) = [];
            end
            
            endFr   = length(results)-1;
            %endFr   = 135;
            profile on;
            tic;
            allFr(length(results)) = Frame1Ch();
            newIm = [];
            
            if isNewAna == 1
                b = Frame1Ch(results,startFr,cellType,threshold);
                b.SearchBlock('BlockL');
                b.blockLs = b.blockLs.StitchBlocks();
                b.SearchBlock('BlockS');
                b.SearchBlock('Cell');
                b.blockSs = b.blockSs.StitchBlocks();
                b.ProfileAlign();
                b.BlockAlign();
                for ii = 1:length(b.cells.cells)
                    b.cells.cells(ii).lLink = ii;
                    b.blockLs.blockLs(ii).cLink = ii;
                end
                allFr(startFr) = b;
            end
            for kthFrame = startFr:endFr
                fprintf ('Analyzing Frame...:\t%d\n',kthFrame);
                b = allFr(kthFrame);

                c = Frame1Ch(results,kthFrame + 1,cellType,threshold);
                c.SearchBlock('BlockL');
                c.blockLs = c.blockLs.StitchBlocks();
                c.SearchBlock('BlockS');
                c.blockSs = c.blockSs.StitchBlocks();
                c.ProfileAlign('bright');
                %c.ProfileAlign();
                c.BlockAlign();

                d = TwoFrame1Ch;
                d.frameNum = b.frameNum;
                d.fr1 = b;
                d.fr2 = c;
                if kthFrame == debuggingFr
                    ;
                end
                d.ProfileAlign();
                d.BlockAlign;

                while d.CellTransfer == 1 % triple split
                    c.cells.cells = [];
                    c.blockSs.blockSs = [];
                    c.SearchBlock('BlockS');
                    c.blockSs = c.blockSs.StitchBlocks();
                    for kthBlock = 1:length(c.blockLs.blockLs)
                        c.blockLs.blockLs(kthBlock).sLink = [];
                        c.blockLs.blockLs(kthBlock).kp1sLink = [];
                        c.blockLs.blockLs(kthBlock).cLink = [];
                    end

                    c.blockLs = c.blockLs.StitchBlocks();
                    c.ProfileAlign();
                    c.BlockAlign();
                    d.fr2 = c;
                    d.ProfileAlign;
                    d.BlockAlign;
        %             d.CellTransfer;
                end
                d.constructIm;
                newIm = [newIm; b.newIm];
                figure(f1); hold off; imagesc([b.newIm; c.newCh]);
                allFr(kthFrame+1) = c;
            end
            toc;
            profile off
            %%
            allData = AllData(allFr, newIm);
            allData.channelW = channelW;
            allData.startFr = startFr;
            %%
            figure(f2);
            imagesc(newIm,'ydata',((1:size(newIm,1))+channelW/2+10)/(channelW + 10)+startFr-1);
            set(gca,'fontsize',20);
        %%
        if anlyzeSingleFile == 0
            allData.cleanData;
            save ([fName(1:end-4), '_final.mat'],'allData');
            fprintf('...done\n');
        end
    end
    if anlyzeSingleFile == 0
        cd('../');
    end
end
%%
            %%
            imagesc(channels,'ydata',((1:size(channels,1))+channelW/2)/(channelW ));
            set(gca,'fontsize',20);
            xlabel('position (pixel)');
            ylabel('frame number');