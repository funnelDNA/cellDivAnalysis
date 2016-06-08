%%
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

% folders{1} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 1)-1-100_rotated_backgroundsub50';
% folders{2} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 2)-1-100_rotated_backgroundsub50';
% folders{3} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 4)_rotated_cropped_backgroundsub50';
% folders{4} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 5)-1-100_rotated_backgroundsub50';
% folders{5} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 6)-1-100_rotated_backgrndsub50-1';
% folders{6} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 7)-1-100_rotated_backgrndsub50';
% folders{7} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 8)-1-100_rotated_backgrndsub50';
% folders{8} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 9)-1-85_rotated_backgrndsub50';
% folders{9} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 10)-1-85_rotated_backgrndsub50';
% folders{10} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 11)-1-80_rotated_backgrndsub50';
% folders{11} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 12)-1-100_rotated_backgrndsub50';


% folders{1} = 'DK1437PLoC.nd2 (series 01)-1-151_cropped_backgrdsub10';
% folders{2} = 'DK1437PLoC.nd2 (series 04)-1-235_cropped_backgrdsub10';
% folders{3} = 'DK1437PLoC.nd2 (series 05)-1-235_cropped_backgrdsub10';
% folders{4} = 'DK1437PLoC.nd2 (series 08)-1-45_cropped_backgrdsub10';
% folders{5} = 'DK1437PLoC.nd2 (series 09)-1-50_cropped_backgrdsub10';
% folders{6} = 'DK1437PLoC.nd2 (series 10)-1-235_cropped_backgrdsub10';
% folders{7} = 'DK1437PLoC.nd2 (series 13)-1-50_cropped_backgrdsub10';

threshold = 1500; % for B substilis
%threshold = 700; % for Crecentis

for kthFolder = 1:length(folders)
    cd(folders{kthFolder});
    disp(folders{kthFolder});
    files2Load = dir('ch*_final.mat');
    for kthFile = 1:length(files2Load);
        chName = files2Load(kthFile).name(1:3);
        fprintf('%s\n',chName);
        f2Load = [chName '_final_2.mat'];
        %if exist([chName '_allCell.mat'])
            if exist(f2Load)
                load ([chName '_final_2.mat']);
            elseif exist([chName '_final.mat'])
                f2Load = [chName '_final.mat'];
                load ([chName '_final.mat']);
            else
                continue;
            end
        allFr = allData.allFr;
        for kthFr = allData.startFr:length(allFr)
            cells = allFr(kthFr).cells.cells;
            for kthCell = 1:length(cells)
                cell = cells(kthCell);
                if cell.block.length > 0
                    area2Ana = allFr(kthFr).channel(:,cell.block.blockS:cell.block.blockE);
                    area2AnaLarge = zeros(size(area2Ana)+2);
                    area2AnaLarge(2:end-1,2:end-1) = area2Ana;
                    %imagesc(area2AnaLarge); hold on;
                    %C = contour(area2AnaLarge,[threshold threshold],'linewidth',3,'color','r');  hold off;
                    C = contourc(area2AnaLarge,[threshold threshold]);
                    if ~isempty(C)                        
                        area = polyarea([C(1,2:end) C(1,2)],[C(2,2:end) C(2,2)]);
                        allData.allFr(kthFr).cells.cells(kthCell).area = area;
                        %area1 = polyarea([C(1,2:end)],[C(2,2:end)]);
                        ;
                    else
                        allData.allFr(kthFr).cells.cells(kthCell).area = 0;
                    end
                else
                    allData.allFr(kthFr).cells.cells(kthCell).area = 0;
                end
            end
        end
        save ([f2Load(1:end-4) '_contour.mat'], 'allData');
    end
    cd('../');
end