%% Create and plot
%  X is a seris of length N which starts as red noise but gradually
%  more and more white noise is added, introducing a crossover in the
%  power spectrum.

N = 10^6; %length of series
windowsize = 0.01*N; %window size for the sliding PS indicator
% mu = @(t)(10*tanh((t-6))+10);
mu = @(t)(-10*tanh((t-6))+10);
% mu = @(t)(0);

T = linspace(0,10,N)';  %the $t$ axis
Mu = mu(T);             %the function $\mu$
% plot(T, Mu)

co_window = find(Mu>5/pi & Mu<50/pi); %window of time in which the crossover point is inside the measured frequencies for the PS indicator
i0 = co_window(1); i1 = co_window(end); 
co_window = find(Mu>(10^(3/2))/(2*pi));
iM = co_window(end);
clear co_window
% i0=1; i1=1;

%% Create the time series

X = RedPlusWhite(T,mu);     %The time series $X$, a combination of red and white noise 

%% PS indicator
%  calculate the PS indicator with a sliding window

%slidingPSE = PSE_sliding(X, windowsize, 0); 
slidingPSE = T;
%% Three examples

mu_vals = [Mu(i0);Mu(iM);Mu(i1)];

Z = struct;
for i = 1:3
    Z(i).mu = mu_vals(i);
    
    Z(i).X = cumsum(randn(N,1)) + Z(i).mu*randn(N,1);

    Z(i).psdx = abs(fft(Z(i).X)).^2/N;
    Z(i).f = linspace(0,1,N)';
    S_expected = (1/(4*pi^2))*(Z(i).f).^(-2) +...
        (Z(i).mu/(2*pi))*(Z(i).f).^(-1) + (Z(i).mu)^2;
    
    Z(i).logS = log10(S_expected);
    Z(i).logf = log10(Z(i).f);
    Z(i).logp = log10(Z(i).psdx);
   
    %windowlimits = [Z(i).logf(2) ,Z(i).logf(end)];
    windowlimits = [-3.5 , 0];
    [newLF, newLP] = logbin(Z(i).logf, Z(i).logp, windowlimits, false);
    Z(i).binnedlogf = newLF;
    Z(i).binnedlogp = newLP;
   
    
    clear windowlimits newLF newLP
    
    Z(i).window_for_fit = find(Z(i).f<=0.1 & Z(i).f>=0.01);
    Z(i).pfit = polyfit(Z(i).logf(Z(i).window_for_fit),...
        Z(i).logp(Z(i).window_for_fit), 1);
    Z(i).v = polyval(Z(i).pfit, Z(i).logf(Z(i).window_for_fit));
    Z(i).ps = -Z(i).pfit(1);
    
    Z(i).window_for_plot = find(Z(i).f<=(0.316) & Z(i).f>=(0.0032));
    
%     figure
%     hold on
%     plot( Z(i).logf(window_for_plot), Z(i).logp(window_for_plot),...
%         'LineWidth', 0.1, 'Color', 'b');
%     plot( Z(i).logf(window_for_plot), Z(i).logS(window_for_plot),...
%         'LineWidth', 3.5, 'Color', 'k');
%     plot( Z(i).logf(window_for_fit), Z(i).v,...
%         'LineWidth', 3.5, 'Color', 'r');
%     
%     xlabel( 'log (F)'); ylabel( 'log(S)');
%     %xlim([]);
%     %ylim([-2, 4]);
%     hold off
end




%% Plot

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,0,40,25];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 2;
hold on

pos1 = [0.1 0.71 0.82 0.25];
pos2 = pos1 - [0 0.25 0 0];
pos3 = pos2 - [0 0.29 0 0];

pos3_1 = [0.1 0.08 0.25 0.30];
pos3_2 = [0.385 0.08 0.25 0.30];
pos3_3 = [0.67 0.08 0.25 0.30];

% plot 1
ax1 = subplot('Position',pos1);
hold on

yyaxis(ax1,'left')
plot(ax1,T,X,...
    'Color','b','LineWidth', 0.1)
xlim([0,10]);
ylim([min(X)-1,max(X)+1]);
ylabel({'$z(t)$'},'Interpreter','latex')

yyaxis(ax1,'right')
plot(ax1,T, Mu,...
    'Color','r','LineWidth', linethickness)
plot(ax1,[T(i0); T(i0)],[0, Mu(i0)],'k--o',...
    'LineWidth', linethickness)
plot(ax1,[T(iM); T(iM)],[0, Mu(iM)],'k--o',...
    'LineWidth', linethickness)
plot(ax1,[T(i1); T(i1)],[0, Mu(i1)],'k--o',...
    'LineWidth', linethickness)
ylim([0,20]);
xlim([0,10]);
ylabel({'$\mu$'},'Interpreter','latex')

ann = annotation('textbox',...
    pos1 + [0.03 0 0 0],...
    'String','a',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','XAxisLocation','top',...
    'box','on','FontSize',fontsize, 'FontName', 'Times New Roman')


% plot 2

ax2 = subplot('Position',pos2);
hold on

plot(ax2, T(windowsize+1:end), slidingPSE(windowsize+1:end),...
    'Color','k','LineWidth', 0.1)
ymin = min(slidingPSE)-0.3;
ymax = max(slidingPSE)+0.3;
plot(ax2,[T(i0); T(i0)],[ymin, ymax],'k--o',...
    'LineWidth', linethickness)
plot(ax2,[T(iM); T(iM)],[ymin, ymax],'k--o',...
    'LineWidth', linethickness)
plot(ax2,[T(i1); T(i1)],[ymin, ymax],'k--o',...
    'LineWidth', linethickness)

xlabel({'$t$'},'Interpreter','latex')
ylabel({'PS indicator'},'Interpreter','latex')
xlim([0,10]);
ylim([ymin,ymax]);
%xticklabels([]);
ann = annotation('textbox',...
    pos2 + [0.03 0 0 0],...
    'String','b',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')


%% three periodograms

Z(1).pos = pos3_1; Z(2).pos = pos3_2; Z(3).pos = pos3_3;

Z(3).ymin = -0.9; Z(2).ymin = 0.1; Z(1).ymin = 1.1; 

for i = 1:3
    Z(i).ax = subplot('Position',Z(i).pos);
    hold on

    plot(Z(i).ax,...
        Z(i).binnedlogf,...
        Z(i).binnedlogp,...
        'LineWidth', 0.1, 'Color', 'b');
    plot(Z(i).ax,...
        Z(i).logf(Z(i).window_for_plot),...
        Z(i).logS(Z(i).window_for_plot),...
        'LineWidth', 3.5, 'Color', 'k');
    plot(Z(i).ax,...
        Z(i).logf(Z(i).window_for_fit), Z(i).v,...
        'LineWidth', 3.5, 'Color', 'r');

    xlabel({'$f$'},'Interpreter','latex');
    if i==1
        ylabel({'log$[S_z(f)]$'},'Interpreter','latex');
    else
        ylabel([]);
    end
    xlim([-2.5 -0.5]);
    ylim([Z(i).ymin, 4.2]);
    yticks([0 1 2 3 4]);
    xticks([-3 -2 -1 0]);
    xticklabels([0.001 0.01 0.1 1]);
    clabelstring = ['c' num2str(i)];
    mulabelstring = ['\mu = ' num2str(Z(i).mu,'%.2f')];
    pslabelstring = ['ps = ' num2str(Z(i).ps,'%.2f')];
    ann1 = annotation('textbox',...
        Z(i).pos + [0.03 0 0 0],...
        'String',clabelstring,...
        'FontSize', 30',...
        'LineStyle', 'none',...
        'FitBoxToText', 'off',...
        'FontName', 'Times New Roman');
    ann2 = annotation('textbox',...
        Z(i).pos + [0.13 0 0 0],...
        'String',mulabelstring,...
        'FontSize', 20',...
        'LineStyle', 'none',...
        'FitBoxToText', 'off',...
        'FontName', 'Times New Roman');
    ann3 = annotation('textbox',...
        Z(i).pos + [0.125 -0.03 0 0],...
        'String',pslabelstring,...
        'FontSize', 20',...
        'LineStyle', 'none',...
        'FitBoxToText', 'off',...
        'FontName', 'Times New Roman');
    set(gca,'YGrid','on','XGrid','on','box','on',...
        'FontSize',fontsize, 'FontName', 'Times New Roman')
end


% ax3_2 = subplot('Position',pos3_2);
% hold on
% 
% ylabel({'ACF1'},'Interpreter','latex')
% xlim([200,380]);
% ylim([0.43,0.57]);
% xticklabels([]);
% ann = annotation('textbox',...
%     pos3 + [0.03 0 0 0],...
%     'String','c',...
%     'FontSize', 30',...
%     'LineStyle', 'none',...
%     'FitBoxToText', 'off',...
%     'FontName', 'Times New Roman');
% set(gca,'YGrid','on','XGrid','on','box','on',...
%     'FontSize',fontsize, 'FontName', 'Times New Roman')
% 
% ax3_3 = subplot('Position',pos3_3);
% hold on
% 
% ylabel({'ACF1'},'Interpreter','latex')
% xlim([200,380]);
% ylim([0.43,0.57]);
% xticklabels([]);
% ann = annotation('textbox',...
%     pos3 + [0.03 0 0 0],...
%     'String','c',...
%     'FontSize', 30',...
%     'LineStyle', 'none',...
%     'FitBoxToText', 'off',...
%     'FontName', 'Times New Roman');
% set(gca,'YGrid','on','XGrid','on','box','on',...
%     'FontSize',fontsize, 'FontName', 'Times New Roman')

%% Plot the 
% ax1 = subplot(2,3,1:3);
% hold on
% yyaxis(ax1,'left')

% plot(ax1,T, Mu)
% plot(ax1,[T(i0); T(i0)],[0, Mu(i0)],'r--o')
% plot(ax1,[T(i1); T(i1)],[0, Mu(i1)],'r--o')

% yyaxis(ax1,'right')
% plot(ax1,T,X)
