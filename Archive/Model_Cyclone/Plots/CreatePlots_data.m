

%% Plot the cyclone ACF and PSE mean

load('cyclones100.mat')
indices = [1:8,12,13,14,16,17,19];
plot_data(cyclones100, 'Sea-level pressure anomaly', indices)

%% Plot the Branching model ACF and PSE mean

load('branching_basic.mat')
plot_data(branching, 'Sytem variable z', indices)

% event_index = cyclones100(1).event_index;
% for i = 1:20
%     
%     m = cyclones100(i).slp_data_RO12(event_index);
%     disp([num2str(m),' -- ',cyclones100(i).h_name])
% end