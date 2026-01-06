function [outputArg1] = PlainPlotSensitivity(meanIndicatorsArray, wsizes)

%% Plot these mean indicators as a contour plot
seriesLength = size(meanIndicatorsArray,2)-1;
%wsizes = (80:1:120)'; %the window sizes to use for comparrison
xaxis = (-seriesLength:0)';

figure('Name',['Sensitivity_Katrina']);
contourf(xaxis, wsizes, meanIndicatorsArray,...
    'LevelStep',0.1,'LineStyle',':');
xlim([-100,0])
xlabel('Time since minimum pressure (hours)', 'FontSize',20)
ylabel('Window size (hours)', 'FontSize',20)

ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];

end

