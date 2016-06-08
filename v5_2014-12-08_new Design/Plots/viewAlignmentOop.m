function viewAlignmentOop( allFr, kthFrame )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    pt1Ref = allFr(kthFrame).ptLRef;
    pt2Ref = allFr(kthFrame).ptSRef;
%    expF   = results(kthFrame).align.expF  ;
    expF = 1;
    err    = allFr(kthFrame).profileAlignErr;

    fr1 = allFr(kthFrame);
    fr2 = allFr(kthFrame+1);
    
    line1origin = fr1.blockLs.stitchedLine;
    line2 = fr2.blockSs.stitchedLine;
%% figure 0
    figure;
    imagesc (err);
%%
    err_sum = err;
    figure; hold off;
    for kk = 1:(size(err,1))
        plot(err_sum(kk,:));    hold on;
    end
%     figure; hold off;
%     for kk = 1:(size(err,1))
%         plot(err_std(kk,:));    hold on;
%     end
%% figure 1: profile align
    figure; 
    hold off;
    pt1S = round(fr1.blockLs.blockLs(pt1Ref).block.stitchS*expF);
    pt2S = round(fr2.blockSs.blockSs(pt2Ref).block.stitchS);
    plot((1:length(line2))+(pt1S - pt2S),line2-kthFrame*200,'r');
    hold on;
    line1 = expand_trace (line1origin, expF);
    plot(line1-kthFrame*200);
    plot([pt1S pt1S],[line1(pt1S)-500 line1(pt1S)+500]-kthFrame*200,'r','linewidth',3);
%% figure 2: block align
    figure;
    alignedLine = allFr(kthFrame).alignedLine;
    for ii = 1:length(alignedLine)
        plot(alignedLine{ii}(1,:),alignedLine{ii}(2,:)); hold on;
        plot(alignedLine{ii}(1,:),alignedLine{ii}(3,:), 'r');
    end
    
%% figure 3: cell align
    figure;
    x0 = 1;
    kp1cellN = 1;
    kthCell = 1;
    cells = [];
    hold off;
    lineSpace = 1200;
    allx0 = x0;
    for ii = 1:length(allFr(kthFrame).blockLs.blockLs)
        b1 = allFr(kthFrame).blockLs.blockLs(ii);
        plot(x0:x0+(b1.block.blockE-b1.block.blockS),b1.block.profile+2*lineSpace); hold on;
        plot([x0+(b1.block.blockE-b1.block.blockS) x0+(b1.block.blockE-b1.block.blockS)],[b1.block.profile(end)+lineSpace*2.5 b1.block.profile(end)+lineSpace*1.5]);
        x0c = x0;
        for jj = 1:length(b1.cLink)
            c1 = allFr(kthFrame).cells.cells(b1.cLink(jj));
            if length(c1.block.profile) > 0
                plot(x0c:x0c+(c1.block.blockE-c1.block.blockS),c1.block.profile+lineSpace,'r');
                plot([x0c+(c1.block.blockE-c1.block.blockS) x0c+(c1.block.blockE-c1.block.blockS)],[c1.block.profile(end)+lineSpace*1.5 c1.block.profile(end)+lineSpace/2],'r');
                x0c = x0c + (c1.block.blockE-c1.block.blockS) +1;
            end
        end
        x0s = x0;
        for jj = 1:length(b1.kp1sLink)
            b2 = allFr(kthFrame+1).blockSs.blockSs(b1.kp1sLink(jj));
            plot(x0s:x0s+(b2.block.blockE-b2.block.blockS),b2.block.profile,'k');
            plot([x0s+(b2.block.blockE-b2.block.blockS) x0s+(b2.block.blockE-b2.block.blockS)],[b2.block.profile(end)+lineSpace/2 b2.block.profile(end)-lineSpace/2],'k');
            x0s = x0s + (b2.block.blockE-b2.block.blockS) +1;
        end
        x0 = max([x0s x0c x0+(b1.block.blockE-b1.block.blockS)+1]);
        allx0 = [allx0 x0];
    end
    x0 = 1;     jj = 1;     
    for ii = 1:length(allFr(kthFrame+1).blockLs.blockLs)
        %x0 = allx0(ii);
        b1 = allFr(kthFrame+1).blockLs.blockLs(ii);
        plot(x0:x0+(b1.block.blockE-b1.block.blockS),b1.block.profile-lineSpace,'g'); hold on;
        plot([x0+(b1.block.blockE-b1.block.blockS) x0+(b1.block.blockE-b1.block.blockS)],[b1.block.profile(end)-1.5*lineSpace b1.block.profile(end)-0.5*lineSpace]);
        x0 = x0+(b1.block.blockE-b1.block.blockS)+1;
    end
end

