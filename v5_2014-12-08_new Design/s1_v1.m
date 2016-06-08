isNewAna = 1;
if isNewAna == 1
    clear;
    clc;
    close all;
    isNewAna = 1;
    load ch2.mat
    %results(54) = [];
end
%close all;
%profile on;
startFr = 1;
brightSpot = 0;  % affect 'profile_align'
f1 = figure('position',[100 200 600 400]);
f2 = figure('position',[700 200 600 400]);
%f1 = figure('position',[-100 -100 10 10]);
%f2 = figure('position',[-100 -100 10 10]);
f3 = figure('position',[10 40 600 300]);
f4 = figure('position',[700 40 600 300]);
f5 = figure('position',[10 400 600 300]);
f6 = figure('position',[700 400 600 300]);
newIm = [];
stitchIm = zeros(100,2000);
stitchImF = zeros(100*18,2000);
alignedIm = zeros(100*36,2000);
uniThreshold = 1500;
%%
for kthFrame = 1:length(results)
    x0 = results(kthFrame).fitting(:,2);
    results(kthFrame).lineProfile(x0<1 | x0>20) = 0;
end
% results(1).cells = search_cell(results(1).channel,results(1).lineProfile,500,600);
% results = stitch_cells(results,1,'cells');
% stitchIm(1,1001:1000+length(results(1).stitchedLine)) = results(1).stitchedLine;
% stitchImF(1:18,1001:1000+length(results(1).stitchedLine)) = results(1).stitchedCh;
cCursor = 1000;
alignedIm = [];
peakHeightMin = 800;
peakHeightMinS = 300;
if isNewAna == 1
    results(startFr).cells = search_cell(results(startFr).channel,results(startFr).lineProfile,peakHeightMin,uniThreshold);
    results(startFr).blockL = search_cell(results(startFr).channel,results(startFr).lineProfile,peakHeightMin,uniThreshold);
    results = stitch_cells(results,startFr,'blockL');
    results(startFr).blockS = search_cell(results(startFr).channel,results(startFr).lineProfile,peakHeightMinS,uniThreshold);
    for ii = 1:length(results(startFr).cells)
        results(startFr).cells(ii).lLink = ii;
        results(startFr).blockL(ii).cLink = ii;
    end
end
for kthFrame = startFr:length(results)-1
    if kthFrame == 0
        a = 0;
    end
    %peakHeightMin = max(results(kthFrame).channel(:))/10;
    %peakHeightMin = 800;
    results(kthFrame+1).blockL = search_cell(results(kthFrame+1).channel,results(kthFrame+1).lineProfile,peakHeightMin,uniThreshold);
    results(kthFrame+1).blockS = search_cell(results(kthFrame+1).channel,results(kthFrame+1).lineProfile,peakHeightMinS,uniThreshold);
    results = stitch_cells(results,kthFrame+1,'blockL');
    results = stitch_cells(results,kthFrame+1,'blockS');
    results = stitch_cells(results,kthFrame,'blockL');
    [ pt1Ref, pt2Ref, expF, cCursor, err ] = profile_align( cCursor, results, kthFrame+1, f1, f2, f3, 'single' );
    %[alignedLine alignedBody, results] = cell_lineage( results, kthFrame, pt1Ref, pt2Ref, uniThreshold );
    [ alignedLine, allLink, results ] = block_align( results, kthFrame+1, pt1Ref, pt2Ref, uniThreshold, 'single' );
    for ii = 1:length(allLink)
        results(kthFrame+1).blockL(allLink{ii}(1)).sLink = allLink{ii}(2:end);
        for jj = 1:length(allLink{ii}(2:end))
            results(kthFrame+1).blockS(allLink{ii}(jj+1)).lLink = allLink{ii}(1);
        end
    end
    if brightSpot == 1
        [ pt1Ref, pt2Ref, expF, cCursor, err ] = profile_align_2( cCursor, results, kthFrame, f1, f2, f3,'double', 'bright' );
    else
        [ pt1Ref, pt2Ref, expF, cCursor, err ] = profile_align_2( cCursor, results, kthFrame, f1, f2, f3,'double');
    end
    %% save information for plotting
    results(kthFrame).align.pt1Ref = pt1Ref;
    results(kthFrame).align.pt2Ref = pt2Ref;
    results(kthFrame).align.expF   = expF;
    results(kthFrame).align.err    = err;
    %%
    figure (f4);
    [ alignedLine, allLink, results ] = block_align( results, kthFrame, pt1Ref, pt2Ref, uniThreshold, 'double' );
    results(kthFrame).align.alignedLine = alignedLine;
    
    for ii = 1:length(allLink)
        results(kthFrame).blockL(allLink{ii}(1)).kp1sLink = allLink{ii}(2:end);
        for jj = 1:length(allLink{ii}(2:end))
            results(kthFrame+1).blockS(allLink{ii}(jj+1)).km1lLink = allLink{ii}(1);
        end
    end
%     figure(f4);
%     hold off;
%     plot(alignedLine(1,:));
%     hold on;
%     plot(alignedLine(2,:)-500,'r');
    figure(f5);
    
    results = cell_transfer(results,kthFrame);
%    stitchIm(kthFrame+1,cCursor+1:cCursor+length(results(kthFrame+1).stitchedLine)) = results(kthFrame+1).stitchedLine;
%    stitchImF(kthFrame*18+1:kthFrame*18+18,cCursor+1:cCursor+length(results(kthFrame+1).stitchedLine)) = results(kthFrame+1).stitchedCh;

    %alignedIm((kthFrame-1)*36+1:kthFrame*36,cCursor+1:cCursor+length(alignedLine)) = alignedBody;
    %fprintf('pt1Ref = %d,    pt2Ref = %d,    peakHeightMin = %f\n',pt1Ref,pt2Ref,peakHeightMin);
    %% construct image
    if kthFrame >= startFr
        figure(f6);
        [ newIm ] = constructIm( newIm, results, kthFrame);
        imagesc(newIm,'ydata',((1:size(newIm,1))+channelW/2+10)/(channelW + 10)+startFr-1);
        set(gca,'fontsize',20);
        drawnow;
    end
end
%profile viewer;