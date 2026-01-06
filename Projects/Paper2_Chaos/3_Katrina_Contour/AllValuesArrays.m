function [allValues, allIndicators] = ...
    AllValuesArrays(CycloneStruct);

seriesLength = 300;

%% Make an array of all the pressure series
allValues = zeros(size(CycloneStruct,2), seriesLength+1);
for i = 1:size(CycloneStruct,2)
    dummy = CycloneStruct(i).value;
    T_min = CycloneStruct(i).T_event;
    
    allValues(i, :) = dummy(T_min-seriesLength: T_min);
end
clear i T_min dummy

%% Make an array of the PS indicators of all the sereis

allIndiactors = zeros(size(CycloneStruct,2), seriesLength+1);
for i = 1:size(CycloneStruct,2)
    dummy = CycloneStruct(i).pse;
    T_min = CycloneStruct(i).T_event;
    
    allIndicators(i, :) = dummy(T_min-seriesLength: T_min);
end
clear i T_min dummy
meanIndicator = mean(allIndicators);
