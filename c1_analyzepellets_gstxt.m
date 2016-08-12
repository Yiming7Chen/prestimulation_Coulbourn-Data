function [ count_pellets, time_pellets ] = c1_analyzepellets_gstxt( infile, feederstate, timestartfeed,fduration,pelletsensor )
%UNTITLED2 take .txt files containing behavior data from coulbourn GS3
%files. Experiments has to be run with feeder and pellet trough; the
%behavior protocol has to be stereotyped (feeder --> detection --> pellet removal --> detection)
%   Detailed explanation goes here
fid1=fopen(infile);
fprintf(infile)
%% change those accordingly
stimtime=0;
interval=0;
feedduration=fduration*60;

GSAll=[];
s='s';
n=100; %working memory
int=0;
while any(s)

s=fscanf(fid1,'%s', [1]);
if strcmp(s,'Off1A4')
    break
end
end

while any(s)
    int=int+1;
    try
    for i=1:12;
        s=fscanf(fid1,'%s', [1]);
        n=str2num(s);
        GSAll(int,i)=n;
        
        
    end
    end
end


Time=GSAll(:,1);
CurrentState=GSAll(:,2);
feeder=double([CurrentState==feederstate]);
TransitionState=GSAll(:,3);
TransitionEvent=GSAll(:,4);
On1A1=GSAll(:,5);
On1A2=GSAll(:,6);
On1A3=GSAll(:,7);
On1A4=GSAll(:,8);
Off1A1=GSAll(:,9);
Off1A2=GSAll(:,10);
Off1A3=GSAll(:,11);
Off1A4=GSAll(:,12);
%% analyze temporal dynamic

feedertime=[];
numer_feeder=find(feeder>0);%the Time of each feeder state
%to eliminate consecutive feeder states which doesn't mean multiple entry
%but multiple system record of the exac same feeder bouts 
int=length(numer_feeder);
while int>1

    if (numer_feeder(int)-numer_feeder(int-1))==1;
        
        x=numer_feeder(int);
        numer_feeder(int)=[];
        
    end
    int=int-1;
end
%
    feedertime=Time(numer_feeder);
    
    defaultpelletsensor=3;
if nargin==5
    defaultpelletsensor=pelletsensor; % if there is a sensor input then change the sensor to corresponding one. Otherwise it will be #3 that I usually use
end

switch defaultpelletsensor
    case 1
        Onsensor=On1A1;
        Offsensor=Off1A1;
    case 2
        Onsensor=On1A2;
        Offsensor=Off1A2;
    case 3
        Onsensor=On1A3;
        Offsensor=Off1A3;
    case 4
        Onsensor=On1A4;
        Offsensor=Off1A4;
end

Offsensortime=[];
numer_Offsensor= Offsensor>0;
    Offsensortime=Time(numer_Offsensor);
    
realOffsensortime=[];
for i=1:length(feedertime)
    a=feedertime(i);
    b=Offsensortime-a;
    c=find(b>0);
    c=min(c);
    try
    realOffsensortime(i)=Offsensortime(c);
    catch
    end
end
realOffsensortime=realOffsensortime-timestartfeed;
acum_Offsensor=[1:length(realOffsensortime)];

a=find(realOffsensortime>feedduration);
% 
 for i=1:length(a);
    
     realOffsensortime(end)=[];
     acum_Offsensor(end)=[];
 end

%%generateFigure
% Create figure
realOffsensortime=realOffsensortime-4; % correct for 4 sec extra time through transition (House Light time)
time_pellets=realOffsensortime/60;
count_pellets=acum_Offsensor*0.02;

end

