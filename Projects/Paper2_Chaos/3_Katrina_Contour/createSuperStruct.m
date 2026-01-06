%% Create the basic structure

H1  = table({'Gustav'},  {'25 August 2008'},    24,  90, {'Louisiana'});
H2  = table({'Katrina'}, {'29 August 2005'},    30, 102, {'Louisiana'});
H3  = table({'Nate'},    {'08 October 2017'},   30, 102, {'Louisiana'});
H4  = table({'Wilma'},   {'24 October 2005'},   50, 102, {'Florida'});
H5  = table({'Harvey'},  {'26 August 2017'} ,   50, 102, {'Texas'});
H6  = table({'Andrew1'}, {'24 August 1992'},    30,  90, {'Florida'});
H7  = table({'Andrew2'}, {'26 August 1992'},    30,  90, {'Louisiana'});
H8  = table({'Irma'},    {'10 Septembar 2017'}, 30,  90, {'Florida'});
H9  = table({'Matthew'}, {'4 Octoberbar 2016'}, 30,  90, {'Florida'});

H = [H1;H2;H3;H4;H5;H6;H7;H8;H9];
H.Properties.VariableNames = ...
    {'name' 'eventDate' 'regressionLapse' 'indicatorWindowSize' 'region'};

SuperStruct = table2struct(H);

clear H H1 H2 H3 H4 H5 H6 H7 H8 H9 H10 H11 H12 H13 H14 H15 H16

%% Add CycloneStruct
for i = 1:size(SuperStruct,1)
    [CycloneStruct, firstStationsList] = CreateCycloneStruct(...       
        SuperStruct(i).eventDate,...
        SuperStruct(i).regressionLapse,...
        SuperStruct(i).indicatorWindowSize,...
        SuperStruct(i).region,...
        SuperStruct(i).dontUseStations);
    
    SuperStruct(i).CycloneStruct = CycloneStruct;
    SuperStruct(i).firstStationsList = firstStationsList;
end
clear CycloneStruct firstStationsList

%% Add track data
for i = 1:size(SuperStruct,1)
    trackFileName = [SuperStruct(i).name,'_track.txt'];    
    SuperStruct(i).trackData = csvread(trackFileName,1,0);
end
clear trackFileName

%% Add allValues and allIndicators arrays
for i = 1:size(SuperStruct,1) 
    [meanIndicatorsArray, allValues, allIndicators] = ...
        Plot_all_timeseries(SuperStruct(i).CycloneStruct);
    
    SuperStruct(i).meanIndicatorsArray = meanIndicatorsArray;
    SuperStruct(i).allValues = allValues;
    SuperStruct(i).allIndicators = allIndicators;
end
clear allValues allIndicators

%% Add the sensitivity grid

for i = 1:size(SuperStruct,1)
    [meanIndicatorsArray, wsizes] = ...
        SensitivityGrid(SuperStruct(hIndex).CycloneStruct);
    
    SuperStruct(i).meanIndicatorsArray = meanIndicatorsArray;
    SuperStruct(i).wsizes = wsizes;
end
clear meanIndicatorsArray
