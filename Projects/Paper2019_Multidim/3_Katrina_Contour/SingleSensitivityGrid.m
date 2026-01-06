function [meanIndicatorsArray, wsizes] = ...
    SingleSensitivityGrid(CycloneStruct,Sno)

seriesLength = 300;
wsizes = (90:1:110)'; %the window sizes to use for comparrison

%% Make the grid
meanIndicatorsArray = zeros(size(wsizes,1), seriesLength+1);

for k = 1:size(wsizes,1)
    windowSize = wsizes(k);

    T_min = CycloneStruct(Sno).T_event;
    dummy = CycloneStruct(Sno).value(T_min-seriesLength: T_min);
    slidingPs = PSE_sliding(dummy,windowSize);
    meanIndicatorsArray(k,:) = slidingPs;
end

xaxis = (-seriesLength:0)';

f = figure('Name',['Sensitivity_plot']);
contourf(xaxis, wsizes, meanIndicatorsArray,...
    'LevelStep',0.1,'LineStyle',':');
xlim([-100,0])
xlabel('Time since minimum pressure (hours)', 'FontSize',20)
ylabel('Window size (hours)', 'FontSize',20)

set(gca, 'FontSize', 16)
c2 = colorbar;
c2.FontSize = 16;

fileName = ['Sensitivity_single'];
print('-fillpage',fileName,'-dpdf')
