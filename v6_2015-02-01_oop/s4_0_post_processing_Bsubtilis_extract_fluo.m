clear;
isSingleFile = 0;
singleFolderName = 'DK1437_1mMIPTG(series 16)-1-130_rotated_cropped_backgrndsub50';
singleFileName = 'ch3_allCell.mat';
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
for kthFolder = 1:endFolder
    load([folders{kthFolder} '.mat']);    
    %% load frames for second fluorescence channel
    tifFileName = [folders{kthFolder} '.tif'];
    imageChannelN = 2;
    info = imfinfo(tifFileName);
    num_images = numel(info);
    kRange = 1:imageChannelN:num_images; 
    for k = 1:length(kRange)
    %        allFrames_1{k} = imread(fName, kRange(k));
            allFrames_2{k} = imread(tifFileName, kRange(k)+1);
    %        allFrames_3{k} = imread(fName, kRange(k)+2);
    end
    % load second fluorescence channel
    for kthCh = 1:length(channel_all)    
        %channel2_all(kthCh).channel = zeros(size(channel_all(kthCh).channel));
        channel2_all(kthCh).channel = [];
        channelsP = channel_all(kthCh).channel_rowN;
        for kthFrame = 1:size(channel_all(kthCh).channel,1)/channelW
            channel2_all(kthCh).channel = [channel2_all(kthCh).channel; double(allFrames_2{kthFrame}(channelsP:channelsP+channelW-1,:))];
        end
    end
    %%
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
        load (files2Load(kthFile).name); % load 'allCell'
        disp(files2Load(kthFile).name);
        if exist([files2Load(kthFile).name(1:3) '_final_2_contour.mat']) % load 'allData'
            load ([files2Load(kthFile).name(1:3) '_final_2_contour.mat']);
        else
            load ([files2Load(kthFile).name(1:3) '_final_contour.mat']);
        end
        for kthCell = 1:length(allCell)
            if allCell(kthCell).isComplete == true;
                %for cellHistKthFr = 1:size(allCell(kthCell).frLocs,1)
                    % extract fluorescence of a single cell
                    kthChannel = str2num(files2Load(kthFile).name(3));
                    cellHistKthFr = size(allCell(kthCell).frLocs,1);
                    kthFr = allCell(kthCell).frLocs(cellHistKthFr,1);
                    jthCell = allCell(kthCell).frLocs(cellHistKthFr,2);
                    cellBlock = allData.allFr(kthFr).cells.cells(jthCell).block;
                    area2Ana2 = channel2_all(kthChannel).channel((kthFr-1)*channelW+1:kthFr*channelW,cellBlock.blockS:cellBlock.blockE);
                    area2Ana = channel_all(kthChannel).channel((kthFr-1)*channelW+1:kthFr*channelW,cellBlock.blockS:cellBlock.blockE);
                    % analyze cell intensity
                    allCell(kthCell).lastFrIntCh1 = median(max(area2Ana));
                    allCell(kthCell).lastFrInt = median(max(area2Ana2));
                    allCell(kthCell).lastFrIntNor = median(max(area2Ana2))/median(max(area2Ana));
                    %% test code
                    if (allCell(kthCell).lastFrIntCh1<2000)
                        fprintf('%s\tch%s\n',folders{kthFolder},files2Load(kthFile).name);
                    end
                    
                %end
            end
        end
        if isSingleFile == 0
            save (files2Load(kthFile).name, 'allCell', '-append');
        end
    end
    cd('../');
end

%% unit conversion
um2pix = 7.5;
pix2um = 1/um2pix;
fr2min = 5;
min2fr = 1/fr2min;

pos_gr(:,2) = pos_gr(:,2).*pix2um./fr2min.*1000;
time_gr(:,1) = time_gr(:,1).*fr2min;
time_gr(:,2) = time_gr(:,2).*pix2um./fr2min.*1000;
sisterDivT = sisterDivT.*fr2min;
%%
figure;
plot(time_gr(:,1),time_gr(:,2),'o')
figure;
plot(pos_gr(:,1),pos_gr(:,2),'o')
figure;
plot(sisterDivT(:,1),sisterDivT(:,2),'o');