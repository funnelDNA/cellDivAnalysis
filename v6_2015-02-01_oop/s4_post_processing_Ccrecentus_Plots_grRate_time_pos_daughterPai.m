fName = [];
fName{1} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 1)-1-100_rotated_backgroundsub50';
fName{2} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 2)-1-100_rotated_backgroundsub50';
fName{3} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 4)_rotated_cropped_backgroundsub50';
fName{4} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 5)-1-100_rotated_backgroundsub50';
fName{5} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 6)-1-100_rotated_backgrndsub50-1';
fName{6} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 7)-1-100_rotated_backgrndsub50';
fName{7} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 8)-1-100_rotated_backgrndsub50';
fName{8} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 9)-1-85_rotated_backgrndsub50';
fName{9} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 10)-1-85_rotated_backgrndsub50';
fName{10} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 11)-1-80_rotated_backgrndsub50';
fName{11} = 'YB6474PLoC.nd2 - YB6474PLoC.nd2 (series 12)-1-100_rotated_backgrndsub50';

% units: gr:pixel/frame
pos_gr = [];
time_gr = [];
sisterDivT = [];
pos_grDivT = [];
time_grDivT = [];

for kthFolder = 1:length(fName)
    cd(fName{kthFolder});
    files2Load = dir('ch*_allCell.mat');
    for kthFile = 1:length(files2Load);
        load (files2Load(kthFile).name);
        for kthCell = 1:length(allCell)
            if allCell(kthCell).isComplete == true && allCell(kthCell).cellType == 0
                pos_gr = [pos_gr; allCell(kthCell).endFrPos allCell(kthCell).grLength];
                time_gr = [time_gr; allCell(kthCell).frLocs(end,1) allCell(kthCell).grLength];
                pos_grDivT = [pos_grDivT; allCell(kthCell).endFrPos allCell(kthCell).divT];
                time_grDivT = [time_grDivT; allCell(kthCell).frLocs(end,1) allCell(kthCell).divT];
                sisterId = allCell(kthCell).sister;
                if allCell(sisterId).isComplete == true && allCell(sisterId).cellType == 1
                    sisterDivT = [sisterDivT; allCell(kthCell).divT allCell(sisterId).divT];
                end
            end
        end
    end
    cd('../');
end

%% unit conversion
um2pix = 7.5;
pix2um = 1/um2pix;
fr2min = 5;
min2fr = 1/fr2min;

pos_gr(:,2) = pos_gr(:,2).*pix2um./fr2min.*1000;
time_gr(:,1) = time_gr(:,1).*fr2min;
time_gr(:,2) = time_gr(:,2).*pix2um./fr2min.*1000;
sisterDivT = sisterDivT.*fr2min;

pos_grDivT(:,2) = pos_grDivT(:,2).*fr2min;
time_grDivT(:,1) = time_grDivT(:,1).*fr2min;
time_grDivT(:,2) = time_grDivT(:,2).*fr2min;
%%
figure;
plot(time_gr(:,1),time_gr(:,2),'o')
figure;
plot(pos_gr(:,1),pos_gr(:,2),'o')
figure;
plot(sisterDivT(:,1),sisterDivT(:,2),'o');