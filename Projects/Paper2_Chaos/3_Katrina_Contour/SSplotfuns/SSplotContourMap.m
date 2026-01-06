function [outputArg1] = SSplotContourMap(hurricaneName)


if ~exist('SuperStruct','var')
    load('SuperStruct.mat', 'SuperStruct');
end

if ischar(hurricaneName)
    hIndex = find(strcmp({SuperStruct.name}, hurricaneName));
elseif isnumeric(hurricaneName)
    hIndex = hurricaneName;
end

try
    disp(['Contour map plot for ',SuperStruct(hIndex).name]);
catch
    warning('Hurricane name or number is not valid')
    hIndex = 1;
    disp(['Contour map plot for ',SuperStruct(hIndex).name]);
end

%% retreive the CycloneStruct
CycloneStruct = SuperStruct(hIndex).CycloneStruct;
hurricaneTrack = SuperStruct(hIndex).trackData;
firstStationsList = SuperStruct(hIndex).firstStationsList;
load coastlines

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

[xq,yq] = meshgrid(bottomLeft(2):0.5:topRight(2),...
    bottomLeft(1):0.5:topRight(1));

MKcoefficient_grid = griddata(latLons(:,2),latLons(:,1),MK30_vals,xq,yq);
pressure0_grid = griddata(latLons(:,2),latLons(:,1),pressure0_vals,xq,yq);
clear latLons

%% Plot the Pressure0 values
figure('Name',['Contour_Map_',SuperStruct(hIndex).name]);
hold on
subplot(2,1,1)
ax = worldmap([bottomLeft(1),topRight(1)],...
    [bottomLeft(2),topRight(2)]);

contourm(yq,xq,pressure0_grid,'Fill','on', 'LineColor','black' )

%Plot the track of Katrina and also all the station locations
plotm( hurricaneTrack(:,3),-hurricaneTrack(:,4),'k','LineWidth',2)
for i = 1:size(CycloneStruct,2)
    plotm(CycloneStruct(i).latlon(1), CycloneStruct(i).latlon(2),'x', 'color','black','LineWidth',3)
end

for i = 1:size(firstStationsList,1)
    firstStation = firstStationsList(i);
    plotm( CycloneStruct(firstStation).latlon(1), CycloneStruct(firstStation).latlon(2),'o', 'color','black','LineWidth',3)
end

c1 = colorbar;
c1.Label.String = 'Pressure (mbar)';

geoshow(coastlat,coastlon)
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];
%%
subplot(2,1,2)
ax = worldmap([bottomLeft(1),topRight(1)],...
    [bottomLeft(2),topRight(2)]);

contourm(yq,xq,MKcoefficient_grid,'Fill','on', 'LineColor','black' )

%Plot the track of Katrina and also all the station locations
plotm( hurricaneTrack(:,3),-hurricaneTrack(:,4),'k','LineWidth',2)
for i = 1:size(CycloneStruct,2)
    plotm(CycloneStruct(i).latlon(1), CycloneStruct(i).latlon(2),'x', 'color','black','LineWidth',3)
end

for i = 1:size(firstStationsList,1)
    firstStation = firstStationsList(i);
    plotm( CycloneStruct(firstStation).latlon(1), CycloneStruct(firstStation).latlon(2),'o', 'color','black','LineWidth',3)
end
geoshow(coastlat,coastlon)

c2 = colorbar;
c2.Label.String = 'Mann-Kendall coefficient';

ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];

end

