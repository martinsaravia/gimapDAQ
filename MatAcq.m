%=========================================================================
%
%           GIMAP NATIONAL INSTRUMENTS DATA ACQUISITION SYSTEM 
%
% License
% This file is part of gimapDAQ.

% gimapDAQ is free software: you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.

% gimapDAQ is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
% for more details.

% You should have received a copy of the GNU General Public License
% along with gimapDAQ.  If not, see <http://www.gnu.org/licenses/>.
%%========================================================================
 

% ------------------------- CONFIGURATION --------------------------------
clc; clear all;
JobName = 'martin01';
Device = 'GIMAP-9174-01_1';

%          Socket             Channel      Sensor
CFG = { 'GIMAP-9174-01'       0         'Acc001'  ;
        'GIMAP-9174-01'       1         'Volt001' };

sampling_rate = 2048;
test_duration = 10;
% ------------------------------------------------------------------------



% xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
%                                 CODE
%----------------------------------------------------------------------------
s = daq.createSession('ni'); 
addpath([cd '/acq/'])
run sens/Sensors

fname = [JobName '.dat'];
fileloc = fullfile( 'data', fname );
ofile = fopen( fileloc ,'w');


% Add channels from table 
for i = 1:length(CFG(:,1))
    sidx = find(strcmp({Sensor.name}, CFG(i,3)) == 1); % Sensor id
    addAnalogInputChannel(s, CFG{i,1}, CFG{i,2}, Sensor(sidx).type);
    if strcmp(Sensor(sidx).type, 'Voltage') == 0 
        s.Channels(i).Sensitivity = Sensor(sidx).sens;
    end
end


% Create Data file
buffer_size = floor(sampling_rate / 3); % 
% buffer_size = test_duration * 20 * (sampling_rate / 1024); % No pregunten porqué!
fname = [JobName '.dat'];
ofile = fopen( fileloc ,'w');

% Configure Session
s.Rate = sampling_rate;
s.DurationInSeconds = test_duration;
nch = length(s.Channels);
% addTriggerConnection(s,[Device '/PFI0',[Device '/PFI0'],'StartTrigger');
% s.ExternalTriggerTimeout = 30;

% s.IsContinuous = true;
s.NotifyWhenDataAvailableExceeds = buffer_size;

% Create Time Table
% dt = 1.0 / s.Rate;
% tf = s.DurationInSeconds;
% time = 0:dt:tf;
% X = zeros(length(time),length(s.Channels)+1);

% Set column names
fprintf(ofile, '%s\n', 'National Instruments Acquisition');
chanstr = 'Time';
for i=1:nch;
    chanstr = strcat(chanstr, {'    '}, {CFG{i,3}});
end
fprintf(ofile, '%s\n', chanstr{:});
% Set the format of the data table 
table_format = '%f';
legend_str = {};
for i = 1:nch    
    table_format = strcat( table_format, ' %f' );
    legend_str{i} =  [ s.Channels(i).ID, ' - ', s.Channels(i).MeasurementType, ' - ', s.Channels(i).Device(1).ID ] ;
end
table_format = strcat( table_format, '\n' );
 
% Set the plot
scrsz = get(groot,'ScreenSize');
% figure('Position',[1 scrsz(4)/.9 scrsz(3)/.9 scrsz(4)/1.3])
ax = gca;
ax.XGrid = 'on';   
ax.YGrid = 'on';  
plt = plot([], 'b');
title('GIMAP DAQ v0.0')
xlabel('Time (s)')
ylabel('DAQ Output')
xlim( [0 test_duration])
hold on

% Add Listener
lh1 = addlistener(s,'DataAvailable', @(s, event)DaqPlot(s, event, ofile, test_duration, table_format, legend_str, ax) );
% End the task, delete the listener and close the output file
[data,timeStamps,triggerTime] = s.startForeground();
% datestr(triggerTime)
s.wait();
delete(lh1);
X = dlmread(fileloc,'', 2, 0);
fclose(ofile);
%xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx



