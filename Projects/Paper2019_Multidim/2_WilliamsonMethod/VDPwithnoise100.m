
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
all_realeigenvals = zeros(301, N);
all_imageigenvals = zeros(301, N);
all_xvalues = zeros(401, N);
for trial = 1:N
    [tout_system,xout_system] = VDPwithnoise_fun(0,T_end, [0;0] ,epsilon, 0.01);
    tout = tout_system(1:100:end);
    xout = xout_system(1:100:end,:);
    
    all_xvalues(:,trial) = xout(:,1);
    
    sliding_eigenvals = plot_eigenvals_Jacobian(xout, T_end, windowsize, delT, false);
    all_realeigenvals(:,trial) = sliding_eigenvals(:,2);
    all_imageigenvals(:,trial) = sliding_eigenvals(:,3);
    disp(num2str(trial))
end

%% Calculate mean and std of N trials 
%  for system output, real part evals, and imag part evals

mean_x = mean(all_xvalues(101:end,:),2);
std_x = std(all_xvalues(101:end,:)');
std_x = std_x';

mean_real = mean(all_realeigenvals,2);
std_real = std(all_realeigenvals');
std_real = std_real';

mean_imag = mean(all_imageigenvals,2);
std_imag = std(all_imageigenvals');
std_imag = std_imag';


%% plot result

time_axis = (100:1:400)'-380;
time_axis = epsilon(100:400)';


% Save these results so we can plot in Grace etc.
VDP40_system = [time_axis, mean_x, std_x];
VDP40_realparts = [time_axis, mean_real, std_real];
VDP40_imagparts = [time_axis, mean_imag, std_imag];
save('VDP40_system.dat', 'VDP40_system', '-ascii')
save('VDP40_realparts.dat', 'VDP40_realparts', '-ascii')
save('VDP40_imagparts.dat', 'VDP40_imagparts', '-ascii')

% plot in Matlab
figure
ax1 = subplot(3,1,2);
hold on
plot(ax1, time_axis, mean_real, 'Color', 'black', 'LineWidth', 2)
plot(ax1, time_axis, mean_real-std_real, 'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
plot(ax1, time_axis, mean_real+std_real, 'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
xlim([time_axis(1), time_axis(end)])
%title('real part')
hold off
ax2 = subplot(3,1,3);
hold on
plot(ax2, time_axis, mean_imag, 'Color', 'black', 'LineWidth', 2)
plot(ax2, time_axis, mean_imag-std_imag, 'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
plot(ax2, time_axis, mean_imag+std_imag, 'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
xlim([time_axis(1), time_axis(end)])
%title('imaginary part')
hold off
ax3 = subplot(3,1,1);
hold on
plot(ax3, time_axis, mean_x, 'Color', 'black', 'LineWidth', 1.5)
plot(ax3, time_axis, mean_x-std_x, 'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
plot(ax3, time_axis, mean_x+std_x, 'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
xlim([time_axis(1), time_axis(end)])
%title('series in x')
hold off
set(ax3, 'XTick',[]);
set(ax1, 'XTick',[]);
ax2.XLabel = '\mu';