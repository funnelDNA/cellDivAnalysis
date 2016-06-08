function [ blocks ] = cursor2Block( allFr, cursors, varargin )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
channelW = 18;
spacerW  = 10;
cursorN = length(cursors);
blocks = zeros(cursorN,2);
if length(varargin) == 0
    blockType = 'cell';
else
    blockType = varargin{1};
end
kthB = 1;
for ii = 1:cursorN
    frameN = ceil(cursors(ii).Position(2)-(channelW/2+10)/(channelW + 10)-0.0001); % (channelW/2+10)/(channelW + 10), from how the image is plotted
    switch blockType
        case 'cell'
            frBlocks = allFr(frameN).cells.cells;
        case 'blockL'
            frBlocks = allFr(frameN).blockLs.blockLs;
        case 'blockS'
            frBlocks = allFr(frameN).blockSs.blockSs;
    end
    for jj = 1:length(frBlocks)
        if frBlocks(jj).block.blockS <= cursors(ii).Position(1) && frBlocks(jj).block.blockE >= cursors(ii).Position(1)
            uniB = blocks(blocks(:,1) == frameN,:);
            uniB = uniB(:,2);
            if isempty(uniB) || isempty(find(uniB == jj))
                blocks(kthB,1) = frameN;
                blocks(kthB,2) = jj;
                kthB = kthB + 1;
            end
            break;
        end
    end
    blocks(kthB:end,:) = [];
end
end

