function [ mcode, experiment, mcount_pellets, mtime_pellets, namtrials, para,time_sensor ] = c2_analyzepellets_gstxt(listoffiles,fduration,boutthreshold)
%UNTITLED2 process all the txt files in the list of experimental details 
%   Detailed explanation goes here

fid = fopen(listoffiles);

%scan the title
fscanf(fid, '%s', [2]);
experiment = fscanf(fid, '%s', [1]);
infile='stuff';
%create variable
mouse={};
mcount_pellets={};
mtime_pellets=[];
namtrials={};
mbouts={};
para=struct('mlatency',[],'mstimlength',[],'mpelletleft',[],'mintervallength',...
    [],'mtotalpellets',[],'firstboutsize',[],'boutnumber',[],'avgboutsize',[],...
    'mtau1',[]);

n=1; %itenerator
%% get the structure of the data;
% for example if mcode=[3,3,2] then there is 3,3,2 technical replicates for each
% respective biological sample.
mcode_raw=fscanf(fid, '%s', [1]);
mcl=length(mcode_raw);
mcode_raw=str2num(mcode_raw);
mcode=[];
time_sensor={};
% convert 43232 to [4,3,2,3,2]
for i=1:mcl
    a=mcode_raw-floor(mcode_raw/10)*10;
    mcode=[a mcode];
    mcode_raw=floor(mcode_raw/10);
end


infile=fscanf(fid, '%s', [1]);
while infile,
%% process ftrace
    fprintf(infile);
    


    trialname=fscanf(fid, '%s', [1]);
    
    stimlength = fscanf(fid, '%s', [1]);
    stimlength=str2double(stimlength);
    
    intervallength = fscanf(fid, '%s', [1]);
    intervallength=str2double(intervallength);
    
    feederstate = fscanf(fid, '%s', [1]);
    feederstate=str2double(feederstate);
    
    feedstart = fscanf(fid, '%s', [1]);
    feedstart=str2double(feedstart);
    
    pelletleft= fscanf(fid, '%s', [1]);
    pelletleft=str2double(pelletleft);

    [ count_pellets, time_pellets ] = slave_analyzepellets_gstxt( strcat(infile,'.txt'), feederstate, feedstart*60,fduration); % 60 --> 60 sec/min
    
    [ time_s]=slave_analyzesensordata_gstxt_v2(strcat(infile,'.txt'));
   %unit of time_pellets: minute
    time_sensor{n}=time_s;
    
    if isempty(time_pellets)==0
    [ bouts ] = analyzepellet_seperatebouts( count_pellets,time_pellets,boutthreshold );
    else
        bouts=[];
    end
    mbouts{n}=bouts; % mbouts will be a cell containing cells
    
    mcount_pellets{n}=count_pellets;
    mtime_pellets{n}=time_pellets;
    
    namtrials{n}=trialname;
% 
%      [figure1]=fun_scatterplotpellets(time_pellets,count_pellets);
%      saveas(figure1,trialname,'fig')
%     
    para.mpelletleft=[para.mpelletleft pelletleft];
    tauthres=0.02*length(count_pellets)*0.632;
    para.mtotalpellets=[para.mtotalpellets length(count_pellets)-pelletleft];
    
    a=find((count_pellets-tauthres)>0);
    if any(a)
    para.mtau1=[para.mtau1 time_pellets(a(1))];
    else
        para.mtau1=[para.mtau1 fduration];
    end
    if isempty(time_pellets)==0
    para.mlatency=[para.mlatency time_pellets(1)];
    else
       para.mlatency=[para.mlatency fduration];
    end
    if isempty(bouts)==0
    para.firstboutsize=[para.firstboutsize length(bouts{1})];
    else 
        para.firstboutsize=[para.firstboutsize 0];
    end
    para.boutnumber=[para.boutnumber length(bouts)];
    
    temp=[];
    for i=1:length(bouts)
        temp=[temp length(bouts{i})];
    end
    a=mean(temp);
    if any(a)==0;
        a=0;
    end
    para.avgboutsize=[para.avgboutsize a];
    
    clear temp
    
    para.mstimlength=[para.mstimlength stimlength];
    para.mintervallength=[para.mintervallength intervallength];
    
    n=n+1;
    fscanf(fid, '%s', [1]);
    infile=fscanf(fid, '%s', [1]);
    fprintf('\n');
end 

end

