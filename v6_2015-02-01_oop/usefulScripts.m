%% For analyzing multi folders at one time
fName = [];
fName{1} = 'DK1437_1mMIPTG(series 1)-1-130_rotated_backgrndsub50_cropped';
%fName{2} = 'DK1437_1mMIPTG(series 3)-1-130_rotated_backgrndsub50_cropped';
fName{2} = 'DK1437_1mMIPTG(series 8)-1-130_rotated_backgrndsub50';
fName{3} = 'DK1437_1mMIPTG(series 9)-1-130_rotated_cropped_backgrndsub50';
fName{4} = 'DK1437_1mMIPTG(series 14)-1-130_rotated_backgrndsub50_cropped';
fName{5} = 'DK1437_1mMIPTG(series 16)-1-130_rotated_cropped_backgrndsub50';
for kthFolder = 1:length(fName)
    cd(fName{kthFolder});
    files2Load = dir('ch*_allCell.mat');
    for kthFile = 1:length(files2Load);
        load (files2Load(kthFile).name);
%         for kthCell = 1:length(allCell)
%             if allCell(kthCell).isComplete == true;
%             end
%         end
    end
    cd('../');
end
%%