function [CycloneStruct, firstStationsList, entryTime, entryLatLon] = ...
    CreateCycloneStruct(eventDate, regressionLapse,...
    indicatorWindowSize, region, dontUseStations, trackData)

%% load the station numbers 
% Note: this could be done by region to save time if necessary 
stationNoFileName = ['stationNos',region,'.mat'];
stationNoVarName  = ['stationNos',region];
stationLoad = load(stationNoFileName);
file_numbers = stationLoad.(stationNoVarName);



%% Get the data for all stations listed in the function "getHadisd17_interp"
daysBefore = 20;
daysAfter = 2;

eventDateNumber = datenum(eventDate);

% Set the "start" and "end" dates 30 days before and 5 days after the
% event date
start_date = datestr(eventDateNumber - daysBefore);
end_date = datestr(eventDateNumber + daysAfter);
clear event_date_num daysBefore daysAfter
    
% Get slp and windspeeds data
varID = 'slp';
%varID = 'windspeeds';
[InitStruct] =...
    getHadisd17_interp(start_date, end_date, file_numbers, varID);
clear varID start_date end_date
 
%% Delete any empty rows of the structure

% here we find the indices of the stations in InitStruct for which the
% time vecotr has zero length (this tends to happen when the station
% is faulty or the data unusable. 
% Before we find these indices, we change the time vector to zero
% artificially if the station is in our manual dontUseStations list
timeVectorLengths = zeros(size(InitStruct,2),1);
for i = 1:size(InitStruct,2)
    timeVectorLengths(i) = size(InitStruct(i).time,1);
    if any(ismember(InitStruct(i).station_number, dontUseStations))
        timeVectorLengths(i) = 0;
        disp(['do not use station ',InitStruct(i).station_number])
    end
end
NonZeroIndices = find(timeVectorLengths~=0);

f = fieldnames(InitStruct)';
f{2,1} = {};
CycloneStruct = struct(f{:});
for i = 1:size(NonZeroIndices,1)
    index = NonZeroIndices(i);
    CycloneStruct(i) = InitStruct(index);
end
    

%% Find the time of the lowest pressure according to each sation

% We find the miniumum pressure value in the final 60 hours of the time 
% series and search the pressure values for values which match this
% minimum.
eventIndicesList = zeros(size(CycloneStruct,2),1);
for i = 1:size(CycloneStruct,2)
    eventIndex = find(CycloneStruct(i).value ==...
        min(CycloneStruct(i).value(end-72:end)));
    CycloneStruct(i).T_event = eventIndex(end);
    eventIndicesList(i) = eventIndex(end);
end
clear i event_index

firstStationsList = find(eventIndicesList==min(eventIndicesList));
first_station = firstStationsList(1);
clear eventIndicesList

%% Find entryTime
%  This is the time when the hurricane first enters the region

% first we must define the region by the maximum and minimum 
% coordinates of the stations
latLons = cell2mat({CycloneStruct.latlon}');
bottomLeft = min(latLons);
topRight   = max(latLons);

polyRegion = polyshape(...
    [bottomLeft(2), bottomLeft(2), topRight(2), topRight(2)  ],...
    [bottomLeft(1), topRight(1),   topRight(1), bottomLeft(1)]);
figure
hold on
plot(polyRegion)
plot(trackData(:, 3), trackData(:, 2))
% find the index of the first point in the trackData which is
% in the interior of the region.
trackIndex = ...
    find(isinterior(polyRegion, trackData(:,[3,2])) ,1);
if trackIndex == 1
    trackIndex = 2;
end
disp(['trackIndex = ',num2str(trackIndex)])

% define two [lon, lat] points, one outside and one inside
pointOut = trackData(trackIndex-1, [3,2]);
pointIn =  trackData(trackIndex,   [3,2]);

% devide the line between these two points into 100 and find the first
% part of this which is inside the region.
dummyX = linspace(pointOut(1),pointIn(1),100)';
dummyY = linspace(pointOut(2),pointIn(2),100)';
entryIndex = find(isinterior(polyRegion, dummyX, dummyY) ,1);
entryLatLon = [dummyY(entryIndex), dummyX(entryIndex)];

% Find the corresponding point in time.
timeOut = trackData(trackIndex-1, 1);
timeIn =  trackData(trackIndex,   1);
dummyTime = linspace(timeOut(1),timeIn(1),100)';
entryTime = dummyTime(entryIndex);

disp(['Entry Time = ',datestr(entryTime)]);

clear pointIn pointOut timeIn timeOut dummyX dummyY dummyTime 
clear trackIndex polyRegion entryIndex

%% Find the eventIndex
%  This is the index of the time vector corresponding to the time of
%  entryTime

eventIndex = find(CycloneStruct(1).time > entryTime,1);
disp(['Event Index = ',num2str(eventIndex)]);

%% Add the pressure at the entryTime
%  Using eventIndex

%find the time index for station 722320-12884 being at the minimum pressure
for i = 1:size(CycloneStruct,2)
    CycloneStruct(i).pressure0 = CycloneStruct(i).value(eventIndex);
end
clear i 

%% Calculate the PS indicator of each series individually.
windowSize = indicatorWindowSize;
for i = 1:size(CycloneStruct,2)
     slidingPs = PSE_sliding(CycloneStruct(i).value, windowSize, false);
     CycloneStruct(i).pse = smoothing(slidingPs);
end
clear windowSize

%% Calculate the MK30 coefficient 
%  and the linear regression coefficient
%  the mann kendall coefficient in a window of 30 points

%Take the MK coefficient from entry-point minus 30 hours
lapse = regressionLapse;
for i = 1:size(CycloneStruct,2)
    CycloneStruct(i).MK30 =...
        mannkendall(CycloneStruct(i).pse(eventIndex-lapse:eventIndex));
%     linearCoefficients = polyfit(...
%         (0:lapse)'/24.0,...
%         CycloneStruct(i).pse(eventIndex-lapse:eventIndex),1);
%     
%     CycloneStruct(i).LinearFit = linearCoefficients(1);
end
clear i eventIndex lapse



return 
