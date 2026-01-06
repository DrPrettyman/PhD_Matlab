%% This script completely recreates Fig3.

%% Define parameters
% First we define the parameters of the model 
% and make one time series as a test

T = 1000;
delta_t = 0.05;
cp = @(t)@(z)z^4/4 - z^2/2 - (0.003*t-2)*z;
initial_z = 0;
sigma = @(t)0.2;
F = @(t)0;

[t, z] = time_series_cp(T, delta_t, cp, initial_z, sigma);
z = z(1:20:end);
t = t(1:20:end);
%figure
%plot(t,z)

%% Create N instances
% now we create 100 instances of the model and save them in a structure
N = 50;

Pitchfork = struct;

figure
hold on
for i = 1:N
    [t, z] = time_series_cp(T, delta_t, cp, initial_z, sigma);
    z = z(1:20:end);
    t = t(1:20:end);
    
    Pitchfork(i).time_axis = t;
    Pitchfork(i).data = z;
    
    plot(t,z)
    disp(num2str(i))
end

%% Make a handy array of all the data
% It will be useful to save this to export to other software, such as Grace
All_instances = zeros(size(Pitchfork(1).data, 1), N);
All_instances(:,1) = Pitchfork(1).time_axis;
for i = 2:N+1
    All_instances(:,i) = Pitchfork(i-1).data;
end

% %% Now we plot all of them
% figure
% hold on
% for i = 2:N+1
%     plot(All_instances(:,i))
% end
% hold off

%% Add the ACF(1) and PSE (window 100)
% now we take the ACF(1) and PSE sliding indicators of each instance

windowSize = 100;
dataString = 'data';

FieldString = 'ACF100';
for i = 1:N
    Pitchfork(i).ACF100 = ACF_sliding(...
        Pitchfork(i).(dataString), 1, windowSize, false);
    
    Pitchfork(i).PSE100 = PSE_sliding(...
        Pitchfork(i).(dataString), windowSize, false);
end


%%  Error bar plots
% Now we calculate the mean and std of all the ACF(1) and PSE 
% indicators, to create a plot with error bars.

All_ACF = zeros(size(Pitchfork(1).ACF100, 1), N);
All_PSE = zeros(size(Pitchfork(1).PSE100, 1), N);

for i = 1:N
    All_ACF(:,i) = Pitchfork(i).ACF100;
    All_PSE(:,i) = Pitchfork(i).PSE100;
end

ACFmean = mean(All_ACF,2);
PSEmean = mean(All_PSE,2);

ACFstd = std(All_ACF,0,2);
PSEstd = std(All_PSE,0,2);

time_axis = Pitchfork(1).time_axis;

ACF_errorbar_data = [time_axis, ACFmean, ACFstd];
PSE_errorbar_data = [time_axis, PSEmean, PSEstd];

figure
ax1 = subplot(2,1,1);
hold on
plot(ax1, time_axis, ACFmean, 'LineWidth', 2, 'color', 'black')
plot(ax1, time_axis, ACFmean-ACFstd, 'LineWidth', 2, 'color', 'black', 'LineStyle', '--')
plot(ax1, time_axis, ACFmean+ACFstd, 'LineWidth', 2, 'color', 'black', 'LineStyle', '--')
xlim(ax1, [200 800]);
title('ACF(1)');

ax2 = subplot(2,1,2);
hold on
plot(ax2, time_axis, PSEmean, 'LineWidth', 2, 'color', 'black')
plot(ax2, time_axis, PSEmean-PSEstd, 'LineWidth', 2, 'color', 'black', 'LineStyle', '--')
plot(ax2, time_axis, PSEmean+PSEstd, 'LineWidth', 2, 'color', 'black', 'LineStyle', '--')
xlim(ax2, [200 800]);
title('PS')


%% Add the DFA (window 100) - Warning, could take some time.
% now we take the DFA sliding indicator of each instance,
% the exact same procedure as the ACF(1) and PSE above.

windowSize = 100;
dataString = 'data';
dfa_endpoint = 800;

for i = 1:N
    Pitchfork(i).DFA100 = DFA_sliding(...
        Pitchfork(i).(dataString)(1:dfa_endpoint), 2, windowSize, false);
    disp(['done', num2str(i)]);
end
All_DFA = zeros(size(Pitchfork(1).DFA100, 1), N);
for i=1:N
    All_DFA(:,i) = Pitchfork(i).DFA100;
end

DFAmean = mean(All_DFA,2);
DFAstd = std(All_DFA,0,2);
time_axis_dfa = Pitchfork(1).time_axis;
time_axis_dfa = time_axis_dfa(windowSize:dfa_endpoint);
DFA_errorbar_data = [time_axis_dfa, DFAmean, DFAstd];
figure
hold on
plot(DFAmean, 'LineWidth', 2, 'color', 'black')
plot(DFAmean-DFAstd, 'LineWidth', 2, 'color', 'black', 'LineStyle', '--')
plot(DFAmean+DFAstd, 'LineWidth', 2, 'color', 'black', 'LineStyle', '--')

% 
%% Save the data for Grace
% We now save the data we want, so we can make some nicer plots using 
% other software (e.g. Grace).

save('saddle_fig3_100modelinstances.dat', 'All_instances', '-ascii');
save('saddle_fig3_ACFindicator.dat', 'ACF_errorbar_data', '-ascii');
save('saddle_fig3_PSEindicator.dat', 'PSE_errorbar_data', '-ascii');
save('saddle_fig3_DFAindicator.dat', 'DFA_errorbar_data', '-ascii');