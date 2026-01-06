%%

N = 10^6;

White = randn(N,1);
Red = cumsum(White);

%%
Fs=1;
windowlimits = [-2.5, -0.5];


xdft_w = fft(White);
xdft_w = xdft_w(1:floor(N/2)+1);
psdx_w = (1/(Fs*N)) * abs(xdft_w).^2;
psdx_w(2:end-1) = 2*psdx_w(2:end-1);
freq_w = (0:Fs/N:Fs/2)';
[binnedLF_w, binnedLP_w] = ...
    logbin(log10(freq_w), log10(psdx_w), windowlimits, false);


xdft_r = fft(Red);
xdft_r = xdft_r(1:floor(N/2)+1);
psdx_r = (1/(Fs*N)) * abs(xdft_r).^2;
psdx_r(2:end-1) = 2*psdx_r(2:end-1);
freq_r = (0:Fs/N:Fs/2)';
[binnedLF_r, binnedLP_r] = ...
    logbin(log10(freq_r), log10(psdx_r), windowlimits, false);


%%
w_logf = log10(freq_w);
w_logp = log10(psdx_w);

b_logf = log10(freq_r);
b_logp = log10(psdx_r);

% %%
% figure
% hold on
% 
% window_for_plot = find(w_freq<=(0.316) & w_freq>=(0.0032));
% 
% plot( logf(window_for_plot), logp(window_for_plot))
% %plot( logf, logp)
% 
% xlabel( 'log (F)'); ylabel( 'log(S)');

%% plot

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,30,12];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 0.2;
hold on

pos1 = [0.1 0.18 0.42 0.80];
ax1 = subplot('Position',pos1);
hold on
plot(ax1, binnedLF_w, binnedLP_w,...
    'Color',0.5*[1,1,1],'LineWidth', linethickness)

%xticks([0 0.5 1 1.5 2])
xlabel({'$\log_{10}[f]$'},'Interpreter','latex')
yticks([-4,-2,0,2,4])
xlim([-2.4,-0.6])
ylim([-1.8,4.8])
ylabel({'$\log_{10}[S(f)]$'},'Interpreter','latex')
a = annotation('textbox',...
    pos1 + [0.03 0 0 0],...
    'String','a',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
%xlim([0,1]);
%ylim([-0.4,2]);
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')

pos2 = [0.57 0.18 0.42 0.80];
ax2 = subplot('Position',pos2);
%ax2 = subplot(2,1,2)
hold on
plot(ax2, binnedLF_r, binnedLP_r,...
    'Color',0.2*[1,1,1],'LineWidth', linethickness)

xlabel({'$\log_{10}[f]$'},'Interpreter','latex')
xlim([-2.4,-0.6])
ylim([-1.8,4.8])
yticks([-4,-2,0,2,4])
yticklabels([])
b = annotation('textbox',...
    pos2 + [0.03 0 0 0],...
    'String','b',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
%xlim([0,2]);
%ylim([-0.4,2]);


set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')
