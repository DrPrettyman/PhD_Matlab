%% Calculate_pitchforkMuRelationship
%
% Calculates the PS and ACF1 single-value stats of time series from
% the supercritical pitchfork model with varying parameter mu
%

%% 
no_mus = 30;        % the number of different mu values to use
no_trials = 10;     % the number of trials for each mu value

%% Initialise
T = 1000;
delta_t = 0.01;
sample_f = 100;
initial_z = 0;
sigma = @(t)0.1;

mu_vals = linspace(-1,0.5,no_mus)';
ps_vals = zeros(no_mus,1);
acf1_vals = zeros(no_mus,1);

%% Calculate
for i = 1:no_mus
    mu = mu_vals(i);
    cp = @(t)@(z)(z^4-mu*z^2);
    ps_temp = zeros(no_trials,1);
    acf1_temp = zeros(no_trials,1);
    for k = 1:no_trials
        [t, z] = time_series_cp(T,delta_t,cp,initial_z,sigma);
        %tp = t(1:sample_f:end);
        zp = z(1:sample_f:end);
        ps_temp(k)   = PSE_noBinning(zp);
        acf1_temp(k) = ACF(zp,1);
    end
    ps_vals(i)   = mean(ps_temp);
    acf1_vals(i) = mean(acf1_temp);
    disp([num2str(i),'/',num2str(no_mus)])
end


%% Nice plot
fig1 = figure; fig1.Units = 'centimeters'; fig1.Resize = 'off';
fig1.Position = [0,0,30,15];
fontsize = 18;
hold on
pos1 = [0.07 0.15 0.40 0.80];
pos2 = pos1 + [0.52 0 0 0];
xlimits = [mu_vals(1),mu_vals(end)];

ax1 = subplot('Position',pos1);
hold on
ylimits = [-0.2,2];
plot(ax1,mu_vals, ps_vals, 'Color', 'k', 'LineWidth',2,...
    'LineStyle','none','Marker','o','MarkerSize',5)
plot([0,0],ylimits, 'LineStyle','--','LineWidth',2,'Color',0.7*[1 1 1])
ylim(ylimits)
xlim(xlimits)
xlabel('pitchfork model parameter \mu')
ylabel('PS exponent \beta')
ann1 = annotation('textbox',...
    pos1 + [0.02 0 0 -0],...
    'String','a',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
% annotation_string = '(PS method)';
% ann2 = annotation('textbox',...
%     pos1 + [0.05 0 0 0],...
%     'String',annotation_string,...
%     'FontSize', 20',...
%     'LineStyle', 'none',...
%     'FitBoxToText', 'off',...
%     'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','XAxisLocation','bottom',...
    'box','on','FontSize',fontsize, 'FontName', 'Times New Roman')

ax2 = subplot('Position',pos2);
hold on
ylimits = [-0.1,1];
plot(ax2,mu_vals, acf1_vals, 'Color', 'k', 'LineWidth',2,...
    'LineStyle','none','Marker','o','MarkerSize',5)
plot([0,0],ylimits, 'LineStyle','--','LineWidth',2,'Color',0.7*[1 1 1])
ylim(ylimits)
xlim(xlimits)
xlabel('pitchfork model parameter \mu')
ylabel('lag-1 ACF')
ann1 = annotation('textbox',...
    pos2 + [0.02 0 0 0],...
    'String','b',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
% annotation_string = '(ACF1 method)';
% ann2 = annotation('textbox',...
%     pos2 + [0.05 0 0 0],...
%     'String',annotation_string,...
%     'FontSize', 20',...
%     'LineStyle', 'none',...
%     'FitBoxToText', 'off',...
%     'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','XAxisLocation','bottom',...
    'box','on','FontSize',fontsize, 'FontName', 'Times New Roman')

clear ann1 ann2 pos1 pos2 ax1 ax2 annotation_string
clear fontsize ylimits xlimits 