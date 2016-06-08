classdef Frame1Ch < matlab.mixin.Copyable % handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        frameNum
        channel
        fitting
        lineProfile
        newCh
        blockLs
        blockSs
        cells
        uniThresh
        ptLRef
        ptSRef
        profileAlignErr
        alignedLine
        newIm
    end
    
    methods
        function FC = Frame1Ch(results,kthFrame,cellType,threshold)
            if nargin ~= 0
                FC.frameNum = kthFrame;
                FC.channel = results(kthFrame).channel;
                FC.fitting = results(kthFrame).fitting;
                FC.lineProfile = results(kthFrame).lineProfile;
                switch cellType
                    case 'B'
                        FC.uniThresh = threshold; %1500 for B Subtilis data
                    case 'C'
                        FC.uniThresh = threshold; %1500 for B Subtilis data
                    otherwise
                        fprintf ('unknown cell type!');
                        pause;
                end
                FC.blockLs = BlockLs(cellType);
                FC.blockSs = BlockSs(cellType);
                FC.cells   = Cells(cellType);
            end
        end
        %function [ peaks ] = search_cell(channel, intP, peakHeightMin, uniThresh)
        function SearchBlock(FC,BlockType)
            %UNTITLED2 Summary of this function goes here
            %   Detailed explanation goes here
            switch BlockType
                case 'BlockL'
                    peakHeightMin = FC.blockLs.peakHeightMin;
                case 'BlockS'
                    peakHeightMin = FC.blockSs.peakHeightMin;
                case 'Cell'
                    peakHeightMin = FC.cells.peakHeightMin;
            end
            channel = FC.channel;
            intP    = FC.lineProfile;
            uniThresh = FC.uniThresh;
            smoothLevel = 3;
            thresholdLevel = 1/6;
            %uniThresh = 500;
            threshold_small = 4;
            smallestA = 1*10^3;
            smallestL = 8;
            smallestI = uniThresh;

            intPbak = intP;
            intP = smooth(intP,smoothLevel);
            %% add small perturbation
            intP = intP + rand(size(intP));
            %%
            intP1 = intP;     intP2 = intP;     intP3 = intP;
            intP1(1:2) = [];
            intP2(end) = [];    intP2(1) = [];
            intP3(end-1:end) = [];
            %% find local maximum and minimum
            hill = intP2 > intP1 & intP2>intP3;
            hillLoc = find(hill);
            hillLoc = hillLoc + 1;
            valy = intP2 < intP1 & intP2<intP3;
            valyLoc = find(valy);
            valyLoc = valyLoc + 1;
            hill_valy = (intP2 < intP1 & intP2<intP3) | (intP2 > intP1 & intP2>intP3);
            hill_valy_loc = find(hill_valy) + 1;
            hill_valy_loc = [1; hill_valy_loc; length(intPbak)];
            %%
            jj = 0;     peaks = [];
            %% finding peaks
            startP = hill_valy_loc(1);
            startH = intP(hill_valy_loc(1));
            peakPt = 2;
            while abs(intP(hill_valy_loc(peakPt))-startH) <= peakHeightMin
                peakPt = peakPt + 1;
                if peakPt > length(hill_valy_loc)
                    return;
                end
            end
            if intP(hill_valy_loc(peakPt))-startH > peakHeightMin
                jj = jj + 1;
                peaks(jj).start = 1;
                current_search = 1;
                searchingH = intP(hill_valy_loc(peakPt));
                searchingHL = hill_valy_loc(peakPt);
            else
                current_search = 0;
                searchingV = intP(hill_valy_loc(peakPt));
                searchingVL = hill_valy_loc(peakPt);
            end
            while peakPt<length(hill_valy_loc)
                peakPt = peakPt + 1;
                if current_search == 1
                    if intP(hill_valy_loc(peakPt)) >= searchingH
                        searchingH = intP(hill_valy_loc(peakPt));
                        searchingHL = hill_valy_loc(peakPt);
                    else
                        if intP(hill_valy_loc(peakPt)) < searchingH - peakHeightMin
                            peaks(jj).hill = searchingHL;
                            current_search = 0;
                            searchingV = intP(hill_valy_loc(peakPt));        
                            searchingVL = hill_valy_loc(peakPt);
                        end
                    end
                else
                    if intP(hill_valy_loc(peakPt)) <= searchingV
                        searchingV = intP(hill_valy_loc(peakPt));
                        searchingVL = hill_valy_loc(peakPt);
                    else
                        if intP(hill_valy_loc(peakPt)) > searchingV + peakHeightMin
                            current_search = 1;
                            searchingH = intP(hill_valy_loc(peakPt));
                            searchingHL = hill_valy_loc(peakPt);                
                            jj = jj + 1;
                            peaks(jj).start = searchingVL+1;
                            if jj > 1
                                peaks(jj-1).end = searchingVL;
                            end
                        end
                    end
                end
            end
            %% find last peak
            if jj>0 && (~isfield(peaks(jj),'end') || isempty(peaks(jj).end))
                if (isfield(peaks(jj),'hill')) && (~isempty(peaks(jj).hill)) && (intP(peaks(jj).hill) - intP(hill_valy_loc(end))) > peakHeightMin
                    peaks(jj).end = hill_valy_loc(end);
                else
                    peaks(jj) = [];
                end
            end
            %% refine peaks' edge
            for ii = 1:length(peaks)
            %     minI = min([intPbak(peaks(ii).start) intPbak(peaks(ii).end)]);
            %     maxI = intPbak(peaks(ii).hill);
                %threshold = maxI*thresholdLevel + minI*(1-thresholdLevel);
                threshold = uniThresh;
                startLim = peaks(ii).start;
                endLim   = peaks(ii).end;
                newS = peaks(ii).hill;
                newE = peaks(ii).hill;
                while newS > startLim && intPbak(newS) >= threshold*2/3
                   newS = newS - 1;
                end
                while newE < endLim && intPbak(newE) >= threshold*2/3
                   newE =newE + 1;
                end    
                peaks(ii).newS = newS;
                peaks(ii).newE = newE;
                while newS < peaks(ii).hill && intPbak(newS) <= threshold
                   newS = newS + 1;
                end
                while newE > peaks(ii).hill && intPbak(newE) <= threshold
                   newE =newE - 1;
                end
                peaks(ii).newS = newS;
                peaks(ii).newE = newE;
                peaks(ii).start = newS;
                peaks(ii).end = newE;
                peaks(ii).length = peaks(ii).newE - peaks(ii).newS + 1;
                peaks(ii).profile = intPbak(peaks(ii).newS:peaks(ii).newE);
                peaks(ii).height = intPbak(peaks(ii).hill) - min(intPbak(peaks(ii).newS),intPbak(peaks(ii).newE));
                peaks(ii).area = sum(intPbak(peaks(ii).newS:peaks(ii).newE));
                peaks(ii).bkLevel = threshold;
                peaks(ii).body = channel(:,peaks(ii).newS:peaks(ii).newE);    
                peaks(ii).cellS = peaks(ii).newS;
                peaks(ii).cellE = peaks(ii).newE;
                peaks(ii).sS = [];
                peaks(ii).sLink = [];
                peaks(ii).lLink = [];
                peaks(ii).mLink = [];
                peaks(ii).dLink = [];
                peaks(ii).cLink = [];
            %%    
            %     plot(intPbak(peaks(ii).start:peaks(ii).end));
            %     hold on;
            %     plot([1 -peaks(ii).start+peaks(ii).end],[threshold threshold]);
            %     drawnow;
            %     hold off;
            %     pause;
            end
            %% remove small peaks
            peakN = length(peaks);
            minGap = 2;
            for kthP = peakN:-1:1
                %% if the intensity are too small, remove the peak;
                %% if the length is too small, check if it is close to other peak, if not, remove;
                if peaks(kthP).area <= smallestA || max(peaks(kthP).profile) <= smallestI
                %if peaks(kthP).area <= smallestA || max(peaks(kthP).profile) <= smallestI || max(peaks(kthP).profile) >= 10000
                    peaks(kthP) = [];
                    peakN = peakN - 1;
                else
                    isRemove = 0;
                    if peaks(kthP).length < smallestL
                        switch kthP
                            case 1
                                if peakN ~= 1 && peaks(kthP+1).cellS - peaks(kthP).cellE > minGap
                                    peaks(kthP) = [];
                                    peakN = peakN - 1;
                                end
                            case peakN
                                if peakN ~= 1 && peaks(kthP).cellS - peaks(kthP-1).cellE > minGap
                                    peaks(kthP) = [];
                                    peakN = peakN - 1;
                                end
                            otherwise
                                if peaks(kthP+1).cellS - peaks(kthP).cellE > minGap && peaks(kthP).cellS - peaks(kthP-1).cellE > minGap
                                    peaks(kthP) = [];
                                    peakN = peakN - 1;
                                end
                        end
                    end
                end
            end
            %peakO(1,length(peaks)) = Block;
            switch BlockType
                case 'BlockL'
                    peakO(1,length(peaks)) = BlockL;
                case 'BlockS'
                    peakO(1,length(peaks)) = BlockS;
                case 'Cell'
                    peakO(1,length(peaks)) = Cell;
            end
            for ii = 1:length(peaks)
                peakO(ii).block = Block;
                peakO(ii).block.blockS = peaks(ii).cellS;
                peakO(ii).block.blockE = peaks(ii).cellE;
                peakO(ii).block.length = peaks(ii).length;
                peakO(ii).block.profile = peaks(ii).profile;
                peakO(ii).block.body = peaks(ii).body;
            end
            switch BlockType
                case 'BlockL'
                    FC.blockLs.blockLs = peakO;
                case 'BlockS'
                    FC.blockSs.blockSs = peakO;
                case 'Cell'
                    FC.cells.cells = peakO;
            end
        end
        
        
        
        %function [ pt1Ref, pt2Ref, expF , newCur, err ] = profile_align( cursor, results, kthFrame, f1, f2, f3, varargin )
        function ProfileAlign(FC,varargin)
        %UNTITLED Summary of this function goes here
        %   align kthFrame 'blockLs' and kthFrame 'blockSs'. Vary expansion coeff. find smallest
        %   std(line1-line2)
            plotToggle = 1;
            offLinePenalty = 1000;
            fr1 = FC;
            fr2 = FC;
            if length (varargin) == 1 && strcmp(varargin{1},'bright')
                allInt = [];
                for ii = 1:length(fr1.blockLs.blockLs)
                    if fr1.blockLs.blockLs(ii).isSkip == 0
                        allInt = [allInt max(fr1.blockLs.blockLs(ii).block.profile)];            
                    end
                end
                [maxInt, pt1] = max(allInt);
            else
                pt1 = round(length(fr1.blockLs.blockLs)/2);
                while fr1.blockLs.blockLs(pt1).isSkip ~= 0
                    pt1 = pt1 + 1;
                end
            end
            err_std = [];   err_sum = [];
            line1origin = fr1.blockLs.stitchedLine;
            line2 = fr2.blockSs.stitchedLine;

            pt1S = round(fr1.blockLs.blockLs(pt1).block.stitchS);
            pt1Ref = pt1;
            kk = 1;
            %expFs = 1:0.01:1.08;
            expFs = 1.02:0.01:1.2;
            for kk = 1:length(expFs)
                expCoeff = expFs(kk);
                line1 = expand_trace (line1origin, expCoeff);
                pt1S = round(fr1.blockLs.blockLs(pt1).block.stitchS*expCoeff);
                for pt2 = 1:length(fr2.blockSs.blockSs)
                    pt2S = round(fr2.blockSs.blockSs(pt2).block.stitchS);
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
            
%             %figure (f1);
%             figure; hold off;
%             for kk = 1:length(expFs)
%                 plot(err_std(kk,:));    hold on;
%             end
%             %figure (f2);
%             figure; hold off;
%             for kk = 1:length(expFs)
%                 plot(err_sum(kk,:));    hold on;
%             end
%             %figure (f3);
            if plotToggle == 1
                figure; hold off;
                pt1S = round(fr1.blockLs.blockLs(pt1Ref).block.stitchS*expF);
                pt2S = round(fr2.blockSs.blockSs(pt2Ref).block.stitchS);
                plot((1:length(line2))+(pt1S - pt2S),line2 + 200,'r');
                hold on;
                line1 = expand_trace (line1origin, expF);
                plot(line1 - 200);
                plot([pt1S pt1S],[line1(pt1S)-500 line1(pt1S)+500] - 200,'r','linewidth',3);
    %            plot(profileii{ii},'r');
                hold off;
            end
            FC.ptLRef = pt1Ref;
            FC.ptSRef = pt2Ref;
        end
        
        
        
        %function [ alignedLine, allLink, results ] = block_align( results, kthFrame, pt1Ref, pt2Ref, uniThreshold, varargin )
        function BlockAlign(FC)
        %UNTITLED Summary of this function goes here
        %   align kthFrame 'blockLs' and kthFrame 'blockSs'.
            plotToggle = 0;
            cells1 = FC.blockLs.blockLs;
            cells2 = FC.blockSs.blockSs;
            hold off;
            %expFs = 0.9:0.02:1.25;
            expFs = 1;
            shftRange = 0;
            smoothLevel = 3;
            % expFs = 0.90:0.02:1.25;
            pt1Ref = FC.ptLRef;
            pt2Ref = FC.ptSRef;
            alignedLine = [];
            allLink = {};
            %% right side
            pt1 = pt1Ref;
            pt2 = pt2Ref;
            nCell1 = length(cells1);
            nCell2 = length(cells2);
            x0 = 1;
            while pt1 <= nCell1 && pt2 <= nCell2
                if cells1(pt1).isSkip == 1
                    pt1 = pt1 + 1;
                    continue;
                end
                dLink = [];
                line1 = smooth(cells1(pt1).block.profile,smoothLevel)';
                line2 = cells2(pt2).block.profile;
                [err2, ob21, ob22] = cmpBlock(line1,smooth(line2,smoothLevel)', expFs, shftRange);
                err1 = inf;
                while err2 < err1
                    dLink = [dLink pt2];
                    pt2 = pt2 + 1;
                    err1 = err2;    ob11 = ob21;    ob12 = ob22;
                    if pt2 <= nCell2
                        line3 = cells2(pt2).block.profile;
                        line2 = [line2 line3];
                        [err2, ob21, ob22] = cmpBlock(line1,smooth(line2,smoothLevel)', expFs, shftRange);
                    else
                        err2 = inf;
                    end
                end

                alignedLine = [alignedLine {[x0:x0+length(ob11)-1;ob11;ob12]}];
                if plotToggle == 1
                    plot(x0:x0+length(ob11)-1,ob11);        hold on;
                    plot(x0:x0+length(ob11)-1,ob12-200, 'r');
                end
                x0 = x0 + length(ob11) + 9;

                allLink = [allLink {[pt1 dLink]}];
%                 fprintf('pt1 = %d ---> pt2 = ',pt1);
%                 fprintf('%d ',dLink);
%                 fprintf('         \n');
                pt1 = pt1 + 1;
            end
            %% left side
            x0 = -15;
            pt1 = pt1Ref-1;
            pt2 = pt2Ref-1;
            while pt1 > 0 && pt2 > 0
                if cells1(pt1).isSkip == 1
                    pt1 = pt1 - 1;
                    continue;
                end
                dLink = [];
                line1 = smooth(cells1(pt1).block.profile,smoothLevel)';
                line1 = line1(end:-1:1);
                line2 = cells2(pt2).block.profile;
                line2cmp = smooth(line2,smoothLevel)';
                line2cmp = line2cmp(end:-1:1);
                [err2, ob21, ob22] = cmpBlock(line1,line2cmp, expFs, shftRange);
                err1 = inf;
                while err2 < err1
                    dLink = [pt2 dLink];
                    pt2 = pt2 - 1;
                    err1 = err2;    ob11 = ob21;    ob12 = ob22;
                    if pt2 > 0
                        line3 = cells2(pt2).block.profile;
                        line2 = [line3 line2];
                        line2cmp = smooth(line2,smoothLevel)';
                        line2cmp = line2cmp(end:-1:1);
                        [err2, ob21, ob22] = cmpBlock(line1,line2cmp, expFs, shftRange);
                    else
                        err2 = inf;
                    end
                end
                ob11 = ob11(end:-1:1);
                ob12 = ob12(end:-1:1);

                alignedLine = [{[x0-length(ob11)+1:x0;ob11;ob12]} alignedLine];
                if plotToggle == 1
                    plot(x0-length(ob11)+1:x0,ob11);
                    plot(x0-length(ob11)+1:x0,ob12-200, 'r');
                end
                x0 = x0 - length(ob11) - 9;

                allLink = [{[pt1 dLink]} allLink];
%                 fprintf('pt1 = %d ---> pt2 = ',pt1);
%                 fprintf('%d ',dLink);
%                 fprintf('         \n');
                pt1 = pt1 - 1;
            end
%            fprintf('\n\n');
            %% converting results from allLink into FC
            for ii = 1:length(allLink)
                FC.blockLs.blockLs(allLink{ii}(1)).sLink = allLink{ii}(2:end);
                for jj = 1:length(allLink{ii}(2:end))
                    FC.blockSs.blockSs(allLink{ii}(jj+1)).lLink = allLink{ii}(1);
                end
            end
        end
    end
    methods
        function aaa(TC)
            disp('aaa');
        end
            
    end
end

