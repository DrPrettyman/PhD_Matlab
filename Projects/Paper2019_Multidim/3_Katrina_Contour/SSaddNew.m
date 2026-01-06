hIndex = size(SuperStruct,1)+1;

%% Add the basic properties
SuperStruct(hIndex).name = 'Hurricane1';
SuperStruct(hIndex).eventDate = '24 September 2006';
SuperStruct(hIndex).regressionLapse = 30;
SuperStruct(hIndex).indicatorWindowSize = 90;
SuperStruct(hIndex).region = 'Florida';
SuperStruct(hIndex).dontUseStations = {};

%% Add CycloneStruct and allValues and allIndicators arrays
RecalculateCycloneStruct(SuperStruct(hIndex).name)

%% Add track data
for i = 1:size(SuperStruct,1)
    trackFileName = [SuperStruct(hIndex).name,'_track.txt'];    
    SuperStruct(hIndex).trackData = csvread(trackFileName,1,0);
end
clear trackFileName

%% Add the sensitivity grid
[meanIndicatorsArray, wsizes] = ...
    SensitivityGrid(SuperStruct(hIndex).CycloneStruct);

SuperStruct(hIndex).meanIndicatorsArray = meanIndicatorsArray;
SuperStruct(hIndex).wsizes = wsizes;


