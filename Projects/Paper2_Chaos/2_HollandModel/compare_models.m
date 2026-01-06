%% This script runs the holland model N times and plots the 
%  indicators.

%% Create N instances
% now we create 100 instances of the model and save them in a structure
N = 30;

Holland_Model_runs = struct;

figure
ax0 = subplot(3,1,1);
hold on
for i = 1:N
    %[t, z] = Holland_model();
    [time_out, pressure_out, d, cyclone_xy, site_xy] ...
        = Grid_Holland_model(2,2,1000,pi/2);
    
    t = time_out;
    z = pressure_out{1,1};
    
    Holland_Model_runs(i).time_axis = t;
    Holland_Model_runs(i).data = z;
    
    plot(ax0,t,z)
    disp(num2str(i))
end
xlim(ax0, [-120,0]);
hold off

%% Make a handy array of all the data
% It will be useful to save this to export to other software, such as Grace
All_instances = zeros(size(Holland_Model_runs(1).data, 1), N);
All_instances(:,1) = Holland_Model_runs(1).time_axis;
for i = 2:N+1
    All_instances(:,i) = Holland_Model_runs(i-1).data;
end

%% Add the ACF(1) and PSE (window 100)
% now we take the ACF(1) and PSE sliding indicators of each instance

windowSize = 50;
dataString = 'data';

FieldString = 'ACF100';
for i = 1:N
    Holland_Model_runs(i).ACF100 = ACF_sliding(...
        Holland_Model_runs(i).(dataString), 1, windowSize, false);
    
    Holland_Model_runs(i).PSE100 = PSE_sliding(...
        Holland_Model_runs(i).(dataString), windowSize, false);
end


%%  Error bar plots
% Now we calculate the mean and std of all the ACF(1) and PSE 
% indicators, to create a plot with error bars.

All_ACF = zeros(size(Holland_Model_runs(1).ACF100, 1), N);
All_PSE = zeros(size(Holland_Model_runs(1).PSE100, 1), N);

for i = 1:N
    All_ACF(:,i) = Holland_Model_runs(i).ACF100;
    All_PSE(:,i) = Holland_Model_runs(i).PSE100;
end

ACFmean = mean(All_ACF,2);
PSEmean = mean(All_PSE,2);

ACFstd = std(All_ACF,0,2);
PSEstd = std(All_PSE,0,2);

time_axis = Holland_Model_runs(1).time_axis;

ACF_errorbar_data = [time_axis, ACFmean, ACFstd];
PSE_errorbar_data = [time_axis, PSEmean, PSEstd];

ax1 = subplot(3,1,2);
hold on
plot(ax1, time_axis, ACFmean, 'LineWidth', 2, 'color', 'black')
plot(ax1, time_axis, ACFmean-ACFstd, 'LineWidth', 2, 'color', 'black', 'LineStyle', '--')
plot(ax1, time_axis, ACFmean+ACFstd, 'LineWidth', 2, 'color', 'black', 'LineStyle', '--')
xlim(ax1, [-120,0]);
title('ACF(1)');

ax2 = subplot(3,1,3);
hold on
plot(ax2, time_axis, PSEmean, 'LineWidth', 2, 'color', 'black')
plot(ax2, time_axis, PSEmean-PSEstd, 'LineWidth', 2, 'color', 'black', 'LineStyle', '--')
plot(ax2, time_axis, PSEmean+PSEstd, 'LineWidth', 2, 'color', 'black', 'LineStyle', '--')
xlim(ax2, [-120,0]);
title('PS')


% %% Add the DFA (window 100) - Warning, could take some time.
% % now we take the DFA sliding indicator of each instance,
% % the exact same procedure as the ACF(1) and PSE above.
% 
% windowSize = 100;
% dataString = 'data';
% dfa_endpoint = 600;
% 
% for i = 1:N
%     Holland_Model_runs(i).DFA100 = DFA_sliding(...
%         Holland_Model_runs(i).(dataString)(1:dfa_endpoint), 2, windowSize, false);
%     disp(['done', num2str(i)]);
% end
% All_DFA = zeros(size(Holland_Model_runs(1).DFA100, 1), N);
% for i=1:N
%     All_DFA(:,i) = Holland_Model_runs(i).DFA100;
% end
% 
% DFAmean = mean(All_DFA,2);
% DFAstd = std(All_DFA,0,2);
% time_axis_dfa = Holland_Model_runs(1).time_axis;
% time_axis_dfa = time_axis_dfa(windowSize:dfa_endpoint);
% DFA_errorbar_data = [time_axis_dfa, DFAmean, DFAstd];
% figure
% hold on
% plot(DFAmean, 'LineWidth', 2, 'color', 'black')
% plot(DFAmean-DFAstd, 'LineWidth', 2, 'color', 'black', 'LineStyle', '--')
% plot(DFAmean+DFAstd, 'LineWidth', 2, 'color', 'black', 'LineStyle', '--')
% 
% 
% %% Save the data for Grace
% % We now save the data we want, so we can make some nicer plots using 
% % other software (e.g. Grace).
% 
% save('fig3_100modelinstances.dat', 'All_instances', '-ascii');
% save('fig3_ACFindicator.dat', 'ACF_errorbar_data', '-ascii');
% save('fig3_PSEindicator.dat', 'PSE_errorbar_data', '-ascii');
% save('fig3_DFAindicator.dat', 'DFA_errorbar_data', '-ascii');