clear;
fname = '4 5 channels-2.tif';
%channel_num = 2;
channelW = 18;
imageChannelN = 2;
channelsP = [];
testing = 0;
%%
f2Save = [fname(1:end-4) '.mat'];
info = imfinfo(fname);
num_images = numel(info);
kRange = 1:imageChannelN:num_images; 
for k = 1:length(kRange)
        allFrames_1{k} = imread(fname, kRange(k));
        allFrames_2{k} = imread(fname, kRange(k)+1);
        realChannelW = size(allFrames_1{k},1);
        realChannelL = size(allFrames_1{k},2);
        if realChannelW < channelW
            addSpaceL = floor((channelW - realChannelW)/2)+5;
            allFrames_1{k} = [zeros(addSpaceL,realChannelL);allFrames_1{k};zeros(addSpaceL,realChannelL)];
            allFrames_2{k} = [zeros(addSpaceL,realChannelL);allFrames_2{k};zeros(addSpaceL,realChannelL)];
        end
%        allFrames_3{k} = imread(fname, kRange(k)+2);
end
%%
allFrames = allFrames_1;
%% get channelsP
channelsP_max = [6];
channelsP = channelsP_max - 8;
%%
if realChannelW < channelW
    channelsP = 1;
end
%%
channel_all = struct([]);
channel2_all = struct([]);
for jj = 1:length(channelsP)
    channel_all(jj).channel = [];
    channel2_all(jj).channel = [];
    channel_all(jj).channel_rowN = [];
    channel_all(jj).channel_rowN(length(allFrames)) = 0;
    channel2_all(jj).channel_rowN = [];
    channel2_all(jj).channel_rowN(length(allFrames)) = 0;
    
    channelVerPos = channelsP(jj);
    for ii = 1:length(allFrames)
        if ii == 1
            channelVerPos = channelVerPos - veticalShift( allFrames{1}, allFrames{ii} );
        else
            channelVerPos = channelVerPos - veticalShift( allFrames{ii-1}, allFrames{ii} );
        end
        
        [maxNum maxPos] = max(sum(allFrames{ii}(channelVerPos:channelVerPos+channelW-1,:)'));
        channelVerPos = channelVerPos + maxPos - channelW/2;
        if channelVerPos <= 0
            channelVerPos = 1;
        end
        channel_all(jj).channel = [channel_all(jj).channel; double(allFrames{ii}(channelVerPos:channelVerPos+channelW-1,:))];
        channel2_all(jj).channel = [channel2_all(jj).channel; double(allFrames_2{ii}(channelVerPos:channelVerPos+channelW-1,:))];
        channel_all(jj).channel_rowN(ii) = channelVerPos;
        channel2_all(jj).channel_rowN(ii) = channelVerPos;
    end
end

%%
if testing == 0
    save (f2Save, 'channel_all', 'channel2_all', 'channelW');
else
    save (['test' f2Save], 'channel_all', 'channel2_all', 'channelW');
end