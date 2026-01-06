function fig1 = plot_sensitivity(meanIndicatorsArray, wsizes, indName,contourStep,ylimits)

%% Plot these mean indicators as a contour plot
seriesLength = size(meanIndicatorsArray,2)-1;
%wsizes = (80:1:120)'; %the window sizes to use for comparrison
xaxis = (-seriesLength:0)';

fig1 = figure;
fig1.Units = 'centimeters';
fig1.Position = [0,15,24,24];
fig1.Resize = 'off';
fontsize = 18;
linethickness = 1.5;
hold on

contourf(xaxis, wsizes, meanIndicatorsArray,...
    'LevelStep',contourStep,'LineStyle',':');
xlim([-100,0])
xticks([-96,-72,-48,-24,0])

ylim(ylimits)

xlabel('Time since minimum pressure (hours)', 'FontSize',20)
ylabel('Window size (hours)', 'FontSize',20)

c = colorbar;
c.Label.String = [indName,' indicator'];
c.Label.FontSize = 20;

ax = gca;
ax.Position = [0.1,0.1,0.77,0.87];

set(ax,'box','on',...
    'FontSize',fontsize, 'FontName', 'Times New Roman')
end

