%% run plotcenteredseries.m first to load H and station_no into the workspace


plotMean = true;



%% set up the line colours and x axis needed for the plots
%line_colours = rand(size(H,2),3);
line_colours = [[0,0,1];[1,0,1];[0,1,1];[0,1,0];[0,0,0];[1,0.5,0.2]];
xaxis = (1:size(H(1).slp_data_RO12,1))'-(floor((size(H(1).slp_data,1)+240)/2)+1);


%% create the aggregated RO12 data

N = 12;

for i = 1:size(H,2)
    H(i).aggregate = zeros(size(H(i).slp_data_RO12));
    for j = N:size(H(i).slp_data_RO12, 1)
        H(i).aggregate(j) = sum( H(i).slp_data_RO12(j-N+1:j) );
    end
end



%% plot the slp data
ax1 = subplot(1,2,1);
hold on
for i = 1:size(H,2)
%for i = 4:7
    col = line_colours(1+mod(i,6),:);
    plot(ax1, xaxis(241:end-140), H(i).aggregate(241:end-140), 'color', col);
    disp(['plotted slp ', H(i).h_name])
    LegendInfo{i} = [H(i).h_name, ':  ', H(i).event_date];
end

if plotMean
    slp_array = [];
    for i = 1:size(H,2)
        slp_array = [slp_array, H(i).aggregate];
    end
    
    Mean_slp_data = mean(slp_array, 2);
   
    plot(ax1, xaxis(241:end-140), Mean_slp_data(241:end-140), 'LineWidth', 2 );
    clear slp_array
    LegendInfo{i+1} = 'Mean of all series';
    
end


%legend(LegendInfo, 'Location', 'southoutside');
%title(ax1,['All the storms, as recorded at station ', num2str(station_no), ' with 12-hoir oscilations removed from data'])
title(ax1,['All the storms'])
legend(LegendInfo, 'Location', 'southwest');
ylabel(ax1, 'de-seasonalised Sea Level Pressure');
xlim(ax1, [-200, 0]);
clear LegendInfo


%% Plot the ACF indicator
%return
% plot the ACF-1 indicators, 240 point window
ax2 = subplot(1,2,2);
hold on

WindowSize = 72;

for i = 1:size(H,2)
    %for i = 4:7
    col = line_colours(1+mod(i,6),:);
    H(i).sacf = ACF_sliding(H(i).aggregate, 1, WindowSize, false);
    plot(ax2, xaxis(241:end-140), H(i).sacf(241:end-140), 'color', col, 'LineWidth', 0.3);
    disp(['plotted acf ', H(i).h_name])
    LegendInfo{i} = [H(i).h_name, ':  ', H(i).event_date];
end


if plotMean
    acf_array = [];
    for i = 1:size(H,2)
        acf_array = [acf_array, H(i).sacf];
    end
    m = mean(acf_array, 2);
    plot(ax2, xaxis(241:end-140), m(241:end-140), 'LineWidth', 2.5 );
    
    x = xaxis;
    y = m;
    linelen = 24;
    windowSize = 12; 

    for i = 1:windowSize:(size(x,1) - linelen-windowSize)
        p = polyfit(x(i:i+linelen), y(i:i+linelen), 1);
        v = polyval(p, x(i:i+linelen) );
        
        plot(x(i:i+linelen), v, 'color', 'k','LineStyle', '-','LineWidth', 2)
    end
    
    clear m acf_array
    LegendInfo{i+1} = 'Mean of all series';
    
    
    sacf = ACF_sliding(Mean_slp_data, 1, 240, false);
    plot(ax2, xaxis(241:end-140), sacf(241:end-140), 'color', 'k','LineStyle', ':','LineWidth', 1.5 );
    
    
    x = xaxis;
    y = sacf;
    linelen = 24;
    windowSize = 12; 

    for i = 1:windowSize:(size(x,1) - linelen-windowSize)
        p = polyfit(x(i:i+linelen), y(i:i+linelen), 1);
        v = polyval(p, x(i:i+linelen) );
        
        plot(x(i:i+linelen), v, 'color', 'k','LineStyle', '-','LineWidth', 2)
    end
    
end

%legend(LegendInfo, 'Location', 'southwest');
ylabel(ax2, 'ACF-1 indicator');
xlabel(ax2, 'Time since event (hours)');
xlim(ax2, [-150, 0]);
ylim(ax2, [0.8 1]);
clear LegendInfo sacf
    
