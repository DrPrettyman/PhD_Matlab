function [outputArg1] = SSplotContour_MKOnly(hurricaneName)


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
hurricaneTrack = SuperStruct(hIndex).trackDataNew;
firstStationsList = SuperStruct(hIndex).firstStationsList;
entryLatLon = SuperStruct(hIndex).entryLatLon;

%% interpolate and contour plot the MK50 values
MK30_vals = zeros(size(CycloneStruct,2),1);
for i = 1:size(CycloneStruct,2)
    MK30_vals(i) = CycloneStruct(i).MK30;
end

%% Make the contour grids
latLons = cell2mat({CycloneStruct.latlon}');
bottomLeft = min(latLons);
topRight   = max(latLons);

[xq,yq] = meshgrid(bottomLeft(2):0.25:topRight(2),...
    bottomLeft(1):0.25:topRight(1));

MKcoefficient_grid = griddata(latLons(:,2),latLons(:,1),MK30_vals,xq,yq);
clear latLons

%%
figure('Name',['MK_ContourPlot_',SuperStruct(hIndex).name]);
hold on
caxis([-1,1]);
levelList = (-1:0.2:1)';

contourf(xq,yq,MKcoefficient_grid,'Fill','on', 'LineColor','black', 'LevelList', levelList )
%Plot the track of Katrina and also all the station locations
plot( hurricaneTrack(:,3),hurricaneTrack(:,2),'k','LineWidth',2)
for i = 1:size(CycloneStruct,2)
    plot(CycloneStruct(i).latlon(2), CycloneStruct(i).latlon(1),'x','MarkerSize',8, 'color','black')
end

plot(entryLatLon(2), entryLatLon(1), 'p','MarkerSize',15, 'MarkerFaceColor','black', 'color','black' )

c2 = colorbar;
c2.Label.String = 'Mann-Kendall coefficient';
xlim([bottomLeft(2)-1, topRight(2)+1])
ylim([bottomLeft(1)-1, topRight(1)+1])


end

