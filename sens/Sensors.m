% =========================================================================
%
%                        GIMAP SENSORS CLASS
%
% =========================================================================

% types = 'Accel', 'Disp', 'Vel'
% units = 'Volt', 'mms2', 'g'


% Sensor 1
Sensor(1).name = 'Acc001';
Sensor(1).bran = 'PCB';
Sensor(1).type = 'Accelerometer';
Sensor(1).sens = 1 / 0.1 ;
Sensor(1).unit = 'g' ;


% Sensor 2
Sensor(2).name = 'Vel002';
Sensor(2).bran = 'PCB';
Sensor(2).type = 'Velocity';
Sensor(2).sens = 1.0 ;
Sensor(2).unit = 'mms';

% Sensor 3
Sensor(3).name = 'Volt001';
Sensor(3).bran = 'PCB';
Sensor(3).type = 'Voltage';
Sensor(3).sens = 1.0 ;
Sensor(3).unit = 'Volta';



% Sensor 1
Sensor(4).name = 'Disp001';
Sensor(4).bran = 'PCB';
Sensor(4).type = 'Displacement';
Sensor(4).sens = 1 / 8.000 ;
Sensor(4).unit = 'mm' ;
