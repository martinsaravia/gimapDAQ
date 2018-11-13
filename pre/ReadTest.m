


function [SG, Sensor] = ReadTest(filedir, filename, t0, tf)


addpath([cd '/util']);
addpath([cd '/data']);
addpath([cd '/sens']);
% Get Files with input key
files = dir( [filedir, filename] );
fileid = fopen( [filedir, files(1).name] );
% Identify Hardware
line1 = fgets( fileid );

run sens/Sensors;

% Pasco Routine
if strfind(line1,'Run') >= 1
    fclose(fileid); 
    for i = 1:(length(files));
        filepath = [filedir, files(i).name];    
        fpath = [filedir files(i).name];
        file    = memmapfile( fpath, 'writable', true );
        file.Data( transpose( file.Data== uint8(',')) ) = uint8('.');
        data = dlmread( filepath ,'\t', 2, 0);
        SG(i+1).data =  data(:,2);
        SG(i+1).name = fgets( fopen(filepath ) );
        SG(i+1).hard = 'Pasco';
    end
    SG(1).data =  data(:,1);    
end



% Labjack Routine
if strfind(line1,'Canal') >= 1 
    file    = memmapfile( [filedir files(1).name], 'writable', true );
    file.Data( transpose( file.Data== uint8(',')) ) = uint8('.');
    data = dlmread( [filedir, files(1).name] ,' ', 1, 0);
    names = strsplit(line1, ' ');
    for i = 1:length(data(1,:))-1
        SG(i+1).data =  data(:,i);
        SG(i+1).sensor = names{i};
        SG(i+1).hard = 'Labjack';
    end
    SG(1).data =  data(:,end);
end


% National Routine
if strfind(line1,'National') >= 1 
    line2 = strsplit( strtrim( fgets( fileid ) ), ' ');
    data = dlmread( [filedir, files(1).name] ,'', 2, 0); 
    for i = 1:length(data(1,:))
        SG(i).data =  data(:,i);
        SG(i).name = line2{i};
    end
end


% Common Block
SG(1).name = 'Time';
for i = 2:length(SG);
    SG(i).sensor = Sensor( structfind(Sensor, 'name', SG(i).name ));
    SG(i).rate = 1 / (SG(1).data(2) - SG(1).data(1));
    lastsample = SG(i).rate * (tf - t0 );
    if lastsample >= length(SG(i).data);  % Avoid problem with bad tf setting
        lastsample = length(SG(i).data);
    end        
    SG(i).data = SG(i).data(1:lastsample); % Cut the signal
    SG(i).samp = length(SG(i).data);
end
SG(1).data = SG(1).data(1:lastsample); % Cut the time vector

