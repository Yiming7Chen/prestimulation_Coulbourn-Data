    %% RUN a list of a bunch of experimental documents in .txt format
close all
clear all
list={
% names of txt files that contains the formated structure of experiment
% information
}

temp_list={};

for i=1:length(list)

infile=list{i}
boutthreshold=5;
fduration=60;
[ mcode, experiment, mcount_pellets, mtime_pellets, namtrials, para,mtime_sensor ] = master_analyzepellets_gstxt_pstructure(infile,fduration,boutthreshold);
clear i
save(strcat(experiment,'.mat'),'-mat');     
temp_list=[temp_list strcat(experiment,'.mat')];
close all

end 


exlist=temp_list;

ctime_pellets={};
ccount_pellets={};
cpara={};
cnamtrials={};
for i=1:length(exlist)
    load(exlist{i});
    te={mtime_pellets};
    ctime_pellets=[ctime_pellets te];
    te={mcount_pellets};
    ccount_pellets=[ccount_pellets te];
    cpara=[cpara para];
    cnamtrials=[cnamtrials namtrials];
end

clear experimen mcount_pellets mtime_pelets para temp_list i 
save('test.mat','-mat');     