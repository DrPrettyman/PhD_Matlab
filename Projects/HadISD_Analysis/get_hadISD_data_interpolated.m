function [lat, lon, time, slp] = get_hadISD_data_interpolated(station, start_date, end_date)

file_numbers = [...
    72201012836;... %Florida         #1
    72202012839;... %Florida   
    72202512849;... %Florida
    72202612826;... %Florida
    72202999999;... %Florida   
    72203012844;... %Florida         #6
    74768599999;... %Gulf            #7
    74768613820;... %Gulf
    74775013846;... %Gulf
    74777003852;... %Gulf
    74780499999;... %Gulf
    74781099999;... %Gulf
    74788012810;... %Gulf
    74790013849;... %Gulf
    74791013717;... %Gulf
    74791593718;... %Gulf
    74794599999;... %Gulf
    74795012867;... %Gulf            #18
    76601099999;... %La Blas Mexico  #19               for Kenna  (2002)
    98548099999;... %nr. Tacloban (philipines)   #20
    98558099999;... %nr. Tacloban (philipines)   #21
    98550099999;... %Tacloban (philipines)       #22   for Haiyan  (2013)
    98233099999;... %TUGUEGARAO (phil - Zeb )    #23   for Zeb  (1998) and Megi (2010)
    43150099999;... %VISHAKHAPATNAM (India)      #24 for Hudhud (2014)
    78711099999;... %Honduras (Puerto Lempira)   #25 for Mitch  
    47778099999;... %JP SHIONOMISAKI             #26 for Flo 
    72222113899;... %PENSACOLA USA               #27 for Opal 
    72222503855;... %PENSACOLA FOREST USA        #28 for Opal
    94142099999;... %MANINGRIDA  AU              #29 for Monica
    94150099999;... %GOVE AIRPORT AU             #30 for Monica
    72223013894;...   %MOBILE REGIONAL             #31 for Ivan
    76750099999;...  %CHETUMAL  MEX                #32 for Dean
    72231553917;... %  NEW ORLEANS LAKEFRONT     #33 for Katrina
    72231012916; ... %  NEW ORLEANS INTL ARPT 
    72240003937; ... %  LAKE CHARLES REGIONAL ARPT  #35 for Rita
    72210612835]; %  FORT MYERS PAGE FIELD       #36 for Charley



% open the netcdf file
s = num2str(file_numbers(station));
file_name = ['hadisd.1.0.4.2015p.' s(1:6) '-' s(7:end) '.nc'];
net = netcdf.open(file_name);
clear s file_numbers file_name

% get the time and slp data
time = netcdf.getVar(net, netcdf.inqVarID(net,'time'),'double');
slp = netcdf.getVar(net, netcdf.inqVarID(net,'slp'),'double');

% get the lat and lon coords
lat = netcdf.getAtt(net,netcdf.getConstant('NC_GLOBAL'),'latitude');
lon = netcdf.getAtt(net,netcdf.getConstant('NC_GLOBAL'),'longitude');
        %disp([lat lon])

%close the file
netcdf.close(net);

% set the time to MatLab format (days from year 0000, not hours from 1973)
time = time/24 + datenum('01-01-1973');

% filter the data so that slp>0 and
% the time is between start and end dates
indices = find(time >= datenum(start_date)...
    & time <= datenum(end_date) & slp > 0);
slp = slp(indices);
time = time(indices);
clear indices

% interpolate the slp data onto the hourly time vector
% (if there is any left after the filtering above)
if size(slp, 1) > 0
    if time(1) ~= datenum(start_date)
        time = [datenum(start_date); time];
        slp = [mean(slp); slp];
    end
    if time(end) ~= datenum(end_date)
        time = [time; datenum(end_date)];
        slp = [slp; mean(slp)];
    end
    
    time_i = (datenum(start_date):(1/24):datenum(end_date))';
    slp = interp1q(time, slp, time_i);
    time = time_i;
else
    time = (datenum(start_date):(1/24):datenum(end_date))';
    slp = zeros(size(time));
end

%time = time(1:24:end);
%slp = slp(1:24:end);
    
return