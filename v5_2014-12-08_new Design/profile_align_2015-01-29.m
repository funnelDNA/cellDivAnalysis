function [ pt1Ref, pt2Ref, expF , newCur, err ] = profile_align( cursor, results, kthFrame, f1, f2, f3, varargin )
%UNTITLED Summary of this function goes here
%   align kthFrame and kthFrame+1. Vary expansion coeff. find smallest
%   std(line1-line2)
offLinePenalty = 1000;
if length(varargin) ~= 0
    switch varargin{1}
        case 'single'
            fr1 = results(kthFrame);
            fr2 = results(kthFrame);
        case 'double'
            fr1 = results(kthFrame);
            fr2 = results(kthFrame+1);
    end
    if length (varargin) == 2 && strcmp(varargin{2},'bright')
        allInt = [];
        for ii = 1:length(fr1.blockL)
            allInt = [allInt max(fr1.blockL(ii).profile)];            
        end
        [maxInt pt1] = max(allInt);
    else
        pt1 = round(length(fr1.blockL)/2);
    end
end
    err_std = [];   err_sum = [];
    line1origin = fr1.stitchedLine;
    line2 = fr2.stitchedLine;
    
    pt1S = round(fr1.blockL(pt1).sS);
    pt1Ref = pt1;
    kk = 1;
    %expFs = 1:0.01:1.08;
    expFs = 1.02:0.01:1.2;
    for kk = 1:length(expFs)
        expCoeff = expFs(kk);
        line1 = expand_trace (line1origin, expCoeff);
        pt1S = round(fr1.blockL(pt1).sS*expCoeff);
        for pt2 = 1:length(fr2.blockS)
            pt2S = round(fr2.blockS(pt2).sS);
            [line1L line2L] = cmpLines(line1(1:pt1S),line2(1:pt2S),mean(line1)-offLinePenalty);
            [line1R line2R] = cmpLines(line1(pt1S+1:end),line2(pt2S+1:end),mean(line1)-offLinePenalty);
            err_std(kk,pt2) = std([line1L line1R]-[line2L line2R]);
            err_sum(kk,pt2) = mean(abs([line1L line1R]-[line2L line2R]));
        end
        kk = kk + 1;
    end
    err = err_sum;
    [minErr pt2Ref] = min(min(err));
    [minErr1 minExpFP] = min(err(:,pt2Ref));
    expF = expFs(minExpFP);
    %disp(expF);
    
    figure (f1); hold off;
    for kk = 1:length(expFs)
        plot(err_std(kk,:));    hold on;
    end
    figure (f2); hold off;
    for kk = 1:length(expFs)
        plot(err_sum(kk,:));    hold on;
    end
    
    figure (f3); hold off;
    pt1S = round(fr1.blockL(pt1Ref).sS*expF);
    pt2S = round(fr2.blockS(pt2Ref).sS);
    plot((1:length(line2))+(pt1S - pt2S),line2-kthFrame*200,'r');
    hold on;
    line1 = expand_trace (line1origin, expF);
    plot(line1-kthFrame*200);
    plot([pt1S pt1S],[line1(pt1S)-500 line1(pt1S)+500]-kthFrame*200,'r','linewidth',3);
    %plot(profileii{ii},'r');
    %hold off;
    newCur = cursor + (round(fr1.blockL(pt1Ref).sS) - pt2S);
end