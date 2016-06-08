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
    matchedLineL = [];
    matchedLineR = [];
    line1origin = fr1.stitchedLine;
    line2 = fr2.stitchedLine;
    
    pt1S = round(fr1.blockL(pt1).sS);
    pt1Ref = pt1;
    kk = 1;
    %expFs = 1:0.01:1.08;
    expFs = 1.02:0.02:1.2;
    shftRange = 0;
    
    line1 = line1origin;
    pt1S = round(fr1.blockL(pt1).sS);
    for pt2 = 1:length(fr2.blockS)
        pt2S = round(fr2.blockS(pt2).sS);
        
%         [line1L line2L] = cmpLines(line1(1:pt1S),line2(1:pt2S),mean(line1)-offLinePenalty);
%         [line1R line2R] = cmpLines(line1(pt1S+1:end),line2(pt2S+1:end),mean(line1)-offLinePenalty);
%         err_std(kk,pt2) = std([line1L line1R]-[line2L line2R]);
%         err_sum(kk,pt2) = mean(abs([line1L line1R]-[line2L line2R]));
%        kk = kk + 1;
%% two segments
%         line1L = line1(1:pt1S);
%         line1R = line1(pt1S+1:end);
%         line2L = line2(1:pt2S);
%         line2R = line2(pt2S+1:end);
% 
%         [errL, ob21, ob22] = cmpBlock(line1L,line2L, expFs, shftRange, mean(line1)-offLinePenalty);
%         matchedLineL{pt2} = [ob21(end:-1:1); ob22(end:-1:1)];
%         [errR, ob21, ob22] = cmpBlock(line1R,line2R, expFs, shftRange, mean(line1)-offLinePenalty);
%         matchedLineR{pt2} = [ob21; ob22];
%         err(pt2) = errL + errR;
%% four segments
%         segP1 = round(pt1S/2);
%         segP2 = pt1S;
%        segP3 = segP3 + round(length(line1)/4);
        line1L = line1(pt1S:-1:1);
        line1R = line1(pt1S+1:end);
        line2L = line2(pt2S:-1:1);
        line2R = line2(pt2S+1:end);
        [errL, ob21, ob22] = cmpBlockL(line1L,line2L, expFs, shftRange, mean(line1)-offLinePenalty);
        matchedLineL{pt2} = [ob21(end:-1:1); ob22(end:-1:1)];
        [errR, ob21, ob22] = cmpBlockL(line1R,line2R, expFs, shftRange, mean(line1)-offLinePenalty);
        [errR, ob21, ob22] = cmpBlock(line1R,line2R, expFs, shftRange, mean(line1)-offLinePenalty);
        matchedLineR{pt2} = [ob21; ob22];
        err(pt2) = errL + errR;
    end
    [minErr pt2Ref] = (min(err));
    %[minErr1 minExpFP] = min(err(:,pt2Ref));
    %expF = expFs(minExpFP);
    %disp(expF);
    
    figure (f1); hold off;
    
    plot(err);
    
%     for kk = 1:length(err)
%         plot(err(kk));    hold on;
%     end
    
    
    
%     figure (f2); hold off;
%     for kk = 1:length(expFs)
%         plot(err_sum(kk,:));    hold on;
%     end
    
%     figure (f3); hold off;
%     pt1S = round(fr1.blockL(pt1Ref).sS*expF);
%     pt2S = round(fr2.blockS(pt2Ref).sS);
%     plot((1:length(line2))+(pt1S - pt2S),line2-kthFrame*200,'r');
%     hold on;
%     line1 = expand_trace (line1origin, expF);
%     plot(line1-kthFrame*200);
%     plot([pt1S pt1S],[line1(pt1S)-500 line1(pt1S)+500]-kthFrame*200,'r','linewidth',3);
    figure (f3); hold off;
    plot ([matchedLineL{pt2Ref}(1,:) zeros(1,10) matchedLineR{pt2Ref}(1,:)]);
    hold on;
    plot ([matchedLineL{pt2Ref}(2,:) zeros(1,10) matchedLineR{pt2Ref}(2,:)],'r');
    
    newCur = cursor + (round(fr1.blockL(pt1Ref).sS) - pt2S);

    expF = 1;
end

