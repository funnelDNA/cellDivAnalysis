function [ output_args ] = cellDieNextFr( allFr, cursor )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[ cells ] = cursor2Block( allFr, cursor, 'cell' );
[ blockSs ] = cursor2Block( allFr, cursor, 'blockS' );
[ blockLs ] = cursor2Block( allFr, cursor, 'blockL' );

frames = cells(:,1);
for ii = 1:length(frames)
    kthFr = frames(ii);
    allFr(kthFr).cells.cells(cells(ii,2)).isSkip = 1;
    allFr(kthFr).cells.cells(cells(ii,2)).dLink = [];
end

frames = blockSs(:,1);
for ii = 1:length(frames)
    kthFr = frames(ii);
    allFr(kthFr).blockSs.blockSs(blockSs(ii,2)).isSkip = 1;
end

frames = blockLs(:,1);
for ii = 1:length(frames)
    kthFr = frames(ii);
    allFr(kthFr).blockLs.blockLs(blockLs(ii,2)).isSkip = 1;
end

b = allFr(kthFr);
b.blockLs = b.blockLs.StitchBlocks();
b.blockSs = b.blockSs.StitchBlocks();
b.ProfileAlign();
b.BlockAlign();

c = allFr(kthFr + 1);
    for ii = 1:length(c.blockLs.blockLs)
        c.blockLs.blockLs(ii).cLink = [];
    end

    d = TwoFrame1Ch;
    d.frameNum = b.frameNum;
    d.fr1 = b;
    d.fr2 = c;
    d.ProfileAlign;
    d.BlockAlign;
    d.CellTransfer;
    d.constructIm;
    %newIm = [newIm; b.newIm];
    figure; imagesc([b.newIm; c.newCh]);
    
    allFr(kthFr) = b;
    allFr(kthFr+1) = c;

end

