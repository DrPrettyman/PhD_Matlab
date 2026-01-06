function [meanIndicatorsArray, wsizes] = ...
    SensitivityGrid(CycloneStruct)

seriesLength = 300;
wsizes = (80:1:120)'; %the window sizes to use for comparrison

%% Make the grid
meanIndicatorsArray = zeros(size(wsizes,1), seriesLength+1);

for k = 1:size(wsizes,1)
    windowSize = wsizes(k);
    allIndiactorsDummy = zeros(size(CycloneStruct,2), seriesLength+1);
    for i = 1:size(CycloneStruct,2)
        T_min = CycloneStruct(i).T_event;
        dummy = CycloneStruct(i).value(T_min-seriesLength: T_min);
        slidingPs = PSE_sliding(dummy,windowSize);
        allIndicatorsDummy(i, :) = smoothing(slidingPs);
    end
    clear i T_min
    meanIndicatorsArray(k,:) = mean(allIndicatorsDummy);
end


