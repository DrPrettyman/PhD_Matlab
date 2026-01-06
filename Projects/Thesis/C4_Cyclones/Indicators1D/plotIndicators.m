
%% Load Data
clear all

varNo = 1; % 1=slp, 2=windspeed, 3=eof
RemoveOscilationsForSLP = true;


%%
if varNo==1 && RemoveOscilationsForSLP % if dealing with the SLP we want the oscilations removed
    load('indicators1D_removed')
    indicators1D = indicators1D_removed;
else
    load('indicators1D')
end

N = size(indicators1D(varNo).values,1) -1;
tAxis = (-N:0)'; % might need to change this
xlimit = [-200,0];
ticks24 = (-240:24:0)';

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
pos2 = pos1 - [0 0.21 0 0];
pos3 = pos2 - [0 0.20 0 0];
pos4 = pos3 - [0 0.20 0 0];


ax1 = subplot('Position',pos1);
hold on
for i = 1:14
    plot(ax1, tAxis, indicators1D(varNo).values(:,i),...
        'LineWidth', 1,'LineStyle', '-')
end
plot(ax1, tAxis, indicators1D(varNo).mean_value,...
    'Color','k','LineWidth', meanthickness)

ylabel(indicators1D(varNo).var_label)
xlim([xlimit]);
xticks(ticks24);
%if varNo == 1; ylim([981,1029]); end %for SLP
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
errorbar(ax2, tAxis, indicators1D(varNo).ACF1_mean,...
    indicators1D(varNo).ACF1_std,...
    'Color','k','LineWidth', linethickness)
plot(ax2, tAxis, indicators1D(varNo).ACF1_mean,...
    'Color','k','LineWidth', meanthickness)
%yticks([0.6 0.8 1 1.2 1.4])
%xlabel({'$t$'},'Interpreter','latex')
ylabel('ACF1')
xlim([xlimit]);
ylim([0.86,0.99]);
if varNo==2; ylim([0.5, 0.94]); end % for windspeed
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
errorbar(ax3, tAxis, indicators1D(varNo).DFA_mean,...
    indicators1D(varNo).DFA_std,...
    'Color','k','LineWidth', linethickness)
plot(ax3, tAxis, indicators1D(varNo).DFA_mean,...
    'Color','k','LineWidth', meanthickness)
%yticks([0.6 0.8 1 1.2 1.4])
%xlabel({'$t$'},'Interpreter','latex')
ylabel('DFA')
xlim([xlimit]);
if varNo==1;
    ylim([1.3,1.9]);
else
    ylim([0.75,1.9]);
end
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
errorbar(ax4, tAxis, indicators1D(varNo).PS_mean,...
    indicators1D(varNo).PS_std,...
    'Color','k','LineWidth', linethickness)
plot(ax4, tAxis, indicators1D(varNo).PS_mean,...
    'Color','k','LineWidth', meanthickness)
%yticks([0.6 0.8 1 1.2 1.4])
xlabel('time before event (hours)')
ylabel('PS')
xlim([xlimit]);
ylim([-1.8,2.2]);
ylim([-0.8,2.6]);
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



