

% create red noise 'z' and white noise 'eta'
N = 10^4;
z = zeros(N,1);
t = linspace(0,1,N)';
for i = 2:N
    z(i) = z(i-1) + randn();
end
z_scale = 10*z./std(z);
eta = randn(N,1);

% Calculate the lags for z
lag_vals = (1:120)';
lags_red = zeros(numel(lag_vals),1);
lags_eta = zeros(numel(lag_vals),1);
for i = 1:numel(lag_vals)
    lags_red(i) = ACF(z,lag_vals(i));
    lags_eta(i) = ACF(eta,lag_vals(i));
end

pfit_eta = polyfit(lag_vals, lags_eta, 1);
acf_value_eta = -pfit_eta(1);
v_eta = polyval(pfit_eta, lag_vals);

pfit_red = polyfit(lag_vals, lags_red, 1);
acf_value_red = -pfit_red(1);
v_red = polyval(pfit_red, lag_vals);

%% plot the figure

col_red = 0*[1,1,1];
col_eta = 0.5*[1,1,1];

fig1 = figure;
fig1.Units = 'centimeters';
w=44; h=14;
fig1.Position = [0,15,w,h];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 0.2;
hold on

plotw = (0.85*h)/w;
pos1 = [0.05 0.13 plotw 0.85];
pos2 = pos1 + [plotw+0.1 0 0 0];
pos3 = pos2 + [plotw+0.02 0 0 0];

ax1 = subplot('Position',pos1)
hold on
plot(ax1, t, eta,...
    'Color',col_eta,'LineWidth', linethickness)
plot(ax1, t, z,...
    'Color',col_red,'LineWidth', linethickness)

ylabel({'$z(t)$'},'Interpreter','latex')
xlabel({'$t$'},'Interpreter','latex')
% xlim([-(24*10),0]);
% ylim([1015.8, 1020.8]);
% xticks(-480:48:0)
% yticks(1016:1021)
legend('white noise', 'red noise')
ann = annotation('textbox',...
    pos1 + [0.02 0 0 0],...
    'String','a',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
%xticklabels([]);
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')

powerlimits = [0,0];
powerlimits(1) = min(min(lags_red),min(lags_eta));
powerlimits(2) = max(max(lags_red),max(lags_eta))+1;
ax2 = subplot('Position',pos2)
hold on
plot(ax2, log10(lag_vals), log10(lags_red),...
    'Color',col_red,'LineWidth', linethickness)
plot(ax2, log10(lag_vals), v_red,...
    'Color','r','LineWidth', 2, 'LineStyle', '--')
ylim(powerlimits);
ylabel({'spectral density: $\log S(f)$'},'Interpreter','latex')
xlabel({'$\log(f)$'},'Interpreter','latex')
% xticks([1/24 1/12 1/8 1/6 1/4 1/3 1/2])
% xticklabels([24 12 8 6 4 3 2]);
% xlim([1/120, 1/5]);
% yticklabels([]);
% ylim([0.88,0.98]);
ann = annotation('textbox',...
    pos2 + [0.03 -0.03 0 0],...
    'String','b',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')

ax3 = subplot('Position',pos3)
hold on
plot(ax3, log10(lag_vals), log10(lags_eta),...
    'Color',col_eta,'LineWidth', linethickness)
plot(ax3, log10(lag_vals), v_eta,...
    'Color','r','LineWidth', 2, 'LineStyle', '--')

ylim(powerlimits);

xlabel({'$\log(f)$'},'Interpreter','latex')
yticklabels([]);
ann = annotation('textbox',...
    pos3 + [0.03 -0.03 0 0],...
    'String','c',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')
