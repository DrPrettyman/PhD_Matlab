function [outputArg1] = SSplotAllStations(hurricaneName)

if ~exist('SuperStruct','var')
    load('SuperStruct.mat', 'SuperStruct');
end

if ischar(hurricaneName)
    hIndex = find(strcmp({SuperStruct.name}, hurricaneName));
elseif isnumeric(hurricaneName)
    hIndex = hurricaneName;
end

try
    disp(['All-stations plot for ',SuperStruct(hIndex).name]);
catch
    warning('Hurricane name or number is not valid')
    hIndex = 1;
    disp(['All-stations plot for ',SuperStruct(hIndex).name]);
end

%% retreive the CycloneStruct
CycloneStruct = SuperStruct(hIndex).CycloneStruct;
indicatorWindowSize = SuperStruct(hIndex).indicatorWindowSize;
meanIndicator = mean(SuperStruct(hIndex).allIndicators);
seriesLength = size(SuperStruct(hIndex).allValues,2)-1;
xaxis = (-seriesLength:0)';

%% Plot all time series
figure('Name',['AllStations_',SuperStruct(hIndex).name]);

ax1 = subplot(2,1,1);
set(gca, 'FontSize', 14)
hold on

ax2 = subplot(2,1,2);
set(gca, 'FontSize', 14)
hold on

xaxis = (-seriesLength:0)';
for i = 1:size(CycloneStruct,2)
    plot(ax1,xaxis, SuperStruct(hIndex).allValues(i,:))
    plot(ax2,xaxis, SuperStruct(hIndex).allIndicators(i,:))
end
plot(ax2,xaxis, meanIndicator, 'color', 'black', 'lineWidth', 2)
xlim(ax1,[-100,0])
xlim(ax2,[-100,0])

xlabel(ax1, 'Time since minimum pressure (hours)')
xlabel(ax2, 'Time since minimum pressure (hours)')

ylabel(ax1, 'Sea-level pressure (mbar)')
ylabel(ax2, ['PS-indicator (',num2str(indicatorWindowSize),'-point window)'])

outerpos = ax1.OuterPosition;
ti = ax1.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax1.Position = [left bottom ax_width ax_height];

outerpos = ax2.OuterPosition;
ti = ax2.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax2.Position = [left bottom ax_width ax_height];


fileName = ['AllStations',SuperStruct(hIndex).name];
print('-fillpage',fileName,'-dpdf')
end

