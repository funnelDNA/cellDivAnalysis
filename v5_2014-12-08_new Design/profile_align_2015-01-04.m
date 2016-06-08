function [ pt1Ref, pt2Ref, newCur ] = profile_align( cursor, results, kthFrame, f1, f2, f3 )
%UNTITLED Summary of this function goes here
%   align kthFrame and kthFrame+1. Vary expansion coeff. find smallest
%   std(line1-line2)
    err_std = [];   err_sum = [];
    line1origin = results(kthFrame).stitchedLine;
    line2 = results(kthFrame+1).stitchedLine;
    
    pt1 = round(length(results(kthFrame).blockL)/2);
    pt1S = round(results(kthFrame).blockL(pt1).sS);
    pt1Ref = pt1;
    kk = 1;
    expFs = 1:0.01:1.08;
    for kk = 1:length(expFs)
        expCoeff = expFs(kk);
        line1 = expand_trace (line1origin, expCoeff);
        pt1S = round(results(kthFrame).blockL(pt1).sS*expCoeff);
        for pt2 = 1:length(results(kthFrame+1).blockS)
            pt2S = round(results(kthFrame+1).blockS(pt2).sS);
            [line1L line2L] = cmpLines(line1(1:pt1S),line2(1:pt2S));
            [line1R line2R] = cmpLines(line1(pt1S+1:end),line2(pt2S+1:end));
            err_std(kk,pt2) = std([line1L line1R]-[line2L line2R]);
            err_sum(kk,pt2) = sum(abs([line1L line1R]-[line2L line2R]));
        end
        kk = kk + 1;
    end
    [minErr pt2Ref] = min(min(err_std));
    [minErr1 minExpFP] = min(err_std(:,pt2Ref));
    expF = expFs(minExpFP);
    %disp(expF);
    
    figure (f1); hold off;
    for kk = 1:length(expFs)
        plot(err_std(kk,:));    hold on;
    end
    figure (f3); hold off;
    for kk = 1:length(expFs)
        plot(err_sum(kk,:));    hold on;
    end
        
        
    figure (f2); hold off;
    pt1S = round(results(kthFrame).blockL(pt1Ref).sS*expF);
    pt2S = round(results(kthFrame+1).blockS(pt2Ref).sS);
    plot((1:length(line2))+(pt1S - pt2S),line2-kthFrame*200,'r');
    hold on;
    line1 = expand_trace (line1origin, expF);
    plot(line1-kthFrame*200);
    plot([pt1S pt1S],[line1(pt1S)-500 line1(pt1S)+500]-kthFrame*200,'r','linewidth',3)
    %plot(profileii{ii},'r');
    %hold off;
    newCur = cursor + (round(results(kthFrame).blockL(pt1Ref).sS) - pt2S);
end