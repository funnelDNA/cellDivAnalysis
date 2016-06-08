function [ output_args ] = viewAlignment( results, kthFrame )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    pt1Ref = results(kthFrame).align.pt1Ref;
    pt2Ref = results(kthFrame).align.pt2Ref;
    expF   = results(kthFrame).align.expF  ;
    err    = results(kthFrame).align.err;

    fr1 = results(kthFrame);
    fr2 = results(kthFrame+1);
    
    line1origin = fr1.stitchedLine;
    line2 = fr2.stitchedLine;
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
    pt1S = round(fr1.blockL(pt1Ref).sS*expF);
    pt2S = round(fr2.blockS(pt2Ref).sS);
    plot((1:length(line2))+(pt1S - pt2S),line2-kthFrame*200,'r');
    hold on;
    line1 = expand_trace (line1origin, expF);
    plot(line1-kthFrame*200);
    plot([pt1S pt1S],[line1(pt1S)-500 line1(pt1S)+500]-kthFrame*200,'r','linewidth',3);
%% figure 2: block align
    figure;
    alignedLine = results(kthFrame).align.alignedLine;
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
    for ii = 1:length(results(kthFrame).blockL)
        b1 = results(kthFrame).blockL(ii);
        plot(x0:x0+(b1.cellE-b1.cellS),b1.profile+2*lineSpace); hold on;
        plot([x0+(b1.cellE-b1.cellS) x0+(b1.cellE-b1.cellS)],[b1.profile(end)+lineSpace*2.5 b1.profile(end)+lineSpace*1.5]);
        x0c = x0;
        for jj = 1:length(b1.cLink)
            c1 = results(kthFrame).cells(b1.cLink(jj));
            if length(c1.profile) > 0
                plot(x0c:x0c+(c1.cellE-c1.cellS),c1.profile+lineSpace,'r');
                plot([x0c+(c1.cellE-c1.cellS) x0c+(c1.cellE-c1.cellS)],[c1.profile(end)+lineSpace*1.5 c1.profile(end)+lineSpace/2],'r');
                x0c = x0c + (c1.cellE-c1.cellS) +1;
            end
        end
        x0s = x0;
        for jj = 1:length(b1.kp1sLink)
            b2 = results(kthFrame+1).blockS(b1.kp1sLink(jj));
            plot(x0s:x0s+(b2.cellE-b2.cellS),b2.profile,'k');
            plot([x0s+(b2.cellE-b2.cellS) x0s+(b2.cellE-b2.cellS)],[b2.profile(end)+lineSpace/2 b2.profile(end)-lineSpace/2],'k');
            x0s = x0s + (b2.cellE-b2.cellS) +1;
        end
        x0 = max([x0s x0c x0+(b1.cellE-b1.cellS)+1]);
        allx0 = [allx0 x0];
    end
    x0 = 1;     jj = 1;     
    for ii = 1:length(results(kthFrame+1).blockL)
        %x0 = allx0(ii);
        b1 = results(kthFrame+1).blockL(ii);
        plot(x0:x0+(b1.cellE-b1.cellS),b1.profile-lineSpace,'g'); hold on;
        plot([x0+(b1.cellE-b1.cellS) x0+(b1.cellE-b1.cellS)],[b1.profile(end)-1.5*lineSpace b1.profile(end)-0.5*lineSpace]);
        x0 = x0+(b1.cellE-b1.cellS)+1;
    end
end

