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
%%
excel2Read = 'Channels to extract info from.xls';
excel2Write = ('Partial results.xls');

excel2ReadInfo = xlsread(excel2Read,1,'a2:k30');
folders2Ana = excel2ReadInfo(:,1) - 1;
channel2Ana = cell(1,length(folders2Ana));

for ii = 1:length(folders2Ana)
    channel2Ana{ii} = excel2ReadInfo(ii,2:end);
    channel2Ana{ii}(isnan(channel2Ana{ii})==1) = [];
end
%%
% units: gr:pixel/frame
pos_gr = [];
time_gr = [];
sisterDivT = [];
pos_grDivT = [];
time_grDivT = [];
time_cor_gr = [];

pos_gr_nor = [];
time_gr_nor = [];

pos_gr_nor_last = [];
time_gr_nor_last = [];

time_fc_gr_nor = [];
for kthFolder = 1:length(folders2Ana)
    cd(folders{folders2Ana(kthFolder)});
    disp(folders{folders2Ana(kthFolder)});
    files2Load = dir('ch*_allCell.mat');
    for kthFile = (channel2Ana{kthFolder})
        load (files2Load(kthFile).name);
        disp (files2Load(kthFile).name);
        if exist([files2Load(kthFile).name(1:3) '_final_2.mat'])
                load ([files2Load(kthFile).name(1:3) '_final_2.mat']);
        elseif exist([files2Load(kthFile).name(1:3) '_final.mat'])
                load ([files2Load(kthFile).name(1:3) '_final.mat']);
        end
        allFr = allData.allFr;
        for kthCell = 1:length(allCell)
            if allCell(kthCell).isComplete == true;
                %%
                pos_gr = [pos_gr; allCell(kthCell).endFrPos allCell(kthCell).grLength];
                time_gr = [time_gr; allCell(kthCell).frLocs(end,1) allCell(kthCell).grLength];
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
            end
        end
    end
    cd('../');
end
%%
%% unit conversion
um2pix = 7.5;
pix2um = 1/um2pix;
fr2min = 5;
min2fr = 1/fr2min;
%% export excel
if exist(excel2Write,'file')
    delete (excel2Write);
end
xlswrite(excel2Write,{'position','time','growth rate','division time','normalized time(channel full)','normalized gr(first cell)','normalized gr(last cell)','daughter pair-1','daughter pair-2'},1,'a1');
xlswrite(excel2Write,[pos_gr(:,1) time_gr(:,1).*fr2min pos_gr(:,2).*pix2um./fr2min.*1000 time_grDivT(:,2).*fr2min time_fc_gr_nor(:,1).*fr2min pos_gr_nor(:,2)./fr2min pos_gr_nor_last(:,2)./fr2min],1,'a2');
xlswrite(excel2Write,sisterDivT.*fr2min,1,'h2');

%%
% pos_gr(:,2) = pos_gr(:,2).*pix2um./fr2min.*1000;
% 
% pos_grDivT(:,2) = pos_grDivT(:,2).*fr2min;
% 
% time_grDivT = time_grDivT.*fr2min;
% 
% time_gr(:,1) = time_gr(:,1).*fr2min;
% time_gr(:,2) = time_gr(:,2).*pix2um./fr2min.*1000;
% 
% time_cor_gr(:,1) = time_cor_gr(:,1).*fr2min;
% time_cor_gr(:,2) = time_cor_gr(:,2).*pix2um./fr2min.*1000;
% 
% sisterDivT = sisterDivT.*fr2min;
% 
% time_fc_gr_nor(:,1) = time_fc_gr_nor(:,1).*fr2min;
% time_fc_gr_nor(:,2) = time_fc_gr_nor(:,2)./fr2min;
% 
% pos_gr_nor(:,2) = pos_gr_nor(:,2)./fr2min;
% pos_gr_nor_last(:,2) = pos_gr_nor_last(:,2)./fr2min;
%%
figure;
plot(time_gr(:,1),time_gr(:,2),'o')
figure;
plot(time_cor_gr(:,1),time_cor_gr(:,2),'o');
figure;
plot(pos_gr(:,1),pos_gr(:,2),'o')
figure;
plot(sisterDivT(:,1),sisterDivT(:,2),'o');