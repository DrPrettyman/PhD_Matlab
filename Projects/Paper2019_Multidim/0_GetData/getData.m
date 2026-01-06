load('basicCycloneStruct.mat')
NewStruct = basicCycloneStruct;
clear basicCycloneStruct

daysBefore = 110;
daysAfter = -10;

for cyclone_number = 1:size(NewStruct,2)
    % Get the station number and event date from the structure
    station_number = NewStruct(cyclone_number).station_no;
    event_date_num = datenum(NewStruct(cyclone_number).event_date);
    % Set the "start" and "end" dates 30 days before and 5 days after the
    % event date
    start_date = datestr(event_date_num - daysBefore);
    end_date = datestr(event_date_num + daysAfter);
    clear event_date_num
    
    % Get slp and windspeeds data
    varIDs = {'slp'; 'windspeeds'};
    [lat, lon, time, OutStruct] =...
        getHadisd_interp(station_number, start_date, end_date, varIDs);
    clear lat lon station_number varIDs
    
    slp = OutStruct(1).value;
    ws = OutStruct(2).value;
    clear OutStruct
    
    % Filter slp to values >=0 (n/a data recorded as -100 or -999)
    slp_indices = find(slp >= 0);
    slp = slp(slp_indices);
    slp_time = time(slp_indices);
    clear slp_indices
    
    % Filter windspeeds to values >=0
    ws_indices = find(ws >= 0);
    ws = ws(ws_indices);
    ws_time = time(ws_indices);
    clear ws_indices
    
    % We nolonger need the "time" variable
    clear time
    
    % Interpolate slp and ws onto the "new_time", which is a simple sequece
    % from start_date to end_date with interval 1/24.
    [ new_time, slp_interpolated ] =...
        interpolate_cyclonedata( start_date, end_date, slp_time, slp );
    [ new_time, ws_interpolated ] =...
        interpolate_cyclonedata( start_date, end_date, ws_time, ws );
    clear slp_time slp ws_time ws start_date end_date
    
    NewStruct(cyclone_number).time = new_time;
    NewStruct(cyclone_number).slp = slp_interpolated;
    NewStruct(cyclone_number).windspeed = ws_interpolated;    
    clear new_time slp_interpolated ws_interpolated
    
end
clear cyclone_number daysBefore daysAfter