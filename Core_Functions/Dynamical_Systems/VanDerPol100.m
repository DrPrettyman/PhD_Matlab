
T_start = 0;
T_end = 400;
N=10;
delT = 1;
windowsize = 100;

all_realeigenvals = zeros(401-windowsize, N);
all_imageigenvals = zeros(401-windowsize, N);
all_EOF_ACF1_series = zeros(401-windowsize, N);
all_EOF_DFA_series = zeros(401-windowsize, N);
all_EOF_PS_series = zeros(401-windowsize, N);
for trial = 1:N
    % start with x near the center
    x_0 = 0.001*randn(2,1);
    
    % Integrate the system in 
    [tout_system,xout_system] = VDPwithnoise_fun(T_start ,T_end, x_0,...
        @(t)(-0.38 + 0.001*t), 0.01);
    tout = tout_system(1:100:end);
    xout = xout_system(1:100:end,:);

    % Apply the Williamson technique
    sliding_eigenvals = plot_eigenvals_Jacobian(xout, T_end, windowsize, delT, false);
    all_realeigenvals(:,trial) = sliding_eigenvals(:,2);
    all_imageigenvals(:,trial) = sliding_eigenvals(:,3);
    
    % Apply the EOF method to the data and then the ACF1 and DFA
    % indicators
    [EOF1score, eigenvector] = EOF1(xout, true);
    
    ACF_series = ACF_sliding(EOF1score,1,windowsize);
    ACF_series = ACF_series(windowsize+1:end);
    all_EOF_ACF1_series(:,trial) = ACF_series;
    
    DFA_series = DFA_sliding(EOF1score,2,windowsize);
    DFA_series = DFA_series(2:end);
    all_EOF_DFA_series(:,trial) = DFA_series;
    
    PS_series = PSE_sliding(EOF1score,windowsize);
    PS_series = PS_series(windowsize+1:end);
    all_EOF_PS_series(:,trial) = PS_series;
    
    disp(num2str(trial))
end

%%

mean_real = mean(all_realeigenvals,2);
mean_imag = mean(all_imageigenvals,2);

std_real = std(all_realeigenvals');
std_imag = std(all_imageigenvals');
std_real = std_real';
std_imag = std_imag';

mean_ACF1 = mean(all_EOF_ACF1_series,2);
std_ACF1 = std(all_EOF_ACF1_series');
std_ACF1 = std_ACF1';

mean_DFA = mean(all_EOF_DFA_series,2);
std_DFA = std(all_EOF_DFA_series');
std_DFA = std_DFA';

mean_PS = mean(all_EOF_PS_series,2);
std_PS = std(all_EOF_PS_series');
std_PS = std_PS';

%% plot result
time_axis = (100:1:T_end)';
figure
title('Homoclinic-bifurcation, Williamson method')
ax1 = subplot(2,1,1);
hold on
plot(ax1, time_axis, mean_real, 'Color', 'black', 'LineWidth', 2)
plot(ax1, time_axis, mean_real-std_real, 'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
plot(ax1, time_axis, mean_real+std_real, 'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
title('real part')
hold off
ax2 = subplot(2,1,2);
hold on
plot(ax2, time_axis, mean_imag, 'Color', 'black', 'LineWidth', 2)
plot(ax2, time_axis, mean_imag-std_imag, 'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
plot(ax2, time_axis, mean_imag+std_imag, 'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
title('imaginary part')
hold off

figure
title('Homoclinic-bifurcation, EOF + ACF1')
hold on
plot(time_axis, mean_ACF1,'Color', 'black', 'LineWidth', 2)
plot(time_axis, mean_ACF1-std_ACF1,'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
plot(time_axis, mean_ACF1+std_ACF1,'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')

figure
title('Homoclinic-bifurcation, EOF + DFA')
hold on
plot(time_axis, mean_DFA,'Color', 'black', 'LineWidth', 2)
plot(time_axis, mean_DFA-std_DFA,'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
plot(time_axis, mean_DFA+std_DFA,'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')

figure
title('Homoclinic-bifurcation, EOF + PS')
hold on
plot(time_axis, mean_PS,'Color', 'black', 'LineWidth', 2)
plot(time_axis, mean_PS-std_PS,'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
plot(time_axis, mean_PS+std_PS,'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')


%% organise in a structure

vdpData = struct;

vdpData.notes = ['Van der Pol Hopf bifurcation example'];

vdpData.time = time_axis;
vdpData.N = N;
vdpData.delT = delT;
vdpData.windowsize = windowsize;

vdpData.mean_ACF1 = mean_ACF1;
vdpData.mean_DFA = mean_DFA;
vdpData.mean_PS = mean_PS;
vdpData.mean_real = mean_real;
vdpData.mean_imag = mean_imag;

vdpData.std_ACF1 = std_ACF1;
vdpData.std_DFA = std_DFA;
vdpData.std_PS = std_PS;
vdpData.std_real = std_real;
vdpData.std_imag = std_imag;
