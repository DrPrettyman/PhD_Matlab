%% Plot the slp over time for all stations, and the ACF
%%
clear all
close all


%% select hurricane and window size for sliding ACF calculation
windowSize = 480;
[start_date, end_date, h_name] = select_hurricane(6);
disp(['Hurricane ', h_name]);

%% Create the axes
ax1 = subplot(2,1,1);
hold on
ax2 = subplot(2,1,2);
hold on

%% For each station, import the data and plot slp and the sliding ACF-1
lag = 1;
for i = 1:6
    station_no = i;
    [lat, lon, time, slp] = ...
        get_hadISD_data_interpolated(station_no, start_date, end_date);
    %labeltext = ['station ' num2str(i)];
    %plot(ax1, time, slp, 'DisplayName', labeltext)
    if ~all(slp==0)
        slidingACF = ACF_sliding(slp, lag, windowSize, false);
        
        plot(ax1, time(windowSize+1:end), slp(windowSize+1:end))
        plot(ax2, time(windowSize+1:end), slidingACF(windowSize+1:end))
    end
end

%% add desirable properties to axes
%legend('Location','southwest')
gap = 120;
ax1.XTick = time((windowSize+1):gap:end);
ax2.XTick = time((windowSize+1):gap:end);
ax1.XTickLabel = datestr(time((windowSize+1):gap:end),'dd-mmm');
ax2.XTickLabel = [];
ax1.XTickLabelRotation = 90;
ax1.Box  = 'on';
ax1.XLim = [time(windowSize+1) time(end)];
ax2.XLim = [time(windowSize+1) time(end)];
ax1.XGrid = 'on';
ax2.XGrid = 'on';
ax1.YLabel.String = 'msl pressure';
ax2.YLabel.String = '5 day ACF indicator';
hold off
        