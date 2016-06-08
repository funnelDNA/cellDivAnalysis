folders = [];
folders{1} = 'DK1437PLoC.nd2 (series 01)-1-151_cropped_backgrdsub10';
folders{2} = 'DK1437PLoC.nd2 (series 04)-1-235_cropped_backgrdsub10';
folders{3} = 'DK1437PLoC.nd2 (series 05)-1-235_cropped_backgrdsub10';
folders{4} = 'DK1437PLoC.nd2 (series 08)-1-45_cropped_backgrdsub10';
folders{5} = 'DK1437PLoC.nd2 (series 09)-1-50_cropped_backgrdsub10';
folders{6} = 'DK1437PLoC.nd2 (series 10)-1-235_cropped_backgrdsub10';
folders{7} = 'DK1437PLoC.nd2 (series 13)-1-50_cropped_backgrdsub10';


% units: gr:pixel/frame
pos_gr = [];
time_gr = [];
pos_grArea = [];

pos_Int1 = [];
pos_Int2 = [];

sisterDivT = [];
pos_grDivT = [];
time_grDivT = [];
time_cor_gr = [];

pos_gr_nor = [];
time_gr_nor = [];

pos_gr_nor_last = [];
time_gr_nor_last = [];

time_fc_gr_nor = [];

divT_age = [];
for kthFolder = 1:length(folders)
    cd(folders{kthFolder});
    disp(folders{kthFolder});
    files2Load = dir('ch*_allCell_contour.mat');
    for kthFile = 1:length(files2Load);
        load (files2Load(kthFile).name);
        disp (files2Load(kthFile).name);
        if exist([files2Load(kthFile).name(1:3) '_final_2_contour.mat'])
                load ([files2Load(kthFile).name(1:3) '_final_2_contour.mat']);
        elseif exist([files2Load(kthFile).name(1:3) '_final_contour.mat'])
                load ([files2Load(kthFile).name(1:3) '_final_contour.mat']);
        end
        allFr = allData.allFr;
        for kthCell = 1:length(allCell)
            if allCell(kthCell).isComplete == true
                %% test
                if (allCell(kthCell).lastFrIntCh1 < 2000)
                    a = 1;
                end
                
                
                %% after
                pos_gr = [pos_gr; allCell(kthCell).endFrPos allCell(kthCell).grLength];
                time_gr = [time_gr; allCell(kthCell).frLocs(end,1) allCell(kthCell).grLength];
                pos_grArea = [pos_grArea; allCell(kthCell).endFrPos allCell(kthCell).grArea];
                
                pos_Int1 = [pos_Int1; allCell(kthCell).endFrPos allCell(kthCell).lastFrIntCh1];
                pos_Int2 = [pos_Int2; allCell(kthCell).endFrPos allCell(kthCell).lastFrInt];
                
                %% normalize growth rate with length of the first cell
                pos_gr_nor = [pos_gr_nor; allCell(kthCell).endFrPos allCell(kthCell).grLength/allFr(allCell(kthCell).frLocs(1,1)).cells.cells(allCell(kthCell).frLocs(1,2)).block.length];
                time_gr_nor = [time_gr_nor; allCell(kthCell).frLocs(end,1) allCell(kthCell).grLength/allFr(allCell(kthCell).frLocs(1,1)).cells.cells(allCell(kthCell).frLocs(1,2)).block.length];
                %% normalize growth rate with length of the last cell
                pos_gr_nor_last = [pos_gr_nor_last; allCell(kthCell).endFrPos allCell(kthCell).grLength/allFr(allCell(kthCell).frLocs(end,1)).cells.cells(allCell(kthCell).frLocs(end,2)).block.length];
                time_gr_nor_last = [time_gr_nor_last; allCell(kthCell).frLocs(end,1) allCell(kthCell).grLength/allFr(allCell(kthCell).frLocs(end,1)).cells.cells(allCell(kthCell).frLocs(end,2)).block.length];
                %% set time zeros to be when the channel fills.
                if fullChFr == 0
                    fullChFr = length(allFr);
                end
                time_fc_gr_nor = [time_fc_gr_nor; allCell(kthCell).frLocs(end,1)-fullChFr allCell(kthCell).grLength/allFr(allCell(kthCell).frLocs(1,1)).cells.cells(allCell(kthCell).frLocs(1,2)).block.length];
                %%
                time_cor_gr = [time_cor_gr; allCell(kthCell).frLocs(end,1)-startFr+1 allCell(kthCell).grLength];
                %%
                pos_grDivT = [pos_grDivT; allCell(kthCell).endFrPos allCell(kthCell).divT];
                time_grDivT = [time_grDivT; allCell(kthCell).frLocs(end,1) allCell(kthCell).divT];
                %%
                sisterId = allCell(kthCell).sister;
                if sisterId > allCell(kthCell).id && allCell(sisterId).isComplete == true
                    sisterDivT = [sisterDivT; allCell(kthCell).divT allCell(sisterId).divT];
                end
                %% divT vs age
                if allCell(kthCell).age ~= -1
                    divT_age = [divT_age; allCell(kthCell).age allCell(kthCell).divT];
                end
            end
        end
        disp(size(pos_gr,1));
    end
    cd('../');
end

%% unit conversion
um2pix = 7.5;
pix2um = 1/um2pix;
fr2min = 5;
min2fr = 1/fr2min;

pos_gr(:,2) = pos_gr(:,2).*pix2um./fr2min.*1000;

pos_grArea(:,2) = pos_grArea(:,2).*pix2um.*pix2um./fr2min.*1000*1000;

pos_grDivT(:,2) = pos_grDivT(:,2).*fr2min;

divT_age(:,2) = divT_age(:,2).*fr2min;

time_grDivT = time_grDivT.*fr2min;

time_gr(:,1) = time_gr(:,1).*fr2min;
time_gr(:,2) = time_gr(:,2).*pix2um./fr2min.*1000;

time_cor_gr(:,1) = time_cor_gr(:,1).*fr2min;
time_cor_gr(:,2) = time_cor_gr(:,2).*pix2um./fr2min.*1000;

sisterDivT = sisterDivT.*fr2min;

time_fc_gr_nor(:,1) = time_fc_gr_nor(:,1).*fr2min;
time_fc_gr_nor(:,2) = time_fc_gr_nor(:,2)./fr2min;

pos_gr_nor(:,2) = pos_gr_nor(:,2)./fr2min;
pos_gr_nor_last(:,2) = pos_gr_nor_last(:,2)./fr2min;
%%
figure;
plot(time_gr(:,1),time_gr(:,2),'o')
figure;
plot(time_cor_gr(:,1),time_cor_gr(:,2),'o')
figure;
plot(pos_gr(:,1),pos_gr(:,2),'o')
figure;
plot(pos_grArea(:,1),pos_grArea(:,2),'o')
figure;
plot(sisterDivT(:,1),sisterDivT(:,2),'o');
%% determine threshold 
a = pos_Int1(:,2);
b = pos_Int2(:,2);
hist(b(a>2000),500);
%hist(a,500);
%hist(b,500);
c = (a<2000);
d = find(c~=0);

threPerct = 20; % 20%
allIntSorted = sort(b);
thresholdOFF = allIntSorted(round(length(b)*threPerct/100));
thresholdON = allIntSorted(end-round(length(b)*threPerct/100));
%%
figure;
meanDivT = [];
divT_age_age = divT_age(:,1);
divT_age_divT = divT_age(:,2);
hist(divT_age_divT(divT_age_age==6),500);
for age = 1:6
    meanDivT = [meanDivT mean(divT_age_divT(divT_age_age==age))];
end