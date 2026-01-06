%% must run the script RemoveOscillations.m first 
%  so that the relavent variables are in the workspace

%RemoveOscillations.m

%% now we plot the ACF1 signal

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,20,20];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 1.5;
hold on


Rcol = [0.7 0.7 0.7 0.7];
Dcol = [0.8 0   0   0.6];
Scol = [0   0   0.8 0.4];

tlimits = [-1000,-500];
tticks = (-960:120:-480);

boxheight = 0.44;
hgap = 0.01;
pos1 = [0.1 1-(boxheight+hgap) 0.87 boxheight];
pos2 = pos1 - [0 (boxheight+hgap) 0 0];

ax1 = subplot('Position',pos1)
hold on
plot(ax1, t,X-mean(X),...
    'Color',Rcol,'LineWidth', 2*linethickness)
plot(ax1, t, newslp_D,...
    'Color',Dcol,'LineWidth', linethickness)
plot(ax1, t, newslp_S,...
    'Color',Scol,'LineWidth', linethickness)
ylabel({'SLP (hPa)'},'Interpreter','latex')
xlim(tlimits);
xticks(tticks);
ylim([-1.9,3.9]);
ann = annotation('textbox',...
    pos1 + [0.03 0 0 0],...
    'String','a',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
xticklabels([]);
legend(ax1,{'original','filtered',['sine wave' 10 'subtracted']},...
    'Location','northeast','FontSize',fontsize, 'FontName', 'Times New Roman','Interpreter','latex')
set(gca,'YGrid','on','XGrid','on','XAxisLocation','top','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')



ax2 = subplot('Position',pos2)
hold on
plot(ax2, t,ACF_R,...
    'Color',Rcol,'LineWidth', 2*linethickness)
plot(ax2, t, ACF_D,...
    'Color',Dcol,'LineWidth', linethickness)
plot(ax2, t, ACF_S,...
    'Color',Scol,'LineWidth', linethickness)
ylabel({'ACF1 indicator'},'Interpreter','latex')
xlim(tlimits);
xticks(tticks);
%ylim([-2,2]);
xlabel({'time before event (hours)'},'Interpreter','latex')
yticks([0.8, 0.9]);
ann = annotation('textbox',...
    pos2 + [0.03 -0.03 0 0],...
    'String','b',...
    'FontSize', 30',...
    'LineStyle', 'none',...
    'FitBoxToText', 'off',...
    'FontName', 'Times New Roman');
set(gca,'YGrid','on','XGrid','on','box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')


