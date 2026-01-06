
%% Load Data

load('fourteen2D.mat')


varNo = 1; % 1=slp, 2=windspeed, 3=eof
tAxis = ((1:size(fourteen2D(1).time,1))-1200)';
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

pos1 = [0.1 0.76 0.87 0.19];
pos2 = pos1 - [0 0.19 0 0];
pos3 = pos2 - [0 0.20 0 0];
pos4 = pos3 - [0 0.20 0 0];

c1 = [1 0 0]*0.7;
c2 = [0 1 0]*0.7;
c3 = [0 0 1]*0.7;

ax1 = subplot('Position',pos1);
hold on
errorbar(ax1, tAxis, fourteen2D(15).WL_real,...
    fourteen2D(16).WL_real,...
    'Color',c1,'LineWidth', linethickness)
plot(ax1, tAxis, fourteen2D(15).WL_real,...
    'Color','k','LineWidth', meanthickness)


ylabel({'Re(\lambda)'})
%ylim(PSylimit);
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
errorbar(ax2, tAxis, -fourteen2D(15).WL_imag,...
    fourteen2D(16).WL_imag,...
    'Color',c1,'LineWidth', linethickness)
plot(ax2, tAxis, -fourteen2D(15).WL_imag,...
    'Color','k','LineWidth', meanthickness)

ylabel({'Im(\lambda)'})
xlim([xlimit]);

ylim([-0.09, 0.19]);
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
errorbar(ax3, tAxis, fourteen2D(15).EOF_ACF1,...
    fourteen2D(16).EOF_ACF1,...
    'Color',c2,'LineWidth', linethickness)
plot(ax3, tAxis, fourteen2D(15).EOF_ACF1,...
    'Color','k','LineWidth', meanthickness)

ylabel('ACF1')
xlim([xlimit]);
%ylim([1.3,1.9]);
%ylim(PSylimit);
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
errorbar(ax4, tAxis, fourteen2D(15).EOF_PS,...
    fourteen2D(16).EOF_PS,...
    'Color',c3,'LineWidth', linethickness)
plot(ax4, tAxis, fourteen2D(15).EOF_PS,...
    'Color','k','LineWidth', meanthickness)

%yticks([0.6 0.8 1 1.2 1.4])
xlabel('time before event (hours)')
ylabel('PS')
xlim([xlimit]);
%ylim(PSylimit);
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



