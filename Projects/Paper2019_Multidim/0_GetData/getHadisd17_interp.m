%% Returns a structure with interpolated Hadisd2017 data.

% start_date / end_date
% varID = name of the variables you want. varID = 'slp'
    
function [OutStruct] = getHadisd17_interp(start_date, end_date,...
    file_numbers, VarID)

OutStruct = struct;
%addpath '/joshuaprettyman/Documants/MatLab/Hadisd2005/data';

for i = 1:size(file_numbers,1)
    % open the netcdf file
    s = num2str(file_numbers(i));
    
    file_name = [...
        'hadisd.2.0.2.2017p_19310101-20171231_' s(1:6) '-' s(7:end) '.nc'...
        ];
    net = netcdf.open(file_name);
    OutStruct(i).station_number = [s(1:6) '-' s(7:end)];
    clear s file_name
    
    % get the time axis
    time = netcdf.getVar(net, netcdf.inqVarID(net,'time'),'double');

    % get the lat and lon coords
    lat = netcdf.getVar(net, netcdf.inqVarID(net,'latitude'),'double');
    lon = netcdf.getVar(net, netcdf.inqVarID(net,'longitude'),'double');
        %disp([lat lon])
    OutStruct(i).latlon = [lat, lon];

    % get the data
    ID_value = netcdf.getVar(net, netcdf.inqVarID(net,VarID),'double');
    %OutStruct.(ID_name) = ID_value;
    OutStruct(i).varID = VarID;
    value = ID_value;
        
    %close the file
    netcdf.close(net);
    clear net

    % set the time to MatLab format (days from year 0000, not hours from 1973)
    time = time/24 + datenum('01-01-1931');

    
    % filter the data so that x>0 and
    % the time is between start and end dates
    indices = find(time >= datenum(start_date)...
        & time <= datenum(end_date));
    time = time(indices);
    value = value(indices);
    
    % filter the data so that slp>=0
    slp_indices = find(value >= 0);
    time_filtered = time(slp_indices);
    value_filtered = value(slp_indices);
    
    clear value time indices slp_indices
    
    [ time_interp, value_interp ] = interpolate_cyclonedata( start_date, end_date, time_filtered, value_filtered );
    
    % add to the structure so long as not all values are zero
    if sum(value_interp)>100
        OutStruct(i).time = time_interp;
        OutStruct(i).value = value_interp;
    end
    clear time_filtered value_filtered time_interp value_interp
    
end

return


