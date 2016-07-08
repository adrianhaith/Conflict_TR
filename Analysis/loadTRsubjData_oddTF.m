function [data] = loadTJsubjData(subjID,blocknames)
% load a single subject's timed response target jump data
%
% Input:    subjname    - string containing subject ID, e.g. 'S01'
%           blocknames  - cell array containing blocknames to be loaded
%                         together and concatenated, e.g. {'B1','B2'}
%
% Output:   data - data structure containing data from these blocks

Nblocks = length(blocknames);
trial = 1;
tFile = [];
for blk=1:Nblocks
    path = ['../Data/',subjID,'/',blocknames{blk}]; % data path
    disp(path);
    
    % load target file
    fid = fopen([path,'/tFile.tgt']);
    TFcell = textscan(fid,'%f %f %f %f %f %f %f %f %f %f %s %f %f %f %f %s');
    %tF1 = dlmread([path,'/tFile.tgt'],' ',[0 0 9 106]);
    tF = zeros(size(TFcell{1},1),16);
    fnames = dir(path);
    Ntrials = size(tF,1);
    for i=1:Ntrials
        d = dlmread([path,'/',fnames(i+2).name],' ',6,0);
        X{trial} = d(3:4:end,3); % hand X location
        Y{trial} = d(3:4:end,4); % hand Y location
        trial = trial+1;
    end
    
    tF(:,2) = TFcell{2};
    tF(:,3) = TFcell{3};
    tF(:,7) = TFcell{7};
    tF(:,14) = TFcell{14};
    tF(:,15) = TFcell{15};
    tFile = [tFile; tF];
    
end
X0 = tFile(1,2);%TFcell{2}(1);%tFile(1,2); % start position x
Y0 = tFile(1,3);%TFcell{3}(1);%tFile(1,3); % start position y

%data.targPos = tFile(:,6:7)-tFile(:,2:2);
data.goalAng = tFile(:,15);%TFcell{15};%atan2(data.targPos(:,2),data.targPos(:,1))*180/pi;
data.symbAng = tFile(:,7);%TFcell{7}; 
data.targ_appear_time = tFile(:,14);%TFcell{14};

% rotate data into canonical coordinate frame
data.Ntrials = size(tFile,1);
for i=1:data.Ntrials % iterate through all trials
    theta = data.goalAng(i);%atan2(data.targPos(i,2),data.targPos(i,1))-pi/2;
    R = [cos(theta) sin(theta); -sin(theta) cos(theta)];
    data.handPos{i} = [X{i}'-X0; Y{i}'-Y0];
    data.handPos_rotated{i} = R*data.handPos{i};
end
data.tFile = tFile;
data = getErr_fixedT(data);





