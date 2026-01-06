function [H] = centeredseries(hurricanes, p, station_no)

% find the 
get_sta_no = false;
if nargin<3
    get_sta_no = true;
end

if nargin < 2
    p=10;
    %slp_data = zeros(2*24*p+1,size(hurricanes,2));
end


H = struct;

figure
hold on

for i = 1:size(hurricanes,2)
    [start_date, end_date, H(i).h_name, station] = select_hurricane(hurricanes(i));
    if get_sta_no
        H(i).station_no = station;
    else
        H(i).station_no = station_no;
    end
    
    [lat, lon, time, slp] =...
        get_hadISD_data_interpolated(H(i).station_no, start_date, end_date);
    disp(size(slp))
    disp(size(time))
    time(5)
        
    H(i).event_date = datestr(time(find(slp==min(slp), 1)));
      
    disp([H(i).h_name, ':  ', H(i).event_date]);
    
    clear start_date end_date
    
    start_date = datestr(datenum(H(i).event_date)-p-100);
    end_date = datestr(datenum(H(i).event_date)+p);
    H(i).event_index = 24*(100+p)+1;
       
    [lat, lon, time, H(i).slp_data] =...
        get_hadISD_data_interpolated(H(i).station_no, start_date, end_date);
    
    
    plot(time, H(i).slp_data);
    
    % also get the NI (Non-interpolated) slp data for comparrison
    [lat, lon, time, H(i).slp_data_NI] =...
        get_hadISD_data(H(i).station_no, start_date, end_date);
    
    
    % also store the timeseries with 12-hourly oscilations removed.
    
    
    H(i).slp_data_RO12 = remove_oscilations(H(i).slp_data, 12);
    
    clear time h_name
    
    H(i).station_latlon = [lat lon];
    
end
hold off

return



