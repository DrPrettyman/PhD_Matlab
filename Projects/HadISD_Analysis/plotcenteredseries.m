% plotcenteredseries

%station_no = 26;

if ~exist('H','var')
    % use only the stronger storms: A, F, S, N and K.
    H = centeredseries([1:9]); 
%elseif H(1).station_no ~= station_no
%    clear H
%    H = centeredseries(station_no);
end

%% set up the line colours and x axis needed for the plots
%line_colours = rand(size(H,2),3);
line_colours = [[0,0,1];[1,0,1];[0,1,1];[0,1,0];[0,0,0];[1,0.5,0.2]];
xaxis = (1:size(H(1).slp_data,1))'-(floor((size(H(1).slp_data,1)+240)/2)+1);

% plot the slp data
ax1 = subplot(1,2,1);
hold on
for i = 1:size(H,2)
%for i = 4:7
    col = line_colours(1+mod(i,6),:);
    plot(ax1, xaxis(241:end-140), H(i).slp_data(241:end-140), 'color', col);
    disp(['plotted slp ', H(i).h_name])
    LegendInfo{i} = [H(i).h_name, ':  ', H(i).event_date];
end
%legend(LegendInfo, 'Location', 'southoutside');

%title(ax1,['All the storms, as recorded at station ', num2str(station_no)])
title(ax1,'All the storms, centered about the event time');
ylabel(ax1, 'Sea Level Pressure');
clear LegendInfo

%return
% plot the ACF-1 indicators, 240 point window
windowSize = 240;
ax2 = subplot(1,2,2);
hold on
for i = 1:size(H,2)
%for i = 4:7
    % sacf = ACF_sliding(H(i).slp_data_RO12, 1, windowSize, false);
    sacf = ACF_sliding(H(i).slp_data, 1, windowSize, false);
    col = line_colours(1+mod(i,6),:);
    plot(ax2, xaxis(241:end-140), sacf(241:end-140), 'color', col);
    disp(['plotted ACF ', H(i).h_name])
    LegendInfo{i} = [H(i).h_name, ':  ', H(i).event_date];
end
legend(LegendInfo, 'Location', 'southwest');
ylabel(ax2, 'ACF-1 indicator');
xlabel(ax2, 'Time since event (hours)');
clear LegendInfo