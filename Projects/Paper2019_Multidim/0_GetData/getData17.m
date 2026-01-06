%% Display the information about the Netcdf files
s = num2str(72232012884);
    
file_name = [...
    'hadisd.2.0.2.2017p_19310101-20171231_' s(1:6) '-' s(7:end) '.nc'...
    ];
addpath '/home/prettyman/MatLab/Hadisd2005/data';
ncdisp(file_name)
clear s file_name 





%% Get the data for all stations listed in the function "getHadisd17_interp"
daysBefore = 20;
daysAfter = 2;

event_date_num = datenum('29 August 2005');
%event_date_num = datenum('13 September 2008');
% Set the "start" and "end" dates 30 days before and 5 days after the
% event date
start_date = datestr(event_date_num - daysBefore);
end_date = datestr(event_date_num + daysAfter);
clear event_date_num daysBefore daysAfter
    
% Get slp and windspeeds data
varID = 'slp';
%varID = 'windspeeds';
[CycloneStruct] =...
    getHadisd17_interp(start_date, end_date, varID);
clear varID start_date end_date

%% Plot all the time series
figure
hold on
for i = 1:size(CycloneStruct,2)
    plot(CycloneStruct(i).time, CycloneStruct(i).value)
end

%% Calculate the first EOF and plot the sliding PS indicator
all_values = zeros(size(CycloneStruct(1).value,1) , size(CycloneStruct,2));
for i = 1:size(CycloneStruct,2)
    all_values(:,i) = CycloneStruct(1).value;
end

first_eof_score = EOF1(all_values);

figure
plot(first_eof_score);

windowSize = 100;
eof_acf = ACF_sliding(first_eof_score, 1, windowSize, false);
eof_pse = PSE_sliding(first_eof_score, windowSize, false);

figure
ax1 = subplot(2,1,1);
plot(ax1, eof_acf)
xlim([windowSize+1 size(CycloneStruct(1).value,1)])
title('ACF(1)');
ax2 = subplot(2,1,2);
plot(ax2, eof_pse)
xlim([windowSize+1 size(CycloneStruct(1).value,1)])
title('PS')

%% Plot the track of Katrina and also all the station locations
kat_track = csvread('Katrina_track.txt',1,0);
figure
hold on
plot(-kat_track(:,4),kat_track(:,3))
for i = 1:size(CycloneStruct,2)
    plot(CycloneStruct(i).latlon(2), CycloneStruct(i).latlon(1),'o')
end
clear kat_track

%% Calculate the PS indicator of each series individually.
for i = 1:size(CycloneStruct,2)
    CycloneStruct(i).pse = PSE_sliding(CycloneStruct(i).value, windowSize, false);
end

%find the time index for station 722320-12884 being at the minimum pressure
event_index = find(CycloneStruct(1).value == min(CycloneStruct(1).value));
%Take the MK coefficient from this point minus 30 hours
for i = 1:size(CycloneStruct,2)
    CycloneStruct(i).MK30 = mannkendall(CycloneStruct(i).pse(event_index-30:event_index));
end

%% interpolate and contour plot the MK50 values
Latitudes = zeros(size(CycloneStruct,2),1);
Longitudes = zeros(size(CycloneStruct,2),1);
MK50_vals = zeros(size(CycloneStruct,2),1);
for i = 1:size(CycloneStruct,2)
    Latitudes(i) = CycloneStruct(i).latlon(1);
    Longitudes(i) = CycloneStruct(i).latlon(2);
    MK50_vals(i) = CycloneStruct(i).MK50;
end

%%
[xq,yq] = meshgrid(-98:0.5:-85, 29:0.2:33);

Vq = griddata(Longitudes,Latitudes,MK50_vals,xq,yq);

contourf(xq,yq,Vq)
