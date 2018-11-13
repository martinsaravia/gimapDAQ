function  [SG] = PostProcess ( SG, fmin, fmax ) 

nc = length(SG)-1; % Number of Channels

% Calculate RMS and FFTs
for i = 2 : (nc+1);
    SG(i).mean = mean(SG(i).data); % Mean of signal
    SG(i).unit = SG(i).data - SG(i).mean;
    SG(i).rms = rms(SG(i).unit); % RMS of signal

    % FFTs Matlab Algorithm
%     xaxe = (SG(i).rate / SG(i).samp) * [0 : SG(i).samp/2]';
%     ytmp = abs( fft(SG(i).unit / SG(i).samp));
%     yaxe = ytmp(1:SG(i).samp / 2 + 1);
%     yaxe(2:end-1) = 2 * yaxe(2:end-1);

% Gatti Algorithm
     xaxe =  (SG(i).rate / SG(i).samp) * [0 : SG(i).samp - 1 ]' ;
     yaxe = abs( fft(SG(i).unit) ); 
    
    SG(i).fft = [ xaxe, yaxe ];
    
end
    
     
    
% Plots  
    
% Windows Position variables
gap = 5; smenu = 45; vmenu = 95; hmenu = 15; screensize = get(0,'ScreenSize');
swide = screensize(3); sheig = screensize(4)-smenu; fwide = swide / 2; fheig = sheig / nc;
scrsz = get(groot,'ScreenSize');
% figure('Position',[1 scrsz(4)/.9 scrsz(3)/.9 scrsz(4)/1.3])

% Set Positions and Plot variables
for i = 1:nc;
    if strcmp(SG(i+1).sensor.type, 'Piezo') == 1;
        color = [0.1 0.7 0.1];
    else
        color = [0.0 0.0 1];
    end
    
    % Time histories
    position1 = [gap, sheig-(i*fheig)+smenu,   fwide-hmenu,  fheig-vmenu]; 
    fh(2*i-1) = figure(2*i-1);
    set(fh(2*i-1),'Position', position1);
    plot( SG(1).data, SG(i+1).unit,'Color',color)
    axis([-inf, inf, -inf,inf])
    xlabel('Time (s)')
    ylabel( strcat(SG(i+1).sensor.type, '-', SG(i+1).sensor.unit ) )
    title( strcat('Time History','-',SG(i+1).sensor.name, '-', SG(i+1).sensor.bran ) ) 
    leg = sprintf('RMS = %4.6f \n MEAN = %4.6f', SG(i+1).rms, SG(i+1).mean);
    legend( leg )
    
    % Spectrums
    position2 = [fwide+gap, sheig-(i*fheig)+smenu,   fwide-hmenu,  fheig-vmenu]; 
    fh(2*i) = figure(2*i);
    set(fh(2*i),'Position', position2);
    
    if strcmp(SG(i+1).sensor.type, 'Piezo') == 1;
        if strcmp(SG(2).sensor.type, 'Displacement') == 1; % Base displacements measure
            if strcmp(SG(2).sensor.unit, 'mm') == 1
                grav = 9810;
            elseif strcmp(SG(2).sensor.unit, 'm') == 1
                grav = 9.81;
            end
            fftVG = SG(i+1).fft(:,2) ./ ( SG(2).fft(:,2) .* ( (SG(2).fft(:,1)*2.0*pi).^2) ./ grav ) ; 
        else
            fftVG = SG(i+1).fft(:,2) ./ SG(2).fft(:,2);
        end
         ax2min = (SG(i+1).samp / SG(i+1).rate) * fmin; % Plot only the needed band (otherwise axes in plotyy cant be set right)
         ax2max = (SG(i+1).samp / SG(i+1).rate) * fmax;
         [ax,h1, h2] = plotyy( SG(i+1).fft(:,1), SG(i+1).fft(:,2), SG(i+1).fft(ax2min:ax2max,1), fftVG(ax2min:ax2max));
         set(h1, 'color', color)
         set(h2, 'color', 'r')
         axis([fmin, fmax, -inf, inf])
%          set(ax,'xlim', [fmin, fmax])
%          set(ax(1),'ylim', [-inf, inf])
%          set(ax(2),'ylim', [0, max(fftVG(ax2min:ax2max))])
          linkaxes([ax(1) ax(2)], 'x')
    else
        plot( SG(i+1).fft(:,1), SG(i+1).fft(:,2) ,'Color', color)
        axis([fmin, fmax, -inf, inf])
    end

    xlabel('Frequency (Hz)')
    ylabel( strcat(SG(i+1).sensor.type, '-', SG(i+1).sensor.unit ) )
    title( strcat('Spectrum','-',SG(i+1).sensor.name, '-', SG(i+1).sensor.bran ) )   

    
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
%     if strcmp(SG(i).type,'Disp') == 1;        
%         SG(i).disp = ( SG(i).data - SG(i).mean ) * SG(i).sens ;
%     elseif strcmp(SG(i).type,'Vel') == 1;
%         SG(i).velo = ( SG(i).data - SG(i).mean ) * SG(i).sens ;
%     elseif strcmp(SG(i).type,'Accel') == 1;
%         SG(i).acce =  SG(i).data - SG(i).mean;   
%     elseif strcmp(SG(i).type,'Piezo') == 1;
%         
%     end
% end
% % Get the RMS Average
% 
% 
% 
%  for i = 1:numProxis 
%     % calcula las fft de los proxis
%     fftdesproxis(:,i) = abs(fft(desproxis(:,i)));
%     % vector frecuencias
%     freqproxis(:,i) = ( 0:length(fftdesproxis(:,i))-1)' * res/length(fftdesproxis(:,i)) ;
%     end