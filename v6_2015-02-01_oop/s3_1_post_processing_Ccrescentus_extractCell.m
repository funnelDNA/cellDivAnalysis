%% For analyzing multi folders at one time
fName = [];
folders{1} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 1)-1-100_rotated_backgroundsub50';
folders{2} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 2)-1-100_rotated_backgroundsub50';
folders{3} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 4)_rotated_cropped_backgroundsub50';
folders{4} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 5)-1-100_rotated_backgroundsub50';
folders{5} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 6)-1-100_rotated_backgrndsub50-1';
folders{6} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 7)-1-100_rotated_backgrndsub50';
folders{7} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 8)-1-100_rotated_backgrndsub50';
folders{8} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 9)-1-85_rotated_backgrndsub50';
folders{9} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 10)-1-85_rotated_backgrndsub50';
folders{10} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 11)-1-80_rotated_backgrndsub50';
folders{11} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 12)-1-100_rotated_backgrndsub50';
%fName{} = '';
for kthFolder = 1:length(fName)
    cd(fName{kthFolder});
    disp(fName{kthFolder});
    files2Load = dir('ch*_final.mat');
    for kthFile = 1:length(files2Load);
        chName = files2Load(kthFile).name(1:3);
        disp(chName);
        f2Load = [chName '_final_2.mat'];
        if exist(f2Load)
            load ([chName '_final_2.mat']);
        else
            load ([chName '_final.mat']);
        end
        allCell = allData.extractCell;
        save ([chName '_allCell.mat'], 'allCell');
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
