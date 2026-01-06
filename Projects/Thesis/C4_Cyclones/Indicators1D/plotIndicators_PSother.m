
%% Load Data

%load('indicators1D')


varNo = 1; % 1=slp, 2=windspeed, 3=eof
tAxis = (-300:0)';
xlimit = [-200,0];
ticks24 = (-240:24:0)';

PSylimit = [-2.49, 2.49];

%% Plot

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,25,28];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 1.5;
meanthickness = 3.5;
hold on

pos1 = [0.1 0.76 0.87 0.20];
pos2 = pos1 - [0 0.20 0 0];
pos3 = pos2 - [0 0.20 0 0];
pos4 = pos3 - [0 0.20 0 0];


ax1 = subplot('Position',pos1);
hold on
errorbar(ax1, tAxis, indicators1D(varNo).PS54_mean,...
    indicators1D(varNo).PS54_std,...
    'Color','k','LineWidth', linethickness)
plot(ax1, tAxis, indicators1D(varNo).PS54_mean,...
    'Color','k','LineWidth', meanthickness)

ylabel('PS54')
ylim(PSylimit);
xlim([xlimit]);
xticks(ticks24);
ann = annotation('textbox',...
    pos1 + [0.03 0 0 0],...
    'String','a',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','XAxisLocation','top',...
    'box','on','FontSize',fontsize, 'FontName', 'Times New Roman')




ax2 = subplot('Position',pos2);
hold on
errorbar(ax2, tAxis, indicators1D(varNo).PS90_mean,...
    indicators1D(varNo).PS90_std,...
    'Color','k','LineWidth', linethickness)
plot(ax2, tAxis, indicators1D(varNo).PS90_mean,...
    'Color','k','LineWidth', meanthickness)

ylabel('PS90')
xlim([xlimit]);

ylim(PSylimit);
xticks(ticks24);
xticklabels([]);
ann = annotation('textbox',...
    pos2 + [0.03 0 0 0],...
    'String','b',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')






ax3 = subplot('Position',pos3);
hold on
errorbar(ax3, tAxis, indicators1D(varNo).PS_mean,...
    indicators1D(varNo).PS_std,...
    'Color','k','LineWidth', linethickness)
plot(ax3, tAxis, indicators1D(varNo).PS_mean,...
    'Color','k','LineWidth', meanthickness)

ylabel('PS102')
xlim([xlimit]);
%ylim([1.3,1.9]);
ylim(PSylimit);
xticks(ticks24);
xticklabels([]);
ann = annotation('textbox',...
    pos3 + [0.03 0 0 0],...
    'String','c',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')




ax4 = subplot('Position',pos4);
hold on
errorbar(ax4, tAxis, indicators1D(varNo).PS150_mean,...
    indicators1D(varNo).PS150_std,...
    'Color','k','LineWidth', linethickness)
plot(ax4, tAxis, indicators1D(varNo).PS150_mean,...
    'Color','k','LineWidth', meanthickness)
%yticks([0.6 0.8 1 1.2 1.4])
xlabel('time before event (hours)')
ylabel('PS150')
xlim([xlimit]);
ylim(PSylimit);
xticks(ticks24);
%xticklabels([]);
ann = annotation('textbox',...
    pos4 + [0.03 0 0 0],...
    'String','d',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')



