
T_end = 100;
N=10;
delT = 0.5;
windowsize = 100;

%%
all_EOF_DFA_series = zeros(201-windowsize, N);
all_altEOF_DFA_series = zeros(201-windowsize, N);

all_EOF_ACF1_series = zeros(201-windowsize, N);
all_altEOF_ACF1_series = zeros(201-windowsize, N);

EOF_eigenvectors = zeros(2,N);
altEOF_eigenvectors = zeros(2,N);

for trial = 1:N
    % start with x near the center
    x_0 = [sqrt(0.2);0.1]; %+0.05*randn(2,1);
    
    % Integrate the system in hopf_fun.m with mu a function
    %  of t which increses from -2.8 to 0.2 as t goes from 0 to 6.
    %  Standard deviation of the noise is 0.01
    [tout, xout]=homoclinic_fun(0,T_end,x_0,@(t)(0.2-0.002*t),0.01);
    tout = tout(1:50:end,:);
    xout = xout(1:50:end,:);
   
    
    % Apply the EOF method to the data and then the ACF1 and DFA
    % indicators
    [EOF1score, eigenvector] = EOF1(xout, true);
    [altEOFscore, altEOF_vector] = Alt_EOF(xout, true);
    
    DFA_series = DFA_sliding(EOF1score,2,windowsize);
    DFA_series = DFA_series(2:end);
    all_EOF_DFA_series(:,trial) = DFA_series;
    
    DFA_series = DFA_sliding(altEOFscore,2,windowsize);
    DFA_series = DFA_series(2:end);
    all_altEOF_DFA_series(:,trial) = DFA_series;
    
    ACF1_series = ACF_sliding(EOF1score,1,windowsize);
    all_EOF_ACF1_series(:,trial) =...
        ACF1_series(windowsize+1:end);
    
    ACF1_series = ACF_sliding(altEOFscore,1,windowsize);
    all_altEOF_ACF1_series(:,trial) =...
        ACF1_series(windowsize+1:end);
    
    EOF_eigenvectors(:,trial) = eigenvector;
    altEOF_eigenvectors(:,trial) = altEOF_vector;
    
    disp(num2str(trial))
end

%%

mean_DFA_reg = mean(all_EOF_DFA_series,2);
std_DFA_reg = std(all_EOF_DFA_series');
std_DFA_reg = std_DFA_reg';

mean_DFA_alt = mean(all_altEOF_DFA_series,2);
std_DFA_alt = std(all_altEOF_DFA_series');
std_DFA_alt = std_DFA_alt';

mean_ACF1_reg = mean(all_EOF_ACF1_series,2);
std_ACF1_reg = std(all_EOF_ACF1_series');
std_ACF1_reg = std_ACF1_reg';

mean_ACF1_alt = mean(all_altEOF_ACF1_series,2);
std_ACF1_alt = std(all_altEOF_ACF1_series');
std_ACF1_alt = std_ACF1_alt';

%% plot DFA result
time_axis = (50:0.5:T_end)';
figure
title('Homoclinic-bifurcation, DFA indicator')
ax1 = subplot(2,1,1);
hold on
plot(ax1, time_axis, mean_DFA_reg, 'Color', 'black', 'LineWidth', 2)
plot(ax1, time_axis, mean_DFA_reg-std_DFA_reg, 'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
plot(ax1, time_axis, mean_DFA_reg+std_DFA_reg, 'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
title('regular EOF')
hold off
ax2 = subplot(2,1,2);
hold on
plot(ax2, time_axis, mean_DFA_alt, 'Color', 'black', 'LineWidth', 2)
plot(ax2, time_axis, mean_DFA_alt-std_DFA_alt, 'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
plot(ax2, time_axis, mean_DFA_alt+std_DFA_alt, 'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
title('alternative EOF')
hold off

%% plot ACF1 result
time_axis = (50:0.5:T_end)';
figure
title('Homoclinic-bifurcation, ACF1 indicator')
ax1 = subplot(2,1,1);
hold on
plot(ax1, time_axis, mean_ACF1_reg, 'Color', 'black', 'LineWidth', 2)
plot(ax1, time_axis, mean_ACF1_reg-std_ACF1_reg, 'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
plot(ax1, time_axis, mean_ACF1_reg+std_ACF1_reg, 'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
title('regular EOF')
hold off
ax2 = subplot(2,1,2);
hold on
plot(ax2, time_axis, mean_ACF1_alt, 'Color', 'black', 'LineWidth', 2)
plot(ax2, time_axis, mean_ACF1_alt-std_ACF1_alt, 'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
plot(ax2, time_axis, mean_ACF1_alt+std_ACF1_alt, 'Color', 'black', 'LineWidth', 1.5, 'LineStyle','--')
title('alternative EOF')
hold off

%% Plot the vectors

figure
hold on
for i = 1:N
    u = -EOF_eigenvectors(:,i);
    v = -altEOF_eigenvectors(:,i);
    
    plot([0, u(1)], [0, u(2)], 'color','b');
    plot([0, v(1)], [0, v(2)], 'color','r');
end
xlim([-1,1])
ylim([-1,1])
title('Eigenvectors: blue, regular; red, alternative')


%% Organise in a structure

AlternativeEOFData = struct;

AlternativeEOFData.notes = ['Homoclinic bifurcation example, mu = @(t)(0.2-0.002*t), x_0 = [sqrt(0.2);0.1]'];

AlternativeEOFData.time = time_axis;
AlternativeEOFData.N = N;
AlternativeEOFData.delT = delT;
AlternativeEOFData.windowsize = windowsize;

AlternativeEOFData.vectors_reg = EOF_eigenvectors;
AlternativeEOFData.vectors_alt = altEOF_eigenvectors;

AlternativeEOFData.mean_DFA_reg = mean_DFA_reg;
AlternativeEOFData.mean_DFA_alt = mean_DFA_alt;

AlternativeEOFData.std_DFA_reg = std_DFA_reg;
AlternativeEOFData.std_DFA_alt = std_DFA_alt;

AlternativeEOFData.mean_ACF1_reg = mean_ACF1_reg;
AlternativeEOFData.mean_ACF1_alt = mean_ACF1_alt;

AlternativeEOFData.std_ACF1_reg = std_ACF1_reg;
AlternativeEOFData.std_ACF1_alt = std_ACF1_alt;