

N = 200;
mu_vals = linspace(0,1,N);
sizeAR = 10^5;
sigma = 1;

p = @(mu)(log10(...
    (1+mu^2-2*mu*cos(0.2*pi))/(1+mu^2-2*mu*cos(0.02*pi))...
    ));

PS_analytic     = zeros(N,1);
PS_experimental = zeros(N,1);

ACF1_analytic     = mu_vals;
ACF1_experimental = zeros(N,1);

for i = 1:N
    mu = mu_vals(i);
    PS_analytic(i)     = p(mu);
    
    AR = zeros(sizeAR,1);
    for k = 2:sizeAR
        AR(k) = mu*AR(k-1)+sigma*randn();
    end
    PS_experimental(i)   = PSE_new(AR);
    ACF1_experimental(i) = ACF(AR,1);
end

%%
figure 
hold on
plot(mu_vals,PS_analytic, 'k')
xlabel('AR(1) model parameter \mu')
ylabel('Power spectrum exponent \beta')
xlim([0,1])
ylim([-0.3,2.3])

figure 
hold on
plot(ACF1_experimental,PS_experimental, 'ro')
xlabel('ACF1(X)')
ylabel('PS(X)')
xlim([0,1])
ylim([-0.3,2.3])

%%

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,0,40,15];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 2;
hold on

pos1 = [0.05 0.12 0.42 0.85];
pos2 = pos1 + [0.52 0 0 0];
ylimits = [-0.3,2.3];
xlimits = [0,1];

ax1 = subplot('Position',pos1);
hold on
plot(ax1, mu_vals, PS_analytic, 'LineWidth', 2, 'Color', 'k');
ylim(ylimits)
xlim(xlimits)
xlabel('AR(1) model parameter \mu')
ylabel('Power spectrum exponent \beta')
ann = annotation('textbox',...
    pos1 + [0.02 0 0 0],...
    'String','a',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','XAxisLocation','bottom',...
    'box','on','FontSize',fontsize, 'FontName', 'Times New Roman')

ax2 = subplot('Position',pos2);
hold on
plot(ax2, ACF1_experimental,PS_experimental,...
    'LineWidth', 1, 'Marker','o','LineStyle','none', 'Color', 'k');
ylim(ylimits)
xlim(xlimits)
xlabel('ACF1(X)')
ylabel('PS(X)')
ann = annotation('textbox',...
    pos2 + [0.02 0 0 0],...
    'String','b',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','YAxisLocation','left',...
    'box','on','FontSize',fontsize, 'FontName', 'Times New Roman')




