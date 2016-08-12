
clear all
close all

exgroups={
    % name of the mat file containing analyzed data
}

tff_mpellets={[],[],[],[],[],[],[]};
%% create variables
samplesize={};
ff_active=[];
ff_inactive=[];
ff_pellets=[];
nf_active=[];
nf_inactive=[];
ppcd=[]; %short-term memory
mpcd=[];
tlever=[];%short-term memory
mtlever=[];
tpellets=[];
mtpellets=[];
plottimerange=[0,60];
numm=length(exgroups)

plotrepall=0;
NORMALIZING=0;
figure 
hold on
mmpcd_p={[],[],[],[],[],[]};
m_mmpcd_p={[],[],[],[],[],[],[]};
sem_mmpcd_p={[],[],[],[],[],[],[]};
colors_light={[0.5,0.5,0.5],[1,0.5,0.5],[0.5,0.5,1]};
colors={'k','r','b','g','m'};
% colors={[0.8,0.8,0.8],[1,0.7,0.7],[1,0.6,0.6],[1,0.5,0.5],[1,0.4,0.4],[1,0.3,0.3],[0.3,0.3,0.3]}
mcode=[1,1,1,1,1,1];
x=[];

%% convert stamps to cdf
for i5=1:length(exgroups);

    load(strcat(exgroups{i5},'.mat'));

    %
    fprintf('***');
    i4=0;
     for i2=1:length(mcode);
         fprintf('//');
        mpcd=[];
        if i2>1;
        i4=sum(mcode(1:i2-1));
        end
        for i3=i4+1:mcode(i2)+i4;
            [pcd,tcd]=reshape_sensor_filltheline(mtime_pellets{i3},plottimerange);

            pcd=pcd*0.02;
            if NORMALIZING==1
                pcd=pcd/max(pcd);

            end
            fprintf(num2str(i3));
            x=[x; pcd];
            mpcd=[mpcd;pcd];
        end
        avgmpcd=mean(mpcd,1);
        if plotrepall==1;
                plot(tcd,avgmpcd,'Color',colors_light{i5})
        end
        tff_mpellets{i5}=[tff_mpellets{i5} mean(mpcd(:,end))];
        mmpcd_p{i5}=[mmpcd_p{i5}; avgmpcd];
        samplesize{i5}=length(mcode);
    end
end

%% STAT

sd_mmpcd_p={};
% sd_mmpcd_p=std(mmpcd_p{i5},1);
for i5=1:length(exgroups);
m_mmpcd_p{i5}=mean(mmpcd_p{i5},1);
sem_mmpcd_p{i5}=std(mmpcd_p{i5},1)/(samplesize{i5}^0.5);
sd_mmpcd_p{i5}=std(mmpcd_p{i5},1);

end

for n=1:length(exgroups);


plot(tcd,m_mmpcd_p{n},'Color',colors{n},'LineWidth',2);
plot(tcd,m_mmpcd_p{n}-sem_mmpcd_p{n},'Color',colors{n});
plot(tcd,m_mmpcd_p{n}+sem_mmpcd_p{n},'Color',colors{n});

% plot(tcd,nostim_active_mean,'-b','LineWidth',2);
% plot(tcd,nostim_active_mean-nostim_activ_se,'b');
% plot(tcd,nostim_active_mean+nostim_activ_se,'b');
% 
% plot(tcd,nostim_inactive_mean,'-k','LineWidth',2);
% plot(tcd,nostim_inactive_mean-nostim_inactiv_se,'k');
% plot(tcd,nostim_inactive_mean+nostim_inactiv_se,'k');
end
% % Create xlabel
  ylim([0,1.5]);
  xlim(plottimerange)
set(gca,'FontSize',20)
xlabel('Time (Min)','FontSize',20)
ylabel('Food intake (g)','FontSize',20)
