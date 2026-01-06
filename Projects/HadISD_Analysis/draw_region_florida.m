
start_date = '07-01-2005';
end_date = '11-01-2005';

% start number k is where the files start, n is where they end
% for Florida, files 1 to 6
% for US Gulf, files 7 to 18

k = 1;
n = 18;

lat = zeros(n-k+1,1);
lon = zeros(n-k+1,1);
for i = 1:(n-k+1)
    station_no = i+k-1;
    [lat(i), lon(i), time, slp] = get_hadISD_data(station_no, start_date, end_date);
end

lon = 360+lon;

figure
worldmap([min(lat)-4,max(lat)+4],[min(lon)-4,max(lon)+4])
coast = load('coast');
plotm(coast.lat,coast.long)

% load('katrinatrack.txt')
% plotm([katrinatrack(:,3), 360-katrinatrack(:,4)],'red')

plotm([lat,lon],'ko')
plotm([lat,lon],'kx')