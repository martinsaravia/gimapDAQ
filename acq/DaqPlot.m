function DaqPlot(s, event, ofile, test_duration, table_format, legend_str, ax)

    % Plot Data
    plt = plot(event.TimeStamps, event.Data);
    xlim( [0 test_duration])
    ax.ColorOrderIndex = 1; % Reset the color order index to default in order to replot with matching color scheme
    ax.XGrid = 'on';   
    ax.YGrid = 'on'; 
    legend(legend_str)
    hold on
    drawnow
    
    % Store data
    data = [event.TimeStamps, event.Data]' ;
   
    % Print data to file
    fprintf(ofile, table_format, data);
    
%     Output to a data array
%     X(count:count+buffy-1, :) = data';    
%     size(data)
%     size(X)  
%     count = count + buffy

end

