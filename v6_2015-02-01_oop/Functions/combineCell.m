function [ output_args ] = combineCell( allFr, kthFr, kthCell, varargin )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
if length(allFr(kthFr).cells.cells) <= kthCell
    fprintf ('Combine error: edge of channel');
    exit;
end
if length(allFr(kthFr).cells.cells(kthCell).dLink) > 1 || length(allFr(kthFr).cells.cells(kthCell+1).dLink)>1
    fprintf ('Combine error: cell to combine cannot have two children');
    exit;
end
%% combine cells, needs also update blockL??
allFr(kthFr).blockLs.blockLs(kthCell).block.blockE = allFr(kthFr).blockLs.blockLs(kthCell+1).block.blockE;
allFr(kthFr).blockLs.blockLs(kthCell).block.length = allFr(kthFr).blockLs.blockLs(kthCell).block.blockE - allFr(kthFr).blockLs.blockLs(kthCell).block.blockS + 1;
allFr(kthFr).blockLs.blockLs(kthCell).block.profile = [allFr(kthFr).blockLs.blockLs(kthCell).block.profile allFr(kthFr).blockLs.blockLs(kthCell+1).block.profile];
allFr(kthFr).blockLs.blockLs(kthCell).block.body = [allFr(kthFr).blockLs.blockLs(kthCell).block.body allFr(kthFr).blockLs.blockLs(kthCell+1).block.body];
allFr(kthFr).blockLs.blockLs(kthCell+1) = [];

        b = allFr(kthFr-1);
        c = allFr(kthFr);  
        c.blockLs = c.blockLs.StitchBlocks();
        c.ProfileAlign();
        c.BlockAlign();

        d = TwoFrame1Ch;
        d.frameNum = b.frameNum;
        d.fr1 = b;
        d.fr2 = c;
        d.ProfileAlign;
        d.BlockAlign;
        d.CellTransfer;
        d.constructIm;
        allFr(kthFr) = c;

        b = allFr(kthFr);
        c = allFr(kthFr+1);

        d = TwoFrame1Ch;
        d.frameNum = b.frameNum;
        d.fr1 = b;
        d.fr2 = c;
        d.ProfileAlign;
        d.BlockAlign;
        d.CellTransfer;
        d.constructIm;
        allFr(kthFr+1) = c;
end

