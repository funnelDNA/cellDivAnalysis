%%
test(allData);
%%
channels = channel2_all(1).channel;     
startFr = 1;
imagesc(channels,'ydata',((1:size(channels,1))+channelW/2)/(channelW)+startFr-1);
set(gca,'fontsize',20);
%%
xlabel('relative position');
ylabel('growth (nm/min)');
set(gca,'fontsize',23);
%%
xlabel('relative position');
ylabel('growth-norm-last (%/min)');
set(gca,'fontsize',23);
%%
xlabel('time (min)');
ylabel('growth (nm/min)');
set(gca,'fontsize',23);
%%
xlabel('daughter 1 - time (min)');
ylabel('daughter 2 - time (min)');
%%
xlabel('time (min)');
ylabel('growth (%/min)');
set(gca,'fontsize',23);
%%
ylabel('division time (min)');
%%
xlabel('stalk division time (min)');
ylabel('swarmer division time (min)');
set(gca,'xlim',[40 160]);
set(gca,'ylim',[40 160]);
%%
figure;
plot(time_grDivT(:,1),time_grDivT(:,2),'o')
figure;
plot(pos_grDivT(:,1),pos_grDivT(:,2),'o')
figure;
plot(sisterDivT(:,1),sisterDivT(:,2),'o');
%% histogram of Amp

%data = q5month_24hr;
data = q60min_5month;
%data = q5month;
%data = q5month_3day;
binN = 206;
upLim = 0.01;
lowLim = 0;
ll = 0;
allAmp = [];        allPpTime = [];
hold off;
for ii = 1:length(data.allEvents)
    if ~isempty(data.allEvents(ii).aveAmp) && ~isempty(data.allEvents(ii).ppTime)
        ll = ll + 1;
        allAmp = [allAmp data.allEvents(ii).aveAmp];
        allPpTime = [allPpTime data.allEvents(ii).ppTime];
    end
end
b = allAmp;% + data.ampCor;
%b = allAmp*1.13*1.13+ 0.000;
b(b>=upLim | b<=lowLim) = [];
b = [b upLim lowLim];
[N P] = hist(b,binN);
%ll,max(P),min(P)
N = N/sum(N); 
plot(P,N,'linewidth',3);
hold on;
%%
%data = q5month;
%data = q5month_24hr;
data = q5month_3day;

binN = 206;
upLim = 0.01;
lowLim = 0;
ll = 0;
allAmp = [];        allPpTime = [];

for ii = 1:length(data.allEvents)
    if ~isempty(data.allEvents(ii).aveAmp) && ~isempty(data.allEvents(ii).ppTime)
        ll = ll + 1;
        allAmp = [allAmp data.allEvents(ii).aveAmp];
        allPpTime = [allPpTime data.allEvents(ii).ppTime];
    end
end
b = allAmp;% + data.ampCor;
b = allAmp*1.3 - 0.00025;
b(b>=upLim | b<=lowLim) = [];
b = [b upLim lowLim];
[N P] = hist(b,binN);
%ll,max(P),min(P)
N = N/sum(N); 
plot(P,N,'linewidth',3);
hold on;









%text(0.006,0.15,[num2str(length(allAmp)) ' Events'],'fontsize',23)
%text(0.006,0.13,[num2str(binN) ' bins'],'fontsize',23)
%text(0.006,0.11,['60' ' measurements'],'fontsize',23)
xlabel('DeltaI/I');
ylabel('Counts %');
set(gca,'fontsize',23);
set(gca,'xlim',[0.002 0.006]);
set(gca,'ylim',[0 0.26]);
%legend('15 s','1 min','5 min','60 min','4d');
legend('15 s');
legend('60 min');
legend('All');
legend('0.05uM-120h');
disp('done');
results_sum = [P' N'];
%%
tic;
load ('2.mat');
toc;
%%
tic;
load 1-1.mat
toc;

%%
tic;
save 1-2.mat channel_all
toc;
%%
tic;
save 1-3.mat allFrames allFrames2
toc;

%%
tic;
load 1-2.mat
toc;

%%
tic;
load 1-4.mat
toc;
%%
tic;
save 1-4.mat allFrames3 channel_all
toc;
%%
tic;
load 3.mat
toc;
%%
tic;
allFrames_ser = hlp_serialize(allFrames);
save allFrames_ser.mat allFrames_ser -v6
load allFrames_ser.mat
allFrames_2 = hlp_deserialize(allFrames_ser);
toc;
%%
tic;
save allFrames.mat allFrames -v6
load allFrames.mat
toc;


%%
tic;
allFrames_ser = hlp_serialize(allFrames);
save allFrames_ser.mat allFrames_ser -v6
load allFrames_ser.mat
allFrames_2 = hlp_deserialize(allFrames_ser);
toc;
%%
tic;
save ch1_finalv6.mat -v6
load ch1_finalv6.mat
toc;

%%
tic;
save ch1_finalv6.mat
load ch1_finalv6.mat
toc;
%%
tic;
save ch1_finalv6_2.mat
load ch1_finalv6_2.mat
toc;


%%
clear;
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
    files2Load = dir('*.mat');
    for ii = 1:length(files2Load)
        disp(files2Load(ii).name);
        tic;
        load (files2Load(ii).name);
        allVar = whos('-file',files2Load(ii).name);
        save (files2Load(ii).name,allVar(1).name,'-v6');
        for jj = 2:length(allVar)
            save (files2Load(ii).name,allVar(jj).name,'-append','-v6');
        end
        toc;
    end
    cd('../');
end

%%
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
        fprintf('%s\n',chName);
        f2Load = [chName '_final_2.mat'];
        %if exist([chName '_allCell.mat'])
            if exist(f2Load)
                load ([chName '_final_2.mat']);
                allData.cleanData;
                save ([chName '_final_2.mat'],'allData');
            end
            if exist([chName '_final.mat'])
                load ([chName '_final.mat']);
                allData.cleanData;
                save ([chName '_final.mat'],'allData');
            end
    end
    cd('../');
end
