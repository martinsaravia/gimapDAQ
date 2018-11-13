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

clc; clear all; close all; 
addpath([cd '/pre/']); addpath([cd '/post/'])
filedir = strcat(pwd,'\data\');

filename = 'martin01*';
t0 = 0;       tf = 60;
fmin = 0;    fmax = 80;

[SG, Sensor] = ReadTest(filedir, filename, t0, tf);

% Manual Instrument Setting for Pasco and Labjack
% SG(2).sensor = Sensor(4);
% SG(3).sensor = Sensor(1);
% SG(4).sensor = Sensor(3);


[SG] = PostProcess ( SG, fmin, fmax ) ;





