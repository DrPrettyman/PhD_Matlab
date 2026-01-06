%% Plot the first PCA score of the six stations' time series and its ACF-1
clear all 
close all

%% select hurricane and window size for sliding ACF calculation
windowSize = 120;
[start_date, end_date, h_name] = select_hurricane('R');


%% Import the slp data from the HadISD set
time = (datenum(start_date):(1/24):datenum(end_date))';
%time = time(1:24:end);
slp_data = zeros(size(time,1), 6);

for i = 1:6
    % for each station add the slp data to the array
    station_no = i;
    [lat, lon, time, slp_data(:,i)] =...
        get_hadISD_data_interpolated(station_no, start_date, end_date);
    
    % resize the array, taking out columns corresponding
    % to stationswhere all slp is zero, i.e. there is no
    % data for the times specified. Also, exit this script
    % if this results in no slp data at all.
    slp_data = slp_data(:,(~all(slp_data==0)));
    if size(slp_data,1) == 0
        return
    end
    
end


%% Perform PCA and also calculate the sliding ACF value
[coeffp,scorep,latentp,tsquaredp,explainedp,mup] = pca(slp_data);
first_score = scorep(:,1);
lag = 1;
slidingACF = ACF_sliding(first_score, lag, windowSize, false);


%% Create the plot

figure
gap = 120;
t_plot = time(windowSize+1:end);

yyaxis left
plot(t_plot, first_score(windowSize+1:end))
ylabel('msl pressure')
ylim([min(first_score)-5 max(first_score)+5])

yyaxis right
plot(t_plot, slidingACF(windowSize+1:end))
ylabel('ACF-1 indicator')

title([h_name ': ' start_date ' - ' end_date])
xlim([time(windowSize) time(end)])
ax = gca;
ax.XTick = time(1:gap:end);
ax.XTickLabel = datestr(time(1:gap:end), 'dd-mmm');
ax.XTickLabelRotation = 90;
ax.Box = 'on';
ax.XGrid = 'on';



        