#!/bin/ksh
set -ex

######################################################################
# Programm for preparing the reference data RF99, the modern estimates of potential natural vegetation cover by Ramanlutty and Foley,1999, Global Biogeochem. Cy., 13(4), 997–1027, 1999. The original data can be downloaded at  http://ecotope.org/anthromes/v2/data/, here the original file is named: potveg.nc
########
# uses Fortran 90 and the gfortran compiler
#
# the outcome of this programm is a RF99 based reference dataset including 9 Mega-Biomes, in the model grids and the original grid (5min resolution)
#######################################################################
####
# 1.) re-grouping of the biomes used in RF99
cdo -setrtoc,14.5,15.5,9 -setrtoc,12.5,13.5,8 -setrtoc,7.5,8.5,11 -setrtoc,13.5,14.5,7 -setrtoc,11.5,12.5,6 -setrtoc,9.5,10.5,6 -setrtoc,10.5,11.5,5 -setrtoc,8.5,9.5,5 -setrtoc,5.5,7.5,4 -setrtoc,3.5,5.5,3 -setrtoc,2.5,3.5,2 -setrtoc,0.5,2.5,1 potveg.nc potveg_10.nc

# 2.) RF99 does not contain the Antarctic and Greenland ice, these regions are artificially added to the reference dataset by adding the file ice.nc, the ice-mask has been derived from a BIOME1 simulation based on CRUTS3.1 input data (for Greenland) and the orography and land see mask for the Antarctic.
cdo -setrtoc,12,22,9 -add ice.nc -setmisstoc,0 potveg_10.nc potveg_10a.nc

cdo outputf,%5.2f,4320 -setmisstoc,0 potveg_10a.nc > potveg_10.txt

# compiles and runs the fortran programm for splitting up the Evergreen/Deciduous Mixed Forest/Woodland Biome of RF99 into the biomes temperate forest and boreal forest via the GDD5 distribution (GDD5 < 900 for boreal) derived from the CRU TS 3.1 dataset, and to assign the temperate savanna region to temperate forest if the mean temperature of the coldest month is below 10°C. The fortran programm also remaps the data to a given model grid by calculating the dominant biome in the model grid cell.

#####
### different resolutions
#######
# T63
#######
gfortran remap_potveg_wo_ocean_t63.f90
./a.out

# converts the output of the fortran programm into netCDF files
# for RF99, data grouped into 9 Mega-Biomes, on a  5min-grid
cdo -f nc input,gridRF  potveg_9.nc < potveg_9.txt

# for the model grid, which starts at 0°E and 90°S
cdo -f nc input,gridt63  potveg_t63_new.nc < potveg_t63.txt
cdo sellonlatbox,0,359,-90,90 potveg_t63_new.nc RF_potveg_t63.nc
#############################
# T31
####
gfortran remap_potveg_wo_ocean_t31.f90
./a.out

# for the model grid T31, which starts at 0°E and 90°S
cdo -f nc input,gridt31  potveg_t31_new.nc < potveg_t31.txt
cdo sellonlatbox,0,359,-90,90 potveg_t31_new.nc RF_potveg_t31.nc

##########################
# 10°
##############
gfortran remap_potveg_wo_ocean_vecode.f90
./a.out
cdo -f nc input,gridvec  potveg_10deg_new.nc < potveg_vecode.txt
cdo -invertlat -sellonlatbox,0,359,-90,90 potveg_10deg_new.nc RF_potveg_10deg.nc
#cleaning up
rm potveg_10.nc potveg_10a.nc potveg_10.txt
rm  potveg_t31_new.nc  potveg_t63_new.nc  potveg_10deg_new.nc
###############
### end
###############
