function [SuperStruct] = RecalculateCycloneStruct(hurricaneName, SuperStruct)
tic

if ischar(hurricaneName)
    hIndex = find(strcmp({SuperStruct.name}, hurricaneName));
elseif isnumeric(hurricaneName)
    hIndex = hurricaneName;
end

try
    disp(['Recalculating CycloneStruct for ',SuperStruct(hIndex).name]);
catch
    warning('Hurricane name or number is not valid')
    hIndex = 1;
    disp(['Recalculating CycloneStruct for ',SuperStruct(hIndex).name]);
end

%%
[CycloneStruct, firstStationsList, entryTime, entryLatLon] = CreateCycloneStruct(...
    SuperStruct(hIndex).eventDate,...
    SuperStruct(hIndex).regressionLapse,...
    SuperStruct(hIndex).indicatorWindowSize,...
    SuperStruct(hIndex).region,...
    SuperStruct(hIndex).dontUseStations,...
    SuperStruct(hIndex).trackDataNew);

SuperStruct(hIndex).CycloneStruct = CycloneStruct;
SuperStruct(hIndex).firstStationsList = firstStationsList;
SuperStruct(hIndex).entryTime = entryTime;
SuperStruct(hIndex).entryLatLon = entryLatLon;
clear CycloneStruct firstStationsList entryTime entryLatLon

%% Add allValues and allIndicators arrays

[allValues, allIndicators] = ...
    AllValuesArrays(SuperStruct(hIndex).CycloneStruct);

SuperStruct(hIndex).allValues = allValues;
SuperStruct(hIndex).allIndicators = allIndicators;

clear CycloneStruct meanIndicatorsArray allValues allIndicators

disp(['Recalculated CycloneStruct in ',num2str(toc),' s']);
end

