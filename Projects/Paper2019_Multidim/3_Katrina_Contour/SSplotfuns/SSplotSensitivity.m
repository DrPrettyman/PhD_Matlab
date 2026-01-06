function [outputArg1] = SSplotSensitivity(hurricaneName)

if ~exist('SuperStruct','var')
    load('SuperStruct.mat', 'SuperStruct');
end

if ischar(hurricaneName)
    hIndex = find(strcmp({SuperStruct.name}, hurricaneName));
elseif isnumeric(hurricaneName)
    hIndex = hurricaneName;
end

try
    disp(['Sensitivity plot for ',SuperStruct(hIndex).name]);
catch
    warning('Hurricane name or number is not valid')
    hIndex = 1;
    disp(['Sensitivity plot for ',SuperStruct(hIndex).name]);
end

%% Plot these mean indicators as a contour plot
meanIndicatorsArray = SuperStruct(hIndex).meanIndicatorsArray;


seriesLength = size(meanIndicatorsArray,2)-1;
wsizes = (80:1:120)'; %the window sizes to use for comparrison
xaxis = (-seriesLength:0)';

f = figure('Name',['Sensitivity_',SuperStruct(hIndex).name]);
contourf(xaxis, wsizes, meanIndicatorsArray,...
    'LevelStep',0.1,'LineStyle',':');
xlim([-100,0])
xlabel('Time since minimum pressure (hours)', 'FontSize',20)
ylabel('Window size (hours)', 'FontSize',20)

% ax = gca;
% outerpos = ax.OuterPosition;
% ti = ax.TightInset; 
% left = outerpos(1) + ti(1);
% bottom = outerpos(2) + ti(2);
% ax_width = outerpos(3) - ti(1) - 4*ti(3);
% ax_height = outerpos(4) - ti(2) - ti(4);
% ax.Position = [left bottom ax_width ax_height];

set(gca, 'FontSize', 16)
c2 = colorbar;
c2.FontSize = 16;

fileName = ['Sensitivity',SuperStruct(hIndex).name];
print('-fillpage',fileName,'-dpdf')



%c2.Location = '';
end

