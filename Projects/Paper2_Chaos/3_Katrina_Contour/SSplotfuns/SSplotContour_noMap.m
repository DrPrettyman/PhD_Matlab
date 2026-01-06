function [outputArg1] = SSplotContour_noMap(hurricaneName)


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
pressure0_vals = zeros(size(CycloneStruct,2),1);

for i = 1:size(CycloneStruct,2)
    MK30_vals(i) = CycloneStruct(i).MK30;
    pressure0_vals(i) = CycloneStruct(i).pressure0;
end

%% Make the contour grids
latLons = cell2mat({CycloneStruct.latlon}');
bottomLeft = min(latLons);
topRight   = max(latLons);

[xq,yq] = meshgrid(bottomLeft(2):0.25:topRight(2),...
    bottomLeft(1):0.25:topRight(1));

MKcoefficient_grid = griddata(latLons(:,2),latLons(:,1),MK30_vals,xq,yq);
SLPcoefficient_grid = griddata(latLons(:,2),latLons(:,1),pressure0_vals,xq,yq);
clear latLons

%%
pos1 = [0.05,0.54,0.9,0.46];
pos2 = [0.05,0.04,0.9,0.46];
figure('Name',['ContourPlot_',SuperStruct(hIndex).name]);
%subplot(2,1,1)
subplot('Position',pos1)
hold on

contourf(xq,yq,SLPcoefficient_grid,'Fill','on', 'LineColor','black')
%Plot the track of Katrina and also all the station locations
plot( hurricaneTrack(:,3),hurricaneTrack(:,2),'k','LineWidth',2)
for i = 1:size(CycloneStruct,2)
    plot(CycloneStruct(i).latlon(2), CycloneStruct(i).latlon(1),'x','MarkerSize',8, 'color','black')
end

plot(entryLatLon(2), entryLatLon(1), 'p','MarkerSize',15, 'MarkerFaceColor','black', 'color','black' )

c1 = colorbar;
c1.Label.String = 'Sea-level pressure';
c1.Label.FontSize = 14;
c1.FontSize = 14;

xlim([bottomLeft(2), topRight(2)])
ylim([bottomLeft(1), topRight(1)])
yticks(-90:1:90)
ylabel('latitude')
%xlabel('longitude')
xticks([])

set(gca, 'FontSize', 12)

%figure('Name',['PS ContourPlot_',SuperStruct(hIndex).name]);
%subplot(2,1,2)
subplot('Position',pos2)
hold on

contourf(xq,yq,MKcoefficient_grid,'Fill','on', 'LineColor','black')
%Plot the track of Katrina and also all the station locations
plot( hurricaneTrack(:,3),hurricaneTrack(:,2),'k','LineWidth',2)
for i = 1:size(CycloneStruct,2)
    plot(CycloneStruct(i).latlon(2), CycloneStruct(i).latlon(1),'x','MarkerSize',8, 'color','black')
end

plot(entryLatLon(2), entryLatLon(1), 'p','MarkerSize',15, 'MarkerFaceColor','black', 'color','black' )

c2 = colorbar;
c2.Label.String = 'Mann-Kendall coefficient';
c2.Label.FontSize = 14;
c2.FontSize = 14;

xlim([bottomLeft(2), topRight(2)])
ylim([bottomLeft(1), topRight(1)])
yticks(-90:1:90)
ylabel('latitude')
xlabel('longitude')
set(gca, 'FontSize', 12)

fileName = ['Contour',SuperStruct(hIndex).name];
print('-fillpage',fileName,'-dpdf')

end

