%% Returns a structure with Hadisd2005 data.

% station = station number of the data you want
% start_date / end_date
% varIDs = Nx1 cell array of the names of the variables you want. 
%           e.g. varIDs = {'slp'; 'windspeed'}

function [lat, lon, time, OutStruct] = getHadisd_interp(station, start_date, end_date, varIDs)

OutStruct = struct;
addpath '/home/prettyman/MatLab/Hadisd2005/data';


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

% get the time axis
time = netcdf.getVar(net, netcdf.inqVarID(net,'time'),'double');

% get the lat and lon coords
lat = netcdf.getAtt(net,netcdf.getConstant('NC_GLOBAL'),'latitude');
lon = netcdf.getAtt(net,netcdf.getConstant('NC_GLOBAL'),'longitude');
        %disp([lat lon])

% get the data
for i = 1:size(varIDs,1)
    ID_name = char(varIDs(i));
    ID_value = netcdf.getVar(net, netcdf.inqVarID(net,ID_name),'double');
    %OutStruct.(ID_name) = ID_value;
    OutStruct(i).varID = ID_name;
    OutStruct(i).value = ID_value;
end
        
%close the file
netcdf.close(net);

% set the time to MatLab format (days from year 0000, not hours from 1973)
time = time/24 + datenum('01-01-1973');


% filter the data so that x>0 and
% the time is between start and end dates
indices = find(time >= datenum(start_date)...
    & time <= datenum(end_date));
time = time(indices);
for i = 1:size(varIDs,1)
    OutStruct(i).value = OutStruct(i).value(indices);
end
clear indices


return


