%% Open the NetCDF files

file_name1 = ['MPI-ESM_r1i1p2_LGM_biomePFT.nc'];
file_name2 = ['MPI-ESM_r1i1p2_LGM_bio1out.nc'];

net1 = netcdf.open(file_name1);
net2 = netcdf.open(file_name2);

%% Get the relevant variables and close the files.

cover_fract = netcdf.getVar(net1, netcdf.inqVarID(net1,'cover_fract'));

t1 = netcdf.getVar(net1, netcdf.inqVarID(net1,'time'));
t2 = netcdf.getVar(net2, netcdf.inqVarID(net2,'time'));