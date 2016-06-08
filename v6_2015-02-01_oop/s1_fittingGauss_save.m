clear; clc; close all;
tic;        profile on;

allFile = dir('*.mat');

%for ii = 8:length(allFile)
for ii = 4:4
load (allFile(ii).name);
mkdir(allFile(ii).name(1:end-4));
fprintf('%s,   %d channels\n',allFile(ii).name,length(channel_all));
for iii = 1:length(channel_all)
    f2Save = ['ch' num2str(iii) '.mat'];
    channels = channel_all(iii).channel;
    channel_rowN = channel_all(iii).channel_rowN;
    channel2Ana = channels;
    results = [];
    for kthChannel = 1:channelW:size(channel2Ana,1)
        kthFrame = (kthChannel-1)/18+1;
        oneChannel = channel2Ana(kthChannel:kthChannel+channelW-1,:);
        fprintf('%d\n',kthChannel);    
    %% Gaussian fit
        coEff = fit_Gaussian(oneChannel);
        results(kthFrame).channel = oneChannel;
        results(kthFrame).fitting = coEff;
        lineProfile = (coEff(:,1));
        results(kthFrame).lineProfile = lineProfile';
    end
    save ([pwd '\' allFile(ii).name(1:end-4) '\' f2Save],'channels','channel_rowN','channelW','results');
end
end
toc;        profile viewer;
