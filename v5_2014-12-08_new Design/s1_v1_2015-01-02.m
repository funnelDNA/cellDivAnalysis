clear;
clc; close all;
load ch1.mat
f1 = figure('position',[100 200 600 400]);
f2 = figure('position',[700 200 600 400]);
f3 = figure('position',[700 200 600 400]);
f4 = figure('position',[700 200 600 400]);
f5 = figure('position',[700 200 600 400]);
f6 = figure('position',[700 200 600 400]);
newIm = [];
stitchIm = zeros(100,2000);
stitchImF = zeros(100*18,2000);
alignedIm = zeros(100*36,2000);
uniThreshold = 800;
%%
for kthFrame = 1:100
    x0 = results(kthFrame).fitting(:,2);
    results(kthFrame).lineProfile(x0<6 | x0>13) = 0;
end
results(1).cells = search_cell(results(1).channel,results(1).lineProfile,500,600);
results = stitch_cells(results,1);
stitchIm(1,1001:1000+length(results(1).stitchedLine)) = results(1).stitchedLine;
stitchImF(1:18,1001:1000+length(results(1).stitchedLine)) = results(1).stitchedCh;
cCursor = 1000;
alignedIm = [];
peakHeightMin = 800;
startFr = 3;
results(startFr).cells = search_cell(results(startFr).channel,results(startFr).lineProfile,peakHeightMin,uniThreshold);
for kthFrame = startFr:100
    %peakHeightMin = max(results(kthFrame).channel(:))/10;
    %peakHeightMin = 800;
    results(kthFrame).cells = search_cell(results(kthFrame).channel,results(kthFrame).lineProfile,peakHeightMin,uniThreshold);
    results(kthFrame+1).cells = search_cell(results(kthFrame+1).channel,results(kthFrame+1).lineProfile,peakHeightMin-300,uniThreshold);
    results = stitch_cells(results,kthFrame);
    results = stitch_cells(results,kthFrame+1);
    [ pt1Ref, pt2Ref, cCursor ] = profile_align( cCursor, results, kthFrame, f1, f2, f3 );
    %[alignedLine alignedBody, results] = cell_lineage( results, kthFrame, pt1Ref, pt2Ref, uniThreshold );
    [ alignedLine, allLink, results ] = block_align( results, kthFrame, pt1Ref, pt2Ref, uniThreshold, 'single' );
    figure(f4);
    %imagesc(alignedBody);
    %alignedIm = [alignedIm; alignedBody];
    figure(f5);
    hold off;
    plot(alignedLine(1,:));
    hold on;
    plot(alignedLine(2,:)-500,'r');
    stitchIm(kthFrame+1,cCursor+1:cCursor+length(results(kthFrame+1).stitchedLine)) = results(kthFrame+1).stitchedLine;
    stitchImF(kthFrame*18+1:kthFrame*18+18,cCursor+1:cCursor+length(results(kthFrame+1).stitchedLine)) = results(kthFrame+1).stitchedCh;
    %alignedIm((kthFrame-1)*36+1:kthFrame*36,cCursor+1:cCursor+length(alignedLine)) = alignedBody;
    %fprintf('pt1Ref = %d,    pt2Ref = %d,    peakHeightMin = %f\n',pt1Ref,pt2Ref,peakHeightMin);
    %% construct image
%     figure(f6);
%     [ newIm ] = constructIm( newIm, results, kthFrame);
%     imagesc(newIm,'ydata',((1:size(newIm,1))+channelW/2+10)/(channelW + 10));
%     drawnow;
end
    [results errMsg] = cell_lineage( results, kthFrame,pt1Ref,pt2Ref );
    while errMsg == 1
        peakHeightMin = peakHeightMin - 100;
        results(kthFrame+1).cells = search_cell(results(kthFrame+1).lineProfile,peakHeightMin,500);
        [ pt1Ref, pt2Ref ] = profile_align( results, kthFrame, f1, f2, f3 );
        [results errMsg] = cell_lineage( results, kthFrame,pt1Ref,pt2Ref );
    end 
    
    
    for ii = 1:length(results(kthFrame).cells)
        results(kthFrame).cells(ii).cellS = results(kthFrame).cells(ii).newS;
        results(kthFrame).cells(ii).cellE = results(kthFrame).cells(ii).newE;
    end
    for ii = 1:length(results(kthFrame+1).cells)
        results(kthFrame+1).cells(ii).cellS = results(kthFrame+1).cells(ii).newS;
        results(kthFrame+1).cells(ii).cellE = results(kthFrame+1).cells(ii).newE;
    end
    [ newIm ] = constructIm( newIm, results, kthFrame);
    imagesc(newIm,'ydata',((1:size(newIm,1))+channelW/2+10)/(channelW + 10));
%end












f1 = figure; hold off;
f2 = figure;
profileii = [];
cellN = [];
cellsL = [];
markerP = [];
pt1Refs = [];
for ii = kthFrame:kthFrame+1
    profileii{ii} = [];
    cellsL{ii}    = [];
    cellP{ii}     = [];
    cellN(ii) = length(results(ii).cells);
    celljjP = 1;
    pt1Refs(ii) = 1;
    for jj = 1:cellN(ii)
        profile_jj = smooth(results(ii).cells(jj).profile,5)';
        if max(profile_jj) > max(profileii{ii})
            pt1Refs(ii) = jj;
        end
        profileii{ii} = [profileii{ii} profile_jj];
        cellsL{ii} = [cellsL{ii} length(results(ii).cells(jj).profile)];
        cellP{ii} = [cellP{ii} celljjP];
        celljjP = celljjP + length(results(ii).cells(jj).profile);
    end
    pt1Refs(ii) = ceil(cellN(ii)/2);
    
    [maxP markerP(ii)] = max(profileii{ii});
    if ii > kthFrame
        expFs = 1:0.01:1.08;
        err_std = [];
        for kk = 1:length(expFs)
            expF = expFs(kk);
            expanded_pre_trace = expand_trace( profileii{ii-1}, expF);
            pt1Ref = pt1Refs(ii-1);
            pt1 = floor((cellP{ii-1}(pt1Ref)*expF));
            for pt2Ref = 1:cellN(ii)
                pt2 = cellP{ii}(pt2Ref);
                trace1Left  = expanded_pre_trace(1:pt1);
                trace1Right = expanded_pre_trace(pt1+1:end);
                trace2Left  = profileii{ii}(1:pt2);
                trace2Right = profileii{ii}(pt2:end);
                if length(trace1Left) < length(trace2Left)
                    trace1Left = [trace1Left zeros(1,length(trace2Left)-length(trace1Left))];
                else
                    trace2Left = [trace2Left zeros(1,length(trace1Left)-length(trace2Left))];
                end
                if length(trace1Right) < length(trace2Right)
                    trace1Right = [trace1Right zeros(1,length(trace2Right)-length(trace1Right))];
                else
                    trace2Right = [trace2Right zeros(1,length(trace1Right)-length(trace2Right))];
                end
                err_std(kk,pt2Ref) = std([trace1Left trace1Right]-[trace2Left trace2Right]);
            end
            figure(f2);
            plot(err_std(kk,:));
            hold on;
        end
        
        figure(f1);
        [minErr pt2Ref] = min(sum(err_std));
        pt2 = cellP{ii}(pt2Ref);
        %plot(expand_trace( profileii{ii-1},
        %length(profileii{ii})/cellN(ii)/(length(profileii{ii-1})/cellN(ii-1))),'r');
        [minExp minExpFP] = min(err_std(:,pt2Ref));
        expF = expFs(minExpFP);
        disp(expF);
        pt1 = floor((cellP{ii-1}(pt1Ref)*expF));
        plot((1:length(profileii{ii}))+(pt1 - pt2),profileii{ii});
        hold on;
        plot(expand_trace( profileii{ii-1}, expF),'r');        
        %plot(profileii{ii},'r');
        hold off;
        
        figure(f2);
        hold off;
        
    end
%    figure(f1); plot(results(ii).lineProfile);
end
