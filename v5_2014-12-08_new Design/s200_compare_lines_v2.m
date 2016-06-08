clear;
clc; close all;
load ch1.mat
f1 = figure; hold off;
f2 = figure;
profileii = [];
cellN = [];
cellsL = [];
markerP = [];
pt1Refs = [];
for ii = 1:length(results)
    profileii{ii} = [];
    cellsL{ii}    = [];
    cellP{ii}     = [];
    cellN(ii) = length(results(ii).cells);
    celljjP = 1;
    for jj = 1:cellN(ii)
        profile_jj = smooth(results(ii).cells(jj).profile,5)';
        if max(profile_jj) > max(profileii{ii})
            pr1Refs(ii) = jj;
        end
        profileii{ii} = [profileii{ii} profile_jj];
        cellsL{ii} = [cellsL{ii} length(results(ii).cells(jj).profile)];
        cellP{ii} = [cellP{ii} celljjP];
        celljjP = celljjP + length(results(ii).cells(jj).profile);
    end   
    
    [maxP markerP(ii)] = max(profileii{ii});
    if ii > 1       
        expFs = 1:0.01:1.08;
        err_std = [];
        for kk = 1:length(expFs)
            expF = expFs(kk);
            expanded_pre_trace = expand_trace( profileii{ii-1}, expF);
            pt1Ref = pr1Refs(ii-1);
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
