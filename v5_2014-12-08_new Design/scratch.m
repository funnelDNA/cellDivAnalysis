%viewAlignmentOop(allFr,2);
%d.CellTransfer;
isNewAna = 1;
if isNewAna == 1
    clear;
    clc;
    close all;
    isNewAna = 1;
    load ch1.mat
    %results(54) = [];
end
startFr = 1;
%endFr   = 5;
endFr   = length(results)-1;
profile on;
tic;
allFr(length(results)) = Frame1Ch;
newIm = [];
f1 = figure;
if isNewAna == 1
    b = Frame1Ch(results,startFr);
    b.SearchBlock('BlockL');
    b.blockLs.StitchBlocks();
    b.SearchBlock('BlockS');
    b.SearchBlock('Cell');
    b.blockSs.StitchBlocks();
    b.ProfileAlign();
    b.BlockAlign();
    for ii = 1:length(b.cells.cells)
        b.cells.cells(ii).lLink = ii;
        b.blockLs.blockLs(ii).cLink = ii;
    end
    allFr(startFr) = b;
end
for kthFrame = startFr:endFr
    
    b = allFr(kthFrame);
    
    c = Frame1Ch(results,kthFrame + 1);
    c.SearchBlock('BlockL');
    c.blockLs.StitchBlocks();
    c.SearchBlock('BlockS');
    c.blockSs.StitchBlocks();
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
    newIm = [newIm; b.newIm];
    figure(f1); imagesc([b.newIm; c.newCh]);
    allFr(kthFrame+1) = c;
end
toc;
profile off
%%
figure;
imagesc(newIm,'ydata',((1:size(newIm,1))+channelW/2+10)/(channelW + 10)+startFr-1);
set(gca,'fontsize',20);
