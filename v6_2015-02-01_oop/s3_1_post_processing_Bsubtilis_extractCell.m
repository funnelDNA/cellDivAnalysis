%% For analyzing multi folders at one time
folders = [];
folders{1} = 'DK14371mM_IPTG.nd2 (series 02)-1-250_stabilized-backgrndsub10';
folders{2} = 'DK14371mM_IPTG.nd2 (series 03)-1-250_stabilized-backgrndsub10';
folders{3} = 'DK14371mM_IPTG.nd2 (series 04)-1-250-stabilized-backgrndsub10';
folders{4} = 'DK14371mM_IPTG.nd2 (series 05)-1-250-stabilized-backgrndsub10';
folders{5} = 'DK14371mM_IPTG.nd2 (series 06)-1-250-stabilized-backgrndsub10';
folders{6} = 'DK14371mM_IPTG.nd2 (series 07)-1-250-stabilized-backgrndsub10';
folders{7} = 'DK14371mM_IPTG.nd2 (series 08)-1-250-stabilized-backgrndsub10';
folders{8} = 'DK14371mM_IPTG.nd2 (series 09)-1-268-stabilized-backgrndsub10';
folders{9} = 'DK14371mM_IPTG.nd2 (series 10)-1-250_stabilized-backgrndsub10';
folders{10} = 'DK14371mM_IPTG.nd2 (series 11)-1-250-stabilized-backgrndsub10';
folders{11} = 'DK14371mM_IPTG.nd2 (series 12)-1-250-stabilized-backgrndsub10';
folders{12} = 'DK14371mM_IPTG.nd2 (series 13)-1-250-stabilized-backgrndsub10';
folders{13} = 'DK14371mM_IPTG.nd2 (series 14)-1-250_stabilized-backgrndsub10';
folders{14} = 'DK14371mM_IPTG.nd2 (series 15)-1-250-stabilized-backgrndsub10';
folders{15} = 'DK14371mM_IPTG.nd2 (series 16)-1-250-stabilized-backgrndsub10';


for kthFolder = 1:length(folders)
    cd(folders{kthFolder});
    disp(folders{kthFolder});
    files2Load = dir('ch*_final.mat');
    for kthFile = 1:length(files2Load);
        chName = files2Load(kthFile).name(1:3);
        fprintf('%s\tfullChFr = ',chName);
        f2Load = [chName '_final_2_contour.mat'];
        %if exist([chName '_allCell.mat'])
            if exist(f2Load)
                load ([chName '_final_2_contour.mat']);
            elseif exist([chName '_final_contour.mat'])
                load ([chName '_final_contour.mat']);
            else
                continue;
            end
            allCell = allData.extractCell;
            startFr = allData.startFr;
            %% find out when does the channel filled
            kthFr = startFr;
            fullChFr = 0;
            while kthFr < length(allData.allFr)
                if (allData.allFr(kthFr).cells.cells(1).block.blockS) < 50 && length(allData.allFr(kthFr).cells.cells) > 20
                    fullChFr = kthFr;
                    break;
                end
                kthFr = kthFr + 1;
            end
            %%
            fprintf('%d\n',fullChFr);
            save ([chName '_allCell_contour.mat'], 'allCell', 'startFr','fullChFr');
        %end
    end
    cd('../');
end
%% combine allCells togeter from all folders
% fName = [];
% fName{1} = 'DK1437_1mMIPTG(series 1)-1-130_rotated_backgrndsub50_cropped';
% %fName{2} = 'DK1437_1mMIPTG(series 3)-1-130_rotated_backgrndsub50_cropped';
% fName{2} = 'DK1437_1mMIPTG(series 8)-1-130_rotated_backgrndsub50';
% fName{3} = 'DK1437_1mMIPTG(series 9)-1-130_rotated_cropped_backgrndsub50';
% fName{4} = 'DK1437_1mMIPTG(series 14)-1-130_rotated_backgrndsub50_cropped';
% fName{5} = 'DK1437_1mMIPTG(series 16)-1-130_rotated_cropped_backgrndsub50';
% allCellCombined = [];
% for kthFolder = 1:length(fName)
%     cd(fName{kthFolder});
%     files2Load = dir('ch*_allCell.mat');
%     for kthFile = 1:length(files2Load);
%         chName = files2Load(kthFile).name;
%         f2Load = chName;
%         load (f2Load);
%         allCellCombined = [allCellCombined allCell];
%     end
%     cd('../');
% end
