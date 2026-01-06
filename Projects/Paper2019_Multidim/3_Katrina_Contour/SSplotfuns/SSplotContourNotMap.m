function [outputArg1] = SSplotContourNotMap(hurricaneName)


if ~exist('SuperStruct','var')
    load('SuperStruct.mat', 'SuperStruct');
end

if ischar(hurricaneName)
    hIndex = find(strcmp({SuperStruct.name}, hurricaneName));
elseif isnumeric(hurricaneName)
    hIndex = hurricaneName;
end

try
    disp(['Contour plot for ',SuperStruct(hIndex).name]);
catch
    warning('Hurricane name or number is not valid')
    hIndex = 1;
    disp(['Contour plot for ',SuperStruct(hIndex).name]);
end

%% retreive the CycloneStruct
CycloneStruct = SuperStruct(hIndex).CycloneStruct;
hurricaneTrack = SuperStruct(hIndex).trackData;
firstStationsList = SuperStruct(hIndex).firstStationsList;

%% interpolate and contour plot the MK50 values
MK30_vals = zeros(size(CycloneStruct,2),1);
pressure0_vals = zeros(size(CycloneStruct,2),1);
for i = 1:size(CycloneStruct,2)
    pressure0_vals(i) = CycloneStruct(i).pressure0;
    MK30_vals(i) = CycloneStruct(i).MK30;
end


%% Make the contour grids
latLons = cell2mat({CycloneStruct.latlon}');
bottomLeft = min(latLons);
topRight   = max(latLons);

[xq,yq] = meshgrid(bottomLeft(2):0.25:topRight(2),...
    bottomLeft(1):0.25:topRight(1));

MKcoefficient_grid = griddata(latLons(:,2),latLons(:,1),MK30_vals,xq,yq);
pressure0_grid = griddata(latLons(:,2),latLons(:,1),pressure0_vals,xq,yq);
clear latLons

%% Plot the Pressure0 values
figure('Name',['Pressure_Contour_Plot_',SuperStruct(hIndex).name]);
hold on

contourf(xq,yq,pressure0_grid,'Fill','on', 'LineColor','black' )

%Plot the track of Katrina and also all the station locations
plot(-hurricaneTrack(:,4),hurricaneTrack(:,3),'k','LineWidth',2)
for i = 1:size(CycloneStruct,2)
    plot(CycloneStruct(i).latlon(2), CycloneStruct(i).latlon(1),'x', 'color','black','LineWidth',3)
end

for i = 1:size(firstStationsList,1)
    firstStation = firstStationsList(i);
    plot( CycloneStruct(firstStation).latlon(2), CycloneStruct(firstStation).latlon(1),'o', 'color','black','LineWidth',3)
end

c1 = colorbar;
c1.Label.String = 'Pressure (mbar)';
xlim([bottomLeft(2),topRight(2)])
ylim([bottomLeft(1),topRight(1)])

%%
figure('Name',['MK_Contour_Plot_',SuperStruct(hIndex).name]);
hold on
caxis([-1,1]);
levelList = (-1:0.2:1)';

contourf(xq,yq,MKcoefficient_grid,'Fill','on', 'LineColor','black', 'LevelList', levelList )
%Plot the track of Katrina and also all the station locations
plot( -hurricaneTrack(:,4),hurricaneTrack(:,3),'k','LineWidth',2)
for i = 1:size(CycloneStruct,2)
    plot(CycloneStruct(i).latlon(2), CycloneStruct(i).latlon(1),'x', 'color','black','LineWidth',3)
end

for i = 1:size(firstStationsList,1)
    firstStation = firstStationsList(i);
    plot( CycloneStruct(firstStation).latlon(2), CycloneStruct(firstStation).latlon(1),'o', 'color','black','LineWidth',3)
end


c2 = colorbar;
c2.Label.String = 'Mann-Kendall coefficient';
xlim([bottomLeft(2),topRight(2)])
ylim([bottomLeft(1),topRight(1)])


end

