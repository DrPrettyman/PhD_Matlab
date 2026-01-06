%% Open the NetCDF files

file_name1 = ['slo0021_AHP_NAF_end_loess70.nc'];
file_name2 = ['slo0021_bsf_loess_smoothed70min8k.nc'];

net1 = netcdf.open(file_name1);
net2 = netcdf.open(file_name2);

%% Get the relevant variables and close the files.

time = netcdf.getVar(net2, netcdf.inqVarID(net2,'time'));
lon  = netcdf.getVar(net2, netcdf.inqVarID(net2,'lon'));
lat  = netcdf.getVar(net2, netcdf.inqVarID(net2,'lat'));
bsf  = netcdf.getVar(net2, netcdf.inqVarID(net2,'bsf_smoothed'));
% BSF is "bare soil fraction" used to estimate the end of the humid
% period. See Clausen2020 section 2.3 (p120).

netcdf.close(net1);
netcdf.close(net2);

%% Create BSF cell array
disp('Creating BSF cell array...')
m_lat = size(lat,1);
m_lon = size(lon,1);
BSF = cell(m_lon, m_lat);
for i = 1:m_lon
    for j = 1:m_lat
        BSF{i,j} = reshape(bsf(i,j,:),size(time));
    end
end

%% Calculate PS indicators
disp('Calculating PS indicator...')
windowSize = 300;
PS_indicator = cell(size(BSF));
for i = 1:m_lon
    for j = 1:m_lat
        if ~all(BSF{i,j}==0)
            PS_indicator{i,j} =...
                PSE_sliding(BSF{i,j},windowSize);
        else
            PS_indicator{i,j} = zeros(size(time));
        end
        [i,j]
    end
end