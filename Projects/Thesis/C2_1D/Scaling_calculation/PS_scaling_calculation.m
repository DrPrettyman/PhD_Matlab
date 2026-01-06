

% create red noise 'z' and white noise 'eta'
N = 10^5;
z = zeros(N,1);
t = linspace(0,1,N)';
for i = 2:N
    z(i) = z(i-1) + randn();
end
z = 10*z./std(z);
eta = randn(N,1);

% calculate power spectrum for 'z'
Fs=1;
windowlimits = [-2, -1];

xdft = fft(z);
xdft = xdft(1:floor(N/2)+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = (0:Fs/N:Fs/2)';
logf = log10(freq);
logp = log10(psdx);
[binnedLF, binnedLP] = logbin(logf, logp, windowlimits, false);
goodones = ~(isnan(binnedLF)+isnan(binnedLP));
binnedLF_red = binnedLF(goodones);
binnedLP_red = binnedLP(goodones);
pfit_red = polyfit(binnedLF_red, binnedLP_red, 1);
pse_value_red = -pfit_red(1);
v_red = polyval(pfit_red, binnedLF_red);
binnedLP_red = binnedLP_red - v_red(1); v_red = v_red - v_red(1);

% calculate power spectrum for 'eta'
xdft = fft(eta);
xdft = xdft(1:floor(N/2)+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = (0:Fs/N:Fs/2)';
logf = log10(freq);
logp = log10(psdx);
[binnedLF, binnedLP] = logbin(logf, logp, windowlimits, false);
goodones = ~(isnan(binnedLF)+isnan(binnedLP));
binnedLF_eta = binnedLF(goodones);
binnedLP_eta = binnedLP(goodones);
pfit_eta = polyfit(binnedLF_eta, binnedLP_eta, 1);
pse_value_eta = -pfit_eta(1);
v_eta = polyval(pfit_eta, binnedLF_eta);


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
powerlimits(1) = min(min(binnedLP_red),min(binnedLP_eta));
powerlimits(2) = max(max(binnedLP_red),max(binnedLP_eta))+1;
ax2 = subplot('Position',pos2)
hold on
plot(ax2, binnedLF_red, binnedLP_red,...
    'Color',col_red,'LineWidth', linethickness)
plot(ax2, binnedLF_red, v_red,...
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
plot(ax3, binnedLF_eta, binnedLP_eta,...
    'Color',col_eta,'LineWidth', linethickness)
plot(ax3, binnedLF_eta, v_eta,...
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
