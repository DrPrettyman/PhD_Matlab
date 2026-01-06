
%% This script runs the Van der Pol system 
%  runs the Van der Pol system from the function "VDPwithnoise_fun", with a
%  changing epsilon and an initial position vector (0,0). 
%  The system is integrated N times and the 


%% Set the parameters 
T_end = 400;
N=10;
epsilon = @(t)(-0.38 + 0.001*t);
delT = 1;
windowsize = 100;

%% Run N trials
all_ACF1_EOF = zeros(401, N);
all_ACF1_altEOF = zeros(401, N);

indiv_ACF1_EOF = zeros( N,1);
indiv_ACF1_altEOF = zeros( N,1);

all_xvalues = zeros(401, N);
all_EOF = zeros(size(all_xvalues));
all_altEOF = zeros(size(all_xvalues));

for trial = 1:N
    [tout_system,xout_system] = VDPwithnoise_fun(0,T_end, [0;0] ,epsilon, 0.01);
    tout = tout_system(1:100:end);
    xout = xout_system(1:100:end,:);
    
    all_xvalues(:,trial) = xout(:,1);
    
    [T, W] = EOF1(xout);
    all_EOF(:,trial) = xout*W;
    indiv_ACF1_EOF(trial) = ACF(all_EOF(:,trial),1);
    
    all_altEOF(:,trial) = Alt_EOF(xout);
    indiv_ACF1_altEOF(trial) = ACF(all_altEOF(:,trial),1);
    
    all_ACF1_EOF(:,trial) = ACF_sliding(all_EOF(:,trial), 1, windowsize);
    all_ACF1_altEOF(:,trial) = ACF_sliding(all_altEOF(:,trial), 1, windowsize);
    
    
    disp(num2str(trial))
end

%% Calculate mean and std of N trials 
%  for system output, real part evals, and imag part evals

mean_x = mean(all_xvalues(101:end,:),2);
std_x = std(all_xvalues(101:end,:)');
std_x = std_x';

mean_EOF = mean(all_EOF(101:end,:),2);
std_EOF = std(all_EOF(101:end,:)');
std_EOF = std_EOF';

mean_altEOF = mean(all_altEOF(101:end,:),2);
std_altEOF = std(all_altEOF(101:end,:)');
std_altEOF = std_altEOF';

mean_ACF1_EOF = mean(all_ACF1_EOF(101:end,:),2);
std_ACF1_EOF = std(all_ACF1_EOF(101:end,:)');
std_ACF1_EOF = std_ACF1_EOF';

mean_ACF1_altEOF = mean(all_ACF1_altEOF(101:end,:),2);
std_ACF1_altEOF = std(all_ACF1_altEOF(101:end,:)');
std_ACF1_altEOF = std_ACF1_altEOF';


%% plot result

time_axis = (100:1:400)'-380;
time_axis = epsilon(100:400)';


% Save these results so we can plot in Grace etc.
VDP40_system = [time_axis, mean_x, std_x];
save('VDP40_system.dat', 'VDP40_system', '-ascii')

%%

% plot in Matlab
figure
ax1 = subplot(2,2,1);
hold on
plot(ax1, time_axis, mean_EOF, 'Color', 'black', 'LineWidth', 2)
plot(ax1, time_axis, mean_EOF-std_EOF, 'Color', 'blue', 'LineWidth', 0.5, 'LineStyle','--')
plot(ax1, time_axis, mean_EOF+std_EOF, 'Color', 'blue', 'LineWidth', 0.5, 'LineStyle','--')
xlim([time_axis(1), time_axis(end)])
%title('real part')
hold off
ax2 = subplot(2,2,2);
hold on
plot(ax2, time_axis, mean_altEOF, 'Color', 'black', 'LineWidth', 2)
plot(ax2, time_axis, mean_altEOF-std_altEOF, 'Color', 'green', 'LineWidth', 0.5, 'LineStyle','--')
plot(ax2, time_axis, mean_altEOF+std_altEOF, 'Color', 'green', 'LineWidth', 0.5, 'LineStyle','--')
xlim([time_axis(1), time_axis(end)])
%title('imaginary part')
hold off
ax3 = subplot(2,2,[3,4]);
hold on
plot(ax3, time_axis, mean_ACF1_EOF, 'Color', 'black', 'LineWidth', 2)
plot(ax3, time_axis, mean_ACF1_EOF-std_ACF1_EOF, 'Color', 'blue', 'LineWidth', 0.5, 'LineStyle','--')
plot(ax3, time_axis, mean_ACF1_EOF+std_ACF1_EOF, 'Color', 'blue', 'LineWidth', 0.5, 'LineStyle','--')
xlim([time_axis(1), time_axis(end)])
%title('series in x')
%hold off
%ax4 = subplot(2,2,4);
%hold on
plot(ax3, time_axis, mean_ACF1_altEOF, 'Color', 'black', 'LineWidth', 2)
plot(ax3, time_axis, mean_ACF1_altEOF-std_ACF1_altEOF, 'Color', 'green', 'LineWidth', 0.5, 'LineStyle','--')
plot(ax3, time_axis, mean_ACF1_altEOF+std_ACF1_altEOF, 'Color', 'green', 'LineWidth', 0.5, 'LineStyle','--')
xlim([time_axis(1), time_axis(end)])
hold off

