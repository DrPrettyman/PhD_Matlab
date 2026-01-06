%% Here we plot a red noise series with exponent 0.85 
%  and the three exponents applied to this.

%% generate the noise
alpha = 1;
N = 1000;
noise = dsp.ColoredNoise(alpha, N, 1);
noise1 = noise();

%% 

% ACF
lags = (1:100)';
ACF_vals = zeros(size(lags));
for i = 1:size(lags,1)
    ACF_vals(i) = ACF(noise1,lags(i));
    if ACF_vals(i)<0.01
        ACF_vals(i)=0.01;
    end
end

loglags = log10(lags);
logACFvals = log10(ACF_vals);

window = lags>=10;
%window = 1:find(coefs==0.1,1);
%window = 1:10;

pfit = polyfit(loglags(window), logACFvals(window), 1);
v = polyval(pfit, logACFvals(window));
ACFS = -pfit(1);


%% plot

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,5,25,25];
fig1.Resize = 'off';
fontsize = 16;
linethickness = 2;
hold on

pos1 = [0.1 0.7 0.85 0.25];
ax1 = subplot('Position',pos1)
hold on
plot(ax1, noise1, 'LineWidth', linethickness , 'Color', 'k')
a = annotation('textbox',...
    pos1 + [0.05 0 0 0],...
    'String','a',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off');
%a.FontSize = fontsize;
set(gca,'FontSize',fontsize)


pos2 = [0.1 0.1 0.25 0.5];
ax2 = subplot('Position',pos2)
%ax2 = subplot(2,1,2)
hold on
plot(ax2, loglags, logACFvals)
v = polyval(pfit,[1,2]);
plot(ax2, [1,2],v,'LineWidth', 3.5, 'Color', 'r')
b = annotation('textbox',...
    pos2 + [0.05 0 0 0],...
    'String','b',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off');
set(gca,'FontSize',fontsize)

pos3 = [0.4 0.1 0.25 0.5];
ax3 = subplot('Position',pos3)
hold on
plot(ax3, [1,2],[1,2])
c = annotation('textbox',...
    pos3 + [0.05 0 0 0],...
    'String','c',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off');
set(gca,'FontSize',fontsize)

pos4 = [0.7 0.1 0.25 0.5];
ax4 = subplot('Position',pos4)
hold on
%plot(ax4)
d = annotation('textbox',...
    pos4 + [0.05 0 0 0],...
    'String','d',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off');
set(gca,'FontSize',fontsize)

set(gca,'FontSize',fontsize)


